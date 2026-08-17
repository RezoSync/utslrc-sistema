-- Migración: módulo Biblioteca (catálogo y préstamos)
-- Úsala si ya tienes una base de datos con información cargada y NO quieres
-- volver a correr schema.sql (que borra y recrea todo).
--
--   mysql -u root -p utslrc_sistema < sql/migration_library.sql

SET NAMES utf8mb4;
USE utslrc_sistema;

CREATE TABLE IF NOT EXISTS books (
  id              VARCHAR(20) COLLATE utf8mb4_unicode_ci PRIMARY KEY,
  isbn            VARCHAR(20) COLLATE utf8mb4_unicode_ci NULL UNIQUE,
  titulo          VARCHAR(300) NOT NULL,
  autor           VARCHAR(300) NOT NULL,
  categoria       VARCHAR(100) NOT NULL DEFAULT 'General',
  ejemplares      INT NOT NULL DEFAULT 1,
  disponibles     INT NOT NULL DEFAULT 1,
  portada         VARCHAR(500) NULL,
  google_books_id VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS loans (
  id                VARCHAR(20) COLLATE utf8mb4_unicode_ci PRIMARY KEY,
  book_id           VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  student_id        VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  fecha_prestamo    DATE NOT NULL,
  fecha_limite      DATE NOT NULL,
  fecha_devolucion  DATE NULL,
  status            ENUM('Vigente','Vencido','Devuelto') NOT NULL DEFAULT 'Vigente',
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;