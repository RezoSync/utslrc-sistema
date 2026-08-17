const BASE_URL = 'https://www.googleapis.com/books/v1/volumes'
const API_KEY = (import.meta.env.VITE_GOOGLE_BOOKS_API_KEY as string | undefined) || ''

export interface LibroGoogleBooks {
  googleBooksId: string
  titulo: string
  autor: string
  isbn: string
  categoria: string
  portada: string
  descripcion: string
}

interface GoogleBooksVolume {
  id: string
  volumeInfo: {
    title?: string
    authors?: string[]
    categories?: string[]
    description?: string
    imageLinks?: { thumbnail?: string; smallThumbnail?: string }
    industryIdentifiers?: { type: string; identifier: string }[]
  }
}

interface GoogleBooksResponse {
  items?: GoogleBooksVolume[]
}

function extraerIsbn(identificadores?: { type: string; identifier: string }[]): string {
  if (!identificadores) return ''
  const isbn13 = identificadores.find((i) => i.type === 'ISBN_13')
  const isbn10 = identificadores.find((i) => i.type === 'ISBN_10')
  return isbn13?.identifier || isbn10?.identifier || ''
}

function mapVolume(v: GoogleBooksVolume): LibroGoogleBooks {
  const info = v.volumeInfo
  return {
    googleBooksId: v.id,
    titulo: info.title || 'Sin título',
    autor: info.authors?.join(', ') || 'Autor desconocido',
    isbn: extraerIsbn(info.industryIdentifiers),
    categoria: info.categories?.[0] || 'General',
    portada: info.imageLinks?.thumbnail?.replace('http://', 'https://') || '',
    descripcion: info.description || '',
  }
}

export async function buscarLibrosGoogleBooks(query: string): Promise<LibroGoogleBooks[]> {
  const texto = query.trim()
  if (texto.length < 2) return []

  const params = new URLSearchParams({
    q: texto,
    maxResults: '10',
    printType: 'books',
    langRestrict: 'es',
  })
  if (API_KEY) params.set('key', API_KEY)

  let res: Response
  try {
    res = await fetch(`${BASE_URL}?${params.toString()}`)
  } catch {
    throw new Error('No se pudo conectar con Google Books. Verifica tu conexión.')
  }

  if (!res.ok) {
    throw new Error(`Google Books respondió con error ${res.status}`)
  }

  const data = (await res.json()) as GoogleBooksResponse
  return (data.items || []).map(mapVolume)
}

export async function buscarLibroPorIsbn(isbn: string): Promise<LibroGoogleBooks | null> {
  const resultados = await buscarLibrosGoogleBooks(`isbn:${isbn.trim()}`)
  return resultados[0] || null
}