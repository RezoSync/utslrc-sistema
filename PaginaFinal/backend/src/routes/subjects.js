const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

// GET /api/subjects?grupo=IDGS%208-3
router.get('/', async (req, res) => {
  const { grupo } = req.query
  let sql = 'SELECT s.* FROM subjects s JOIN `groups` g ON g.id = s.group_id WHERE 1=1'
  const params = []
  if (grupo) {
    sql += ' AND s.group_id = ?'
    params.push(grupo)
  }
  if (req.user.role === 'Administrador') {
    sql += ' AND g.career_id = ?'
    params.push('IDGS')
  }
  if (req.user.role === 'Docente') {
    sql += ' AND s.teacher_id = ?'
    params.push(req.user.teacherId)
  }
  sql += ' ORDER BY s.id'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM subjects WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Materia no encontrada' })
  res.json(rows[0])
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { id, nombre, group_id, teacher_id, docente_nombre, creditos } = req.body
  if (!id || !nombre || !group_id) {
    return res.status(400).json({ error: 'id, nombre y group_id son requeridos' })
  }
  try {
    await pool.query(
      'INSERT INTO subjects (id, nombre, group_id, teacher_id, docente_nombre, creditos) VALUES (?, ?, ?, ?, ?, ?)',
      [id, nombre, group_id, teacher_id || null, docente_nombre || null, creditos || 0]
    )
    const [rows] = await pool.query('SELECT * FROM subjects WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Esa materia ya existe' })
    console.error(err)
    res.status(500).json({ error: 'Error al crear materia' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['nombre', 'group_id', 'teacher_id', 'docente_nombre', 'creditos']
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

  const [result] = await pool.query(`UPDATE subjects SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Materia no encontrada' })
  const [rows] = await pool.query('SELECT * FROM subjects WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM subjects WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Materia no encontrada' })
  res.status(204).end()
})

module.exports = router