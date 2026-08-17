const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

const STATUS_VALUES = ['Disponible', 'En uso', 'Prestado', 'En reparación', 'Baja']

// Genera el siguiente folio disponible (INV-<year>-001, INV-<year>-002, ...)
async function nextInventoryId() {
  const year = new Date().getFullYear()
  const [rows] = await pool.query(
    "SELECT MAX(CAST(SUBSTRING(id, 10) AS UNSIGNED)) AS maxNum FROM inventory_items WHERE id LIKE ?",
    [`INV-${year}-%`]
  )
  const next = (rows[0].maxNum || 0) + 1
  return `INV-${year}-${String(next).padStart(3, '0')}`
}

// GET /api/inventory?q=texto
router.get('/', async (req, res) => {
  const { q } = req.query
  let sql = 'SELECT * FROM inventory_items WHERE 1=1'
  const params = []
  if (q) {
    sql += ' AND (nombre LIKE ? OR id LIKE ? OR qr LIKE ?)'
    params.push(`%${q}%`, `%${q}%`, `%${q}%`)
  }
  sql += ' ORDER BY id DESC'
  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

// GET /api/inventory/scan/:code -> busca por folio o código QR (para el escáner)
router.get('/scan/:code', async (req, res) => {
  const { code } = req.params
  const [rows] = await pool.query('SELECT * FROM inventory_items WHERE id = ? OR qr = ?', [code, code])
  if (!rows[0]) return res.status(404).json({ error: 'No se encontró ningún activo con ese código' })
  res.json(rows[0])
})

router.get('/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM inventory_items WHERE id = ?', [req.params.id])
  if (!rows[0]) return res.status(404).json({ error: 'Activo no encontrado' })
  res.json(rows[0])
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  let { id, nombre, categoria, ubicacion, responsable, status, valor, qr } = req.body
  if (!nombre || !categoria) {
    return res.status(400).json({ error: 'nombre y categoria son requeridos' })
  }
  if (status && !STATUS_VALUES.includes(status)) {
    return res.status(400).json({ error: `status inválido. Usa uno de: ${STATUS_VALUES.join(', ')}` })
  }
  try {
    if (!id) id = await nextInventoryId()
    if (!qr) qr = `QR-${id}`
    await pool.query(
      `INSERT INTO inventory_items (id, nombre, categoria, ubicacion, responsable, status, valor, qr)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, nombre, categoria, ubicacion || null, responsable || null, status || 'Disponible', valor || null, qr]
    )
    const [rows] = await pool.query('SELECT * FROM inventory_items WHERE id = ?', [id])
    res.status(201).json(rows[0])
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Ya existe un activo con ese folio o código QR' })
    console.error(err)
    res.status(500).json({ error: 'Error al registrar el activo' })
  }
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['nombre', 'categoria', 'ubicacion', 'responsable', 'status', 'valor', 'qr']
  if (req.body.status !== undefined && !STATUS_VALUES.includes(req.body.status)) {
    return res.status(400).json({ error: `status inválido. Usa uno de: ${STATUS_VALUES.join(', ')}` })
  }
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

  const [result] = await pool.query(`UPDATE inventory_items SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Activo no encontrado' })
  const [rows] = await pool.query('SELECT * FROM inventory_items WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM inventory_items WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Activo no encontrado' })
  res.status(204).end()
})

module.exports = router
