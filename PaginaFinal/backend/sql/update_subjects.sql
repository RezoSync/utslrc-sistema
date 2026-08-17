USE utslrc_sistema;
SET FOREIGN_KEY_CHECKS = 0;

-- Delete old subjects
DELETE FROM subjects;

-- Insert 21 new subjects (7 for each of the 3 groups)
INSERT INTO `subjects` (`id`, `nombre`, `group_id`, `teacher_id`, `docente_nombre`, `creditos`, `horas por cuatrimestre`, `required_room`, `sessions_per_week`) VALUES
-- IDGS 8-1
('MAT01-81', 'Algebra Lineal', 'IDGS 8-1', 'DOC001', 'Ana Sarahí Yeomans Aguirre', 6, 90, 'GENERAL', 6),
('MAT02-81', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-1', 'DOC002', 'Carlos Ramírez', 5, 45, 'GENERAL', 5),
('MAT03-81', 'Fundamentos de TI', 'IDGS 8-1', 'DOC003', 'Mariana Molina Parra', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-81', 'Fundamentos de Redes', 'IDGS 8-1', 'DOC004', 'Paola Torres Félix', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-81', 'Ingles', 'IDGS 8-1', 'DOC002', 'Carlos Ramírez', 4, 60, 'GENERAL', 4),
('MAT08-81', 'Expresion oral y escrita', 'IDGS 8-1', 'DOC005', 'Martha Olivia García Zavala', 4, 75, 'GENERAL', 4),
('MAT09-81', 'Formacion sociocultural I', 'IDGS 8-1', 'DOC008', 'Mariana Molina', 5, 30, 'GENERAL', 5),

-- IDGS 8-2
('MAT01-82', 'Algebra Lineal', 'IDGS 8-2', 'DOC001', 'Ana Sarahí Yeomans Aguirre', 6, 90, 'GENERAL', 6),
('MAT02-82', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-2', 'DOC002', 'Carlos Ramírez', 5, 45, 'GENERAL', 5),
('MAT03-82', 'Fundamentos de TI', 'IDGS 8-2', 'DOC003', 'Mariana Molina Parra', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-82', 'Fundamentos de Redes', 'IDGS 8-2', 'DOC004', 'Paola Torres Félix', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-82', 'Ingles', 'IDGS 8-2', 'DOC002', 'Carlos Ramírez', 4, 60, 'GENERAL', 4),
('MAT08-82', 'Expresion oral y escrita', 'IDGS 8-2', 'DOC005', 'Martha Olivia García Zavala', 4, 75, 'GENERAL', 4),
('MAT09-82', 'Formacion sociocultural I', 'IDGS 8-2', 'DOC008', 'Mariana Molina', 5, 30, 'GENERAL', 5),

-- IDGS 8-3
('MAT01-83', 'Algebra Lineal', 'IDGS 8-3', 'DOC001', 'Ana Sarahí Yeomans Aguirre', 6, 90, 'GENERAL', 6),
('MAT02-83', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-3', 'DOC002', 'Carlos Ramírez', 5, 45, 'GENERAL', 5),
('MAT03-83', 'Fundamentos de TI', 'IDGS 8-3', 'DOC003', 'Mariana Molina Parra', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-83', 'Fundamentos de Redes', 'IDGS 8-3', 'DOC004', 'Paola Torres Félix', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-83', 'Ingles', 'IDGS 8-3', 'DOC002', 'Carlos Ramírez', 4, 60, 'GENERAL', 4),
('MAT08-83', 'Expresion oral y escrita', 'IDGS 8-3', 'DOC005', 'Martha Olivia García Zavala', 4, 75, 'GENERAL', 4),
('MAT09-83', 'Formacion sociocultural I', 'IDGS 8-3', 'DOC008', 'Mariana Molina', 5, 30, 'GENERAL', 5);

-- Update enrollments subject_ids based on student group to preserve enrollments
UPDATE enrollments e JOIN students s ON e.student_id = s.id SET e.subject_id = CONCAT(e.subject_id, '-81') WHERE s.group_id = 'IDGS 8-1' AND e.subject_id NOT LIKE '%-81';
UPDATE enrollments e JOIN students s ON e.student_id = s.id SET e.subject_id = CONCAT(e.subject_id, '-82') WHERE s.group_id = 'IDGS 8-2' AND e.subject_id NOT LIKE '%-82';
UPDATE enrollments e JOIN students s ON e.student_id = s.id SET e.subject_id = CONCAT(e.subject_id, '-83') WHERE s.group_id = 'IDGS 8-3' AND e.subject_id NOT LIKE '%-83';
UPDATE enrollments e JOIN students s ON e.student_id = s.id SET e.id = CONCAT(s.id, '-EN-', e.subject_id);

-- Update grade_records subject_ids based on student group to preserve grades
UPDATE grade_records g JOIN students s ON g.student_id = s.id SET g.subject_id = CONCAT(g.subject_id, '-81') WHERE s.group_id = 'IDGS 8-1' AND g.subject_id NOT LIKE '%-81';
UPDATE grade_records g JOIN students s ON g.student_id = s.id SET g.subject_id = CONCAT(g.subject_id, '-82') WHERE s.group_id = 'IDGS 8-2' AND g.subject_id NOT LIKE '%-82';
UPDATE grade_records g JOIN students s ON g.student_id = s.id SET g.subject_id = CONCAT(g.subject_id, '-83') WHERE s.group_id = 'IDGS 8-3' AND g.subject_id NOT LIKE '%-83';
UPDATE grade_records g JOIN students s ON g.student_id = s.id SET g.id = CONCAT(s.id, '-', g.subject_id);

-- Clear obsolete schedules
DELETE FROM schedule_slots;

SET FOREIGN_KEY_CHECKS = 1;
