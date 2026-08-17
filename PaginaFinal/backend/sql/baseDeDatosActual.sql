-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-08-2026 a las 07:20:43
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET FOREIGN_KEY_CHECKS = 0;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `utslrc_sistema`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `attendance_summary`
--

CREATE TABLE `attendance_summary` (
  `student_id` varchar(10) NOT NULL,
  `asistencias` int(11) NOT NULL DEFAULT 0,
  `faltas` int(11) NOT NULL DEFAULT 0,
  `retardos` int(11) NOT NULL DEFAULT 0,
  `porcentaje` int(11) NOT NULL DEFAULT 0,
  `estado` enum('Regular','En riesgo','Crítico') NOT NULL DEFAULT 'Regular'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `attendance_summary`
--

INSERT INTO `attendance_summary` (`student_id`, `asistencias`, `faltas`, `retardos`, `porcentaje`, `estado`) VALUES
('AL001', 36, 3, 1, 89, 'En riesgo'),
('AL002', 37, 2, 1, 92, 'Regular'),
('AL003', 38, 1, 1, 95, 'Regular'),
('AL004', 39, 1, 0, 98, 'Regular'),
('AL005', 35, 3, 2, 88, 'En riesgo'),
('AL006', 36, 3, 1, 91, 'Regular'),
('AL007', 38, 1, 1, 94, 'Regular'),
('AL008', 39, 1, 0, 97, 'Regular'),
('AL009', 35, 3, 2, 87, 'En riesgo'),
('AL010', 36, 3, 1, 90, 'Regular'),
('AL011', 37, 2, 1, 93, 'Regular'),
('AL012', 38, 2, 0, 96, 'Regular'),
('AL013', 34, 4, 2, 86, 'En riesgo'),
('AL014', 36, 3, 1, 89, 'En riesgo'),
('AL015', 37, 2, 1, 92, 'Regular'),
('AL016', 38, 1, 1, 95, 'Regular'),
('AL017', 39, 1, 0, 98, 'Regular'),
('AL018', 35, 3, 2, 88, 'En riesgo'),
('AL019', 36, 3, 1, 91, 'Regular'),
('AL020', 38, 1, 1, 94, 'Regular'),
('AL021', 39, 1, 0, 97, 'Regular'),
('AL022', 35, 3, 2, 87, 'En riesgo'),
('AL023', 36, 3, 1, 90, 'Regular'),
('AL024', 37, 2, 1, 93, 'Regular'),
('AL025', 38, 2, 0, 96, 'Regular'),
('AL026', 36, 3, 1, 89, 'En riesgo'),
('AL027', 37, 2, 1, 92, 'Regular'),
('AL028', 38, 1, 1, 95, 'Regular'),
('AL029', 39, 1, 0, 98, 'Regular'),
('AL030', 35, 3, 2, 88, 'En riesgo'),
('AL031', 36, 3, 1, 91, 'Regular'),
('AL032', 38, 1, 1, 94, 'Regular'),
('AL033', 39, 1, 0, 97, 'Regular'),
('AL034', 35, 3, 2, 87, 'En riesgo'),
('AL035', 36, 3, 1, 90, 'Regular'),
('AL036', 37, 2, 1, 93, 'Regular'),
('AL037', 38, 2, 0, 96, 'Regular'),
('AL038', 34, 4, 2, 86, 'En riesgo'),
('AL039', 36, 3, 1, 89, 'En riesgo'),
('AL040', 37, 2, 1, 92, 'Regular'),
('AL041', 38, 1, 1, 95, 'Regular'),
('AL042', 39, 1, 0, 98, 'Regular'),
('AL043', 35, 3, 2, 88, 'En riesgo'),
('AL044', 36, 3, 1, 91, 'Regular'),
('AL045', 36, 3, 1, 89, 'En riesgo'),
('AL046', 37, 2, 1, 92, 'Regular'),
('AL047', 38, 1, 1, 95, 'Regular'),
('AL048', 39, 1, 0, 98, 'Regular'),
('AL049', 35, 3, 2, 88, 'En riesgo'),
('AL050', 36, 3, 1, 91, 'Regular'),
('AL051', 38, 1, 1, 94, 'Regular'),
('AL052', 39, 1, 0, 97, 'Regular'),
('AL053', 35, 3, 2, 87, 'En riesgo'),
('AL054', 36, 3, 1, 90, 'Regular'),
('AL055', 37, 2, 1, 93, 'Regular'),
('AL056', 38, 2, 0, 96, 'Regular'),
('AL057', 34, 4, 2, 86, 'En riesgo'),
('AL058', 36, 3, 1, 89, 'En riesgo'),
('AL059', 37, 2, 1, 92, 'Regular'),
('AL060', 38, 1, 1, 95, 'Regular'),
('AL061', 39, 1, 0, 98, 'Regular'),
('AL062', 35, 3, 2, 88, 'En riesgo'),
('AL063', 36, 3, 1, 91, 'Regular'),
('AL064', 38, 1, 1, 94, 'Regular'),
('AL065', 39, 1, 0, 97, 'Regular');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `careers`
--

CREATE TABLE `careers` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `siglas` varchar(10) NOT NULL,
  `nivel` varchar(50) NOT NULL,
  `duracion` varchar(50) NOT NULL,
  `modalidad` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `careers`
--

INSERT INTO `careers` (`id`, `nombre`, `siglas`, `nivel`, `duracion`, `modalidad`, `descripcion`) VALUES
('GEMP', 'Gestión y Administración de PyMEs', 'GEMP', 'TSU', '2 años (6 cuatrimestres)', 'Presencial', 'Administración, finanzas y gestión de pequeñas y medianas empresas.'),
('IDGS', 'Ingeniería en Desarrollo y Gestión de Software', 'IDGS', 'Ingeniería / TSU', '4 años (13 cuatrimestres)', 'Presencial', 'Formación en desarrollo de software, gestión de proyectos TI, bases de datos e infraestructura tecnológica.'),
('MECA', 'Mecatrónica', 'MECA', 'Ingeniería / TSU', '4 años (13 cuatrimestres)', 'Presencial', 'Integración de mecánica, electrónica y sistemas de control.'),
('TIC', 'Tecnologías de la Información y Comunicación', 'TIC', 'TSU', '2 años (6 cuatrimestres)', 'Presencial', 'Formación técnica en redes, soporte y sistemas de información.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `enrollments`
--

CREATE TABLE `enrollments` (
  `id` varchar(30) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `subject_id` varchar(10) NOT NULL,
  `periodo` varchar(50) NOT NULL,
  `status` enum('Inscrito','Pendiente de pago','Baja') NOT NULL DEFAULT 'Inscrito'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `subject_id`, `periodo`, `status`) VALUES
('AL001-EN-MAT01', 'AL001', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-MAT04', 'AL001', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-MAT07', 'AL001', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-MAT01', 'AL002', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-MAT04', 'AL002', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-MAT07', 'AL002', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL003-EN-MAT01', 'AL003', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-MAT04', 'AL003', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL003-EN-MAT07', 'AL003', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-MAT01', 'AL004', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL004-EN-MAT04', 'AL004', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-MAT07', 'AL004', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-MAT01', 'AL005', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-MAT04', 'AL005', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-MAT07', 'AL005', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-MAT01', 'AL006', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-MAT04', 'AL006', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-MAT07', 'AL006', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL007-EN-MAT01', 'AL007', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-MAT04', 'AL007', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL007-EN-MAT07', 'AL007', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-MAT01', 'AL008', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL008-EN-MAT04', 'AL008', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-MAT07', 'AL008', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-MAT01', 'AL009', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-MAT04', 'AL009', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-MAT07', 'AL009', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-MAT01', 'AL010', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-MAT04', 'AL010', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-MAT07', 'AL010', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL011-EN-MAT01', 'AL011', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-MAT04', 'AL011', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL011-EN-MAT07', 'AL011', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-MAT01', 'AL012', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL012-EN-MAT04', 'AL012', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-MAT07', 'AL012', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-MAT01', 'AL013', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-MAT04', 'AL013', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-MAT07', 'AL013', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-MAT01', 'AL014', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-MAT04', 'AL014', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-MAT07', 'AL014', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL015-EN-MAT01', 'AL015', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-MAT04', 'AL015', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL015-EN-MAT07', 'AL015', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-MAT01', 'AL016', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL016-EN-MAT04', 'AL016', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-MAT07', 'AL016', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-MAT01', 'AL017', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-MAT04', 'AL017', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-MAT07', 'AL017', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-MAT01', 'AL018', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-MAT04', 'AL018', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-MAT07', 'AL018', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL019-EN-MAT01', 'AL019', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-MAT04', 'AL019', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL019-EN-MAT07', 'AL019', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-MAT01', 'AL020', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL020-EN-MAT04', 'AL020', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-MAT07', 'AL020', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-MAT01', 'AL021', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-MAT04', 'AL021', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-MAT07', 'AL021', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-MAT01', 'AL022', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-MAT04', 'AL022', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-MAT07', 'AL022', 'MAT07', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL023-EN-MAT01', 'AL023', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-MAT04', 'AL023', 'MAT04', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL023-EN-MAT07', 'AL023', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-MAT01', 'AL024', 'MAT01', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL024-EN-MAT04', 'AL024', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-MAT07', 'AL024', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-MAT01', 'AL025', 'MAT01', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-MAT04', 'AL025', 'MAT04', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-MAT07', 'AL025', 'MAT07', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-MAT02', 'AL026', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-MAT08', 'AL026', 'MAT08', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL027-EN-MAT02', 'AL027', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-MAT08', 'AL027', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-MAT02', 'AL028', 'MAT02', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL028-EN-MAT08', 'AL028', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-MAT02', 'AL029', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-MAT08', 'AL029', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-MAT02', 'AL030', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-MAT08', 'AL030', 'MAT08', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL031-EN-MAT02', 'AL031', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-MAT08', 'AL031', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-MAT02', 'AL032', 'MAT02', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL032-EN-MAT08', 'AL032', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-MAT02', 'AL033', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-MAT08', 'AL033', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-MAT02', 'AL034', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-MAT08', 'AL034', 'MAT08', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL035-EN-MAT02', 'AL035', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-MAT08', 'AL035', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-MAT02', 'AL036', 'MAT02', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL036-EN-MAT08', 'AL036', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-MAT02', 'AL037', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-MAT08', 'AL037', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-MAT02', 'AL038', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-MAT08', 'AL038', 'MAT08', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL039-EN-MAT02', 'AL039', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-MAT08', 'AL039', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-MAT02', 'AL040', 'MAT02', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL040-EN-MAT08', 'AL040', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-MAT02', 'AL041', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-MAT08', 'AL041', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-MAT02', 'AL042', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-MAT08', 'AL042', 'MAT08', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL043-EN-MAT02', 'AL043', 'MAT02', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-MAT08', 'AL043', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-MAT02', 'AL044', 'MAT02', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL044-EN-MAT08', 'AL044', 'MAT08', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-MAT03', 'AL045', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-MAT09', 'AL045', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-MAT03', 'AL046', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-MAT09', 'AL046', 'MAT09', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL047-EN-MAT03', 'AL047', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-MAT09', 'AL047', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-MAT03', 'AL048', 'MAT03', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL048-EN-MAT09', 'AL048', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-MAT03', 'AL049', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-MAT09', 'AL049', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-MAT03', 'AL050', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-MAT09', 'AL050', 'MAT09', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL051-EN-MAT03', 'AL051', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-MAT09', 'AL051', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-MAT03', 'AL052', 'MAT03', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL052-EN-MAT09', 'AL052', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-MAT03', 'AL053', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-MAT09', 'AL053', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-MAT03', 'AL054', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-MAT09', 'AL054', 'MAT09', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL055-EN-MAT03', 'AL055', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-MAT09', 'AL055', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-MAT03', 'AL056', 'MAT03', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL056-EN-MAT09', 'AL056', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-MAT03', 'AL057', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-MAT09', 'AL057', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-MAT03', 'AL058', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-MAT09', 'AL058', 'MAT09', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL059-EN-MAT03', 'AL059', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-MAT09', 'AL059', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-MAT03', 'AL060', 'MAT03', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL060-EN-MAT09', 'AL060', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-MAT03', 'AL061', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-MAT09', 'AL061', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-MAT03', 'AL062', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-MAT09', 'AL062', 'MAT09', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL063-EN-MAT03', 'AL063', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-MAT09', 'AL063', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-MAT03', 'AL064', 'MAT03', 'Enero – Abril 2025', 'Pendiente de pago'),
('AL064-EN-MAT09', 'AL064', 'MAT09', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-MAT03', 'AL065', 'MAT03', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-MAT09', 'AL065', 'MAT09', 'Enero – Abril 2025', 'Inscrito');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grade_records`
--

CREATE TABLE `grade_records` (
  `id` varchar(20) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `subject_id` varchar(10) NOT NULL,
  `parcial` enum('Parcial 1','Parcial 2','Parcial 3') NOT NULL DEFAULT 'Parcial 1',
  `evidencias` decimal(3,1) NOT NULL,
  `conocimiento` decimal(3,1) NOT NULL,
  `desempeno` decimal(3,1) NOT NULL,
  `actitud` decimal(3,1) NOT NULL,
  `examen` decimal(3,1) NOT NULL,
  `final` decimal(3,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `grade_records`
--

INSERT INTO `grade_records` (`id`, `student_id`, `subject_id`, `parcial`, `evidencias`, `conocimiento`, `desempeno`, `actitud`, `examen`, `final`) VALUES
('AL001-MAT01', 'AL001', 'MAT01', 'Parcial 1', 9.6, 9.7, 9.8, 9.9, 9.5, 9.7),
('AL001-MAT04', 'AL001', 'MAT04', 'Parcial 1', 9.7, 9.9, 9.6, 9.8, 9.5, 9.7),
('AL001-MAT07', 'AL001', 'MAT07', 'Parcial 1', 9.8, 9.6, 9.9, 9.7, 9.5, 9.7),
('AL002-MAT01', 'AL002', 'MAT01', 'Parcial 1', 8.7, 8.9, 8.6, 8.8, 8.5, 8.7),
('AL002-MAT04', 'AL002', 'MAT04', 'Parcial 1', 8.8, 8.6, 8.9, 8.7, 8.5, 8.7),
('AL002-MAT07', 'AL002', 'MAT07', 'Parcial 1', 8.9, 8.8, 8.7, 8.6, 8.5, 8.7),
('AL003-MAT01', 'AL003', 'MAT01', 'Parcial 1', 9.5, 9.3, 9.6, 9.4, 9.2, 9.4),
('AL003-MAT04', 'AL003', 'MAT04', 'Parcial 1', 9.6, 9.5, 9.4, 9.3, 9.2, 9.4),
('AL003-MAT07', 'AL003', 'MAT07', 'Parcial 1', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL004-MAT01', 'AL004', 'MAT01', 'Parcial 1', 8.6, 8.5, 8.4, 8.3, 8.2, 8.4),
('AL004-MAT04', 'AL004', 'MAT04', 'Parcial 1', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL004-MAT07', 'AL004', 'MAT07', 'Parcial 1', 8.3, 8.4, 8.5, 8.6, 8.2, 8.4),
('AL005-MAT01', 'AL005', 'MAT01', 'Parcial 1', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL005-MAT04', 'AL005', 'MAT04', 'Parcial 1', 9.0, 9.1, 9.2, 9.3, 8.9, 9.1),
('AL005-MAT07', 'AL005', 'MAT07', 'Parcial 1', 9.1, 9.3, 9.0, 9.2, 8.9, 9.1),
('AL006-MAT01', 'AL006', 'MAT01', 'Parcial 1', 9.7, 9.8, 9.9, 10.0, 9.6, 9.8),
('AL006-MAT04', 'AL006', 'MAT04', 'Parcial 1', 9.8, 10.0, 9.7, 9.9, 9.6, 9.8),
('AL006-MAT07', 'AL006', 'MAT07', 'Parcial 1', 9.9, 9.7, 10.0, 9.8, 9.6, 9.8),
('AL007-MAT01', 'AL007', 'MAT01', 'Parcial 1', 8.8, 9.0, 8.7, 8.9, 8.6, 8.8),
('AL007-MAT04', 'AL007', 'MAT04', 'Parcial 1', 8.9, 8.7, 9.0, 8.8, 8.6, 8.8),
('AL007-MAT07', 'AL007', 'MAT07', 'Parcial 1', 9.0, 8.9, 8.8, 8.7, 8.6, 8.8),
('AL008-MAT01', 'AL008', 'MAT01', 'Parcial 1', 9.6, 9.4, 9.7, 9.5, 9.3, 9.5),
('AL008-MAT04', 'AL008', 'MAT04', 'Parcial 1', 9.7, 9.6, 9.5, 9.4, 9.3, 9.5),
('AL008-MAT07', 'AL008', 'MAT07', 'Parcial 1', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL009-MAT01', 'AL009', 'MAT01', 'Parcial 1', 8.7, 8.6, 8.5, 8.4, 8.3, 8.5),
('AL009-MAT04', 'AL009', 'MAT04', 'Parcial 1', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL009-MAT07', 'AL009', 'MAT07', 'Parcial 1', 8.4, 8.5, 8.6, 8.7, 8.3, 8.5),
('AL010-MAT01', 'AL010', 'MAT01', 'Parcial 1', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL010-MAT04', 'AL010', 'MAT04', 'Parcial 1', 9.1, 9.2, 9.3, 9.4, 9.0, 9.2),
('AL010-MAT07', 'AL010', 'MAT07', 'Parcial 1', 9.2, 9.4, 9.1, 9.3, 9.0, 9.2),
('AL011-MAT01', 'AL011', 'MAT01', 'Parcial 1', 8.1, 8.2, 8.3, 8.4, 8.0, 8.2),
('AL011-MAT04', 'AL011', 'MAT04', 'Parcial 1', 8.2, 8.4, 8.1, 8.3, 8.0, 8.2),
('AL011-MAT07', 'AL011', 'MAT07', 'Parcial 1', 8.3, 8.1, 8.4, 8.2, 8.0, 8.2),
('AL012-MAT01', 'AL012', 'MAT01', 'Parcial 1', 8.9, 9.1, 8.8, 9.0, 8.7, 8.9),
('AL012-MAT04', 'AL012', 'MAT04', 'Parcial 1', 9.0, 8.8, 9.1, 8.9, 8.7, 8.9),
('AL012-MAT07', 'AL012', 'MAT07', 'Parcial 1', 9.1, 9.0, 8.9, 8.8, 8.7, 8.9),
('AL013-MAT01', 'AL013', 'MAT01', 'Parcial 1', 9.7, 9.5, 9.8, 9.6, 9.4, 9.6),
('AL013-MAT04', 'AL013', 'MAT04', 'Parcial 1', 9.8, 9.7, 9.6, 9.5, 9.4, 9.6),
('AL013-MAT07', 'AL013', 'MAT07', 'Parcial 1', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL014-MAT01', 'AL014', 'MAT01', 'Parcial 1', 8.8, 8.7, 8.6, 8.5, 8.4, 8.6),
('AL014-MAT04', 'AL014', 'MAT04', 'Parcial 1', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL014-MAT07', 'AL014', 'MAT07', 'Parcial 1', 8.5, 8.6, 8.7, 8.8, 8.4, 8.6),
('AL015-MAT01', 'AL015', 'MAT01', 'Parcial 1', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL015-MAT04', 'AL015', 'MAT04', 'Parcial 1', 9.2, 9.3, 9.4, 9.5, 9.1, 9.3),
('AL015-MAT07', 'AL015', 'MAT07', 'Parcial 1', 9.3, 9.5, 9.2, 9.4, 9.1, 9.3),
('AL016-MAT01', 'AL016', 'MAT01', 'Parcial 1', 8.2, 8.3, 8.4, 8.5, 8.1, 8.3),
('AL016-MAT04', 'AL016', 'MAT04', 'Parcial 1', 8.3, 8.5, 8.2, 8.4, 8.1, 8.3),
('AL016-MAT07', 'AL016', 'MAT07', 'Parcial 1', 8.4, 8.2, 8.5, 8.3, 8.1, 8.3),
('AL017-MAT01', 'AL017', 'MAT01', 'Parcial 1', 9.0, 9.2, 8.9, 9.1, 8.8, 9.0),
('AL017-MAT04', 'AL017', 'MAT04', 'Parcial 1', 9.1, 8.9, 9.2, 9.0, 8.8, 9.0),
('AL017-MAT07', 'AL017', 'MAT07', 'Parcial 1', 9.2, 9.1, 9.0, 8.9, 8.8, 9.0),
('AL018-MAT01', 'AL018', 'MAT01', 'Parcial 1', 9.8, 9.6, 9.9, 9.7, 9.5, 9.7),
('AL018-MAT04', 'AL018', 'MAT04', 'Parcial 1', 9.9, 9.8, 9.7, 9.6, 9.5, 9.7),
('AL018-MAT07', 'AL018', 'MAT07', 'Parcial 1', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL019-MAT01', 'AL019', 'MAT01', 'Parcial 1', 8.9, 8.8, 8.7, 8.6, 8.5, 8.7),
('AL019-MAT04', 'AL019', 'MAT04', 'Parcial 1', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL019-MAT07', 'AL019', 'MAT07', 'Parcial 1', 8.6, 8.7, 8.8, 8.9, 8.5, 8.7),
('AL020-MAT01', 'AL020', 'MAT01', 'Parcial 1', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL020-MAT04', 'AL020', 'MAT04', 'Parcial 1', 9.3, 9.4, 9.5, 9.6, 9.2, 9.4),
('AL020-MAT07', 'AL020', 'MAT07', 'Parcial 1', 9.4, 9.6, 9.3, 9.5, 9.2, 9.4),
('AL021-MAT01', 'AL021', 'MAT01', 'Parcial 1', 8.3, 8.4, 8.5, 8.6, 8.2, 8.4),
('AL021-MAT04', 'AL021', 'MAT04', 'Parcial 1', 8.4, 8.6, 8.3, 8.5, 8.2, 8.4),
('AL021-MAT07', 'AL021', 'MAT07', 'Parcial 1', 8.5, 8.3, 8.6, 8.4, 8.2, 8.4),
('AL022-MAT01', 'AL022', 'MAT01', 'Parcial 1', 9.1, 9.3, 9.0, 9.2, 8.9, 9.1),
('AL022-MAT04', 'AL022', 'MAT04', 'Parcial 1', 9.2, 9.0, 9.3, 9.1, 8.9, 9.1),
('AL022-MAT07', 'AL022', 'MAT07', 'Parcial 1', 9.3, 9.2, 9.1, 9.0, 8.9, 9.1),
('AL023-MAT01', 'AL023', 'MAT01', 'Parcial 1', 9.9, 9.7, 10.0, 9.8, 9.6, 9.8),
('AL023-MAT04', 'AL023', 'MAT04', 'Parcial 1', 10.0, 9.9, 9.8, 9.7, 9.6, 9.8),
('AL023-MAT07', 'AL023', 'MAT07', 'Parcial 1', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL024-MAT01', 'AL024', 'MAT01', 'Parcial 1', 9.0, 8.9, 8.8, 8.7, 8.6, 8.8),
('AL024-MAT04', 'AL024', 'MAT04', 'Parcial 1', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL024-MAT07', 'AL024', 'MAT07', 'Parcial 1', 8.7, 8.8, 8.9, 9.0, 8.6, 8.8),
('AL025-MAT01', 'AL025', 'MAT01', 'Parcial 1', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL025-MAT04', 'AL025', 'MAT04', 'Parcial 1', 9.4, 9.5, 9.6, 9.7, 9.3, 9.5),
('AL025-MAT07', 'AL025', 'MAT07', 'Parcial 1', 9.5, 9.7, 9.4, 9.6, 9.3, 9.5),
('AL026-MAT02', 'AL026', 'MAT02', 'Parcial 1', 9.6, 9.7, 9.8, 9.9, 9.5, 9.7),
('AL026-MAT08', 'AL026', 'MAT08', 'Parcial 1', 9.8, 9.6, 9.9, 9.7, 9.5, 9.7),
('AL027-MAT02', 'AL027', 'MAT02', 'Parcial 1', 8.7, 8.9, 8.6, 8.8, 8.5, 8.7),
('AL027-MAT08', 'AL027', 'MAT08', 'Parcial 1', 8.9, 8.8, 8.7, 8.6, 8.5, 8.7),
('AL028-MAT02', 'AL028', 'MAT02', 'Parcial 1', 9.5, 9.3, 9.6, 9.4, 9.2, 9.4),
('AL028-MAT08', 'AL028', 'MAT08', 'Parcial 1', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL029-MAT02', 'AL029', 'MAT02', 'Parcial 1', 8.6, 8.5, 8.4, 8.3, 8.2, 8.4),
('AL029-MAT08', 'AL029', 'MAT08', 'Parcial 1', 8.3, 8.4, 8.5, 8.6, 8.2, 8.4),
('AL030-MAT02', 'AL030', 'MAT02', 'Parcial 1', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL030-MAT08', 'AL030', 'MAT08', 'Parcial 1', 9.1, 9.3, 9.0, 9.2, 8.9, 9.1),
('AL031-MAT02', 'AL031', 'MAT02', 'Parcial 1', 9.7, 9.8, 9.9, 10.0, 9.6, 9.8),
('AL031-MAT08', 'AL031', 'MAT08', 'Parcial 1', 9.9, 9.7, 10.0, 9.8, 9.6, 9.8),
('AL032-MAT02', 'AL032', 'MAT02', 'Parcial 1', 8.8, 9.0, 8.7, 8.9, 8.6, 8.8),
('AL032-MAT08', 'AL032', 'MAT08', 'Parcial 1', 9.0, 8.9, 8.8, 8.7, 8.6, 8.8),
('AL033-MAT02', 'AL033', 'MAT02', 'Parcial 1', 9.6, 9.4, 9.7, 9.5, 9.3, 9.5),
('AL033-MAT08', 'AL033', 'MAT08', 'Parcial 1', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL034-MAT02', 'AL034', 'MAT02', 'Parcial 1', 8.7, 8.6, 8.5, 8.4, 8.3, 8.5),
('AL034-MAT08', 'AL034', 'MAT08', 'Parcial 1', 8.4, 8.5, 8.6, 8.7, 8.3, 8.5),
('AL035-MAT02', 'AL035', 'MAT02', 'Parcial 1', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL035-MAT08', 'AL035', 'MAT08', 'Parcial 1', 9.2, 9.4, 9.1, 9.3, 9.0, 9.2),
('AL036-MAT02', 'AL036', 'MAT02', 'Parcial 1', 8.1, 8.2, 8.3, 8.4, 8.0, 8.2),
('AL036-MAT08', 'AL036', 'MAT08', 'Parcial 1', 8.3, 8.1, 8.4, 8.2, 8.0, 8.2),
('AL037-MAT02', 'AL037', 'MAT02', 'Parcial 1', 8.9, 9.1, 8.8, 9.0, 8.7, 8.9),
('AL037-MAT08', 'AL037', 'MAT08', 'Parcial 1', 9.1, 9.0, 8.9, 8.8, 8.7, 8.9),
('AL038-MAT02', 'AL038', 'MAT02', 'Parcial 1', 9.7, 9.5, 9.8, 9.6, 9.4, 9.6),
('AL038-MAT08', 'AL038', 'MAT08', 'Parcial 1', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL039-MAT02', 'AL039', 'MAT02', 'Parcial 1', 8.8, 8.7, 8.6, 8.5, 8.4, 8.6),
('AL039-MAT08', 'AL039', 'MAT08', 'Parcial 1', 8.5, 8.6, 8.7, 8.8, 8.4, 8.6),
('AL040-MAT02', 'AL040', 'MAT02', 'Parcial 1', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL040-MAT08', 'AL040', 'MAT08', 'Parcial 1', 9.3, 9.5, 9.2, 9.4, 9.1, 9.3),
('AL041-MAT02', 'AL041', 'MAT02', 'Parcial 1', 8.2, 8.3, 8.4, 8.5, 8.1, 8.3),
('AL041-MAT08', 'AL041', 'MAT08', 'Parcial 1', 8.4, 8.2, 8.5, 8.3, 8.1, 8.3),
('AL042-MAT02', 'AL042', 'MAT02', 'Parcial 1', 9.0, 9.2, 8.9, 9.1, 8.8, 9.0),
('AL042-MAT08', 'AL042', 'MAT08', 'Parcial 1', 9.2, 9.1, 9.0, 8.9, 8.8, 9.0),
('AL043-MAT02', 'AL043', 'MAT02', 'Parcial 1', 9.8, 9.6, 9.9, 9.7, 9.5, 9.7),
('AL043-MAT08', 'AL043', 'MAT08', 'Parcial 1', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL044-MAT02', 'AL044', 'MAT02', 'Parcial 1', 8.9, 8.8, 8.7, 8.6, 8.5, 8.7),
('AL044-MAT08', 'AL044', 'MAT08', 'Parcial 1', 8.6, 8.7, 8.8, 8.9, 8.5, 8.7),
('AL045-MAT03', 'AL045', 'MAT03', 'Parcial 1', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL045-MAT09', 'AL045', 'MAT09', 'Parcial 1', 9.7, 9.9, 9.6, 9.8, 9.5, 9.7),
('AL046-MAT03', 'AL046', 'MAT03', 'Parcial 1', 8.6, 8.7, 8.8, 8.9, 8.5, 8.7),
('AL046-MAT09', 'AL046', 'MAT09', 'Parcial 1', 8.8, 8.6, 8.9, 8.7, 8.5, 8.7),
('AL047-MAT03', 'AL047', 'MAT03', 'Parcial 1', 9.4, 9.6, 9.3, 9.5, 9.2, 9.4),
('AL047-MAT09', 'AL047', 'MAT09', 'Parcial 1', 9.6, 9.5, 9.4, 9.3, 9.2, 9.4),
('AL048-MAT03', 'AL048', 'MAT03', 'Parcial 1', 8.5, 8.3, 8.6, 8.4, 8.2, 8.4),
('AL048-MAT09', 'AL048', 'MAT09', 'Parcial 1', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL049-MAT03', 'AL049', 'MAT03', 'Parcial 1', 9.3, 9.2, 9.1, 9.0, 8.9, 9.1),
('AL049-MAT09', 'AL049', 'MAT09', 'Parcial 1', 9.0, 9.1, 9.2, 9.3, 8.9, 9.1),
('AL050-MAT03', 'AL050', 'MAT03', 'Parcial 1', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL050-MAT09', 'AL050', 'MAT09', 'Parcial 1', 9.8, 10.0, 9.7, 9.9, 9.6, 9.8),
('AL051-MAT03', 'AL051', 'MAT03', 'Parcial 1', 8.7, 8.8, 8.9, 9.0, 8.6, 8.8),
('AL051-MAT09', 'AL051', 'MAT09', 'Parcial 1', 8.9, 8.7, 9.0, 8.8, 8.6, 8.8),
('AL052-MAT03', 'AL052', 'MAT03', 'Parcial 1', 9.5, 9.7, 9.4, 9.6, 9.3, 9.5),
('AL052-MAT09', 'AL052', 'MAT09', 'Parcial 1', 9.7, 9.6, 9.5, 9.4, 9.3, 9.5),
('AL053-MAT03', 'AL053', 'MAT03', 'Parcial 1', 8.6, 8.4, 8.7, 8.5, 8.3, 8.5),
('AL053-MAT09', 'AL053', 'MAT09', 'Parcial 1', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL054-MAT03', 'AL054', 'MAT03', 'Parcial 1', 9.4, 9.3, 9.2, 9.1, 9.0, 9.2),
('AL054-MAT09', 'AL054', 'MAT09', 'Parcial 1', 9.1, 9.2, 9.3, 9.4, 9.0, 9.2),
('AL055-MAT03', 'AL055', 'MAT03', 'Parcial 1', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL055-MAT09', 'AL055', 'MAT09', 'Parcial 1', 8.2, 8.4, 8.1, 8.3, 8.0, 8.2),
('AL056-MAT03', 'AL056', 'MAT03', 'Parcial 1', 8.8, 8.9, 9.0, 9.1, 8.7, 8.9),
('AL056-MAT09', 'AL056', 'MAT09', 'Parcial 1', 9.0, 8.8, 9.1, 8.9, 8.7, 8.9),
('AL057-MAT03', 'AL057', 'MAT03', 'Parcial 1', 9.6, 9.8, 9.5, 9.7, 9.4, 9.6),
('AL057-MAT09', 'AL057', 'MAT09', 'Parcial 1', 9.8, 9.7, 9.6, 9.5, 9.4, 9.6),
('AL058-MAT03', 'AL058', 'MAT03', 'Parcial 1', 8.7, 8.5, 8.8, 8.6, 8.4, 8.6),
('AL058-MAT09', 'AL058', 'MAT09', 'Parcial 1', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL059-MAT03', 'AL059', 'MAT03', 'Parcial 1', 9.5, 9.4, 9.3, 9.2, 9.1, 9.3),
('AL059-MAT09', 'AL059', 'MAT09', 'Parcial 1', 9.2, 9.3, 9.4, 9.5, 9.1, 9.3),
('AL060-MAT03', 'AL060', 'MAT03', 'Parcial 1', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL060-MAT09', 'AL060', 'MAT09', 'Parcial 1', 8.3, 8.5, 8.2, 8.4, 8.1, 8.3),
('AL061-MAT03', 'AL061', 'MAT03', 'Parcial 1', 8.9, 9.0, 9.1, 9.2, 8.8, 9.0),
('AL061-MAT09', 'AL061', 'MAT09', 'Parcial 1', 9.1, 8.9, 9.2, 9.0, 8.8, 9.0),
('AL062-MAT03', 'AL062', 'MAT03', 'Parcial 1', 9.7, 9.9, 9.6, 9.8, 9.5, 9.7),
('AL062-MAT09', 'AL062', 'MAT09', 'Parcial 1', 9.9, 9.8, 9.7, 9.6, 9.5, 9.7),
('AL063-MAT03', 'AL063', 'MAT03', 'Parcial 1', 8.8, 8.6, 8.9, 8.7, 8.5, 8.7),
('AL063-MAT09', 'AL063', 'MAT09', 'Parcial 1', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL064-MAT03', 'AL064', 'MAT03', 'Parcial 1', 9.6, 9.5, 9.4, 9.3, 9.2, 9.4),
('AL064-MAT09', 'AL064', 'MAT09', 'Parcial 1', 9.3, 9.4, 9.5, 9.6, 9.2, 9.4),
('AL065-MAT03', 'AL065', 'MAT03', 'Parcial 1', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL065-MAT09', 'AL065', 'MAT09', 'Parcial 1', 8.4, 8.6, 8.3, 8.5, 8.2, 8.4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `id` varchar(20) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `career_id` varchar(10) NOT NULL,
  `cuatrimestre` varchar(10) NOT NULL,
  `periodo` varchar(50) NOT NULL,
  `aula` varchar(50) DEFAULT NULL,
  `turno` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `groups`
--

INSERT INTO `groups` (`id`, `nombre`, `career_id`, `cuatrimestre`, `periodo`, `aula`, `turno`) VALUES
('IDGS 8-1', 'IDGS 8-1', 'IDGS', '8°', 'Enero – Abril 2025', 'Aula TI-204', 'Matutino'),
('IDGS 8-2', 'IDGS 8-2', 'IDGS', '8°', 'Enero – Abril 2025', 'Móvil / Lab TI', 'Matutino'),
('IDGS 8-3', 'IDGS 8-3', 'IDGS', '8°', 'Enero – Abril 2025', 'Aula TI-206', 'Matutino'),
('MECA 8-1', 'MECA 8-1', 'MECA', '8°', 'Enero – Abril 2025', 'Aula MECA-1', 'Matutino'),
('GEMP 8-1', 'GEMP 8-1', 'GEMP', '8°', 'Enero – Abril 2025', 'Aula GEMP-1', 'Matutino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rooms`
--

CREATE TABLE `rooms` (
  `room_id` varchar(50) NOT NULL,
  `capacity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rooms`
--

INSERT INTO `rooms` (`room_id`, `capacity`) VALUES
('1', 30),
('2', 30),
('3', 30),
('4', 30),
('LABORATORIO CISCO', 30),
('LABORATORIO DE DESARROLLO', 30),
('LABORATORIO IOT', 30);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `schedule_slots`
--

CREATE TABLE `schedule_slots` (
  `id` int(11) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `dia` varchar(15) NOT NULL,
  `hora` varchar(20) NOT NULL,
  `subject_id` varchar(10) NOT NULL,
  `aula` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `schedule_slots`
--

INSERT INTO `schedule_slots` (`id`, `group_id`, `dia`, `hora`, `subject_id`, `aula`) VALUES
(1, 'IDGS 8-1', 'Lunes', '07:00 – 08:40', 'MAT01', 'Aula TI-204'),
(2, 'IDGS 8-1', 'Lunes', '08:40 – 10:20', 'MAT04', 'Aula TI-205'),
(3, 'IDGS 8-1', 'Lunes', '10:20 – 12:00', 'MAT07', 'Aula TI-206'),
(5, 'IDGS 8-1', 'Martes', '07:00 – 08:40', 'MAT01', 'Aula TI-205'),
(6, 'IDGS 8-1', 'Martes', '08:40 – 10:20', 'MAT04', 'Aula TI-206'),
(7, 'IDGS 8-1', 'Martes', '10:20 – 12:00', 'MAT07', 'Aula TI-204'),
(9, 'IDGS 8-1', 'Miércoles', '07:00 – 08:40', 'MAT01', 'Aula TI-206'),
(10, 'IDGS 8-1', 'Miércoles', '08:40 – 10:20', 'MAT04', 'Aula TI-204'),
(11, 'IDGS 8-1', 'Miércoles', '10:20 – 12:00', 'MAT07', 'Aula TI-205'),
(13, 'IDGS 8-1', 'Jueves', '07:00 – 08:40', 'MAT01', 'Aula TI-204'),
(14, 'IDGS 8-1', 'Jueves', '08:40 – 10:20', 'MAT04', 'Aula TI-205'),
(15, 'IDGS 8-1', 'Jueves', '10:20 – 12:00', 'MAT07', 'Aula TI-206'),
(17, 'IDGS 8-1', 'Viernes', '07:00 – 08:40', 'MAT01', 'Aula TI-205'),
(18, 'IDGS 8-1', 'Viernes', '08:40 – 10:20', 'MAT04', 'Aula TI-206'),
(19, 'IDGS 8-1', 'Viernes', '10:20 – 12:00', 'MAT07', 'Aula TI-204'),
(21, 'IDGS 8-2', 'Lunes', '07:00 – 08:40', 'MAT02', 'Aula TI-204'),
(23, 'IDGS 8-2', 'Lunes', '10:20 – 12:00', 'MAT08', 'Aula TI-206'),
(24, 'IDGS 8-2', 'Lunes', '12:20 – 14:00', 'MAT02', 'Aula TI-204'),
(26, 'IDGS 8-2', 'Martes', '08:40 – 10:20', 'MAT08', 'Aula TI-206'),
(27, 'IDGS 8-2', 'Martes', '10:20 – 12:00', 'MAT02', 'Aula TI-204'),
(29, 'IDGS 8-2', 'Miércoles', '07:00 – 08:40', 'MAT08', 'Aula TI-206'),
(30, 'IDGS 8-2', 'Miércoles', '08:40 – 10:20', 'MAT02', 'Aula TI-204'),
(32, 'IDGS 8-2', 'Miércoles', '12:20 – 14:00', 'MAT08', 'Aula TI-206'),
(33, 'IDGS 8-2', 'Jueves', '07:00 – 08:40', 'MAT02', 'Aula TI-204'),
(35, 'IDGS 8-2', 'Jueves', '10:20 – 12:00', 'MAT08', 'Aula TI-206'),
(36, 'IDGS 8-2', 'Jueves', '12:20 – 14:00', 'MAT02', 'Aula TI-204'),
(38, 'IDGS 8-2', 'Viernes', '08:40 – 10:20', 'MAT08', 'Aula TI-206'),
(39, 'IDGS 8-2', 'Viernes', '10:20 – 12:00', 'MAT02', 'Aula TI-204'),
(41, 'IDGS 8-3', 'Lunes', '17:00-17:50', 'MAT10-83', 'LAB DESARROLLO DE SOFTWARE'),
(42, 'IDGS 8-3', 'Lunes', '17:50-18:40', 'MAT10-83', 'LAB DESARROLLO DE SOFTWARE'),
(43, 'IDGS 8-3', 'Lunes', '18:40-19:30', 'MAT14-83', 'UD1-A6'),
(44, 'IDGS 8-3', 'Lunes', '19:30-20:20', 'MAT11-83', 'UD1-A6'),
(45, 'IDGS 8-3', 'Lunes', '20:20-21:10', 'MAT13-83', 'UD1-A6'),
(146, 'IDGS 8-3', 'Lunes', '21:10-22:00', 'MAT13-83', 'UD1-A6'),
(46, 'IDGS 8-3', 'Martes', '17:00-17:50', 'MAT11-83', 'UD1-A6'),
(47, 'IDGS 8-3', 'Martes', '17:50-18:40', 'MAT13-83', 'UD1-A6'),
(147, 'IDGS 8-3', 'Martes', '18:40-19:30', 'MAT15-83', 'LAB REDES CISCO'),
(48, 'IDGS 8-3', 'Martes', '19:30-20:20', 'MAT15-83', 'LAB REDES CISCO'),
(49, 'IDGS 8-3', 'Martes', '20:20-21:10', 'MAT12-83', 'LAB DESARROLLO DE SOFTWARE'),
(148, 'IDGS 8-3', 'Martes', '21:10-22:00', 'MAT12-83', 'LAB DESARROLLO DE SOFTWARE'),
(50, 'IDGS 8-3', 'Miercoles', '17:00-17:50', 'MAT12-83', 'UD1-MOVIL'),
(51, 'IDGS 8-3', 'Miercoles', '17:50-18:40', 'MAT12-83', 'UD1-MOVIL'),
(52, 'IDGS 8-3', 'Miercoles', '18:40-19:30', 'MAT10-83', 'LAB DESARROLLO DE SOFTWARE'),
(53, 'IDGS 8-3', 'Miercoles', '19:30-20:20', 'MAT11-83', 'UD1-A6'),
(55, 'IDGS 8-3', 'Jueves', '17:00-17:50', 'MAT12-83', 'UD1-MOVIL'),
(56, 'IDGS 8-3', 'Jueves', '17:50-18:40', 'MAT10-83', 'LAB DESARROLLO DE SOFTWARE'),
(149, 'IDGS 8-3', 'Jueves', '18:40-19:30', 'MAT15-83', 'LAB REDES CISCO'),
(58, 'IDGS 8-3', 'Jueves', '19:30-20:20', 'MAT15-83', 'LAB REDES CISCO'),
(59, 'IDGS 8-3', 'Jueves', '20:20-21:10', 'MAT14-83', 'UD1-A6'),
(150, 'IDGS 8-3', 'Jueves', '21:10-22:00', 'MAT14-83', 'UD1-A6'),
(151, 'IDGS 8-3', 'Viernes', '17:00-17:50', 'MAT11-83', 'UD1-A6'),
(152, 'IDGS 8-3', 'Viernes', '17:50-18:40', 'MAT11-83', 'UD1-A6'),
(153, 'IDGS 8-3', 'Viernes', '18:40-19:30', 'MAT14-83', 'UD1-A6'),
(154, 'IDGS 8-3', 'Viernes', '19:30-20:20', 'MAT14-83', 'UD1-A6');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_tickets`
--

CREATE TABLE `service_tickets` (
  `id` varchar(20) NOT NULL,
  `folio` varchar(30) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `categoria` enum('Trámite escolar','Soporte / Incidencia') NOT NULL,
  `fecha` date NOT NULL,
  `status` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `service_tickets`
--

INSERT INTO `service_tickets` (`id`, `folio`, `student_id`, `tipo`, `categoria`, `fecha`, `status`) VALUES
('TK-1000', 'SE-2026-0300', 'AL006', 'Constancia de estudios', 'Trámite escolar', '2026-08-01', 'En proceso'),
('TK-1001', 'SE-2026-0301', 'AL007', 'Incidencia de aula', 'Soporte / Incidencia', '2026-08-02', 'En proceso'),
('TK-1002', 'SE-2026-0302', 'AL008', 'Historial académico', 'Trámite escolar', '2026-08-03', 'Entregado'),
('TK-1003', 'SE-2026-0303', 'AL009', 'Soporte técnico', 'Soporte / Incidencia', '2026-08-04', 'Abierto'),
('TK-1004', 'SE-2026-0304', 'AL010', 'Baja temporal', 'Trámite escolar', '2026-08-05', 'En proceso'),
('TK-1005', 'SE-2026-0305', 'AL011', 'Credencial', 'Soporte / Incidencia', '2026-08-06', 'Resuelto'),
('TK-1006', 'SE-2026-0306', 'AL012', 'Kardex', 'Trámite escolar', '2026-08-07', 'Entregado'),
('TK-1007', 'SE-2026-0307', 'AL013', 'Incidencia de aula', 'Soporte / Incidencia', '2026-08-08', 'En proceso'),
('TK-1008', 'SE-2026-0308', 'AL014', 'Carta de pasante', 'Trámite escolar', '2026-08-01', 'En proceso'),
('TK-1009', 'SE-2026-0309', 'AL015', 'Soporte técnico', 'Soporte / Incidencia', '2026-08-02', 'Abierto'),
('TK-1010', 'SE-2026-0310', 'AL016', 'Constancia de estudios', 'Trámite escolar', '2026-08-03', 'Entregado'),
('TK-1011', 'SE-2026-0311', 'AL017', 'Credencial', 'Soporte / Incidencia', '2026-08-04', 'Resuelto'),
('TK-1012', 'SE-2026-0312', 'AL018', 'Historial académico', 'Trámite escolar', '2026-08-05', 'En proceso'),
('TK-1013', 'SE-2026-0313', 'AL019', 'Incidencia de aula', 'Soporte / Incidencia', '2026-08-06', 'En proceso'),
('TK-1014', 'SE-2026-0314', 'AL020', 'Baja temporal', 'Trámite escolar', '2026-08-07', 'Entregado'),
('TK-1015', 'SE-2026-0315', 'AL021', 'Soporte técnico', 'Soporte / Incidencia', '2026-08-08', 'Abierto');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `students`
--

CREATE TABLE `students` (
  `id` varchar(10) NOT NULL,
  `no` int(11) NOT NULL,
  `expediente` varchar(20) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `status` enum('Activo','Baja temporal','Egresado') NOT NULL DEFAULT 'Activo',
  `career_id` varchar(10) NOT NULL,
  `cuatrimestre` varchar(10) DEFAULT NULL,
  `periodo` varchar(50) DEFAULT NULL,
  `promedio` decimal(3,1) DEFAULT 0.0,
  `asistencia` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `students`
--

INSERT INTO `students` (`id`, `no`, `expediente`, `nombre`, `group_id`, `email`, `status`, `career_id`, `cuatrimestre`, `periodo`, `promedio`, `asistencia`) VALUES
('AL001', 1, '23304095', 'ARELLANO MUÑOZ ANGEL ROBERTO', 'IDGS 8-1', 'arellano.roberto@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 89),
('AL002', 2, '23304050', 'ATIENZO CENICEROS JOSE HARVEY', 'IDGS 8-1', 'atienzo.harvey@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 92),
('AL003', 3, '23304030', 'DELGADILLO DIAZ ERIC JOEL', 'IDGS 8-1', 'delgadillo.joel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 95),
('AL004', 4, '23304053', 'FELIX GONZALEZ AARÓN ALBERTO', 'IDGS 8-1', 'felix.alberto@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 98),
('AL005', 5, '23304076', 'GONZÁLEZ MARÍN KEVIN ALBERTO', 'IDGS 8-1', 'gonzalez.alberto@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 88),
('AL006', 6, '23304056', 'HIGUERA ORTIZ EBER', 'IDGS 8-1', 'higuera.eber@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 91),
('AL007', 7, '23304033', 'LOPEZ COTA BENJAMIN', 'IDGS 8-1', 'lopez.benjamin@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 94),
('AL008', 8, '23304048', 'MARTINEZ ALCANTAR JUAN JOSE', 'IDGS 8-1', 'martinez.jose@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 97),
('AL009', 9, '23304013', 'MARTINEZ GARCIA RICARDO', 'IDGS 8-1', 'martinez.ricardo@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 87),
('AL010', 10, '23304027', 'MICHEL TELLO YAHIR ROMAN', 'IDGS 8-1', 'michel.roman@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 90),
('AL011', 11, '23304015', 'MONREAL GAMEZ JOSE ARMANDO', 'IDGS 8-1', 'monreal.armando@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 93),
('AL012', 12, '23304079', 'MORENO FIGUEROA EVI AIRAM', 'IDGS 8-1', 'moreno.airam@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 96),
('AL013', 13, '23304054', 'MUNGARRO LOPEZ BIHANKA YAZZMIN', 'IDGS 8-1', 'mungarro.yazzmin@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 86),
('AL014', 14, 'S/E-014', 'MUÑOZ PEREA ALEXIS ANTEUS', 'IDGS 8-1', 'munoz.anteus@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 89),
('AL015', 15, '22304038', 'MUÑOZ PEREA JULIAN ANTHUA', 'IDGS 8-1', 'munoz.anthua@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 92),
('AL016', 16, '23304080', 'NUÑEZ RAMIREZ BRYAN DE JESUS', 'IDGS 8-1', 'nunez.jesus@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 95),
('AL017', 17, '23304017', 'OCHOA MORA URIEL', 'IDGS 8-1', 'ochoa.uriel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 98),
('AL018', 18, '23304046', 'ORTUÑO ALVARADO JONATHAN ANTONIO', 'IDGS 8-1', 'ortuno.antonio@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 88),
('AL019', 19, '23304060', 'PÉREZ ÁLVAREZ LUÍS RAMÓN', 'IDGS 8-1', 'perez.ramon@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 91),
('AL020', 20, '23304012', 'RODRIGUEZ VERA ALVARO ALOISSES', 'IDGS 8-1', 'rodriguez.aloisses@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 94),
('AL021', 21, '23304044', 'SALAZAR NEGRETE ISMAEL', 'IDGS 8-1', 'salazar.ismael@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 97),
('AL022', 22, '23304026', 'SÁNCHEZ PLANTILLAS MIGUEL', 'IDGS 8-1', 'sanchez.miguel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 87),
('AL023', 23, '22304029', 'URIARTE CAZARES JULIAN', 'IDGS 8-1', 'uriarte.julian@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 90),
('AL024', 24, '23304052', 'VARGAS ANTOLIN RAMON ALEXANDRO', 'IDGS 8-1', 'vargas.alexandro@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 93),
('AL025', 25, '23304086', 'VEJAR ESTRADA JOSÉ MANUEL', 'IDGS 8-1', 'vejar.manuel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 96),
('AL026', 1, '23304025', 'CASTELLANOS LEYVA EZEQUIEL', 'IDGS 8-2', 'castellanos.ezequiel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 89),
('AL027', 2, '23304023', 'CUADRAS AVILÉZ KASSANDRA', 'IDGS 8-2', 'cuadras.kassandra@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 92),
('AL028', 3, '23304096', 'HERNANDEZ ACOSTA HECTOR MANUEL', 'IDGS 8-2', 'hernandez.manuel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 95),
('AL029', 4, '23304005', 'HERNANDEZ DUARTE ALBERTO IÑAKI', 'IDGS 8-2', 'hernandez.inaki@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 98),
('AL030', 5, '23304014', 'HERRERA SOSA RODOLFO ADRIAN', 'IDGS 8-2', 'herrera.adrian@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 88),
('AL031', 6, '22304023', 'KIM RODRIGUEZ LLUVIA YUKIE', 'IDGS 8-2', 'kim.yukie@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 91),
('AL032', 7, '23304031', 'LEÓN ALMAZÁN LUIS ÁNGEL', 'IDGS 8-2', 'leon.angel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 94),
('AL033', 8, '23304035', 'LEON GERMAN EDUARDO ALONSO', 'IDGS 8-2', 'leon.alonso@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 97),
('AL034', 9, '23304078', 'MEDINA RIVERA ESTEBAN', 'IDGS 8-2', 'medina.esteban@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 87),
('AL035', 10, '23304034', 'MEDINA ZAVALA BRYAN FERNANDO', 'IDGS 8-2', 'medina.fernando@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 90),
('AL036', 11, '23304008', 'OLMEDO GARCIA VIVIANA ANAHI', 'IDGS 8-2', 'olmedo.anahi@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 93),
('AL037', 12, '23304009', 'PEREZ FRAUSTO JESHUA EMMANUEL', 'IDGS 8-2', 'perez.emmanuel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 96),
('AL038', 13, '23304082', 'RAMÍREZ CÁRDENAS AXEL', 'IDGS 8-2', 'ramirez.axel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 86),
('AL039', 14, '22304042', 'RAMÍREZ LICÓN JORGE ALBERTO', 'IDGS 8-2', 'ramirez.alberto@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 89),
('AL040', 15, '23304092', 'RESENDIZ CORONA ELIN ALEKSEY', 'IDGS 8-2', 'resendiz.aleksey@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 92),
('AL041', 16, '23304001', 'SAMANIEGO SANCHEZ LEVI ENRIQUE', 'IDGS 8-2', 'samaniego.enrique@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 95),
('AL042', 17, '23304047', 'SANCHEZ CELIS BLANCA ISABEL', 'IDGS 8-2', 'sanchez.isabel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 98),
('AL043', 18, '23304039', 'SANTILLAN BARRÓN JUAN GUILLERMO', 'IDGS 8-2', 'santillan.guillermo@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 88),
('AL044', 19, '23304093', 'SOTO PEÑUELA JESÚS DAVID', 'IDGS 8-2', 'soto.david@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 91),
('AL045', 1, '23304063', 'ACOSTA ARREGUIN ROMAN', 'IDGS 8-3', 'acosta.roman@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 89),
('AL046', 2, '23304059', 'ALCALA FELIX VLADIMIR EMANUEL', 'IDGS 8-3', 'alcala.emanuel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 92),
('AL047', 3, '23304028', 'ARMENTA MUNOZ OSKAR', 'IDGS 8-3', 'armenta.oskar@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 95),
('AL048', 4, '23304007', 'BARRIOS SECUNDINO JOE BRAYAN', 'IDGS 8-3', 'barrios.brayan@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 98),
('AL049', 5, '23304071', 'CARDENAS TIRADO MIGUEL ANGEL', 'IDGS 8-3', 'cardenas.angel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 88),
('AL050', 6, '23304077', 'GRIJALVA MURRIETA ALVARO ALAN', 'IDGS 8-3', 'grijalva.alan@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 91),
('AL051', 7, '23304065', 'GUTIERREZ CARDENAS MARTIN ALFREDO', 'IDGS 8-3', 'gutierrez.alfredo@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 94),
('AL052', 8, '23304069', 'HERNANDEZ URIBE GABRIEL ARMANDO', 'IDGS 8-3', 'hernandez.armando@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 97),
('AL053', 9, '23304049', 'HUIZAR RAMIREZ DEREK', 'IDGS 8-3', 'huizar.derek@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 87),
('AL054', 10, '23304040', 'JIMENEZ JARAMILLO AXEL ALAN', 'IDGS 8-3', 'jimenez.alan@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 90),
('AL055', 11, '23304064', 'LARA TORRES ADRIAN FELIPE', 'IDGS 8-3', 'lara.felipe@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 93),
('AL056', 12, '23304061', 'LOPEZ GAMEZ JESUS RODOLFO', 'IDGS 8-3', 'lopez.rodolfo@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 96),
('AL057', 13, '23304062', 'LOPEZ PADILLA LUIS FERNANDO', 'IDGS 8-3', 'lopez.fernando@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 86),
('AL058', 14, '23304018', 'MONTANO GASPAR RENE', 'IDGS 8-3', 'montano.rene@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 89),
('AL059', 15, '23304066', 'MORALES HIGUERA CHRISTIAN DE JESUS', 'IDGS 8-3', 'morales.jesus@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 92),
('AL060', 16, '22304066', 'RAMIREZ BRAULIO', 'IDGS 8-3', 'ramirez.braulio@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 95),
('AL061', 17, '23304020', 'SILVA TALAMANTES KEVIN URIEL', 'IDGS 8-3', 'silva.uriel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 98),
('AL062', 18, '23304085', 'VALENZUELA VERDUGO JOSUE MISRAIM', 'IDGS 8-3', 'valenzuela.misraim@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 88),
('AL063', 19, '23304006', 'VALLEJO PUENTE CARLOS MANUEL', 'IDGS 8-3', 'vallejo.manuel@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 91),
('AL064', 20, '23304051', 'VELAZQUEZ FLORES FERNANDO', 'IDGS 8-3', 'velazquez.fernando@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 94),
('AL065', 21, '23304057', 'VILLAGRANA CORDOVA EDGAR FERMIN', 'IDGS 8-3', 'villagrana.fermin@alumnos.utslrc.edu.mx', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 97);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subjects`
--

CREATE TABLE `subjects` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `teacher_id` varchar(10) DEFAULT NULL,
  `docente_nombre` varchar(150) DEFAULT NULL,
  `creditos` int(11) DEFAULT 0,
  `horas por cuatrimestre` int(11) DEFAULT 0,
  `required_room` varchar(50) DEFAULT NULL,
  `sessions_per_week` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `subjects`
--

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

-- IDGS 8-3 (datos reales del horario FAS-PA-06, Mayo-Agosto 2026-2)
('MAT10-83', 'Seguridad en el Desarrollo de Aplicaciones', 'IDGS 8-3', 'DOC009', 'Ramon Eduardo Mercado Carreon', 4, 60, 'LAB DESARROLLO DE SOFTWARE', 4),
('MAT11-83', 'Ingles VII', 'IDGS 8-3', 'DOC010', 'Norma Beatriz Flores Nuñez', 4, 60, 'UD1-A6', 4),
('MAT12-83', 'Administracion de Base de Datos', 'IDGS 8-3', 'DOC011', 'Julia Elizabeth Garcia Herrera', 5, 75, 'UD1-MOVIL', 5),
('MAT13-83', 'Planeacion y Organizacion del Trabajo', 'IDGS 8-3', 'DOC012', 'Eutilia Guadalupe Olivares Velazquez', 4, 60, 'UD1-A6', 4),
('MAT14-83', 'Matematicas para Ingenieria II', 'IDGS 8-3', 'DOC013', 'Jordy Zaid Quintero Diaz', 5, 75, 'UD1-A6', 5),
('MAT15-83', 'Desarrollo Web Profesional', 'IDGS 8-3', 'DOC014', 'Aurelio Arturo Flores Quitarte', 4, 60, 'LAB REDES CISCO', 4),

-- MECA 8-1
('MECA01-81', 'Robótica Industrial', 'MECA 8-1', 'DOC001', 'Yerenia Cano', 6, 90, 'GENERAL', 6),
('MECA02-81', 'Sistemas de Control', 'MECA 8-1', 'DOC003', 'Irene', 5, 75, 'GENERAL', 5),

-- GEMP 8-1
('GEMP01-81', 'Mercadotecnia Estratégica', 'GEMP 8-1', 'DOC005', 'Liney', 6, 90, 'GENERAL', 6),
('GEMP02-81', 'Finanzas Corporativas', 'GEMP 8-1', 'DOC008', 'Marisol', 5, 75, 'GENERAL', 5);



-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `teachers`
--

CREATE TABLE `teachers` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `grado` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `available_slots` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `teachers`
--

INSERT INTO `teachers` (`id`, `nombre`, `grado`, `email`, `available_slots`) VALUES
('DOC001', 'Yerenia Cano', 'Ingeniera', 'ycano@utslrc.edu.mx', NULL),
('DOC002', 'Miguel', 'Maestro', 'miguel@utslrc.edu.mx', NULL),
('DOC003', 'Irene', 'Ingeniera', 'irene@utslrc.edu.mx', NULL),
('DOC004', 'Yohani Valdez', 'Maestra', 'yvaldez@utslrc.edu.mx', NULL),
('DOC005', 'Liney', 'Licenciada', 'liney@utslrc.edu.mx', NULL),
('DOC006', 'Andrea Reyes', 'Ingeniero', 'areyes@utslrc.edu.mx', NULL),
('DOC007', 'Ing. Daniel Soto', 'Ingeniero', 'dsoto@utslrc.edu.mx', NULL),
('DOC008', 'Marisol', 'Ingeniera', 'marisol@utslrc.edu.mx', NULL),
('DOC009', 'Ramon Eduardo Mercado Carreon', 'Ingeniero', 'rmercado@utslrc.edu.mx', NULL),
('DOC010', 'Norma Beatriz Flores Nuñez', 'Licenciada', 'nflores@utslrc.edu.mx', NULL),
('DOC011', 'Julia Elizabeth Garcia Herrera', 'Ingeniera', 'jgarcia@utslrc.edu.mx', NULL),
('DOC012', 'Eutilia Guadalupe Olivares Velazquez', 'Licenciada', 'eolivares@utslrc.edu.mx', NULL),
('DOC013', 'Jordy Zaid Quintero Diaz', 'Ingeniero', 'jquintero@utslrc.edu.mx', NULL),
('DOC014', 'Aurelio Arturo Flores Quitarte', 'Ingeniero', 'aflores@utslrc.edu.mx', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `teacher_groups`
--

CREATE TABLE `teacher_groups` (
  `teacher_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `teacher_groups`
--

INSERT INTO `teacher_groups` (`teacher_id`, `group_id`) VALUES
('DOC001', 'IDGS 8-1'),
('DOC001', 'IDGS 8-2'),
('DOC002', 'IDGS 8-1'),
('DOC003', 'IDGS 8-3'),
('DOC004', 'IDGS 8-1'),
('DOC005', 'IDGS 8-2'),
('DOC005', 'IDGS 8-3'),
('DOC006', 'IDGS 8-3'),
('DOC007', 'IDGS 8-2'),
('DOC008', 'IDGS 8-1'),
('DOC008', 'IDGS 8-3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `timeslots`
--

CREATE TABLE `timeslots` (
  `slot_id` varchar(10) NOT NULL,
  `day` varchar(10) DEFAULT NULL,
  `start` time DEFAULT NULL,
  `end` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `timeslots`
--

INSERT INTO `timeslots` (`slot_id`, `day`, `start`, `end`) VALUES
('S1', 'Mon', '07:00:00', '07:50:00'),
('S10', 'Tue', '07:00:00', '07:50:00'),
('S11', 'Tue', '07:50:00', '08:40:00'),
('S12', 'Tue', '08:40:00', '09:30:00'),
('S13', 'Tue', '09:30:00', '10:20:00'),
('S14', 'Tue', '10:40:00', '11:30:00'),
('S15', 'Tue', '11:30:00', '12:20:00'),
('S16', 'Tue', '12:20:00', '13:10:00'),
('S17', 'Tue', '13:10:00', '14:00:00'),
('S18', 'Tue', '14:00:00', '14:50:00'),
('S19', 'Wed', '07:00:00', '07:50:00'),
('S2', 'Mon', '07:50:00', '08:40:00'),
('S20', 'Wed', '07:50:00', '08:40:00'),
('S21', 'Wed', '08:40:00', '09:30:00'),
('S22', 'Wed', '09:30:00', '10:20:00'),
('S23', 'Wed', '10:40:00', '11:30:00'),
('S24', 'Wed', '11:30:00', '12:20:00'),
('S25', 'Wed', '12:20:00', '13:10:00'),
('S26', 'Wed', '13:10:00', '14:00:00'),
('S27', 'Wed', '14:00:00', '14:50:00'),
('S28', 'Thu', '07:00:00', '07:50:00'),
('S29', 'Thu', '07:50:00', '08:40:00'),
('S3', 'Mon', '08:40:00', '09:30:00'),
('S30', 'Thu', '08:40:00', '09:30:00'),
('S31', 'Thu', '09:30:00', '10:20:00'),
('S32', 'Thu', '10:40:00', '11:30:00'),
('S33', 'Thu', '11:30:00', '12:20:00'),
('S34', 'Thu', '12:20:00', '13:10:00'),
('S35', 'Thu', '13:10:00', '14:00:00'),
('S36', 'Thu', '14:00:00', '14:50:00'),
('S37', 'Fri', '07:00:00', '07:50:00'),
('S38', 'Fri', '07:50:00', '08:40:00'),
('S39', 'Fri', '08:40:00', '09:30:00'),
('S4', 'Mon', '09:30:00', '10:20:00'),
('S40', 'Fri', '09:30:00', '10:20:00'),
('S41', 'Fri', '10:40:00', '11:30:00'),
('S42', 'Fri', '11:30:00', '12:20:00'),
('S43', 'Fri', '12:20:00', '13:10:00'),
('S44', 'Fri', '13:10:00', '14:00:00'),
('S45', 'Fri', '14:00:00', '14:50:00'),
('S5', 'Mon', '10:40:00', '11:30:00'),
('S6', 'Mon', '11:30:00', '12:20:00'),
('S7', 'Mon', '12:20:00', '13:10:00'),
('S8', 'Mon', '13:10:00', '14:00:00'),
('S9', 'Mon', '14:00:00', '14:50:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `role` enum('Administrador','Control Escolar','Docente','Alumno') NOT NULL,
  `student_id` varchar(10) DEFAULT NULL,
  `teacher_id` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `nombre`, `role`, `student_id`, `teacher_id`, `created_at`) VALUES
(1, 'admin', '$2a$10$eARuAymPTLmwhPPI3FReweSQB9G3HtEfEGkRCdX/NgH8Hz.aIDs1a', 'Administrador General', 'Administrador', NULL, NULL, '2026-08-12 02:16:59'),
(2, 'control', '$2a$10$/44SqEAje3hrzSj7.CWwXeL6k.2rY48PBy5UY1b.UajXHtHTSPSOu', 'Control Escolar', 'Control Escolar', NULL, NULL, '2026-08-12 02:16:59'),
(3, 'mmolina', '$2a$10$OixNkp.6YE70g2a7rwrIbO3ta8z6EPk9uy4lXg4qS9Si0j4JPlc0q', 'Ing. Mariana Molina Parra', 'Docente', NULL, 'DOC003', '2026-08-12 02:16:59'),
(4, '23304059', '$2a$10$Sbyludprxh8jFLivusYXaeQjrPLuhRqfM70McRP2hYrjcguhdgbf2', 'ALCALA FELIX VLADIMIR EMANUEL', 'Alumno', 'AL046', NULL, '2026-08-12 02:16:59');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `attendance_summary`
--
ALTER TABLE `attendance_summary`
  ADD PRIMARY KEY (`student_id`);

--
-- Indices de la tabla `careers`
--
ALTER TABLE `careers`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indices de la tabla `grade_records`
--
ALTER TABLE `grade_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_student_subject_parcial` (`student_id`,`subject_id`,`parcial`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `career_id` (`career_id`);

--
-- Indices de la tabla `schedule_slots`
--
ALTER TABLE `schedule_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indices de la tabla `service_tickets`
--
ALTER TABLE `service_tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `folio` (`folio`),
  ADD KEY `student_id` (`student_id`);

--
-- Indices de la tabla `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `career_id` (`career_id`);

--
-- Indices de la tabla `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indices de la tabla `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `teacher_groups`
--
ALTER TABLE `teacher_groups`
  ADD PRIMARY KEY (`teacher_id`,`group_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `schedule_slots`
--
ALTER TABLE `schedule_slots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `attendance_summary`
--
ALTER TABLE `attendance_summary`
  ADD CONSTRAINT `attendance_summary_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `grade_records`
--
ALTER TABLE `grade_records`
  ADD CONSTRAINT `grade_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grade_records_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`career_id`) REFERENCES `careers` (`id`);

--
-- Filtros para la tabla `schedule_slots`
--
ALTER TABLE `schedule_slots`
  ADD CONSTRAINT `schedule_slots_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `schedule_slots_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `service_tickets`
--
ALTER TABLE `service_tickets`
  ADD CONSTRAINT `service_tickets_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`career_id`) REFERENCES `careers` (`id`);

--
-- Filtros para la tabla `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subjects_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `teacher_groups`
--
ALTER TABLE `teacher_groups`
  ADD CONSTRAINT `teacher_groups_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE SET NULL;
--
-- FIX: remapear subject_id huerfanos (sin sufijo de grupo) a los IDs reales
-- de la tabla subjects (con sufijo -81/-82/-83), usando el grupo del alumno.
--
UPDATE enrollments e
JOIN students s ON s.id = e.student_id
SET e.subject_id = CONCAT(e.subject_id, CASE s.group_id
    WHEN 'IDGS 8-1' THEN '-81'
    WHEN 'IDGS 8-2' THEN '-82'
    WHEN 'IDGS 8-3' THEN '-83'
    ELSE ''
  END)
WHERE e.subject_id IN ('MAT01','MAT02','MAT03','MAT04','MAT07','MAT08','MAT09');

UPDATE grade_records g
JOIN students s ON s.id = g.student_id
SET g.subject_id = CONCAT(g.subject_id, CASE s.group_id
    WHEN 'IDGS 8-1' THEN '-81'
    WHEN 'IDGS 8-2' THEN '-82'
    WHEN 'IDGS 8-3' THEN '-83'
    ELSE ''
  END)
WHERE g.subject_id IN ('MAT01','MAT02','MAT03','MAT04','MAT07','MAT08','MAT09');

UPDATE schedule_slots sl
SET sl.subject_id = CONCAT(sl.subject_id, CASE sl.group_id
    WHEN 'IDGS 8-1' THEN '-81'
    WHEN 'IDGS 8-2' THEN '-82'
    WHEN 'IDGS 8-3' THEN '-83'
    ELSE ''
  END)
WHERE sl.subject_id IN ('MAT01','MAT02','MAT03','MAT04','MAT07','MAT08','MAT09');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
