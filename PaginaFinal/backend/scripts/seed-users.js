// Crea usuarios iniciales con contraseña encriptada.
// Uso: npm run seed:users
require('dotenv').config()
const bcrypt = require('bcryptjs')
const pool = require('../src/db')

// Cambia estos usuarios/contraseñas antes de usar en producción.
const USERS = [
  { username: 'admin', password: 'admin123', nombre: 'Administrador General', role: 'Administrador' },
  { username: 'control', password: 'control123', nombre: 'Control Escolar', role: 'Control Escolar' },
  { username: 'mmolina', password: 'docente123', nombre: 'Ing. Mariana Molina Parra', role: 'Docente', teacher_id: 'DOC003' },
  { username: '23304059', password: 'alumno123', nombre: 'ALCALA FELIX VLADIMIR EMANUEL', role: 'Alumno', student_id: 'AL046' },
]

async function main() {
  for (const u of USERS) {
    const hash = await bcrypt.hash(u.password, 10)
    try {
      await pool.query(
        'INSERT INTO users (username, password_hash, nombre, role, student_id, teacher_id) VALUES (?, ?, ?, ?, ?, ?)',
        [u.username, hash, u.nombre, u.role, u.student_id || null, u.teacher_id || null]
      )
      console.log(`Creado: ${u.username} (${u.role})`)
    } catch (err) {
      if (err.code === 'ER_DUP_ENTRY') {
        console.log(`Ya existe: ${u.username}`)
      } else {
        console.error(`Error creando ${u.username}:`, err.message)
      }
    }
  }
  await pool.end()
}

main()
