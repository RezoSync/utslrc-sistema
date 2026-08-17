// Recorre los libros del catálogo sin portada y les jala datos de Google Books.
// Intenta: 1) por ISBN, 2) por título+autor con operadores, 3) por texto simple.
// Uso: npm run backfill:portadas

require('dotenv').config()
const pool = require('../src/db')

const API_KEY = process.env.GOOGLE_BOOKS_API_KEY || ''

async function buscarEnGoogleBooks(query, intento = 1) {
  const params = new URLSearchParams({ q: query })
  if (API_KEY) params.set('key', API_KEY)

  const res = await fetch(`https://www.googleapis.com/books/v1/volumes?${params.toString()}`)

  if ((res.status === 429 || res.status === 503) && intento <= 4) {
    const espera = 2000 * intento
    console.log(`  ${res.status} recibido, esperando ${espera}ms…`)
    await new Promise((r) => setTimeout(r, espera))
    return buscarEnGoogleBooks(query, intento + 1)
  }

  if (!res.ok) throw new Error(`Google Books respondió ${res.status}`)

  const data = await res.json()
  return data.items || []
}

function extraerPortada(item) {
  const img = item.volumeInfo?.imageLinks
  const url = img?.thumbnail || img?.smallThumbnail
  return url ? url.replace('http://', 'https://') : null
}

async function intentar(query) {
  const items = await buscarEnGoogleBooks(query)
  const item = items[0]
  if (!item) return null
  const portada = extraerPortada(item)
  if (!portada) return null
  return { portada, googleBooksId: item.id }
}

async function resolverLibro(libro) {
  const primerAutor = libro.autor.split(',')[0].split('&')[0].trim()

  if (libro.isbn) {
    const r = await intentar(`isbn:${libro.isbn}`)
    if (r) return { ...r, via: 'isbn' }
  }

  const r2 = await intentar(`intitle:${libro.titulo} inauthor:${primerAutor}`)
  if (r2) return { ...r2, via: 'titulo+autor' }

  const r3 = await intentar(`${libro.titulo} ${primerAutor}`)
  if (r3) return { ...r3, via: 'texto simple' }

  return null
}

async function main() {
  const [libros] = await pool.query('SELECT id, isbn, titulo, autor FROM books WHERE portada IS NULL')

  console.log(`Encontrados ${libros.length} libros sin portada.`)

  for (const libro of libros) {
    try {
      const resultado = await resolverLibro(libro)
      if (!resultado) {
        console.log(`Sin resultado: ${libro.titulo}`)
        continue
      }
      await pool.query('UPDATE books SET portada = ?, google_books_id = ? WHERE id = ?', [
        resultado.portada,
        resultado.googleBooksId,
        libro.id,
      ])
      console.log(`Actualizado (${resultado.via}): ${libro.titulo}`)
    } catch (err) {
      console.error(`Error con ${libro.titulo}:`, err.message)
    }
    await new Promise((r) => setTimeout(r, 1200))
  }

  await pool.end()
  console.log('Listo.')
}

main()