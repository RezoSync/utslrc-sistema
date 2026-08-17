require('dotenv').config()
const express = require('express')
const cors = require('cors')

const authRoutes = require('./src/routes/auth')
const publicRoutes = require('./src/routes/public')
const studentsRoutes = require('./src/routes/students')
const groupsRoutes = require('./src/routes/groups')
const teachersRoutes = require('./src/routes/teachers')
const subjectsRoutes = require('./src/routes/subjects')
const careersRoutes = require('./src/routes/careers')
const schedulesRoutes = require('./src/routes/schedules')
const gradesRoutes = require('./src/routes/grades')
const attendanceRoutes = require('./src/routes/attendance')
const servicesRoutes = require('./src/routes/services')
const enrollmentsRoutes = require('./src/routes/enrollments')
const classroomRoutes = require('./src/routes/classroom')
const libraryRoutes = require('./src/routes/library')
const inventoryRoutes = require('./src/routes/inventory')

const app = express()

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }))
app.use(express.json())

app.get('/api/health', (req, res) => res.json({ ok: true }))

app.use('/api/auth', authRoutes)
app.use('/api/public', publicRoutes)
app.use('/api/students', studentsRoutes)
app.use('/api/groups', groupsRoutes)
app.use('/api/teachers', teachersRoutes)
app.use('/api/subjects', subjectsRoutes)
app.use('/api/careers', careersRoutes)
app.use('/api/schedules', schedulesRoutes)
app.use('/api/grades', gradesRoutes)
app.use('/api/attendance', attendanceRoutes)
app.use('/api/services', servicesRoutes)
app.use('/api/enrollments', enrollmentsRoutes)
app.use('/api/classroom', classroomRoutes)
app.use('/api/library', libraryRoutes)
app.use('/api/inventory', inventoryRoutes)

// 404
app.use((req, res) => res.status(404).json({ error: 'Ruta no encontrada' }))

// Manejador de errores
app.use((err, req, res, next) => {
  console.error(err)
  res.status(500).json({ error: 'Error interno del servidor' })
})

const PORT = process.env.PORT || 57913
app.listen(PORT, () => {
  console.log(`API escuchando en http://localhost:${PORT}`)
})