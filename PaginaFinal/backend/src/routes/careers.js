const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

router.get('/', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM careers ORDER BY nombre')
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM careers WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Carrera no encontrada' })
  res.json(rows[0])
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { id, nombre, siglas, nivel, duracion, modalidad, descripcion } = req.body
  if (!id || !nombre || !siglas) return res.status(400).json({ error: 'id, nombre y siglas son requeridos' })
  try {
    await pool.query(
      'INSERT INTO careers (id, nombre, siglas, nivel, duracion, modalidad, descripcion) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [id, nombre, siglas, nivel || null, duracion || null, modalidad || null, descripcion || null]
    )
    const [rows] = await pool.query('SELECT * FROM careers WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Esa carrera ya existe' })
    console.error(err)
    res.status(500).json({ error: 'Error al crear carrera' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['nombre', 'siglas', 'nivel', 'duracion', 'modalidad', 'descripcion']
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

  const [result] = await pool.query(`UPDATE careers SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Carrera no encontrada' })
  const [rows] = await pool.query('SELECT * FROM careers WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM careers WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Carrera no encontrada' })
  res.status(204).end()
})

module.exports = router
