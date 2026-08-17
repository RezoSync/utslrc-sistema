const asyncRouter = require('../utils/asyncRouter')
const fs = require('fs')
const path = require('path')
const crypto = require('crypto')
const multer = require('multer')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

const UPLOAD_ROOT = path.join(__dirname, '..', '..', 'uploads')

// Límites de caracteres compartidos con el frontend (los contadores de ahí
// muestran los mismos números). Se validan también aquí porque el frontend
// nunca es la única línea de defensa.
const TITLE_MAX = 60
const TEXT_MAX = 600

// Tipos de archivo permitidos para adjuntos: PDF, PowerPoint e imágenes.
// Cualquier otro mimetype se rechaza antes de tocar disco.
const ALLOWED_MIME = new Set([
  'application/pdf',
  'application/vnd.ms-powerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
])
const MAX_FILES = 5
const MAX_FILE_SIZE = 25 * 1024 * 1024 // 25MB

function sanitizeFilename(name) {
  return name.replace(/[^\w.\-áéíóúÁÉÍÓÚñÑ ]/g, '_').slice(0, 150)
}

function fileFilter(req, file, cb) {
  if (!ALLOWED_MIME.has(file.mimetype)) {
    cb(new Error('FILE_TYPE_NOT_ALLOWED'))
    return
  }
  cb(null, true)
}

function makeUpload(subdir) {
  const storage = multer.diskStorage({
    destination: (req, _file, cb) => {
      const dir = path.join(UPLOAD_ROOT, subdir, req.params.id)
      fs.mkdirSync(dir, { recursive: true })
      cb(null, dir)
    },
    filename: (req, file, cb) => {
      cb(null, `${Date.now()}-${crypto.randomBytes(4).toString('hex')}-${sanitizeFilename(file.originalname)}`)
    },
  })
  return multer({ storage, fileFilter, limits: { fileSize: MAX_FILE_SIZE, files: MAX_FILES } })
}

const uploadAssignmentFiles = makeUpload('assignments')
const uploadSubmissionFiles = makeUpload('submissions')

// Envuelve upload.array(...) para convertir los errores de multer (tipo no
// permitido, archivo muy grande, demasiados archivos) en un JSON 400
// consistente con el resto de la API, en vez del HTML por defecto de multer.
function handleUpload(uploadMiddleware) {
  return (req, res, next) => {
    uploadMiddleware(req, res, (err) => {
      if (!err) return next()
      if (err.message === 'FILE_TYPE_NOT_ALLOWED') {
        return res.status(400).json({ error: 'Solo se permiten archivos PDF, PowerPoint (.ppt/.pptx) o imágenes (jpg, png, webp, gif).' })
      }
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ error: 'Cada archivo debe pesar máximo 25MB.' })
      }
      if (err.code === 'LIMIT_FILE_COUNT' || err.code === 'LIMIT_UNEXPECTED_FILE') {
        return res.status(400).json({ error: `Puedes adjuntar máximo ${MAX_FILES} archivos.` })
      }
      return res.status(400).json({ error: 'No se pudieron procesar los archivos adjuntos.' })
    })
  }
}

async function nextId(prefix, table) {
  const [rows] = await pool.query(
    `SELECT MAX(CAST(SUBSTRING(id, ${prefix.length + 1}) AS UNSIGNED)) AS maxNum FROM ${table} WHERE id REGEXP '^${prefix}[0-9]+$'`
  )
  const next = (rows[0].maxNum || 0) + 1
  return prefix + String(next).padStart(4, '0')
}

async function teacherOwnsGroup(teacherId, groupId) {
  const [rows] = await pool.query('SELECT 1 FROM teacher_groups WHERE teacher_id = ? AND group_id = ?', [teacherId, groupId])
  return rows.length > 0
}

async function teacherOwnsAssignment(teacherId, assignmentId) {
  const [rows] = await pool.query('SELECT 1 FROM assignments WHERE id = ? AND teacher_id = ?', [assignmentId, teacherId])
  return rows.length > 0
}

function validateLengths(res, fields) {
  for (const [label, value, max] of fields) {
    if (value && value.length > max) {
      res.status(400).json({ error: `${label} no puede superar los ${max} caracteres.` })
      return false
    }
  }
  return true
}

// Guardamos la ruta RELATIVA a UPLOAD_ROOT (no la ruta absoluta de disco).
// La ruta absoluta solo es válida en la máquina donde se subió el archivo;
// si la base de datos se comparte/copia entre laptops (o el proyecto vive en
// otra carpeta), una ruta absoluta guardada deja de existir ahí y el archivo
// "desaparece" (404) aunque sí se haya subido correctamente.
function resolveStoredPath(storedPath) {
  if (path.isAbsolute(storedPath)) return storedPath // compatibilidad con registros viejos
  return path.join(UPLOAD_ROOT, storedPath)
}

async function saveAttachments(table, fkColumn, ownerId, files) {
  if (!files || files.length === 0) return []
  const rows = files.map((f) => [
    crypto.randomUUID(),
    ownerId,
    f.originalname,
    path.relative(UPLOAD_ROOT, f.path),
    f.mimetype,
    f.size,
  ])
  await pool.query(
    `INSERT INTO ${table} (id, ${fkColumn}, original_name, stored_path, mime_type, size_bytes) VALUES ?`,
    [rows]
  )
  return rows.map(([id, , original_name, , mime_type, size_bytes]) => ({ id, original_name, mime_type, size_bytes }))
}

async function attachmentsByOwner(table, fkColumn, ownerIds) {
  if (ownerIds.length === 0) return {}
  const [rows] = await pool.query(
    `SELECT id, ${fkColumn} AS owner_id, original_name, mime_type, size_bytes, created_at FROM ${table} WHERE ${fkColumn} IN (?) ORDER BY created_at ASC`,
    [ownerIds]
  )
  const map = {}
  for (const r of rows) {
    if (!map[r.owner_id]) map[r.owner_id] = []
    map[r.owner_id].push({ id: r.id, original_name: r.original_name, mime_type: r.mime_type, size_bytes: r.size_bytes })
  }
  return map
}

// ---------------------------------------------------------------
// GET /api/classroom/feed/:groupId — anuncios + trabajos de un grupo (stream tipo Classroom)
router.get('/feed/:groupId', async (req, res) => {
  const { groupId } = req.params
  const { role, studentId, teacherId } = req.user

  if (role === 'Alumno') {
    const [s] = await pool.query('SELECT group_id FROM students WHERE id = ?', [studentId])
    if (!s[0] || s[0].group_id !== groupId) return res.status(403).json({ error: 'No perteneces a este grupo' })
  } else if (role === 'Docente') {
    const owns = await teacherOwnsGroup(teacherId, groupId)
    if (!owns) return res.status(403).json({ error: 'No impartes clase en este grupo' })
  }
  // Administrador / Control Escolar: acceso de solo consulta a cualquier grupo

  const [announcements] = await pool.query(
    `SELECT a.id, a.titulo, a.mensaje, a.created_at, t.nombre AS docente, s.nombre AS materia
     FROM announcements a
     JOIN teachers t ON t.id = a.teacher_id
     LEFT JOIN subjects s ON s.id = a.subject_id
     WHERE a.group_id = ? ORDER BY a.created_at DESC`,
    [groupId]
  )

  const [assignments] = await pool.query(
    `SELECT a.id, a.titulo, a.descripcion, a.tipo, a.fecha_limite, a.created_at, t.nombre AS docente, s.nombre AS materia
     FROM assignments a
     JOIN teachers t ON t.id = a.teacher_id
     LEFT JOIN subjects s ON s.id = a.subject_id
     WHERE a.group_id = ? ORDER BY a.created_at DESC`,
    [groupId]
  )

  const assignmentAttachments = await attachmentsByOwner('assignment_attachments', 'assignment_id', assignments.map((a) => a.id))

  let assignmentsWithStatus
  if (role === 'Alumno') {
    const submissionIds = assignments.map((a) => `${a.id}-${studentId}`)
    const submissionAttachments = await attachmentsByOwner('submission_attachments', 'submission_id', submissionIds)
    assignmentsWithStatus = await Promise.all(
      assignments.map(async (a) => {
        const [sub] = await pool.query('SELECT * FROM submissions WHERE assignment_id = ? AND student_id = ?', [a.id, studentId])
        const miEntrega = sub[0] ? { ...sub[0], adjuntos: submissionAttachments[sub[0].id] || [] } : null
        return { ...a, adjuntos: assignmentAttachments[a.id] || [], miEntrega }
      })
    )
  } else {
    assignmentsWithStatus = await Promise.all(
      assignments.map(async (a) => {
        const [rows] = await pool.query(
          `SELECT status, COUNT(*) AS n FROM submissions WHERE assignment_id = ? GROUP BY status`,
          [a.id]
        )
        const counts = { Pendiente: 0, Entregado: 0, 'Con retraso': 0, Revisado: 0 }
        for (const r of rows) counts[r.status] = r.n
        const total = Object.values(counts).reduce((x, y) => x + y, 0)
        return { ...a, adjuntos: assignmentAttachments[a.id] || [], resumenEntregas: { ...counts, total } }
      })
    )
  }

  const feed = [
    ...announcements.map((a) => ({ kind: 'anuncio', ...a })),
    ...assignmentsWithStatus.map((a) => ({ kind: 'trabajo', ...a })),
  ].sort((x, y) => new Date(y.created_at) - new Date(x.created_at))

  res.json(feed)
})

// POST /api/classroom/announcements — Docente publica un anuncio
router.post('/announcements', requireRole('Docente'), async (req, res) => {
  const { groupId, subjectId, titulo, mensaje } = req.body
  if (!groupId || !titulo || !mensaje) return res.status(400).json({ error: 'groupId, titulo y mensaje son requeridos' })
  if (!validateLengths(res, [['El título', titulo, TITLE_MAX], ['El mensaje', mensaje, TEXT_MAX]])) return

  const owns = await teacherOwnsGroup(req.user.teacherId, groupId)
  if (!owns) return res.status(403).json({ error: 'No impartes clase en este grupo' })

  const id = await nextId('AN-', 'announcements')
  await pool.query(
    'INSERT INTO announcements (id, teacher_id, group_id, subject_id, titulo, mensaje) VALUES (?, ?, ?, ?, ?, ?)',
    [id, req.user.teacherId, groupId, subjectId || null, titulo, mensaje]
  )
  const [rows] = await pool.query(
    `SELECT a.id, a.titulo, a.mensaje, a.created_at, t.nombre AS docente, s.nombre AS materia
     FROM announcements a JOIN teachers t ON t.id = a.teacher_id LEFT JOIN subjects s ON s.id = a.subject_id
     WHERE a.id = ?`,
    [id]
  )
  res.status(201).json({ kind: 'anuncio', ...rows[0] })
})

// POST /api/classroom/assignments — Docente publica un trabajo/tarea (con adjuntos opcionales)
router.post(
  '/assignments',
  requireRole('Docente'),
  // El id del trabajo aún no existe cuando multer decide la carpeta de destino,
  // así que subimos primero a una carpeta temporal por-request y la movemos
  // al id real ya generado, justo antes de guardar los registros en BD.
  (req, res, next) => {
    req.params.id = `tmp-${Date.now()}-${crypto.randomBytes(4).toString('hex')}`
    next()
  },
  handleUpload(uploadAssignmentFiles.array('archivos', MAX_FILES)),
  async (req, res) => {
    const { groupId, subjectId, titulo, descripcion, tipo, fechaLimite } = req.body
    if (!groupId || !titulo) return res.status(400).json({ error: 'groupId y titulo son requeridos' })
    if (!validateLengths(res, [['El título', titulo, TITLE_MAX], ['La descripción', descripcion, TEXT_MAX]])) return

    const owns = await teacherOwnsGroup(req.user.teacherId, groupId)
    if (!owns) return res.status(403).json({ error: 'No impartes clase en este grupo' })

    const id = await nextId('TR-', 'assignments')
    await pool.query(
      'INSERT INTO assignments (id, teacher_id, group_id, subject_id, titulo, descripcion, tipo, fecha_limite) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [id, req.user.teacherId, groupId, subjectId || null, titulo, descripcion || null, tipo || 'Tarea', fechaLimite || null]
    )

    // Mueve los archivos de la carpeta temporal a la carpeta definitiva del trabajo.
    const finalDir = path.join(UPLOAD_ROOT, 'assignments', id)
    fs.mkdirSync(finalDir, { recursive: true })
    const movedFiles = (req.files || []).map((f) => {
      const finalPath = path.join(finalDir, path.basename(f.path))
      fs.renameSync(f.path, finalPath)
      return { ...f, path: finalPath }
    })
    const adjuntos = await saveAttachments('assignment_attachments', 'assignment_id', id, movedFiles)

    // Crea automáticamente el registro "Pendiente" para cada alumno activo del grupo,
    // así el profesor ve de inmediato quién ha entregado y quién no.
    const [students] = await pool.query("SELECT id FROM students WHERE group_id = ? AND status = 'Activo'", [groupId])
    for (const s of students) {
      await pool.query('INSERT IGNORE INTO submissions (id, assignment_id, student_id, status) VALUES (?, ?, ?, ?)', [
        `${id}-${s.id}`,
        id,
        s.id,
        'Pendiente',
      ])
    }

    const [rows] = await pool.query(
      `SELECT a.id, a.titulo, a.descripcion, a.tipo, a.fecha_limite, a.created_at, t.nombre AS docente, s.nombre AS materia
       FROM assignments a JOIN teachers t ON t.id = a.teacher_id LEFT JOIN subjects s ON s.id = a.subject_id
       WHERE a.id = ?`,
      [id]
    )
    res.status(201).json({
      kind: 'trabajo',
      ...rows[0],
      adjuntos,
      resumenEntregas: { Pendiente: students.length, Entregado: 0, 'Con retraso': 0, Revisado: 0, total: students.length },
    })
  }
)

// GET /api/classroom/assignments/:id/submissions — Docente ve quién entregó
router.get('/assignments/:id/submissions', async (req, res) => {
  const { id } = req.params
  const [a] = await pool.query('SELECT * FROM assignments WHERE id = ?', [id])
  if (!a[0]) return res.status(404).json({ error: 'Trabajo no encontrado' })

  if (req.user.role === 'Docente' && a[0].teacher_id !== req.user.teacherId) {
    return res.status(403).json({ error: 'No tienes permiso para ver este trabajo' })
  }
  if (!['Docente', 'Administrador', 'Control Escolar'].includes(req.user.role)) {
    return res.status(403).json({ error: 'No tienes permiso para ver esta información' })
  }

  const [rows] = await pool.query(
    `SELECT sub.*, st.nombre AS alumno, st.expediente
     FROM submissions sub JOIN students st ON st.id = sub.student_id
     WHERE sub.assignment_id = ? ORDER BY st.no`,
    [id]
  )
  const attachmentsMap = await attachmentsByOwner('submission_attachments', 'submission_id', rows.map((r) => r.id))
  const entregas = rows.map((r) => ({ ...r, adjuntos: attachmentsMap[r.id] || [] }))
  res.json({ assignment: a[0], entregas })
})

// POST /api/classroom/assignments/:id/submit — Alumno sube su trabajo (archivos y/o comentario)
router.post(
  '/assignments/:id/submit',
  requireRole('Alumno'),
  handleUpload(uploadSubmissionFiles.array('archivos', MAX_FILES)),
  async (req, res) => {
    const { id } = req.params
    const { comentario } = req.body
    const studentId = req.user.studentId

    if (!validateLengths(res, [['El comentario', comentario, TEXT_MAX]])) return

    const [a] = await pool.query('SELECT * FROM assignments WHERE id = ?', [id])
    if (!a[0]) return res.status(404).json({ error: 'Trabajo no encontrado' })

    const [s] = await pool.query('SELECT group_id FROM students WHERE id = ?', [studentId])
    if (!s[0] || s[0].group_id !== a[0].group_id) {
      return res.status(403).json({ error: 'Este trabajo no corresponde a tu grupo' })
    }
    if ((!req.files || req.files.length === 0) && !(comentario && comentario.trim())) {
      return res.status(400).json({ error: 'Adjunta al menos un archivo o escribe un comentario para entregar' })
    }

    const now = new Date()
    const status = a[0].fecha_limite && now > new Date(`${a[0].fecha_limite}T23:59:59`) ? 'Con retraso' : 'Entregado'
    const submissionId = `${id}-${studentId}`

    await pool.query(
      `INSERT INTO submissions (id, assignment_id, student_id, status, comentario, entregado_at, calificacion, revisado_at)
       VALUES (?, ?, ?, ?, ?, NOW(), NULL, NULL)
       ON DUPLICATE KEY UPDATE
         status = VALUES(status), comentario = VALUES(comentario),
         entregado_at = NOW(), calificacion = NULL, revisado_at = NULL`,
      [submissionId, id, studentId, status, comentario || null]
    )

    // Cada nueva entrega reemplaza los adjuntos anteriores de esa entrega
    // (si el alumno "vuelve a entregar", no queremos acumular archivos viejos
    // de un intento anterior mezclados con los nuevos).
    if (req.files && req.files.length > 0) {
      const [oldFiles] = await pool.query('SELECT stored_path FROM submission_attachments WHERE submission_id = ?', [submissionId])
      await pool.query('DELETE FROM submission_attachments WHERE submission_id = ?', [submissionId])
      for (const f of oldFiles) {
        fs.unlink(resolveStoredPath(f.stored_path), () => {})
      }
    }
    const savedNow = await saveAttachments('submission_attachments', 'submission_id', submissionId, req.files)

    const [rows] = await pool.query('SELECT * FROM submissions WHERE id = ?', [submissionId])
    const finalAdjuntos =
      req.files && req.files.length > 0
        ? savedNow
        : (await attachmentsByOwner('submission_attachments', 'submission_id', [submissionId]))[submissionId] || []
    res.status(201).json({ ...rows[0], adjuntos: finalAdjuntos })
  }
)

// PATCH /api/classroom/submissions/:id — Docente califica / marca como revisado
router.patch('/submissions/:id', requireRole('Docente'), async (req, res) => {
  const { id } = req.params
  const { calificacion } = req.body

  // La calificación es opcional (se puede marcar "Revisado" sin nota), pero si
  // se manda, tiene que ser un número entre 1 y 10 — sin este chequeo, cualquier
  // request directo a la API (sin pasar por el input del frontend) podía guardar
  // valores fuera de rango como 999.
  let calificacionFinal = null
  if (calificacion !== undefined && calificacion !== null && calificacion !== '') {
    const num = Number(calificacion)
    if (Number.isNaN(num) || num < 1 || num > 10) {
      return res.status(400).json({ error: 'La calificación debe ser un número entre 1 y 10.' })
    }
    calificacionFinal = num
  }

  const [sub] = await pool.query('SELECT * FROM submissions WHERE id = ?', [id])
  if (!sub[0]) return res.status(404).json({ error: 'Entrega no encontrada' })

  const owns = await teacherOwnsAssignment(req.user.teacherId, sub[0].assignment_id)
  if (!owns) return res.status(403).json({ error: 'No tienes permiso sobre este trabajo' })

  await pool.query('UPDATE submissions SET status = ?, calificacion = ?, revisado_at = NOW() WHERE id = ?', [
    'Revisado',
    calificacionFinal,
    id,
  ])
  const [rows] = await pool.query(
    `SELECT sub.*, st.nombre AS alumno, st.expediente FROM submissions sub JOIN students st ON st.id = sub.student_id WHERE sub.id = ?`,
    [id]
  )
  res.json(rows[0])
})

// --- Adjuntos: verificación de permisos compartida ------------------------

async function canAccessAssignment(user, assignmentId) {
  const [a] = await pool.query('SELECT * FROM assignments WHERE id = ?', [assignmentId])
  if (!a[0]) return false
  const { role, studentId, teacherId } = user
  if (role === 'Administrador' || role === 'Control Escolar') return true
  if (role === 'Docente') return a[0].teacher_id === teacherId
  if (role === 'Alumno') {
    const [s] = await pool.query('SELECT group_id FROM students WHERE id = ?', [studentId])
    return !!s[0] && s[0].group_id === a[0].group_id
  }
  return false
}

async function canAccessSubmission(user, submissionId) {
  const [rows] = await pool.query('SELECT * FROM submissions WHERE id = ?', [submissionId])
  const sub = rows[0]
  if (!sub) return false
  const { role, studentId, teacherId } = user
  if (role === 'Administrador' || role === 'Control Escolar') return true
  if (role === 'Alumno') return studentId === sub.student_id
  if (role === 'Docente') return teacherOwnsAssignment(teacherId, sub.assignment_id)
  return false
}

// GET /api/classroom/assignments/:assignmentId/attachments/:attachmentId/download
// Adjunto de un trabajo publicado por el docente — visible a todo el grupo.
router.get('/assignments/:assignmentId/attachments/:attachmentId/download', async (req, res) => {
  const { assignmentId, attachmentId } = req.params
  const allowed = await canAccessAssignment(req.user, assignmentId)
  if (!allowed) return res.status(403).json({ error: 'No tienes permiso para ver este archivo' })

  const [rows] = await pool.query('SELECT * FROM assignment_attachments WHERE id = ? AND assignment_id = ?', [attachmentId, assignmentId])
  const file = rows[0]
  if (!file) return res.status(404).json({ error: 'Archivo no encontrado' })
  const resolved = resolveStoredPath(file.stored_path)
  if (!fs.existsSync(resolved)) return res.status(404).json({ error: 'El archivo ya no está disponible en el servidor' })
  res.download(resolved, file.original_name)
})

// GET /api/classroom/submissions/:submissionId/attachments/:attachmentId/download
// Adjunto de una entrega — visible solo al alumno dueño, su docente y administración.
router.get('/submissions/:submissionId/attachments/:attachmentId/download', async (req, res) => {
  const { submissionId, attachmentId } = req.params
  const allowed = await canAccessSubmission(req.user, submissionId)
  if (!allowed) return res.status(403).json({ error: 'No tienes permiso para descargar este archivo' })

  const [rows] = await pool.query('SELECT * FROM submission_attachments WHERE id = ? AND submission_id = ?', [attachmentId, submissionId])
  const file = rows[0]
  if (!file) return res.status(404).json({ error: 'Archivo no encontrado' })
  const resolved = resolveStoredPath(file.stored_path)
  if (!fs.existsSync(resolved)) return res.status(404).json({ error: 'El archivo ya no está disponible en el servidor' })
  res.download(resolved, file.original_name)
})

// GET /api/classroom/submissions/:id/download — legado: descarga el único
// archivo de entregas antiguas (guardado antes de que existiera la tabla
// submission_attachments). Se conserva para no romper entregas viejas.
router.get('/submissions/:id/download', async (req, res) => {
  const { id } = req.params
  const [rows] = await pool.query('SELECT * FROM submissions WHERE id = ?', [id])
  const sub = rows[0]
  if (!sub || !sub.archivo_ruta) return res.status(404).json({ error: 'Archivo no encontrado' })

  const allowed = await canAccessSubmission(req.user, id)
  if (!allowed) return res.status(403).json({ error: 'No tienes permiso para descargar este archivo' })

  const resolvedLegacy = resolveStoredPath(sub.archivo_ruta)
  if (!fs.existsSync(resolvedLegacy)) return res.status(404).json({ error: 'El archivo ya no está disponible en el servidor' })
  res.download(resolvedLegacy, sub.archivo_nombre || 'archivo')
})

module.exports = router