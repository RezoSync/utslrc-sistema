const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

router.get('/', async (req, res) => {
  const { status, categoria } = req.query
  let { studentId } = req.query

  // Un alumno solo puede ver sus propios tickets, sin importar lo que mande en el query string.
  if (req.user.role === 'Alumno') {
    studentId = req.user.studentId
  }

  let sql = 'SELECT * FROM service_tickets WHERE 1=1'
  const params = []
  if (status) {
    sql += ' AND status = ?'
    params.push(status)
  }
  if (categoria) {
    sql += ' AND categoria = ?'
    params.push(categoria)
  }
  if (studentId) {
    sql += ' AND student_id = ?'
    params.push(studentId)
  }
  sql += ' ORDER BY fecha DESC'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM service_tickets WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Ticket no encontrado' })

  // Un alumno solo puede consultar el detalle de su propio ticket
  if (req.user.role === 'Alumno' && rows[0].student_id !== req.user.studentId) {
    return res.status(403).json({ error: 'No tienes permiso para ver este ticket' })
  }
  res.json(rows[0])
})

// Cualquier usuario autenticado puede abrir un ticket (trámite o soporte).
// Un alumno solo puede abrir tickets a su propio nombre: se ignora cualquier
// student_id que venga en el body y se fuerza el de su sesión (evita que un
// alumno abra o vea trámites a nombre de otro alumno).
const DESCRIPCION_MAX = 600

router.post('/', async (req, res) => {
  const { tipo, categoria, fecha, descripcion } = req.body
  let { student_id } = req.body

  if (req.user.role === 'Alumno') {
    if (!req.user.studentId) return res.status(403).json({ error: 'Tu usuario no tiene un expediente de alumno asociado' })
    student_id = req.user.studentId
  }

  if (!student_id || !tipo || !categoria) {
    return res.status(400).json({ error: 'student_id, tipo y categoria son requeridos' })
  }
  if (descripcion && descripcion.length > DESCRIPCION_MAX) {
    return res.status(400).json({ error: `La descripción no puede superar los ${DESCRIPCION_MAX} caracteres.` })
  }

  const [studentRows] = await pool.query('SELECT id FROM students WHERE id = ?', [student_id])
  if (!studentRows[0]) return res.status(400).json({ error: 'El alumno indicado no existe' })

  const [countRows] = await pool.query('SELECT COUNT(*) AS c FROM service_tickets')
  const n = countRows[0].c + 1
  const id = `TK-${1000 + n}`
  const folio = `SE-${new Date().getFullYear()}-${String(300 + n).padStart(4, '0')}`
  const status = categoria === 'Trámite escolar' ? 'En proceso' : 'Abierto'

  await pool.query(
    'INSERT INTO service_tickets (id, folio, student_id, tipo, descripcion, categoria, fecha, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [id, folio, student_id, tipo, descripcion || null, categoria, fecha || new Date().toISOString().slice(0, 10), status]
  )
  const [rows] = await pool.query('SELECT * FROM service_tickets WHERE id = ?', [id])
  res.status(201).json(rows[0])
})

router.put('/:id', requireRole('Administrador', 'Control Escolar', 'Vinculacion'), async (req, res) => {
  const { status } = req.body
  if (!status) return res.status(400).json({ error: 'status es requerido' })

  const [result] = await pool.query('UPDATE service_tickets SET status = ? WHERE id = ?', [status, req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Ticket no encontrado' })
  const [rows] = await pool.query('SELECT * FROM service_tickets WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM service_tickets WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Ticket no encontrado' })
  res.status(204).end()
})

module.exports = router