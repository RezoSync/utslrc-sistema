-- Migración: módulo "Plataforma de Trabajos" (anuncios, tareas y entregas).
-- Estas tablas están en sql/schema.sql pero faltaban en baseDeDatosActual.sql,
-- por eso el backend tronaba con "Table 'utslrc_sistema.announcements' doesn't exist"
-- al abrir Plataforma de Trabajos (o el feed del dashboard).
--
-- Ejecutar una sola vez sobre la base de datos ya importada:
--   mysql -u root -p utslrc_sistema < sql/classroom.sql

CREATE TABLE IF NOT EXISTS `announcements` (
  `id` varchar(20) NOT NULL,
  `teacher_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `group_id` (`group_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `announcements_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `announcements_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `assignments` (
  `id` varchar(20) NOT NULL,
  `teacher_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo` enum('Tarea','Proyecto','Exposición','Investigación') NOT NULL DEFAULT 'Tarea',
  `fecha_limite` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `group_id` (`group_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assignments_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `submissions` (
  `id` varchar(30) NOT NULL,
  `assignment_id` varchar(20) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `status` enum('Pendiente','Entregado','Con retraso','Revisado') NOT NULL DEFAULT 'Pendiente',
  `comentario` text DEFAULT NULL,
  `archivo_nombre` varchar(255) DEFAULT NULL,
  `archivo_ruta` varchar(500) DEFAULT NULL,
  `calificacion` decimal(4,1) DEFAULT NULL,
  `entregado_at` datetime DEFAULT NULL,
  `revisado_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assignment_student` (`assignment_id`, `student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
