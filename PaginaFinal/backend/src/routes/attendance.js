const asyncRouter = require('../utils/asyncRouter')
const crypto = require('crypto')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

// Fecha de "hoy" en el servidor, usando componentes locales (no UTC) para
// evitar el mismo desfase que tenía el frontend en zonas UTC negativas.
function todayLocalISO() {
  const d = new Date()
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

function estadoFor(porcentaje) {
  if (porcentaje >= 90) return 'Regular'
  if (porcentaje >= 80) return 'En riesgo'
  return 'Crítico'
}

router.get('/', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM attendance_summary')
  res.json(rows)
})

router.get('/student/:studentId', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM attendance_summary WHERE student_id = ?', [req.params.studentId])
  if (!rows[0]) return res.status(404).json({ error: 'Sin registro de asistencia para este alumno' })
  res.json(rows[0])
})

// Crea o actualiza el resumen de asistencia de un alumno (upsert manual,
// para correcciones administrativas puntuales — el flujo normal de "tomar
// asistencia" pasa por POST /take y recalcula esto automáticamente).
router.put('/student/:studentId', requireRole('Administrador', 'Control Escolar', 'Docente'), async (req, res) => {
  const { asistencias, faltas, retardos, porcentaje } = req.body
  if (asistencias == null || faltas == null || retardos == null || porcentaje == null) {
    return res.status(400).json({ error: 'asistencias, faltas, retardos y porcentaje son requeridos' })
  }
  const estado = estadoFor(porcentaje)

  await pool.query(
    `INSERT INTO attendance_summary (student_id, asistencias, faltas, retardos, porcentaje, estado)
     VALUES (?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE asistencias=VALUES(asistencias), faltas=VALUES(faltas), retardos=VALUES(retardos), porcentaje=VALUES(porcentaje), estado=VALUES(estado)`,
    [req.params.studentId, asistencias, faltas, retardos, porcentaje, estado]
  )
  await pool.query('UPDATE students SET asistencia = ? WHERE id = ?', [porcentaje, req.params.studentId])

  const [rows] = await pool.query('SELECT * FROM attendance_summary WHERE student_id = ?', [req.params.studentId])
  res.json(rows[0])
})

async function teacherTeachesSubjectInGroup(teacherId, groupId, subjectId) {
  const [rows] = await pool.query(
    `SELECT 1 FROM teacher_groups tg
     JOIN subjects s ON s.group_id = tg.group_id
     WHERE tg.teacher_id = ? AND tg.group_id = ? AND s.id = ? AND s.teacher_id = ?`,
    [teacherId, groupId, subjectId, teacherId]
  )
  return rows.length > 0
}

// Recalcula el acumulado (attendance_summary + students.asistencia) de un
// alumno a partir de TODOS sus registros de asistencia_records (todas las
// materias), que es lo que ya se muestra en la pantalla de Asistencia.
async function recomputeSummary(studentId) {
  const [rows] = await pool.query(
    `SELECT
       COUNT(*) AS total,
       SUM(estado = 'Falta') AS faltas,
       SUM(estado = 'Retardo') AS retardos
     FROM attendance_records WHERE student_id = ?`,
    [studentId]
  )
  const { total, faltas, retardos } = rows[0]
  if (!total) return
  const asistencias = total - faltas
  const porcentaje = Math.round((asistencias / total) * 100)
  const estado = estadoFor(porcentaje)

  await pool.query(
    `INSERT INTO attendance_summary (student_id, asistencias, faltas, retardos, porcentaje, estado)
     VALUES (?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE asistencias=VALUES(asistencias), faltas=VALUES(faltas), retardos=VALUES(retardos), porcentaje=VALUES(porcentaje), estado=VALUES(estado)`,
    [studentId, asistencias, faltas, retardos, porcentaje, estado]
  )
  await pool.query('UPDATE students SET asistencia = ? WHERE id = ?', [porcentaje, studentId])
}

// GET /attendance/session?groupId=&subjectId=&fecha= — trae lo ya tomado
// para esa materia/fecha (si el docente vuelve a entrar, ve lo que ya marcó).
router.get('/session', requireRole('Docente', 'Administrador', 'Control Escolar'), async (req, res) => {
  const { groupId, subjectId, fecha } = req.query
  if (!groupId || !subjectId || !fecha) {
    return res.status(400).json({ error: 'groupId, subjectId y fecha son requeridos' })
  }
  if (req.user.role === 'Docente') {
    const owns = await teacherTeachesSubjectInGroup(req.user.teacherId, groupId, subjectId)
    if (!owns) return res.status(403).json({ error: 'No impartes esa materia en ese grupo' })
  }
  const [rows] = await pool.query(
    'SELECT student_id, estado, justificacion FROM attendance_records WHERE group_id = ? AND subject_id = ? AND fecha = ?',
    [groupId, subjectId, fecha]
  )
  res.json(rows)
})

// GET /attendance/history?groupId=&subjectId= — lista de fechas ya tomadas
// para esa materia/grupo, con conteos, para poder entrar a un día pasado
// y editar/justificar desde ahí.
router.get('/history', requireRole('Docente', 'Administrador', 'Control Escolar'), async (req, res) => {
  const { groupId, subjectId } = req.query
  if (!groupId || !subjectId) {
    return res.status(400).json({ error: 'groupId y subjectId son requeridos' })
  }
  if (req.user.role === 'Docente') {
    const owns = await teacherTeachesSubjectInGroup(req.user.teacherId, groupId, subjectId)
    if (!owns) return res.status(403).json({ error: 'No impartes esa materia en ese grupo' })
  }
  const [rows] = await pool.query(
    `SELECT
       fecha,
       SUM(estado = 'Presente') AS presentes,
       SUM(estado = 'Falta') AS faltas,
       SUM(estado = 'Retardo') AS retardos,
       COUNT(*) AS total
     FROM attendance_records
     WHERE group_id = ? AND subject_id = ?
     GROUP BY fecha
     ORDER BY fecha DESC`,
    [groupId, subjectId]
  )
  res.json(rows)
})

// POST /attendance/take — el docente pasa lista: un estado por alumno, para
// una materia y fecha. Vuelve a llamarse el mismo día para corregir (upsert).
router.post('/take', requireRole('Docente', 'Administrador', 'Control Escolar'), async (req, res) => {
  const { groupId, subjectId, fecha, registros } = req.body
  if (!groupId || !subjectId || !fecha || !Array.isArray(registros) || registros.length === 0) {
    return res.status(400).json({ error: 'groupId, subjectId, fecha y registros son requeridos' })
  }
  if (fecha > todayLocalISO()) {
    return res.status(400).json({ error: 'No se puede pasar asistencia en una fecha futura.' })
  }
  const ESTADOS = new Set(['Presente', 'Falta', 'Retardo'])
  for (const r of registros) {
    if (!r.studentId || !ESTADOS.has(r.estado)) {
      return res.status(400).json({ error: 'Cada registro necesita studentId y un estado válido (Presente, Falta o Retardo)' })
    }
  }

  let teacherId = req.user.teacherId
  if (req.user.role === 'Docente') {
    const owns = await teacherTeachesSubjectInGroup(req.user.teacherId, groupId, subjectId)
    if (!owns) return res.status(403).json({ error: 'No impartes esa materia en ese grupo' })
  } else {
    // Admin/Control Escolar tomando asistencia en nombre de un grupo: se
    // guarda con el docente titular de esa materia, si existe.
    const [subj] = await pool.query('SELECT teacher_id FROM subjects WHERE id = ?', [subjectId])
    teacherId = subj[0]?.teacher_id || null
  }

  for (const r of registros) {
    await pool.query(
      `INSERT INTO attendance_records (id, student_id, group_id, subject_id, teacher_id, fecha, estado, justificacion)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE estado = VALUES(estado), justificacion = VALUES(justificacion), teacher_id = VALUES(teacher_id), updated_at = NOW()`,
      [crypto.randomUUID(), r.studentId, groupId, subjectId, teacherId, fecha, r.estado, r.justificacion || null]
    )
  }
  for (const r of registros) {
    await recomputeSummary(r.studentId)
  }

  const [summaryRows] = await pool.query('SELECT * FROM attendance_summary WHERE student_id IN (?)', [registros.map((r) => r.studentId)])
  res.status(201).json({ saved: registros.length, summary: summaryRows })
})

module.exports = router