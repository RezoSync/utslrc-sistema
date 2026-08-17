const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')

const router = asyncRouter()

// GET /api/public/stats -> métricas generales para el portal público
router.get('/stats', async (req, res) => {
  const [[students]] = await pool.query('SELECT COUNT(*) AS total, AVG(promedio) AS promedio FROM students')
  const [[groups]] = await pool.query('SELECT COUNT(*) AS total FROM `groups`')
  const [[careers]] = await pool.query('SELECT COUNT(*) AS total FROM careers')
  res.json({
    totalStudents: students.total,
    promedioGlobal: Number(students.promedio || 0),
    totalGroups: groups.total,
    totalCareers: careers.total,
  })
})

// GET /api/public/careers -> listado de carreras (info pública)
router.get('/careers', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM careers ORDER BY nombre')
  res.json(rows)
})

// GET /api/public/teachers -> directorio de docentes (info pública)
router.get('/teachers', async (req, res) => {
  const [teachers] = await pool.query('SELECT * FROM teachers ORDER BY nombre')
  const [subs] = await pool.query('SELECT id, nombre, teacher_id FROM subjects')
  const result = teachers.map((t) => ({
    ...t,
    materias: subs.filter((s) => s.teacher_id === t.id).map((s) => s.nombre),
  }))
  res.json(result)
})

module.exports = router
