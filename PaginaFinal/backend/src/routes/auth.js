const asyncRouter = require('../utils/asyncRouter')
const jwt = require('jsonwebtoken')
const pool = require('../db')
const { requireAuth } = require('../middleware/auth')

const router = asyncRouter()

function issueToken(res, payload) {
  const token = jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '8h',
  })
  res.json({ token, user: payload })
}

// POST /api/auth/login
router.post('/login', async (req, res) => {
  const { username, password } = req.body
  if (!username || !password) {
    return res.status(400).json({ error: 'username y password son requeridos' })
  }

  try {
    // 1. Administradores (login con expediente o correo)
    const [admins] = await pool.query(
      'SELECT * FROM administradores WHERE expediente = ? OR correo = ?',
      [username, username]
    )
    if (admins[0]) {
      const admin = admins[0]
      if (admin.contrasena !== password) {
        return res.status(401).json({ error: 'Usuario o contraseña incorrectos' })
      }
      return issueToken(res, {
        id: admin.id,
        username: admin.expediente,
        nombre: admin.nombre,
        role: 'Administrador',
        studentId: null,
        teacherId: null,
      })
    }

    // 1b. Vinculación (login con expediente o correo) — tabla dedicada,
    // separada de administradores. Único rol con acceso a préstamos de biblioteca.
    const [vinculacion] = await pool.query(
      'SELECT * FROM vinculacion WHERE expediente = ? OR correo = ?',
      [username, username]
    )
    if (vinculacion[0]) {
      const usuario = vinculacion[0]
      if (usuario.contrasena !== password) {
        return res.status(401).json({ error: 'Usuario o contraseña incorrectos' })
      }
      return issueToken(res, {
        id: usuario.id,
        username: usuario.expediente,
        nombre: usuario.nombre,
        role: 'Vinculacion',
        studentId: null,
        teacherId: null,
      })
    }

    // 2. Docentes (login con id institucional o correo)
    const [teachers] = await pool.query(
      'SELECT * FROM teachers WHERE id = ? OR email = ?',
      [username, username]
    )
    if (teachers[0]) {
      const teacher = teachers[0]
      if (teacher.contrasena !== password) {
        return res.status(401).json({ error: 'Usuario o contraseña incorrectos' })
      }
      return issueToken(res, {
        id: teacher.id,
        username: teacher.id,
        nombre: teacher.nombre,
        role: 'Docente',
        studentId: null,
        teacherId: teacher.id,
      })
    }

    // 3. Alumnos (login con expediente)
    const [students] = await pool.query(
      'SELECT * FROM students WHERE expediente = ?',
      [username]
    )
    if (students[0]) {
      const student = students[0]
      if (student.contrasena !== password) {
        return res.status(401).json({ error: 'Usuario o contraseña incorrectos' })
      }
      return issueToken(res, {
        id: student.id,
        username: student.expediente,
        nombre: student.nombre,
        role: 'Alumno',
        studentId: student.id,
        teacherId: null,
      })
    }

    return res.status(401).json({ error: 'Usuario o contraseña incorrectos' })
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Error al iniciar sesión' })
  }
})

// GET /api/auth/me
router.get('/me', requireAuth, (req, res) => {
  res.json(req.user)
})

module.exports = router