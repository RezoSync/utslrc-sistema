-- Migración: módulo Classroom (anuncios, trabajos y entregas)
-- Úsala si ya tienes una base de datos con información cargada y NO quieres
-- volver a correr schema.sql (que borra y recrea todo).
--
--   mysql -u root -p utslrc_sistema < sql/migration_classroom.sql

SET NAMES utf8mb4;
USE utslrc_sistema;

CREATE TABLE IF NOT EXISTS announcements (
  id         VARCHAR(20) PRIMARY KEY,
  teacher_id VARCHAR(10) NOT NULL,
  group_id   VARCHAR(20) NOT NULL,
  subject_id VARCHAR(10) NULL,
  titulo     VARCHAR(200) NOT NULL,
  mensaje    TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS assignments (
  id           VARCHAR(20) PRIMARY KEY,
  teacher_id   VARCHAR(10) NOT NULL,
  group_id     VARCHAR(20) NOT NULL,
  subject_id   VARCHAR(10) NULL,
  titulo       VARCHAR(200) NOT NULL,
  descripcion  TEXT,
  tipo         ENUM('Tarea','Proyecto','Exposición','Investigación') NOT NULL DEFAULT 'Tarea',
  fecha_limite DATE NULL,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS submissions (
  id             VARCHAR(30) PRIMARY KEY,
  assignment_id  VARCHAR(20) NOT NULL,
  student_id     VARCHAR(10) NOT NULL,
  status         ENUM('Pendiente','Entregado','Con retraso','Revisado') NOT NULL DEFAULT 'Pendiente',
  comentario     TEXT NULL,
  archivo_nombre VARCHAR(255) NULL,
  archivo_ruta   VARCHAR(500) NULL,
  calificacion   DECIMAL(4,1) NULL,
  entregado_at   DATETIME NULL,
  revisado_at    DATETIME NULL,
  UNIQUE KEY uq_assignment_student (assignment_id, student_id),
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
