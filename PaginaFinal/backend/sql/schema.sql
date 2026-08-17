-- Esquema de base de datos - Sistema Escolar UTSLRC (IDGS 8-3)
-- MySQL 8+

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS utslrc_sistema CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE utslrc_sistema;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS announcements;
DROP TABLE IF EXISTS schedule_slots;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS service_tickets;
DROP TABLE IF EXISTS attendance_summary;
DROP TABLE IF EXISTS grade_records;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS teacher_groups;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS `groups`;
DROP TABLE IF EXISTS careers;

-- ---------------------------------------------------------------
CREATE TABLE careers (
  id           VARCHAR(10)  PRIMARY KEY,
  nombre       VARCHAR(150) NOT NULL,
  siglas       VARCHAR(10)  NOT NULL,
  nivel        VARCHAR(50)  NOT NULL,
  duracion     VARCHAR(50)  NOT NULL,
  modalidad    VARCHAR(50)  NOT NULL,
  descripcion  TEXT
);

CREATE TABLE `groups` (
  id           VARCHAR(20)  PRIMARY KEY,   -- ej. 'IDGS 8-3'
  nombre       VARCHAR(20)  NOT NULL,
  career_id    VARCHAR(10)  NOT NULL,
  cuatrimestre VARCHAR(10)  NOT NULL,
  periodo      VARCHAR(50)  NOT NULL,
  aula         VARCHAR(50),
  turno        VARCHAR(20),
  FOREIGN KEY (career_id) REFERENCES careers(id) ON DELETE RESTRICT
);

CREATE TABLE teachers (
  id     VARCHAR(10)  PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  grado  VARCHAR(50),
  email  VARCHAR(150) UNIQUE
);

CREATE TABLE teacher_groups (
  teacher_id VARCHAR(10) NOT NULL,
  group_id   VARCHAR(20) NOT NULL,
  PRIMARY KEY (teacher_id, group_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE
);

CREATE TABLE students (
  id           VARCHAR(10)  PRIMARY KEY,   -- ej. 'AL045'
  no           INT          NOT NULL,
  expediente   VARCHAR(20)  NOT NULL,
  nombre       VARCHAR(150) NOT NULL,
  group_id     VARCHAR(20)  NOT NULL,
  email        VARCHAR(150) UNIQUE,
  status       ENUM('Activo','Baja temporal','Egresado') NOT NULL DEFAULT 'Activo',
  career_id    VARCHAR(10)  NOT NULL,
  cuatrimestre VARCHAR(10),
  periodo      VARCHAR(50),
  promedio     DECIMAL(3,1) DEFAULT 0,
  asistencia   INT          DEFAULT 0,
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE RESTRICT,
  FOREIGN KEY (career_id) REFERENCES careers(id) ON DELETE RESTRICT
);

CREATE TABLE subjects (
  id             VARCHAR(10)  PRIMARY KEY,  -- ej. 'MAT06'
  nombre         VARCHAR(150) NOT NULL,
  group_id       VARCHAR(20)  NOT NULL,
  teacher_id     VARCHAR(10)  NULL,         -- puede ser NULL (ej. 'Academia TI')
  docente_nombre VARCHAR(150),              -- nombre visible aunque no exista teacher_id
  creditos       INT          DEFAULT 0,
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL
);

CREATE TABLE grade_records (
  id           VARCHAR(20)  PRIMARY KEY,   -- ej. 'AL045-MAT06'
  student_id   VARCHAR(10)  NOT NULL,
  subject_id   VARCHAR(10)  NOT NULL,
  parcial      ENUM('Parcial 1','Parcial 2','Parcial 3') NOT NULL DEFAULT 'Parcial 1',
  evidencias   DECIMAL(3,1) NOT NULL,
  conocimiento DECIMAL(3,1) NOT NULL,
  desempeno    DECIMAL(3,1) NOT NULL,
  actitud      DECIMAL(3,1) NOT NULL,
  examen       DECIMAL(3,1) NOT NULL,
  final        DECIMAL(3,1) NOT NULL,
  UNIQUE KEY uq_student_subject_parcial (student_id, subject_id, parcial),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE attendance_summary (
  student_id  VARCHAR(10)  PRIMARY KEY,
  asistencias INT NOT NULL DEFAULT 0,
  faltas      INT NOT NULL DEFAULT 0,
  retardos    INT NOT NULL DEFAULT 0,
  porcentaje  INT NOT NULL DEFAULT 0,
  estado      ENUM('Regular','En riesgo','Crítico') NOT NULL DEFAULT 'Regular',
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE service_tickets (
  id         VARCHAR(20) PRIMARY KEY,      -- ej. 'TK-1005'
  folio      VARCHAR(30) UNIQUE NOT NULL,
  student_id VARCHAR(10) NOT NULL,
  tipo       VARCHAR(50) NOT NULL,
  categoria  ENUM('Trámite escolar','Soporte / Incidencia') NOT NULL,
  fecha      DATE NOT NULL,
  status     VARCHAR(30) NOT NULL,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE enrollments (
  id         VARCHAR(30) PRIMARY KEY,      -- ej. 'AL045-EN-MAT06'
  student_id VARCHAR(10) NOT NULL,
  subject_id VARCHAR(10) NOT NULL,
  periodo    VARCHAR(50) NOT NULL,
  status     ENUM('Inscrito','Pendiente de pago','Baja') NOT NULL DEFAULT 'Inscrito',
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE schedule_slots (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  group_id   VARCHAR(20) NOT NULL,
  dia        VARCHAR(15) NOT NULL,
  hora       VARCHAR(20) NOT NULL,
  subject_id VARCHAR(10) NOT NULL,
  aula       VARCHAR(50),
  FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Usuarios reales del sistema (login con JWT + bcrypt)
CREATE TABLE users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  nombre        VARCHAR(150) NOT NULL,
  role          ENUM('Administrador','Control Escolar','Docente','Alumno') NOT NULL,
  student_id    VARCHAR(10) NULL,
  teacher_id    VARCHAR(10) NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE SET NULL,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL
);

-- ---------------------------------------------------------------
-- Classroom: anuncios y trabajos por grupo/materia, con entregas de alumnos
CREATE TABLE announcements (
  id         VARCHAR(20) PRIMARY KEY,     -- ej. 'AN-0001'
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

CREATE TABLE assignments (
  id           VARCHAR(20) PRIMARY KEY,   -- ej. 'TR-0001'
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

CREATE TABLE submissions (
  id             VARCHAR(30) PRIMARY KEY, -- ej. 'TR-0001-AL045'
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

SET FOREIGN_KEY_CHECKS = 1;
