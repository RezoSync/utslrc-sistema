USE utslrc_sistema;
SET FOREIGN_KEY_CHECKS = 0;

-- Insert groups
INSERT INTO `groups` (`id`, `nombre`, `career_id`, `cuatrimestre`, `periodo`, `aula`, `turno`) VALUES
('MECA 8-1', 'MECA 8-1', 'MECA', '8°', 'Enero – Abril 2025', 'Aula MECA-1', 'Matutino'),
('GEMP 8-1', 'GEMP 8-1', 'GEMP', '8°', 'Enero – Abril 2025', 'Aula GEMP-1', 'Matutino')
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insert subjects
INSERT INTO `subjects` (`id`, `nombre`, `group_id`, `teacher_id`, `docente_nombre`, `creditos`, `horas por cuatrimestre`, `required_room`, `sessions_per_week`) VALUES
('MECA01-81', 'Robótica Industrial', 'MECA 8-1', 'DOC001', 'Yerenia Cano', 6, 90, 'GENERAL', 6),
('MECA02-81', 'Sistemas de Control', 'MECA 8-1', 'DOC003', 'Irene', 5, 75, 'GENERAL', 5),
('GEMP01-81', 'Mercadotecnia Estratégica', 'GEMP 8-1', 'DOC005', 'Liney', 6, 90, 'GENERAL', 6),
('GEMP02-81', 'Finanzas Corporativas', 'GEMP 8-1', 'DOC008', 'Marisol', 5, 75, 'GENERAL', 5)
ON DUPLICATE KEY UPDATE nombre=nombre;

SET FOREIGN_KEY_CHECKS = 1;
