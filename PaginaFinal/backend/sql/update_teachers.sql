USE utslrc_sistema;
SET FOREIGN_KEY_CHECKS = 0;

-- Clean subjects
DELETE FROM subjects;

-- Insert new subjects with the new teacher_id and names
INSERT INTO `subjects` (`id`, `nombre`, `group_id`, `teacher_id`, `docente_nombre`, `creditos`, `horas por cuatrimestre`, `required_room`, `sessions_per_week`) VALUES
-- IDGS 8-1
('MAT01-81', 'Algebra Lineal', 'IDGS 8-1', 'DOC001', 'Yerenia Cano', 6, 90, 'GENERAL', 6),
('MAT02-81', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-1', 'DOC002', 'Miguel', 5, 45, 'GENERAL', 5),
('MAT03-81', 'Fundamentos de TI', 'IDGS 8-1', 'DOC003', 'Irene', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-81', 'Fundamentos de Redes', 'IDGS 8-1', 'DOC004', 'Yohani Valdez', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-81', 'Ingles', 'IDGS 8-1', 'DOC006', 'Andrea Reyes', 4, 60, 'GENERAL', 4),
('MAT08-81', 'Expresion oral y escrita', 'IDGS 8-1', 'DOC005', 'Liney', 4, 75, 'GENERAL', 4),
('MAT09-81', 'Formacion sociocultural I', 'IDGS 8-1', 'DOC008', 'Marisol', 5, 30, 'GENERAL', 5),

-- IDGS 8-2
('MAT01-82', 'Algebra Lineal', 'IDGS 8-2', 'DOC001', 'Yerenia Cano', 6, 90, 'GENERAL', 6),
('MAT02-82', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-2', 'DOC002', 'Miguel', 5, 45, 'GENERAL', 5),
('MAT03-82', 'Fundamentos de TI', 'IDGS 8-2', 'DOC003', 'Irene', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-82', 'Fundamentos de Redes', 'IDGS 8-2', 'DOC004', 'Yohani Valdez', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-82', 'Ingles', 'IDGS 8-2', 'DOC006', 'Andrea Reyes', 4, 60, 'GENERAL', 4),
('MAT08-82', 'Expresion oral y escrita', 'IDGS 8-2', 'DOC005', 'Liney', 4, 75, 'GENERAL', 4),
('MAT09-82', 'Formacion sociocultural I', 'IDGS 8-2', 'DOC008', 'Marisol', 5, 30, 'GENERAL', 5),

-- IDGS 8-3
('MAT01-83', 'Algebra Lineal', 'IDGS 8-3', 'DOC001', 'Yerenia Cano', 6, 90, 'GENERAL', 6),
('MAT02-83', 'Desarrollo de habilidades de pensamiento lógico', 'IDGS 8-3', 'DOC002', 'Miguel', 5, 45, 'GENERAL', 5),
('MAT03-83', 'Fundamentos de TI', 'IDGS 8-3', 'DOC003', 'Irene', 5, 75, 'LABORATORIO IOT', 5),
('MAT04-83', 'Fundamentos de Redes', 'IDGS 8-3', 'DOC004', 'Yohani Valdez', 4, 75, 'LABORATORIO CISCO', 4),
('MAT07-83', 'Ingles', 'IDGS 8-3', 'DOC006', 'Andrea Reyes', 4, 60, 'GENERAL', 4),
('MAT08-83', 'Expresion oral y escrita', 'IDGS 8-3', 'DOC005', 'Liney', 4, 75, 'GENERAL', 4),
('MAT09-83', 'Formacion sociocultural I', 'IDGS 8-3', 'DOC008', 'Marisol', 5, 30, 'GENERAL', 5);

-- Update teachers
UPDATE teachers SET nombre = 'Yerenia Cano', email = 'ycano@utslrc.edu.mx' WHERE id = 'DOC001';
UPDATE teachers SET nombre = 'Miguel', email = 'miguel@utslrc.edu.mx' WHERE id = 'DOC002';
UPDATE teachers SET nombre = 'Irene', email = 'irene@utslrc.edu.mx' WHERE id = 'DOC003';
UPDATE teachers SET nombre = 'Yohani Valdez', email = 'yvaldez@utslrc.edu.mx' WHERE id = 'DOC004';
UPDATE teachers SET nombre = 'Liney', email = 'liney@utslrc.edu.mx' WHERE id = 'DOC005';
UPDATE teachers SET nombre = 'Andrea Reyes', email = 'areyes@utslrc.edu.mx' WHERE id = 'DOC006';
UPDATE teachers SET nombre = 'Marisol', email = 'marisol@utslrc.edu.mx' WHERE id = 'DOC008';

-- Clear obsolete schedules
DELETE FROM schedule_slots;

SET FOREIGN_KEY_CHECKS = 1;
