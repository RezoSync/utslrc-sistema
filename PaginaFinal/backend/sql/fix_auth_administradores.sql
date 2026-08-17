-- Migración: alinear la base de datos con el login nuevo (backend/src/routes/auth.js),
-- que ahora consulta `administradores`, `teachers.contrasena` y `students.contrasena`
-- en texto plano, en vez de la tabla `users` con bcrypt que se usaba antes.
--
-- Ejecútalo UNA vez sobre tu base ya importada (phpMyAdmin > Importar,
-- o pégalo en la pestaña SQL). No borra nada de lo que ya tienes.

USE utslrc_sistema;

-- 1) Tabla de administradores (no existía)
CREATE TABLE IF NOT EXISTS administradores (
  id         varchar(10)  NOT NULL,
  nombre     varchar(150) NOT NULL,
  correo     varchar(150) NOT NULL,
  expediente varchar(20)  NOT NULL,
  contrasena varchar(255) NOT NULL DEFAULT '12345678',
  PRIMARY KEY (id),
  UNIQUE KEY correo (correo),
  UNIQUE KEY expediente (expediente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Cuenta de administrador para que puedas entrar
--    Usuario: admin   /   Contraseña: admin123
INSERT INTO administradores (id, nombre, correo, expediente, contrasena) VALUES
  ('ADM001', 'Administrador General', 'admin@utslrc.edu.mx', 'admin', 'admin123')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- 3) Columna de contraseña en teachers (no existía)
--    Todos los docentes existentes quedan con contraseña por defecto: 12345678
ALTER TABLE teachers
  ADD COLUMN IF NOT EXISTS contrasena varchar(255) NOT NULL DEFAULT '12345678';

-- 4) Columna de contraseña en students (no existía)
--    Todos los alumnos existentes quedan con contraseña por defecto: 12345678
ALTER TABLE students
  ADD COLUMN IF NOT EXISTS contrasena varchar(255) NOT NULL DEFAULT '12345678';
