const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

// Genera el siguiente id de alumno disponible (AL001, AL002, ...)
async function nextStudentId() {
  const [rows] = await pool.query(
    "SELECT MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)) AS maxNum FROM students WHERE id REGEXP '^AL[0-9]+$'"
  )
  const next = (rows[0].maxNum || 0) + 1
  return 'AL' + String(next).padStart(3, '0')
}

// GET /api/students?grupo=IDGS%208-3&q=texto
router.get('/', async (req, res) => {
  const { grupo, q } = req.query
  let sql = 'SELECT * FROM students WHERE 1=1'
  const params = []

  if (grupo) {
    sql += ' AND group_id = ?'
    params.push(grupo)
  }
  if (q) {
    sql += ' AND (nombre LIKE ? OR expediente LIKE ?)'
    params.push(`%${q}%`, `%${q}%`)
  }
  if (req.user.role === 'Administrador') {
    sql += ' AND career_id = ?'
    params.push('IDGS')
  }
  sql += ' ORDER BY group_id, no'

  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM students WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Alumno no encontrado' })
  res.json(rows[0])
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  let { id, no, expediente, nombre, group_id, email, status, career_id, cuatrimestre, periodo, promedio, asistencia } = req.body
  if (!nombre || !group_id || !career_id) {
    return res.status(400).json({ error: 'nombre, group_id y career_id son requeridos' })
  }
  try {
    if (!id) id = await nextStudentId()

    if (!no) {
      const [rows] = await pool.query('SELECT COALESCE(MAX(no), 0) AS maxNo FROM students WHERE group_id = ?', [group_id])
      no = (rows[0].maxNo || 0) + 1
    }

    await pool.query(
      `INSERT INTO students (id, no, expediente, nombre, group_id, email, status, career_id, cuatrimestre, periodo, promedio, asistencia)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, no, expediente || '', nombre, group_id, email || null, status || 'Activo', career_id, cuatrimestre || null, periodo || null, promedio || 0, asistencia || 0]
    )
    const [rows] = await pool.query('SELECT * FROM students WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Ya existe un alumno con ese id, expediente o email' })
    if (err.code === 'ER_NO_REFERENCED_ROW_2') return res.status(400).json({ error: 'El grupo o la carrera seleccionados no existen' })
    console.error(err)
    res.status(500).json({ error: 'Error al crear alumno' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['no', 'expediente', 'nombre', 'group_id', 'email', 'status', 'career_id', 'cuatrimestre', 'periodo', 'promedio', 'asistencia']
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

  const [result] = await pool.query(`UPDATE students SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Alumno no encontrado' })
  const [rows] = await pool.query('SELECT * FROM students WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM students WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Alumno no encontrado' })
  res.status(204).end()
})

module.exports = router
