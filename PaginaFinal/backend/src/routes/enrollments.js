const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

router.get('/', async (req, res) => {
  const { studentId } = req.query
  let sql = 'SELECT e.* FROM enrollments e WHERE 1=1'
  const params = []
  if (studentId) {
    sql += ' AND e.student_id = ?'
    params.push(studentId)
  }
  if (req.user.role === 'Administrador') {
    sql += ' AND EXISTS (SELECT 1 FROM students st WHERE st.id = e.student_id AND st.career_id = ?)'
    params.push('IDGS')
  }
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.get('/student/:studentId', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM enrollments WHERE student_id = ?', [req.params.studentId])
  res.json(rows)
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { student_id, subject_id, periodo, status } = req.body
  if (!student_id || !subject_id || !periodo) {
    return res.status(400).json({ error: 'student_id, subject_id y periodo son requeridos' })
  }
  const id = `${student_id}-EN-${subject_id}`
  try {
    await pool.query(
      'INSERT INTO enrollments (id, student_id, subject_id, periodo, status) VALUES (?, ?, ?, ?, ?)',
      [id, student_id, subject_id, periodo, status || 'Inscrito']
    )
    const [rows] = await pool.query('SELECT * FROM enrollments WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'El alumno ya está inscrito en esa materia' })
    console.error(err)
    res.status(500).json({ error: 'Error al inscribir' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { status } = req.body
  if (!status) return res.status(400).json({ error: 'status es requerido' })

  const [result] = await pool.query('UPDATE enrollments SET status = ? WHERE id = ?', [status, req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Inscripción no encontrada' })
  const [rows] = await pool.query('SELECT * FROM enrollments WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM enrollments WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Inscripción no encontrada' })
  res.status(204).end()
})

module.exports = router
