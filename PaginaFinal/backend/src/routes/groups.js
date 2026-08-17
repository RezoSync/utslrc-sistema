const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

router.get('/', async (req, res) => {
  let sql = 'SELECT * FROM `groups` WHERE 1=1'
  const params = []
  if (req.user.role === 'Administrador') {
    sql += ' AND career_id = ?'
    params.push('IDGS')
  }
  sql += ' ORDER BY id'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM `groups` WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Grupo no encontrado' })
  res.json(rows[0])
})

// GET /api/groups/:id/average -> promedio general del grupo
router.get('/:id/average', async (req, res) => {
  const [rows] = await pool.query('SELECT AVG(promedio) AS promedio FROM students WHERE group_id = ?', [req.params.id])
  res.json({ grupo: req.params.id, promedio: Number(rows[0].promedio || 0) })
})

// GET /api/groups/:id/attendance -> asistencia promedio del grupo
router.get('/:id/attendance', async (req, res) => {
  const [rows] = await pool.query('SELECT AVG(asistencia) AS asistencia FROM students WHERE group_id = ?', [req.params.id])
  res.json({ grupo: req.params.id, asistencia: Math.round(Number(rows[0].asistencia || 0)) })
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { id, nombre, career_id, cuatrimestre, periodo, aula, turno } = req.body
  if (!id || !nombre || !career_id) {
    return res.status(400).json({ error: 'id, nombre y career_id son requeridos' })
  }
  try {
    await pool.query(
      'INSERT INTO `groups` (id, nombre, career_id, cuatrimestre, periodo, aula, turno) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [id, nombre, career_id, cuatrimestre || null, periodo || null, aula || null, turno || null]
    )
    const [rows] = await pool.query('SELECT * FROM `groups` WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Ese grupo ya existe' })
    console.error(err)
    res.status(500).json({ error: 'Error al crear grupo' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['nombre', 'career_id', 'cuatrimestre', 'periodo', 'aula', 'turno']
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

  const [result] = await pool.query(`UPDATE \`groups\` SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Grupo no encontrado' })
  const [rows] = await pool.query('SELECT * FROM `groups` WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM `groups` WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Grupo no encontrado' })
  res.status(204).end()
})

module.exports = router
