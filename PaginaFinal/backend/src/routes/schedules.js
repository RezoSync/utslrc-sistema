const asyncRouter = require('../utils/asyncRouter')
const pool = require('../db')
const { requireAuth, requireRole } = require('../middleware/auth')

const router = asyncRouter()
router.use(requireAuth)

// GET /api/schedules?grupo=IDGS%208-3
router.get('/', async (req, res) => {
  const { grupo } = req.query
  let sql = `
    SELECT sl.id, sl.group_id, sl.dia, sl.hora, sl.aula,
           s.id AS subject_id, s.nombre AS materia, s.docente_nombre AS docente
    FROM schedule_slots sl
    JOIN subjects s ON s.id = sl.subject_id
    JOIN \`groups\` g ON g.id = sl.group_id
    WHERE 1=1`
  const params = []
  if (grupo) {
    sql += ' AND sl.group_id = ?'
    params.push(grupo)
  }
  if (req.user.role === 'Administrador') {
    sql += ' AND g.career_id = ?'
    params.push('IDGS')
  }
  sql += ' ORDER BY FIELD(sl.dia, "Lunes","Martes","Miércoles","Jueves","Viernes"), sl.hora'

  const [rows] = await pool.query(sql, params)
  res.json(rows)
})

router.post('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { group_id, dia, hora, subject_id, aula } = req.body
  if (!group_id || !dia || !hora || !subject_id) {
    return res.status(400).json({ error: 'group_id, dia, hora y subject_id son requeridos' })
  }
  const [result] = await pool.query(
    'INSERT INTO schedule_slots (group_id, dia, hora, subject_id, aula) VALUES (?, ?, ?, ?, ?)',
    [group_id, dia, hora, subject_id, aula || null]
  )
  const [rows] = await pool.query('SELECT * FROM schedule_slots WHERE id = ?', [result.insertId])
  res.status(201).json(rows[0])
})

router.put('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const fields = ['group_id', 'dia', 'hora', 'subject_id', 'aula']
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

  const [result] = await pool.query(`UPDATE schedule_slots SET ${updates.join(', ')} WHERE id = ?`, params)
  if (!result.affectedRows) return res.status(404).json({ error: 'Horario no encontrado' })
  const [rows] = await pool.query('SELECT * FROM schedule_slots WHERE id = ?', [req.params.id])
  res.json(rows[0])
})

// DELETE /api/schedules - Eliminar todos los horarios de una carrera y cuatrimestre
router.delete('/', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { career, cuatrimestre } = req.query
  if (!career || !cuatrimestre) {
    return res.status(400).json({ error: 'Se requieren los parámetros de consulta career y cuatrimestre' })
  }
  
  try {
    // Eliminar solo los slots asociados a grupos de esa carrera y cuatrimestre
    await pool.query(`
      DELETE sl FROM schedule_slots sl
      JOIN \`groups\` g ON sl.group_id = g.id
      WHERE g.career_id = ? AND g.cuatrimestre = ?
    `, [career, cuatrimestre])
    
    res.json({ 
      success: true, 
      message: `Los horarios de la carrera ${career} para el cuatrimestre ${cuatrimestre} fueron eliminados correctamente.` 
    })
  } catch (error) {
    console.error('Error al eliminar los horarios filtrados:', error)
    res.status(500).json({ error: 'Error interno del servidor al eliminar los horarios.' })
  }
})

// POST /api/schedules/save - Guardar bulk de horarios
router.post('/save', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { slots } = req.body
  if (!Array.isArray(slots)) {
    return res.status(400).json({ error: 'slots debe ser un array' })
  }
  
  const connection = await pool.getConnection()
  try {
    await connection.beginTransaction()
    
    // Eliminar horarios anteriores
    await connection.query('DELETE FROM schedule_slots')
    
    // Insertar los nuevos slots
    for (const slot of slots) {
      let subjectId = slot.subjectId
      
      // Fallback a buscar por nombre y grupo si no viene subjectId
      if (!subjectId) {
        const [subj] = await connection.query(
          'SELECT id FROM subjects WHERE nombre = ? AND group_id = ?', 
          [slot.materia, slot.grupo]
        )
        subjectId = subj.length > 0 ? subj[0].id : null
      }
      
      if (subjectId) {
        await connection.query(
          'INSERT INTO schedule_slots (group_id, dia, hora, subject_id, aula) VALUES (?, ?, ?, ?, ?)',
          [slot.grupo, slot.dia, slot.hora, subjectId, slot.aula]
        )
      }
    }
    
    await connection.commit()
    res.json({ success: true, message: 'Horarios guardados correctamente en la base de datos.' })
  } catch (error) {
    await connection.rollback()
    console.error('Error al guardar horarios:', error)
    res.status(500).json({ error: 'Error interno del servidor al guardar los horarios.' })
  } finally {
    connection.release()
  }
})

router.delete('/:id', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const [result] = await pool.query('DELETE FROM schedule_slots WHERE id = ?', [req.params.id])
  if (!result.affectedRows) return res.status(404).json({ error: 'Horario no encontrado' })
  res.status(204).end()
})

// POST /api/schedules/generate
router.post('/generate', requireRole('Administrador', 'Control Escolar'), async (req, res) => {
  const { spawn } = require('child_process')
  const path = require('path')
  const fs = require('fs')

  try {
    const pythonPathWindows = path.join(__dirname, '..', '..', '..', 'app', 'timetable_mvp', 'venv', 'Scripts', 'python.exe')
    const pythonPathUnix = path.join(__dirname, '..', '..', '..', 'app', 'timetable_mvp', 'venv', 'bin', 'python')
    const scriptPath = path.join(__dirname, '..', '..', '..', 'app', 'timetable_mvp', 'scheduler.py')

    let pythonPath = pythonPathWindows
    if (!fs.existsSync(pythonPath)) {
      pythonPath = pythonPathUnix
    }

    if (!fs.existsSync(pythonPath)) {
      pythonPath = 'python'
    }

    console.log(`Ejecutando script de horarios con: ${pythonPath}`)

    // Pasar variables de entorno del backend (DB_HOST, etc.)
    const env = {
      ...process.env,
      DB_HOST: process.env.DB_HOST || 'localhost',
      DB_PORT: process.env.DB_PORT || '3306',
      DB_USER: process.env.DB_USER || 'root',
      DB_PASSWORD: process.env.DB_PASSWORD || '',
      DB_NAME: process.env.DB_NAME || 'utslrc_sistema'
    }

    const pythonProcess = spawn(pythonPath, [scriptPath], { env })

    let stdout = ''
    let stderr = ''

    pythonProcess.stdout.on('data', (data) => {
      stdout += data.toString()
    })

    pythonProcess.stderr.on('data', (data) => {
      stderr += data.toString()
    })

    pythonProcess.on('close', (code) => {
      console.log(`Proceso de generación finalizó con código: ${code}`)
      if (code === 0) {
        let slots = []
        try {
          const startIndex = stdout.indexOf('JSON_START')
          const endIndex = stdout.indexOf('JSON_END')
          if (startIndex !== -1 && endIndex !== -1) {
            const jsonText = stdout.substring(startIndex + 'JSON_START'.length, endIndex).trim()
            slots = JSON.parse(jsonText)
          }
        } catch (e) {
          console.error('Error al parsear el JSON del solver:', e)
        }
        res.json({ 
          success: true, 
          message: 'Horarios generados correctamente (Borrador). Presiona Guardar para confirmar.', 
          slots 
        })
      } else {
        console.error('Error del solver en python:', stderr || stdout)
        res.status(500).json({ error: 'Error al generar los horarios.', details: stderr || stdout })
      }
    })
  } catch (error) {
    console.error('Error al iniciar el generador de horarios:', error)
    res.status(500).json({ error: 'Error interno al ejecutar el generador de horarios.' })
  }
})

module.exports = router
