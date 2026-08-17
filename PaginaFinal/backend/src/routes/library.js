const express = require('express')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = express.Router()
router.use(requireAuth)

// ---------- LIBROS ----------

// GET /api/library/books?q=texto
router.get('/books', async (req, res) => {
  const { q } = req.query
  let sql = 'SELECT * FROM books WHERE 1=1'
  const params = []
  if (q) {
    sql += ' AND (titulo LIKE ? OR autor LIKE ?)'
    params.push(`%${q}%`, `%${q}%`)
  }
  sql += ' ORDER BY created_at DESC'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.post('/books', requireRole('Administrador'), async (req, res) => {
  const { isbn, titulo, autor, categoria, ejemplares, portada, google_books_id } = req.body
  if (!titulo || !autor) {
    return res.status(400).json({ error: 'titulo y autor son requeridos' })
  }
  const id = `L-${Date.now()}`
  const total = ejemplares || 1
  try {
    await pool.query(
      `INSERT INTO books (id, isbn, titulo, autor, categoria, ejemplares, disponibles, portada, google_books_id)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, isbn || null, titulo, autor, categoria || 'General', total, total, portada || null, google_books_id || null]
    )
    const [rows] = await pool.query('SELECT * FROM books WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Ese ISBN ya está registrado en el catálogo' })
    console.error(err)
    res.status(500).json({ error: 'Error al registrar el libro' })
  }
})

router.put('/books/:id', requireRole('Administrador'), async (req, res) => {
  const fields = ['titulo', 'autor', 'categoria', 'ejemplares', 'disponibles', 'portada']
  const updates = []
  const params = []
  for (const f of fields) {
    if (req.body[f] !== undefined) {
      updates.push(`${f} = ?`)
      params.push(req.body[f])
    }
  }
  if (!updates.length) return res.status(400).json({ error: 'Nada para actualizar' })
  params.push(req.params.id)

  const [result] = await pool.query(`UPDATE books SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Libro no encontrado' })
  const [rows] = await pool.query('SELECT * FROM books WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/books/:id', requireRole('Administrador'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM books WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Libro no encontrado' })
  res.status(204).end()
})

// ---------- PRÉSTAMOS ----------

// GET /api/library/loans?status=Vigente
// Solo Vinculación puede ver préstamos (ni alumnos, ni docentes, ni administradores).
router.get('/loans', requireRole('Vinculacion'), async (req, res) => {
  const { status } = req.query
  let sql = `
    SELECT loans.*, books.titulo AS libro_titulo, students.nombre AS alumno_nombre
    FROM loans
    JOIN books ON books.id = loans.book_id
    JOIN students ON students.id = loans.student_id
    WHERE 1=1`
  const params = []
  if (status) {
    sql += ' AND loans.status = ?'
    params.push(status)
  }
  sql += ' ORDER BY loans.fecha_prestamo DESC'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.post('/loans', requireRole('Vinculacion'), async (req, res) => {
  const { book_id, student_id, fecha_limite } = req.body
  if (!book_id || !student_id || !fecha_limite) {
    return res.status(400).json({ error: 'book_id, student_id y fecha_limite son requeridos' })
  }
  // La fecha límite debe ser estrictamente posterior al día de hoy.
  const hoy = new Date()
  hoy.setHours(0, 0, 0, 0)
  const limite = new Date(`${fecha_limite}T00:00:00`)
  if (Number.isNaN(limite.getTime()) || limite <= hoy) {
    return res.status(400).json({ error: 'La fecha límite debe ser mayor al día de hoy' })
  }
  const conn = await pool.getConnection()
  try {
    await conn.beginTransaction()
    const [[libro]] = await conn.query('SELECT disponibles FROM books WHERE id = ? FOR UPDATE', [book_id])
    if (!libro) {
      await conn.rollback()
      return res.status(404).json({ error: 'Libro no encontrado' })
    }
    if (libro.disponibles < 1) {
      await conn.rollback()
      return res.status(409).json({ error: 'No hay ejemplares disponibles' })
    }
    const id = `P-${Date.now()}`
    await conn.query(
      `INSERT INTO loans (id, book_id, student_id, fecha_prestamo, fecha_limite, status)
       VALUES (?, ?, ?, CURDATE(), ?, 'Vigente')`,
      [id, book_id, student_id, fecha_limite]
    )
    await conn.query('UPDATE books SET disponibles = disponibles - 1 WHERE id = ?', [book_id])
    await conn.commit()
    const [rows] = await pool.query('SELECT * FROM loans WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    await conn.rollback()
    console.error(err)
    res.status(500).json({ error: 'Error al registrar el préstamo' })
  } finally {
    conn.release()
  }
})

// PATCH /api/library/loans/:id/devolver
router.patch('/loans/:id/devolver', requireRole('Vinculacion'), async (req, res) => {
  const conn = await pool.getConnection()
  try {
    await conn.beginTransaction()
    const [[prestamo]] = await conn.query('SELECT * FROM loans WHERE id = ? FOR UPDATE', [req.params.id])
    if (!prestamo) {
      await conn.rollback()
      return res.status(404).json({ error: 'Préstamo no encontrado' })
    }
    if (prestamo.status === 'Devuelto') {
      await conn.rollback()
      return res.status(409).json({ error: 'Ese préstamo ya fue devuelto' })
    }
    await conn.query(
      `UPDATE loans SET status = 'Devuelto', fecha_devolucion = CURDATE() WHERE id = ?`,
      [req.params.id]
    )
    await conn.query('UPDATE books SET disponibles = disponibles + 1 WHERE id = ?', [prestamo.book_id])
    await conn.commit()
    const [rows] = await pool.query('SELECT * FROM loans WHERE id = ?', [req.params.id])
    res.json(rows[0])
  } catch (err) {
    await conn.rollback()
    console.error(err)
    res.status(500).json({ error: 'Error al procesar la devolución' })
  } finally {
    conn.release()
  }
})

module.exports = router