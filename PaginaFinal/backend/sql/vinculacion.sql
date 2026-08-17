-- Tabla dedicada para el rol "Vinculación" (independiente de administradores).
-- Es el único rol con acceso a préstamos de biblioteca: alumnos, docentes y
-- administradores ya no pueden ver ni registrar préstamos.

CREATE TABLE IF NOT EXISTS vinculacion (
  id         varchar(10)  NOT NULL,
  nombre     varchar(150) NOT NULL,
  correo     varchar(150) NOT NULL,
  expediente varchar(20)  NOT NULL,
  contrasena varchar(255) NOT NULL DEFAULT '12345678',
  PRIMARY KEY (id),
  UNIQUE KEY correo (correo),
  UNIQUE KEY expediente (expediente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Cuenta de ejemplo para iniciar sesión con el rol Vinculación.
--   Usuario: vinculacion   /   Contraseña: vinculacion123
-- Cambia la contraseña después de probar.
INSERT INTO vinculacion (id, nombre, correo, expediente, contrasena) VALUES
  ('VIN001', 'Vinculación', 'vinculacion@utslrc.edu.mx', 'vinculacion', 'vinculacion123')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- Si en algún momento ejecutaste la migración anterior (add_rol_vinculacion.sql)
-- que agregaba una columna `rol` a `administradores`, puedes quitarla; ya no
-- se usa (ahora Vinculación vive en su propia tabla):
-- ALTER TABLE administradores DROP COLUMN rol;
