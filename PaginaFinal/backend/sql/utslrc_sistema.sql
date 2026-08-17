-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-08-2026 a las 05:02:08
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
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
-- Estructura de tabla para la tabla `administradores`
--

CREATE TABLE `administradores` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `expediente` varchar(20) NOT NULL,
  `contrasena` varchar(255) NOT NULL DEFAULT '12345678'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `administradores`
--

INSERT INTO `administradores` (`id`, `nombre`, `correo`, `expediente`, `contrasena`) VALUES
('ADM001', 'Administrador General', 'admin@utslrc.edu.mx', 'admin', 'admin123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `announcements`
--

CREATE TABLE `announcements` (
  `id` varchar(20) NOT NULL,
  `teacher_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `announcements`
--

INSERT INTO `announcements` (`id`, `teacher_id`, `group_id`, `subject_id`, `titulo`, `mensaje`, `created_at`) VALUES
('AN-0001', 'DOC001', 'IDGS 8-1', 'SUB007', 'Practica 7 (SAST)', 'Practica SAST\n\nSigan las instrucciones del PDF y adjunten evidencia (screenshots)\nNo olviden portada!', '2026-08-15 13:52:59'),
('AN-0002', 'DOC001', 'IDGS 8-3', 'SUB001', 'NO HAY CLASES HOY!', 'No podre asistir a clases por temas de hueva. Nos vemos mañana!', '2026-08-15 19:49:03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `assignments`
--

CREATE TABLE `assignments` (
  `id` varchar(20) NOT NULL,
  `teacher_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo` enum('Tarea','Proyecto','Exposición','Investigación') NOT NULL DEFAULT 'Tarea',
  `fecha_limite` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `assignments`
--

INSERT INTO `assignments` (`id`, `teacher_id`, `group_id`, `subject_id`, `titulo`, `descripcion`, `tipo`, `fecha_limite`, `created_at`) VALUES
('TR-0001', 'DOC001', 'IDGS 8-1', 'SUB007', 'Practica 8 DAST', 'Realizar la serie de pasos indicados en el archivo PDF que les adjunto. Hagan un reporte adjuntando imagenes.\r\nNo olviden agregar portada!', 'Tarea', '2026-08-17', '2026-08-15 19:39:11'),
('TR-0002', 'DOC001', 'IDGS 8-1', 'SUB007', 'Practica 8 DAST', 'Realizar la serie de pasos indicados en el archivo PDF que les adjunto. Hagan un reporte adjuntando imagenes.\r\nNo olviden agregar portada!', 'Tarea', '2026-08-17', '2026-08-15 19:39:45'),
('TR-0003', 'DOC001', 'IDGS 8-3', 'SUB001', 'Practica 1 Investigacion SAST', 'Realizar una investigacion sobre lo visto en clase.\r\nEntregar PDF con portada', 'Tarea', '2026-08-17', '2026-08-15 19:43:19'),
('TR-0004', 'DOC001', 'IDGS 8-3', 'SUB001', 'trabajo 8000', 'xd', 'Tarea', '2026-08-18', '2026-08-16 16:01:24'),
('TR-0005', 'DOC001', 'IDGS 8-1', 'SUB007', 'PRACTICA 10 MINUTOS', 'Sigue las 120092391039 paginas de instrucciones y haz la practica flop.', 'Tarea', '2026-08-20', '2026-08-16 17:28:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `assignment_attachments`
--

CREATE TABLE `assignment_attachments` (
  `id` varchar(40) NOT NULL,
  `assignment_id` varchar(20) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `stored_path` varchar(500) NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `size_bytes` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `assignment_attachments`
--

INSERT INTO `assignment_attachments` (`id`, `assignment_id`, `original_name`, `stored_path`, `mime_type`, `size_bytes`, `created_at`) VALUES
('246ff16a-ca04-4265-a1ea-30ee35bd021d', 'TR-0003', 'Practica 1- IAST (1).pdf', 'C:\\Users\\ferba\\Desktop\\ADondeLoMando\\utslrc-sistema-fusionado\\backend\\uploads\\assignments\\TR-0003\\1786848199616-25e8b378-Practica 1- IAST _1_.pdf', 'application/pdf', 629179, '2026-08-15 19:43:19'),
('333b1d5b-67d0-4272-bd6d-c4e7956366fc', 'TR-0005', 'Practica5 (1).pdf', 'assignments\\TR-0005\\1786926513458-0e24e75d-Practica5 _1_.pdf', 'application/pdf', 248767, '2026-08-16 17:28:33'),
('909c63cc-40f3-4f1e-95a0-991d4659e0b8', 'TR-0004', 'Ejercicio Docker.pdf', 'C:\\Users\\ferba\\Desktop\\ADondeLoMando\\utslrc-sistema-fusionado\\backend\\uploads\\assignments\\TR-0004\\1786921284800-5f6c7fa4-Ejercicio Docker.pdf', 'application/pdf', 731968, '2026-08-16 16:01:24'),
('90c416b1-43ab-4758-a9c2-f36575621825', 'TR-0002', 'Practica 1- IAST (1).pdf', 'C:\\Users\\ferba\\Desktop\\ADondeLoMando\\utslrc-sistema-fusionado\\backend\\uploads\\assignments\\TR-0002\\1786847985818-35b8a146-Practica 1- IAST _1_.pdf', 'application/pdf', 629179, '2026-08-15 19:39:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `attendance_records`
--

CREATE TABLE `attendance_records` (
  `id` varchar(40) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `subject_id` varchar(10) NOT NULL,
  `teacher_id` varchar(10) NOT NULL,
  `fecha` date NOT NULL,
  `estado` enum('Presente','Falta','Retardo') NOT NULL,
  `justificacion` text DEFAULT NULL,
  `justificada` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `attendance_records`
--

INSERT INTO `attendance_records` (`id`, `student_id`, `group_id`, `subject_id`, `teacher_id`, `fecha`, `estado`, `justificacion`, `justificada`, `created_at`, `updated_at`) VALUES
('01174c9e-409b-42f8-81a5-15080deef79b', 'AL060', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('03a891fb-a660-48d8-969e-a4c96432595f', 'AL011', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('050c9730-6a30-40d3-bb37-b57c1aefb1e5', 'AL010', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('0b54953a-9f5b-4ef5-81c2-75283f8091e3', 'AL063', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('0de3a558-f0e6-4858-bd75-b062b5dfdb67', 'AL025', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('0f006c3a-0652-4372-834c-95e4cce8be9e', 'AL055', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('156957ca-4d17-4d66-b203-3ddf940a3adc', 'AL065', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('18d7743e-9c65-4d72-9def-7ab5f9dc5472', 'AL058', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('1ced7f44-91a1-4be5-a82d-9fb6a87ae53c', 'AL051', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('20073e5d-7a47-4015-9e6e-cb6ad636d2e6', 'AL050', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('2254d249-e6e7-4de2-a21d-2a0c6ff87e98', 'AL025', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('25b39472-10f8-4907-a738-846c56317290', 'AL009', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('274dac3a-898d-42ed-81b5-ab615dfb4fc6', 'AL060', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('2b411346-7293-4f70-8966-2f6aa625ee21', 'AL040', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('30929773-698c-4589-bc87-a45573030b56', 'AL061', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('31816125-ba0c-4ba6-a7fb-e61ea81ace16', 'AL019', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('32190d36-4758-4701-9e81-37181f314351', 'AL024', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('330389c7-7058-4eb2-b29a-3d4340dbd96c', 'AL007', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('377ec110-c5c5-41ba-9334-6cf4e174c448', 'AL052', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('38da90ed-dc1e-4f21-85a3-633e2548b482', 'AL056', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('3bad5b31-3bf4-429b-b382-1ac4e0ebad72', 'AL049', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('3d0d01c7-0a10-4131-a791-132a239cb940', 'AL007', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('3e6a131f-aa5f-4e5b-8fba-7908ab5df374', 'AL009', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('3fe0a25a-a2ec-4b73-8fe3-d98bfc453b95', 'AL023', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('452e1a1d-dd78-4b8d-9712-ad81c4989d5f', 'AL008', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('48d87d53-09ff-4518-8f87-1fe5e2efa192', 'AL061', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('49458c20-648a-416d-9fa9-8d2645a0fde1', 'AL016', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('5155a91b-4604-4535-b1eb-783caa075a04', 'AL011', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('5829712f-8b71-466d-85de-505a6ee35d99', 'AL062', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('5855a071-3fd0-4676-a368-5f781aab5674', 'AL038', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('5a2173a3-80da-4979-bfc4-e3f340e51741', 'AL037', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('5a8100a3-081d-4abc-ba33-175a51ee9bc5', 'AL021', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('5d99dd60-c742-467e-bb4a-47f2dbc793d7', 'AL017', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('5f66daee-4a10-41d9-a805-bc311bbe797c', 'AL053', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('5fa28336-aa05-475a-b47e-2da127f0bb53', 'AL034', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('624fa876-49ea-488d-a3f2-8a0461467a6b', 'AL002', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('633377d9-7b24-4273-910b-d8e193c9dbf4', 'AL039', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('65d12739-b39e-4552-bb4c-7a3b3f509bb1', 'AL015', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('69421f93-c682-4a1c-9ac0-288a06cec0a1', 'AL014', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('6aef388d-5039-44e9-9282-a251bdf5a88f', 'AL014', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('6edb8cf9-d442-498e-b0ec-46b3e8900f48', 'AL018', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('71e8fc98-b50d-4b6e-9b31-50e595c75dce', 'AL046', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('7536688b-f0c9-48f7-9f6f-1b617aebb24c', 'AL020', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('76d3cba6-6a1f-4361-ad57-f92979f91f2f', 'AL005', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('7d591beb-df3d-4426-88b4-ae4d8c9a20dc', 'AL059', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('7df8ce9d-6c16-407d-9d4f-187a37cec60d', 'AL020', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Falta', NULL, 1, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('7e00b6fe-1421-4905-9c5a-38325c48822f', 'AL046', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('7f38166c-6925-4334-a814-50ca6507c22d', 'AL028', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('7f60abaf-99e2-491a-99c4-89056f6026db', 'AL003', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('81b25437-b809-48c1-b80f-856528a84fce', 'AL026', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('86b57137-0c5e-448d-b976-989db78dbc0c', 'AL057', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('8b5784dd-b7f4-45ba-8f78-15754e0bedf6', 'AL002', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('8bb800a2-b294-4bd3-8fcc-b2c5abc0bab3', 'AL062', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('8c1655b3-9c74-4eb0-978a-7a642b16c447', 'AL054', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('8c6213ab-6849-45f0-bd4b-588910b91e65', 'AL054', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('900dbcac-5f48-4ab6-ac3c-d32eab8d0531', 'AL051', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('9113c5ed-6cf5-4dfd-8766-ef86609ecb4a', 'AL064', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('96949645-c66d-4bae-a6d7-40552b28eda2', 'AL013', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('98c83956-7e32-421e-831c-fc84d8e78c82', 'AL021', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('9b477567-8c37-41f7-8608-b66e91004081', 'AL004', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('9d9b1944-17ff-4559-ae83-25a805590314', 'AL024', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('9e42b228-0c2c-4b6e-ab52-b91bd196f6b5', 'AL042', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('9e4ce407-d5ae-4ede-9637-b1c1600540bf', 'AL019', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('a2d5e094-a2ab-485b-8b13-46b9714338b0', 'AL029', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('a73e5c49-62d4-41e2-bc11-db30b4b57038', 'AL045', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('af08a593-7e8d-4b36-84fe-30d884c0e8c2', 'AL044', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('af4dbfe6-1733-48e9-aa95-29c824588d0f', 'AL050', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('b216d758-30bc-45f9-9aee-022ca1a9cf47', 'AL063', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('b4fb6ee5-7b85-497c-93c2-bcf42f91a125', 'AL013', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('b5fe43f4-3ef6-445b-9227-bfcb4cc54679', 'AL047', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('b7471d26-1b68-4e8d-b9be-e8829f615a8a', 'AL012', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('b87b11cf-ddde-42a7-ae00-f94cdab96979', 'AL004', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('b9272875-e5f7-46db-acca-7a0f5c278f0d', 'AL048', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('bc5d52ba-16b8-47b1-9437-3977d7952fbe', 'AL065', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('bd6ee7f8-3de8-45d3-8d4f-404834b437fa', 'AL053', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('be233b1d-edb9-49a1-97b5-498c6ec0042f', 'AL008', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('c04d90a8-57f8-44a4-aa76-0d354fa2c073', 'AL032', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('c253f86a-5723-4d2a-a2f7-c15a548bef24', 'AL033', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('c2ee4e40-7c80-4f3c-aa73-dddeae1a2776', 'AL027', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('c4161acf-b805-4ac2-99f5-7c9314fb90dd', 'AL023', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('c4e965ad-8bd4-47e7-8502-ba04f554fe6a', 'AL048', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('c9e6e2b8-591e-4d99-a2b8-b13148c47461', 'AL006', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('cc31af4d-570b-41bb-ba1c-233483982f2d', 'AL012', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('cd88440b-3872-4b45-bf8b-d0bb64144f19', 'AL016', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('d183e110-1dcf-4b3a-8581-22833888bd39', 'AL056', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('d3ab3e36-47f6-4077-bbcb-ab50f8fcce2c', 'AL006', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('d8830ed6-4da4-4851-b542-2e1493d5d707', 'AL022', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('da2db611-485e-46a7-be4d-f7f9e65cfeb0', 'AL041', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('dc601a92-4235-4b78-815a-814683457c37', 'AL018', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('dd1bfd8a-b898-4118-b4a4-c7a37f5853ba', 'AL001', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('ddf47492-6052-4924-8486-84896c948bea', 'AL049', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('de732d73-c35f-4282-8aed-6572457ff391', 'AL031', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('e0a4c529-6ef0-4fed-a466-5e2dcfc1babe', 'AL030', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('e18635a9-f32e-43e1-a97e-e5d6877d46cc', 'AL036', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('e83a6f6f-e74e-432f-95f6-c8024a884604', 'AL010', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('e91f2f4c-a920-4530-b12c-3418f4b20105', 'AL052', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('ea76c791-9310-46d2-b4db-c369d26f279c', 'AL003', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('ebec2add-be97-4b3a-a865-3597b83923b7', 'AL043', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('ebfe7e35-dd7e-4962-a162-ae89f36e77af', 'AL015', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('ec247246-56eb-4541-af04-5df82341b31c', 'AL045', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('ecd0358f-0ff9-4698-993a-38f522ce641d', 'AL001', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('ef280a9b-fb6a-45f5-b148-15e4707f1a37', 'AL005', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:31:12', '2026-08-16 17:04:45'),
('f0d25494-47d3-447b-ba28-9ea2eeb2c8f4', 'AL057', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('f11877fc-cc32-425c-b1b2-ca59103c2128', 'AL055', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('f4edf577-0f91-4ce3-b908-d17179c17bcf', 'AL022', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('f6120ac0-f06f-4446-aaa6-1b1a7847f857', 'AL059', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('f9b2574a-2fc5-40de-ac5d-185d51fed0a8', 'AL017', 'IDGS 8-1', 'SUB007', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:31:25', '2026-08-16 16:31:25'),
('fb3b5d21-2e94-4fcc-8224-6ca6c982b5aa', 'AL035', 'IDGS 8-2', 'SUB013', 'DOC001', '2026-08-17', 'Presente', NULL, 0, '2026-08-16 17:11:39', '2026-08-16 17:11:39'),
('fe30f9ec-e593-4e9b-a404-d8a588ab1813', 'AL047', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-15', 'Presente', NULL, 0, '2026-08-16 16:41:30', '2026-08-16 16:41:30'),
('ff247289-9479-43cc-94e5-c39f54d2a3ec', 'AL058', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23'),
('ff343061-6c5d-4340-8ae1-b8a913881e1e', 'AL064', 'IDGS 8-3', 'SUB001', 'DOC001', '2026-08-16', 'Presente', NULL, 0, '2026-08-16 16:41:17', '2026-08-16 16:41:23');

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
('AL001', 2, 0, 0, 100, 'Regular'),
('AL002', 2, 0, 0, 100, 'Regular'),
('AL003', 2, 0, 0, 100, 'Regular'),
('AL004', 2, 0, 0, 100, 'Regular'),
('AL005', 2, 0, 0, 100, 'Regular'),
('AL006', 2, 0, 0, 100, 'Regular'),
('AL007', 2, 0, 0, 100, 'Regular'),
('AL008', 2, 0, 0, 100, 'Regular'),
('AL009', 2, 0, 0, 100, 'Regular'),
('AL010', 2, 0, 0, 100, 'Regular'),
('AL011', 2, 0, 0, 100, 'Regular'),
('AL012', 2, 0, 0, 100, 'Regular'),
('AL013', 2, 0, 0, 100, 'Regular'),
('AL014', 2, 0, 0, 100, 'Regular'),
('AL015', 2, 0, 0, 100, 'Regular'),
('AL016', 2, 0, 0, 100, 'Regular'),
('AL017', 2, 0, 0, 100, 'Regular'),
('AL018', 2, 0, 0, 100, 'Regular'),
('AL019', 2, 0, 0, 100, 'Regular'),
('AL020', 1, 1, 0, 50, 'Crítico'),
('AL021', 2, 0, 0, 100, 'Regular'),
('AL022', 2, 0, 0, 100, 'Regular'),
('AL023', 2, 0, 0, 100, 'Regular'),
('AL024', 2, 0, 0, 100, 'Regular'),
('AL025', 2, 0, 0, 100, 'Regular'),
('AL026', 1, 0, 0, 100, 'Regular'),
('AL027', 1, 0, 0, 100, 'Regular'),
('AL028', 1, 0, 0, 100, 'Regular'),
('AL029', 1, 0, 0, 100, 'Regular'),
('AL030', 1, 0, 0, 100, 'Regular'),
('AL031', 1, 0, 0, 100, 'Regular'),
('AL032', 1, 0, 0, 100, 'Regular'),
('AL033', 1, 0, 0, 100, 'Regular'),
('AL034', 1, 0, 0, 100, 'Regular'),
('AL035', 1, 0, 0, 100, 'Regular'),
('AL036', 1, 0, 0, 100, 'Regular'),
('AL037', 1, 0, 0, 100, 'Regular'),
('AL038', 1, 0, 0, 100, 'Regular'),
('AL039', 1, 0, 0, 100, 'Regular'),
('AL040', 1, 0, 0, 100, 'Regular'),
('AL041', 1, 0, 0, 100, 'Regular'),
('AL042', 1, 0, 0, 100, 'Regular'),
('AL043', 1, 0, 0, 100, 'Regular'),
('AL044', 1, 0, 0, 100, 'Regular'),
('AL045', 2, 0, 0, 100, 'Regular'),
('AL046', 2, 0, 0, 100, 'Regular'),
('AL047', 2, 0, 0, 100, 'Regular'),
('AL048', 2, 0, 0, 100, 'Regular'),
('AL049', 2, 0, 0, 100, 'Regular'),
('AL050', 2, 0, 0, 100, 'Regular'),
('AL051', 2, 0, 0, 100, 'Regular'),
('AL052', 2, 0, 0, 100, 'Regular'),
('AL053', 2, 0, 0, 100, 'Regular'),
('AL054', 2, 0, 0, 100, 'Regular'),
('AL055', 2, 0, 0, 100, 'Regular'),
('AL056', 2, 0, 0, 100, 'Regular'),
('AL057', 2, 0, 0, 100, 'Regular'),
('AL058', 2, 0, 0, 100, 'Regular'),
('AL059', 2, 0, 0, 100, 'Regular'),
('AL060', 2, 0, 0, 100, 'Regular'),
('AL061', 2, 0, 0, 100, 'Regular'),
('AL062', 2, 0, 0, 100, 'Regular'),
('AL063', 2, 0, 0, 100, 'Regular'),
('AL064', 2, 0, 0, 100, 'Regular'),
('AL065', 2, 0, 0, 100, 'Regular');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `books`
--

CREATE TABLE `books` (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `titulo` varchar(300) NOT NULL,
  `autor` varchar(300) NOT NULL,
  `categoria` varchar(100) NOT NULL DEFAULT 'General',
  `ejemplares` int(11) NOT NULL DEFAULT 1,
  `disponibles` int(11) NOT NULL DEFAULT 1,
  `portada` varchar(500) DEFAULT NULL,
  `google_books_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `books`
--

INSERT INTO `books` (`id`, `isbn`, `titulo`, `autor`, `categoria`, `ejemplares`, `disponibles`, `portada`, `google_books_id`, `created_at`) VALUES
('L-0001', '9789684443457', 'Estructuras de Datos y Algoritmos', 'Aho, Hopcroft & Ullman', 'Programación', 6, 2, 'https://books.google.com/books/content?id=2nEbPAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '2nEbPAAACAAJ', '2026-08-14 00:30:36'),
('L-0002', '9786073208178', 'Redes de Computadoras', 'Andrew S. Tanenbaum', 'Redes', 4, 4, 'https://books.google.com/books/content?id=d_m3W_Yob8kC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'd_m3W_Yob8kC', '2026-08-14 00:30:36'),
('L-0003', '9788478290857', 'Bases de Datos: Diseño y Gestión', 'Ramez Elmasri', 'Bases de Datos', 5, 1, 'https://books.google.com/books/content?id=NT3uPQAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'NT3uPQAACAAJ', '2026-08-14 00:30:36'),
('L-0004', '9786073206037', 'Ingeniería de Software Moderna', 'Ian Sommerville', 'Software', 3, 0, 'https://books.google.com/books/content?id=gQWd49zSut4C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 'gQWd49zSut4C', '2026-08-14 00:30:36'),
('L-0005', '9781456223960', 'Metodología de la Investigación', 'Roberto Hernández Sampieri', 'General', 8, 5, 'https://books.google.com/books/content?id=5A2QDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', '5A2QDwAAQBAJ', '2026-08-14 00:30:36'),
('L-0006', '9788499640365', 'Enciclopedia de la Seguridad Informática', 'Álvaro Gómez Vieites', 'Seguridad', 3, 3, 'https://books.google.com/books/content?id=Bq8-DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 'Bq8-DwAAQBAJ', '2026-08-14 00:30:36'),
('L-0007', '9788448146412', 'Sistemas Operativos: Conceptos Fundamentales', 'Abraham Silberschatz', 'Sistemas Operativos', 4, 4, 'https://books.google.com/books/content?id=9sdXAAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9sdXAAAACAAJ', '2026-08-14 00:30:36'),
('L-0008', '9788429126204', 'Arquitectura de Computadoras', 'David A. Patterson & John L. Hennessy', 'Hardware', 3, 2, 'https://books.google.com/books/content?id=rEjaLxQ4bl8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 'rEjaLxQ4bl8C', '2026-08-14 00:30:36'),
('L-0009', '9786071514684', 'Fundamentos de Programación', 'Luis Joyanes Aguilar', 'Programación', 6, 6, 'https://books.google.com/books/content?id=nrNvPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'nrNvPwAACAAJ', '2026-08-14 00:30:36'),
('L-0011', '9788420540030', 'Inteligencia Artificial: Un Enfoque Moderno', 'Stuart Russell & Peter Norvig', 'Inteligencia Artificial', 4, 4, 'https://books.google.com/books/content?id=yZCVPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'yZCVPwAACAAJ', '2026-08-14 00:30:36'),
('L-0012', '978-607-15-0982', 'Desarrollo Web con JavaScript Moderno', 'Marijn Haverbeke', 'Desarrollo Web', 5, 3, 'https://books.google.com/books/content?id=yDGgEQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 'yDGgEQAAQBAJ', '2026-08-14 00:30:36');

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
('IDGS', 'Ingeniería en Desarrollo y Gestión de Software', 'IDGS', 'Ingeniería / TSU', '4 años (13 cuatrimestres)', 'Presencial', 'Formación en desarrollo de software, gestión de proyectos TI, bases de datos e infraestructura tecnológica.'),
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
('AL001-EN-SUB007', 'AL001', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-SUB008', 'AL001', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-SUB009', 'AL001', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-SUB010', 'AL001', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-SUB011', 'AL001', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL001-EN-SUB012', 'AL001', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB007', 'AL002', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB008', 'AL002', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB009', 'AL002', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB010', 'AL002', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB011', 'AL002', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL002-EN-SUB012', 'AL002', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB007', 'AL003', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB008', 'AL003', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB009', 'AL003', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB010', 'AL003', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB011', 'AL003', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL003-EN-SUB012', 'AL003', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB007', 'AL004', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB008', 'AL004', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB009', 'AL004', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB010', 'AL004', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB011', 'AL004', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL004-EN-SUB012', 'AL004', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB007', 'AL005', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB008', 'AL005', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB009', 'AL005', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB010', 'AL005', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB011', 'AL005', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL005-EN-SUB012', 'AL005', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB007', 'AL006', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB008', 'AL006', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB009', 'AL006', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB010', 'AL006', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB011', 'AL006', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL006-EN-SUB012', 'AL006', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB007', 'AL007', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB008', 'AL007', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB009', 'AL007', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB010', 'AL007', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB011', 'AL007', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL007-EN-SUB012', 'AL007', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB007', 'AL008', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB008', 'AL008', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB009', 'AL008', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB010', 'AL008', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB011', 'AL008', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL008-EN-SUB012', 'AL008', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB007', 'AL009', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB008', 'AL009', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB009', 'AL009', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB010', 'AL009', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB011', 'AL009', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL009-EN-SUB012', 'AL009', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB007', 'AL010', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB008', 'AL010', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB009', 'AL010', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB010', 'AL010', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB011', 'AL010', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL010-EN-SUB012', 'AL010', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB007', 'AL011', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB008', 'AL011', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB009', 'AL011', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB010', 'AL011', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB011', 'AL011', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL011-EN-SUB012', 'AL011', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB007', 'AL012', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB008', 'AL012', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB009', 'AL012', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB010', 'AL012', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB011', 'AL012', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL012-EN-SUB012', 'AL012', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB007', 'AL013', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB008', 'AL013', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB009', 'AL013', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB010', 'AL013', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB011', 'AL013', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL013-EN-SUB012', 'AL013', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB007', 'AL014', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB008', 'AL014', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB009', 'AL014', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB010', 'AL014', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB011', 'AL014', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL014-EN-SUB012', 'AL014', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB007', 'AL015', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB008', 'AL015', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB009', 'AL015', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB010', 'AL015', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB011', 'AL015', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL015-EN-SUB012', 'AL015', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB007', 'AL016', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB008', 'AL016', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB009', 'AL016', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB010', 'AL016', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB011', 'AL016', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL016-EN-SUB012', 'AL016', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB007', 'AL017', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB008', 'AL017', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB009', 'AL017', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB010', 'AL017', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB011', 'AL017', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL017-EN-SUB012', 'AL017', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB007', 'AL018', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB008', 'AL018', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB009', 'AL018', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB010', 'AL018', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB011', 'AL018', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL018-EN-SUB012', 'AL018', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB007', 'AL019', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB008', 'AL019', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB009', 'AL019', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB010', 'AL019', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB011', 'AL019', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL019-EN-SUB012', 'AL019', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB007', 'AL020', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB008', 'AL020', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB009', 'AL020', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB010', 'AL020', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB011', 'AL020', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL020-EN-SUB012', 'AL020', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB007', 'AL021', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB008', 'AL021', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB009', 'AL021', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB010', 'AL021', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB011', 'AL021', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL021-EN-SUB012', 'AL021', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB007', 'AL022', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB008', 'AL022', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB009', 'AL022', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB010', 'AL022', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB011', 'AL022', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL022-EN-SUB012', 'AL022', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB007', 'AL023', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB008', 'AL023', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB009', 'AL023', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB010', 'AL023', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB011', 'AL023', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL023-EN-SUB012', 'AL023', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB007', 'AL024', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB008', 'AL024', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB009', 'AL024', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB010', 'AL024', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB011', 'AL024', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL024-EN-SUB012', 'AL024', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB007', 'AL025', 'SUB007', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB008', 'AL025', 'SUB008', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB009', 'AL025', 'SUB009', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB010', 'AL025', 'SUB010', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB011', 'AL025', 'SUB011', 'Enero – Abril 2025', 'Inscrito'),
('AL025-EN-SUB012', 'AL025', 'SUB012', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB013', 'AL026', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB014', 'AL026', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB015', 'AL026', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB016', 'AL026', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB017', 'AL026', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL026-EN-SUB018', 'AL026', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB013', 'AL027', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB014', 'AL027', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB015', 'AL027', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB016', 'AL027', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB017', 'AL027', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL027-EN-SUB018', 'AL027', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB013', 'AL028', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB014', 'AL028', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB015', 'AL028', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB016', 'AL028', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB017', 'AL028', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL028-EN-SUB018', 'AL028', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB013', 'AL029', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB014', 'AL029', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB015', 'AL029', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB016', 'AL029', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB017', 'AL029', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL029-EN-SUB018', 'AL029', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB013', 'AL030', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB014', 'AL030', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB015', 'AL030', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB016', 'AL030', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB017', 'AL030', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL030-EN-SUB018', 'AL030', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB013', 'AL031', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB014', 'AL031', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB015', 'AL031', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB016', 'AL031', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB017', 'AL031', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL031-EN-SUB018', 'AL031', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB013', 'AL032', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB014', 'AL032', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB015', 'AL032', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB016', 'AL032', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB017', 'AL032', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL032-EN-SUB018', 'AL032', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB013', 'AL033', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB014', 'AL033', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB015', 'AL033', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB016', 'AL033', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB017', 'AL033', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL033-EN-SUB018', 'AL033', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB013', 'AL034', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB014', 'AL034', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB015', 'AL034', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB016', 'AL034', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB017', 'AL034', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL034-EN-SUB018', 'AL034', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB013', 'AL035', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB014', 'AL035', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB015', 'AL035', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB016', 'AL035', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB017', 'AL035', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL035-EN-SUB018', 'AL035', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB013', 'AL036', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB014', 'AL036', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB015', 'AL036', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB016', 'AL036', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB017', 'AL036', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL036-EN-SUB018', 'AL036', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB013', 'AL037', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB014', 'AL037', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB015', 'AL037', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB016', 'AL037', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB017', 'AL037', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL037-EN-SUB018', 'AL037', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB013', 'AL038', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB014', 'AL038', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB015', 'AL038', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB016', 'AL038', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB017', 'AL038', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL038-EN-SUB018', 'AL038', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB013', 'AL039', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB014', 'AL039', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB015', 'AL039', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB016', 'AL039', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB017', 'AL039', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL039-EN-SUB018', 'AL039', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB013', 'AL040', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB014', 'AL040', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB015', 'AL040', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB016', 'AL040', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB017', 'AL040', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL040-EN-SUB018', 'AL040', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB013', 'AL041', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB014', 'AL041', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB015', 'AL041', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB016', 'AL041', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB017', 'AL041', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL041-EN-SUB018', 'AL041', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB013', 'AL042', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB014', 'AL042', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB015', 'AL042', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB016', 'AL042', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB017', 'AL042', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL042-EN-SUB018', 'AL042', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB013', 'AL043', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB014', 'AL043', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB015', 'AL043', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB016', 'AL043', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB017', 'AL043', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL043-EN-SUB018', 'AL043', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB013', 'AL044', 'SUB013', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB014', 'AL044', 'SUB014', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB015', 'AL044', 'SUB015', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB016', 'AL044', 'SUB016', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB017', 'AL044', 'SUB017', 'Enero – Abril 2025', 'Inscrito'),
('AL044-EN-SUB018', 'AL044', 'SUB018', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB001', 'AL045', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB002', 'AL045', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB003', 'AL045', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB004', 'AL045', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB005', 'AL045', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL045-EN-SUB006', 'AL045', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB001', 'AL046', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB002', 'AL046', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB003', 'AL046', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB004', 'AL046', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB005', 'AL046', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL046-EN-SUB006', 'AL046', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB001', 'AL047', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB002', 'AL047', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB003', 'AL047', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB004', 'AL047', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB005', 'AL047', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL047-EN-SUB006', 'AL047', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB001', 'AL048', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB002', 'AL048', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB003', 'AL048', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB004', 'AL048', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB005', 'AL048', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL048-EN-SUB006', 'AL048', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB001', 'AL049', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB002', 'AL049', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB003', 'AL049', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB004', 'AL049', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB005', 'AL049', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL049-EN-SUB006', 'AL049', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB001', 'AL050', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB002', 'AL050', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB003', 'AL050', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB004', 'AL050', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB005', 'AL050', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL050-EN-SUB006', 'AL050', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB001', 'AL051', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB002', 'AL051', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB003', 'AL051', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB004', 'AL051', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB005', 'AL051', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL051-EN-SUB006', 'AL051', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB001', 'AL052', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB002', 'AL052', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB003', 'AL052', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB004', 'AL052', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB005', 'AL052', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL052-EN-SUB006', 'AL052', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB001', 'AL053', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB002', 'AL053', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB003', 'AL053', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB004', 'AL053', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB005', 'AL053', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL053-EN-SUB006', 'AL053', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB001', 'AL054', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB002', 'AL054', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB003', 'AL054', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB004', 'AL054', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB005', 'AL054', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL054-EN-SUB006', 'AL054', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB001', 'AL055', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB002', 'AL055', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB003', 'AL055', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB004', 'AL055', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB005', 'AL055', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL055-EN-SUB006', 'AL055', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB001', 'AL056', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB002', 'AL056', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB003', 'AL056', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB004', 'AL056', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB005', 'AL056', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL056-EN-SUB006', 'AL056', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB001', 'AL057', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB002', 'AL057', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB003', 'AL057', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB004', 'AL057', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB005', 'AL057', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL057-EN-SUB006', 'AL057', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB001', 'AL058', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB002', 'AL058', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB003', 'AL058', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB004', 'AL058', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB005', 'AL058', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL058-EN-SUB006', 'AL058', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB001', 'AL059', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB002', 'AL059', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB003', 'AL059', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB004', 'AL059', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB005', 'AL059', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL059-EN-SUB006', 'AL059', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB001', 'AL060', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB002', 'AL060', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB003', 'AL060', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB004', 'AL060', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB005', 'AL060', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL060-EN-SUB006', 'AL060', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB001', 'AL061', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB002', 'AL061', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB003', 'AL061', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB004', 'AL061', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB005', 'AL061', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL061-EN-SUB006', 'AL061', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB001', 'AL062', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB002', 'AL062', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB003', 'AL062', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB004', 'AL062', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB005', 'AL062', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL062-EN-SUB006', 'AL062', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB001', 'AL063', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB002', 'AL063', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB003', 'AL063', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB004', 'AL063', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB005', 'AL063', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL063-EN-SUB006', 'AL063', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB001', 'AL064', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB002', 'AL064', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB003', 'AL064', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB004', 'AL064', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB005', 'AL064', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL064-EN-SUB006', 'AL064', 'SUB006', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB001', 'AL065', 'SUB001', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB002', 'AL065', 'SUB002', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB003', 'AL065', 'SUB003', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB004', 'AL065', 'SUB004', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB005', 'AL065', 'SUB005', 'Enero – Abril 2025', 'Inscrito'),
('AL065-EN-SUB006', 'AL065', 'SUB006', 'Enero – Abril 2025', 'Inscrito');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grade_records`
--

CREATE TABLE `grade_records` (
  `id` varchar(20) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `subject_id` varchar(10) NOT NULL,
  `parcial` enum('Parcial 1','Parcial 2','Parcial 3') NOT NULL DEFAULT 'Parcial 1',
  `periodo` varchar(50) NOT NULL DEFAULT 'Enero – Abril 2025',
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

INSERT INTO `grade_records` (`id`, `student_id`, `subject_id`, `parcial`, `periodo`, `evidencias`, `conocimiento`, `desempeno`, `actitud`, `examen`, `final`) VALUES
('AL001-SUB007-P1', 'AL001', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL001-SUB007-P2', 'AL001', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL001-SUB008-P1', 'AL001', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL001-SUB008-P2', 'AL001', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL001-SUB009-P1', 'AL001', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL001-SUB009-P2', 'AL001', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL001-SUB010-P1', 'AL001', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL001-SUB010-P2', 'AL001', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL001-SUB011-P1', 'AL001', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL001-SUB011-P2', 'AL001', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL001-SUB012-P1', 'AL001', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL001-SUB012-P2', 'AL001', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL002-SUB007-P1', 'AL002', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL002-SUB007-P2', 'AL002', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL002-SUB008-P1', 'AL002', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL002-SUB008-P2', 'AL002', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL002-SUB009-P1', 'AL002', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL002-SUB009-P2', 'AL002', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL002-SUB010-P1', 'AL002', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL002-SUB010-P2', 'AL002', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL002-SUB011-P1', 'AL002', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL002-SUB011-P2', 'AL002', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL002-SUB012-P1', 'AL002', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL002-SUB012-P2', 'AL002', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL003-SUB007-P1', 'AL003', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL003-SUB007-P2', 'AL003', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL003-SUB008-P1', 'AL003', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL003-SUB008-P2', 'AL003', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL003-SUB009-P1', 'AL003', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL003-SUB009-P2', 'AL003', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL003-SUB010-P1', 'AL003', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL003-SUB010-P2', 'AL003', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL003-SUB011-P1', 'AL003', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL003-SUB011-P2', 'AL003', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL003-SUB012-P1', 'AL003', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL003-SUB012-P2', 'AL003', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL004-SUB007-P1', 'AL004', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL004-SUB007-P2', 'AL004', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL004-SUB008-P1', 'AL004', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL004-SUB008-P2', 'AL004', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL004-SUB009-P1', 'AL004', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL004-SUB009-P2', 'AL004', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL004-SUB010-P1', 'AL004', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL004-SUB010-P2', 'AL004', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL004-SUB011-P1', 'AL004', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL004-SUB011-P2', 'AL004', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL004-SUB012-P1', 'AL004', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL004-SUB012-P2', 'AL004', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL005-SUB007-P1', 'AL005', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL005-SUB007-P2', 'AL005', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL005-SUB008-P1', 'AL005', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL005-SUB008-P2', 'AL005', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL005-SUB009-P1', 'AL005', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL005-SUB009-P2', 'AL005', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL005-SUB010-P1', 'AL005', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL005-SUB010-P2', 'AL005', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL005-SUB011-P1', 'AL005', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL005-SUB011-P2', 'AL005', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL005-SUB012-P1', 'AL005', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL005-SUB012-P2', 'AL005', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL006-SUB007-P1', 'AL006', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL006-SUB007-P2', 'AL006', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL006-SUB008-P1', 'AL006', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL006-SUB008-P2', 'AL006', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL006-SUB009-P1', 'AL006', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL006-SUB009-P2', 'AL006', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL006-SUB010-P1', 'AL006', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL006-SUB010-P2', 'AL006', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL006-SUB011-P1', 'AL006', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL006-SUB011-P2', 'AL006', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL006-SUB012-P1', 'AL006', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL006-SUB012-P2', 'AL006', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL007-SUB007-P1', 'AL007', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL007-SUB007-P2', 'AL007', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL007-SUB008-P1', 'AL007', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL007-SUB008-P2', 'AL007', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL007-SUB009-P1', 'AL007', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL007-SUB009-P2', 'AL007', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL007-SUB010-P1', 'AL007', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL007-SUB010-P2', 'AL007', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL007-SUB011-P1', 'AL007', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL007-SUB011-P2', 'AL007', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL007-SUB012-P1', 'AL007', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL007-SUB012-P2', 'AL007', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL008-SUB007-P1', 'AL008', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL008-SUB007-P2', 'AL008', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL008-SUB008-P1', 'AL008', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL008-SUB008-P2', 'AL008', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL008-SUB009-P1', 'AL008', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL008-SUB009-P2', 'AL008', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL008-SUB010-P1', 'AL008', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL008-SUB010-P2', 'AL008', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL008-SUB011-P1', 'AL008', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL008-SUB011-P2', 'AL008', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL008-SUB012-P1', 'AL008', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL008-SUB012-P2', 'AL008', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL009-SUB007-P1', 'AL009', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL009-SUB007-P2', 'AL009', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL009-SUB008-P1', 'AL009', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL009-SUB008-P2', 'AL009', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL009-SUB009-P1', 'AL009', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL009-SUB009-P2', 'AL009', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL009-SUB010-P1', 'AL009', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL009-SUB010-P2', 'AL009', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL009-SUB011-P1', 'AL009', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL009-SUB011-P2', 'AL009', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL009-SUB012-P1', 'AL009', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL009-SUB012-P2', 'AL009', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL010-SUB007-P1', 'AL010', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL010-SUB007-P2', 'AL010', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL010-SUB008-P1', 'AL010', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL010-SUB008-P2', 'AL010', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL010-SUB009-P1', 'AL010', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL010-SUB009-P2', 'AL010', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL010-SUB010-P1', 'AL010', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL010-SUB010-P2', 'AL010', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL010-SUB011-P1', 'AL010', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL010-SUB011-P2', 'AL010', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL010-SUB012-P1', 'AL010', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL010-SUB012-P2', 'AL010', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL011-SUB007-P1', 'AL011', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL011-SUB007-P2', 'AL011', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL011-SUB008-P1', 'AL011', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL011-SUB008-P2', 'AL011', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL011-SUB009-P1', 'AL011', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL011-SUB009-P2', 'AL011', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL011-SUB010-P1', 'AL011', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL011-SUB010-P2', 'AL011', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL011-SUB011-P1', 'AL011', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL011-SUB011-P2', 'AL011', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL011-SUB012-P1', 'AL011', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL011-SUB012-P2', 'AL011', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL012-SUB007-P1', 'AL012', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL012-SUB007-P2', 'AL012', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL012-SUB008-P1', 'AL012', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL012-SUB008-P2', 'AL012', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL012-SUB009-P1', 'AL012', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL012-SUB009-P2', 'AL012', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL012-SUB010-P1', 'AL012', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL012-SUB010-P2', 'AL012', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL012-SUB011-P1', 'AL012', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL012-SUB011-P2', 'AL012', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL012-SUB012-P1', 'AL012', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL012-SUB012-P2', 'AL012', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL013-SUB007-P1', 'AL013', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL013-SUB007-P2', 'AL013', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL013-SUB008-P1', 'AL013', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL013-SUB008-P2', 'AL013', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL013-SUB009-P1', 'AL013', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL013-SUB009-P2', 'AL013', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL013-SUB010-P1', 'AL013', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL013-SUB010-P2', 'AL013', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL013-SUB011-P1', 'AL013', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL013-SUB011-P2', 'AL013', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL013-SUB012-P1', 'AL013', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL013-SUB012-P2', 'AL013', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL014-SUB007-P1', 'AL014', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL014-SUB007-P2', 'AL014', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL014-SUB008-P1', 'AL014', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL014-SUB008-P2', 'AL014', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL014-SUB009-P1', 'AL014', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL014-SUB009-P2', 'AL014', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL014-SUB010-P1', 'AL014', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL014-SUB010-P2', 'AL014', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL014-SUB011-P1', 'AL014', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL014-SUB011-P2', 'AL014', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL014-SUB012-P1', 'AL014', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL014-SUB012-P2', 'AL014', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL015-SUB007-P1', 'AL015', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL015-SUB007-P2', 'AL015', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL015-SUB008-P1', 'AL015', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL015-SUB008-P2', 'AL015', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL015-SUB009-P1', 'AL015', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL015-SUB009-P2', 'AL015', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL015-SUB010-P1', 'AL015', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL015-SUB010-P2', 'AL015', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL015-SUB011-P1', 'AL015', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL015-SUB011-P2', 'AL015', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL015-SUB012-P1', 'AL015', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL015-SUB012-P2', 'AL015', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL016-SUB007-P1', 'AL016', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL016-SUB007-P2', 'AL016', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL016-SUB008-P1', 'AL016', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL016-SUB008-P2', 'AL016', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL016-SUB009-P1', 'AL016', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL016-SUB009-P2', 'AL016', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL016-SUB010-P1', 'AL016', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL016-SUB010-P2', 'AL016', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL016-SUB011-P1', 'AL016', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL016-SUB011-P2', 'AL016', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL016-SUB012-P1', 'AL016', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL016-SUB012-P2', 'AL016', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL017-SUB007-P1', 'AL017', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL017-SUB007-P2', 'AL017', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL017-SUB008-P1', 'AL017', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL017-SUB008-P2', 'AL017', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL017-SUB009-P1', 'AL017', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL017-SUB009-P2', 'AL017', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL017-SUB010-P1', 'AL017', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL017-SUB010-P2', 'AL017', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL017-SUB011-P1', 'AL017', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL017-SUB011-P2', 'AL017', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL017-SUB012-P1', 'AL017', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL017-SUB012-P2', 'AL017', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL018-SUB007-P1', 'AL018', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL018-SUB007-P2', 'AL018', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL018-SUB008-P1', 'AL018', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL018-SUB008-P2', 'AL018', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL018-SUB009-P1', 'AL018', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL018-SUB009-P2', 'AL018', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL018-SUB010-P1', 'AL018', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL018-SUB010-P2', 'AL018', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL018-SUB011-P1', 'AL018', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL018-SUB011-P2', 'AL018', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL018-SUB012-P1', 'AL018', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL018-SUB012-P2', 'AL018', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL019-SUB007-P1', 'AL019', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL019-SUB007-P2', 'AL019', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL019-SUB008-P1', 'AL019', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL019-SUB008-P2', 'AL019', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL019-SUB009-P1', 'AL019', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL019-SUB009-P2', 'AL019', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL019-SUB010-P1', 'AL019', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL019-SUB010-P2', 'AL019', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL019-SUB011-P1', 'AL019', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL019-SUB011-P2', 'AL019', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL019-SUB012-P1', 'AL019', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL019-SUB012-P2', 'AL019', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL020-SUB007-P1', 'AL020', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL020-SUB007-P2', 'AL020', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL020-SUB008-P1', 'AL020', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL020-SUB008-P2', 'AL020', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL020-SUB009-P1', 'AL020', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL020-SUB009-P2', 'AL020', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL020-SUB010-P1', 'AL020', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL020-SUB010-P2', 'AL020', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL020-SUB011-P1', 'AL020', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL020-SUB011-P2', 'AL020', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL020-SUB012-P1', 'AL020', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL020-SUB012-P2', 'AL020', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL021-SUB007-P1', 'AL021', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL021-SUB007-P2', 'AL021', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL021-SUB008-P1', 'AL021', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL021-SUB008-P2', 'AL021', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL021-SUB009-P1', 'AL021', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL021-SUB009-P2', 'AL021', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL021-SUB010-P1', 'AL021', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL021-SUB010-P2', 'AL021', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL021-SUB011-P1', 'AL021', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL021-SUB011-P2', 'AL021', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL021-SUB012-P1', 'AL021', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL021-SUB012-P2', 'AL021', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL022-SUB007-P1', 'AL022', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL022-SUB007-P2', 'AL022', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL022-SUB008-P1', 'AL022', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL022-SUB008-P2', 'AL022', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL022-SUB009-P1', 'AL022', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL022-SUB009-P2', 'AL022', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL022-SUB010-P1', 'AL022', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL022-SUB010-P2', 'AL022', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL022-SUB011-P1', 'AL022', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL022-SUB011-P2', 'AL022', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL022-SUB012-P1', 'AL022', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL022-SUB012-P2', 'AL022', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL023-SUB007-P1', 'AL023', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL023-SUB007-P2', 'AL023', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL023-SUB008-P1', 'AL023', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL023-SUB008-P2', 'AL023', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL023-SUB009-P1', 'AL023', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL023-SUB009-P2', 'AL023', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL023-SUB010-P1', 'AL023', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL023-SUB010-P2', 'AL023', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL023-SUB011-P1', 'AL023', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL023-SUB011-P2', 'AL023', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL023-SUB012-P1', 'AL023', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL023-SUB012-P2', 'AL023', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL024-SUB007-P1', 'AL024', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL024-SUB007-P2', 'AL024', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL024-SUB008-P1', 'AL024', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL024-SUB008-P2', 'AL024', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL024-SUB009-P1', 'AL024', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL024-SUB009-P2', 'AL024', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL024-SUB010-P1', 'AL024', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL024-SUB010-P2', 'AL024', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL024-SUB011-P1', 'AL024', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL024-SUB011-P2', 'AL024', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL024-SUB012-P1', 'AL024', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL024-SUB012-P2', 'AL024', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL025-SUB007-P1', 'AL025', 'SUB007', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL025-SUB007-P2', 'AL025', 'SUB007', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL025-SUB008-P1', 'AL025', 'SUB008', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL025-SUB008-P2', 'AL025', 'SUB008', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL025-SUB009-P1', 'AL025', 'SUB009', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL025-SUB009-P2', 'AL025', 'SUB009', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL025-SUB010-P1', 'AL025', 'SUB010', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL025-SUB010-P2', 'AL025', 'SUB010', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL025-SUB011-P1', 'AL025', 'SUB011', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL025-SUB011-P2', 'AL025', 'SUB011', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL025-SUB012-P1', 'AL025', 'SUB012', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL025-SUB012-P2', 'AL025', 'SUB012', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL026-SUB013-P1', 'AL026', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL026-SUB013-P2', 'AL026', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL026-SUB014-P1', 'AL026', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL026-SUB014-P2', 'AL026', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL026-SUB015-P1', 'AL026', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL026-SUB015-P2', 'AL026', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL026-SUB016-P1', 'AL026', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL026-SUB016-P2', 'AL026', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL026-SUB017-P1', 'AL026', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL026-SUB017-P2', 'AL026', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL026-SUB018-P1', 'AL026', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL026-SUB018-P2', 'AL026', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL027-SUB013-P1', 'AL027', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL027-SUB013-P2', 'AL027', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL027-SUB014-P1', 'AL027', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL027-SUB014-P2', 'AL027', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL027-SUB015-P1', 'AL027', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL027-SUB015-P2', 'AL027', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL027-SUB016-P1', 'AL027', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL027-SUB016-P2', 'AL027', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL027-SUB017-P1', 'AL027', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL027-SUB017-P2', 'AL027', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL027-SUB018-P1', 'AL027', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL027-SUB018-P2', 'AL027', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL028-SUB013-P1', 'AL028', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL028-SUB013-P2', 'AL028', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL028-SUB014-P1', 'AL028', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL028-SUB014-P2', 'AL028', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL028-SUB015-P1', 'AL028', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL028-SUB015-P2', 'AL028', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL028-SUB016-P1', 'AL028', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL028-SUB016-P2', 'AL028', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL028-SUB017-P1', 'AL028', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL028-SUB017-P2', 'AL028', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL028-SUB018-P1', 'AL028', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL028-SUB018-P2', 'AL028', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL029-SUB013-P1', 'AL029', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL029-SUB013-P2', 'AL029', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL029-SUB014-P1', 'AL029', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL029-SUB014-P2', 'AL029', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL029-SUB015-P1', 'AL029', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL029-SUB015-P2', 'AL029', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL029-SUB016-P1', 'AL029', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL029-SUB016-P2', 'AL029', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL029-SUB017-P1', 'AL029', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL029-SUB017-P2', 'AL029', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL029-SUB018-P1', 'AL029', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL029-SUB018-P2', 'AL029', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL030-SUB013-P1', 'AL030', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL030-SUB013-P2', 'AL030', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL030-SUB014-P1', 'AL030', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL030-SUB014-P2', 'AL030', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL030-SUB015-P1', 'AL030', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL030-SUB015-P2', 'AL030', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL030-SUB016-P1', 'AL030', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL030-SUB016-P2', 'AL030', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL030-SUB017-P1', 'AL030', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL030-SUB017-P2', 'AL030', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL030-SUB018-P1', 'AL030', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL030-SUB018-P2', 'AL030', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL031-SUB013-P1', 'AL031', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL031-SUB013-P2', 'AL031', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL031-SUB014-P1', 'AL031', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL031-SUB014-P2', 'AL031', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL031-SUB015-P1', 'AL031', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL031-SUB015-P2', 'AL031', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL031-SUB016-P1', 'AL031', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL031-SUB016-P2', 'AL031', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL031-SUB017-P1', 'AL031', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL031-SUB017-P2', 'AL031', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL031-SUB018-P1', 'AL031', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL031-SUB018-P2', 'AL031', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL032-SUB013-P1', 'AL032', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL032-SUB013-P2', 'AL032', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL032-SUB014-P1', 'AL032', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL032-SUB014-P2', 'AL032', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL032-SUB015-P1', 'AL032', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL032-SUB015-P2', 'AL032', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL032-SUB016-P1', 'AL032', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL032-SUB016-P2', 'AL032', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL032-SUB017-P1', 'AL032', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL032-SUB017-P2', 'AL032', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL032-SUB018-P1', 'AL032', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL032-SUB018-P2', 'AL032', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL033-SUB013-P1', 'AL033', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL033-SUB013-P2', 'AL033', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL033-SUB014-P1', 'AL033', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL033-SUB014-P2', 'AL033', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL033-SUB015-P1', 'AL033', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL033-SUB015-P2', 'AL033', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL033-SUB016-P1', 'AL033', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL033-SUB016-P2', 'AL033', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL033-SUB017-P1', 'AL033', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL033-SUB017-P2', 'AL033', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL033-SUB018-P1', 'AL033', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL033-SUB018-P2', 'AL033', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL034-SUB013-P1', 'AL034', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL034-SUB013-P2', 'AL034', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL034-SUB014-P1', 'AL034', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL034-SUB014-P2', 'AL034', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL034-SUB015-P1', 'AL034', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL034-SUB015-P2', 'AL034', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL034-SUB016-P1', 'AL034', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL034-SUB016-P2', 'AL034', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL034-SUB017-P1', 'AL034', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL034-SUB017-P2', 'AL034', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL034-SUB018-P1', 'AL034', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL034-SUB018-P2', 'AL034', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL035-SUB013-P1', 'AL035', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL035-SUB013-P2', 'AL035', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL035-SUB014-P1', 'AL035', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL035-SUB014-P2', 'AL035', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL035-SUB015-P1', 'AL035', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL035-SUB015-P2', 'AL035', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL035-SUB016-P1', 'AL035', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL035-SUB016-P2', 'AL035', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL035-SUB017-P1', 'AL035', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL035-SUB017-P2', 'AL035', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL035-SUB018-P1', 'AL035', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL035-SUB018-P2', 'AL035', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL036-SUB013-P1', 'AL036', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL036-SUB013-P2', 'AL036', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL036-SUB014-P1', 'AL036', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL036-SUB014-P2', 'AL036', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL036-SUB015-P1', 'AL036', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL036-SUB015-P2', 'AL036', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL036-SUB016-P1', 'AL036', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL036-SUB016-P2', 'AL036', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL036-SUB017-P1', 'AL036', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL036-SUB017-P2', 'AL036', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL036-SUB018-P1', 'AL036', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9),
('AL036-SUB018-P2', 'AL036', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL037-SUB013-P1', 'AL037', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL037-SUB013-P2', 'AL037', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL037-SUB014-P1', 'AL037', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL037-SUB014-P2', 'AL037', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL037-SUB015-P1', 'AL037', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL037-SUB015-P2', 'AL037', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL037-SUB016-P1', 'AL037', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL037-SUB016-P2', 'AL037', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL037-SUB017-P1', 'AL037', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL037-SUB017-P2', 'AL037', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL037-SUB018-P1', 'AL037', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL037-SUB018-P2', 'AL037', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL038-SUB013-P1', 'AL038', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL038-SUB013-P2', 'AL038', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL038-SUB014-P1', 'AL038', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL038-SUB014-P2', 'AL038', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL038-SUB015-P1', 'AL038', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL038-SUB015-P2', 'AL038', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL038-SUB016-P1', 'AL038', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL038-SUB016-P2', 'AL038', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL038-SUB017-P1', 'AL038', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL038-SUB017-P2', 'AL038', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL038-SUB018-P1', 'AL038', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL038-SUB018-P2', 'AL038', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL039-SUB013-P1', 'AL039', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL039-SUB013-P2', 'AL039', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL039-SUB014-P1', 'AL039', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL039-SUB014-P2', 'AL039', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL039-SUB015-P1', 'AL039', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL039-SUB015-P2', 'AL039', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL039-SUB016-P1', 'AL039', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL039-SUB016-P2', 'AL039', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL039-SUB017-P1', 'AL039', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL039-SUB017-P2', 'AL039', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL039-SUB018-P1', 'AL039', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL039-SUB018-P2', 'AL039', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL040-SUB013-P1', 'AL040', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL040-SUB013-P2', 'AL040', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL040-SUB014-P1', 'AL040', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL040-SUB014-P2', 'AL040', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL040-SUB015-P1', 'AL040', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL040-SUB015-P2', 'AL040', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL040-SUB016-P1', 'AL040', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL040-SUB016-P2', 'AL040', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL040-SUB017-P1', 'AL040', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL040-SUB017-P2', 'AL040', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL040-SUB018-P1', 'AL040', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL040-SUB018-P2', 'AL040', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL041-SUB013-P1', 'AL041', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL041-SUB013-P2', 'AL041', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9);
INSERT INTO `grade_records` (`id`, `student_id`, `subject_id`, `parcial`, `periodo`, `evidencias`, `conocimiento`, `desempeno`, `actitud`, `examen`, `final`) VALUES
('AL041-SUB014-P1', 'AL041', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL041-SUB014-P2', 'AL041', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL041-SUB015-P1', 'AL041', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL041-SUB015-P2', 'AL041', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL041-SUB016-P1', 'AL041', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL041-SUB016-P2', 'AL041', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL041-SUB017-P1', 'AL041', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL041-SUB017-P2', 'AL041', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL041-SUB018-P1', 'AL041', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL041-SUB018-P2', 'AL041', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL042-SUB013-P1', 'AL042', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL042-SUB013-P2', 'AL042', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL042-SUB014-P1', 'AL042', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL042-SUB014-P2', 'AL042', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL042-SUB015-P1', 'AL042', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL042-SUB015-P2', 'AL042', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL042-SUB016-P1', 'AL042', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL042-SUB016-P2', 'AL042', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL042-SUB017-P1', 'AL042', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL042-SUB017-P2', 'AL042', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL042-SUB018-P1', 'AL042', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL042-SUB018-P2', 'AL042', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL043-SUB013-P1', 'AL043', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL043-SUB013-P2', 'AL043', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL043-SUB014-P1', 'AL043', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL043-SUB014-P2', 'AL043', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL043-SUB015-P1', 'AL043', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL043-SUB015-P2', 'AL043', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL043-SUB016-P1', 'AL043', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL043-SUB016-P2', 'AL043', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL043-SUB017-P1', 'AL043', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL043-SUB017-P2', 'AL043', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL043-SUB018-P1', 'AL043', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL043-SUB018-P2', 'AL043', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL044-SUB013-P1', 'AL044', 'SUB013', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL044-SUB013-P2', 'AL044', 'SUB013', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL044-SUB014-P1', 'AL044', 'SUB014', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL044-SUB014-P2', 'AL044', 'SUB014', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL044-SUB015-P1', 'AL044', 'SUB015', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL044-SUB015-P2', 'AL044', 'SUB015', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL044-SUB016-P1', 'AL044', 'SUB016', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL044-SUB016-P2', 'AL044', 'SUB016', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL044-SUB017-P1', 'AL044', 'SUB017', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL044-SUB017-P2', 'AL044', 'SUB017', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL044-SUB018-P1', 'AL044', 'SUB018', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL044-SUB018-P2', 'AL044', 'SUB018', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL045-SUB001-P1', 'AL045', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL045-SUB001-P2', 'AL045', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL045-SUB002-P1', 'AL045', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL045-SUB002-P2', 'AL045', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL045-SUB003-P1', 'AL045', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL045-SUB003-P2', 'AL045', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL045-SUB004-P1', 'AL045', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL045-SUB004-P2', 'AL045', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL045-SUB005-P1', 'AL045', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL045-SUB005-P2', 'AL045', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL045-SUB006-P1', 'AL045', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.9, 9.9, 9.9, 9.9, 9.9, 9.9),
('AL045-SUB006-P2', 'AL045', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL046-SUB001-P1', 'AL046', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL046-SUB001-P2', 'AL046', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL046-SUB002-P1', 'AL046', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL046-SUB002-P2', 'AL046', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL046-SUB003-P1', 'AL046', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL046-SUB003-P2', 'AL046', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL046-SUB004-P1', 'AL046', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL046-SUB004-P2', 'AL046', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL046-SUB005-P1', 'AL046', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL046-SUB005-P2', 'AL046', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL046-SUB006-P1', 'AL046', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL046-SUB006-P2', 'AL046', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL047-SUB001-P1', 'AL047', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL047-SUB001-P2', 'AL047', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL047-SUB002-P1', 'AL047', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL047-SUB002-P2', 'AL047', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL047-SUB003-P1', 'AL047', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL047-SUB003-P2', 'AL047', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL047-SUB004-P1', 'AL047', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL047-SUB004-P2', 'AL047', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL047-SUB005-P1', 'AL047', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL047-SUB005-P2', 'AL047', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL047-SUB006-P1', 'AL047', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL047-SUB006-P2', 'AL047', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL048-SUB001-P1', 'AL048', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL048-SUB001-P2', 'AL048', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL048-SUB002-P1', 'AL048', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL048-SUB002-P2', 'AL048', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL048-SUB003-P1', 'AL048', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL048-SUB003-P2', 'AL048', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL048-SUB004-P1', 'AL048', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL048-SUB004-P2', 'AL048', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL048-SUB005-P1', 'AL048', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL048-SUB005-P2', 'AL048', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL048-SUB006-P1', 'AL048', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL048-SUB006-P2', 'AL048', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL049-SUB001-P1', 'AL049', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL049-SUB001-P2', 'AL049', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL049-SUB002-P1', 'AL049', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL049-SUB002-P2', 'AL049', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL049-SUB003-P1', 'AL049', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL049-SUB003-P2', 'AL049', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL049-SUB004-P1', 'AL049', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL049-SUB004-P2', 'AL049', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL049-SUB005-P1', 'AL049', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL049-SUB005-P2', 'AL049', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL049-SUB006-P1', 'AL049', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL049-SUB006-P2', 'AL049', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL050-SUB001-P1', 'AL050', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL050-SUB001-P2', 'AL050', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL050-SUB002-P1', 'AL050', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL050-SUB002-P2', 'AL050', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL050-SUB003-P1', 'AL050', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL050-SUB003-P2', 'AL050', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL050-SUB004-P1', 'AL050', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL050-SUB004-P2', 'AL050', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL050-SUB005-P1', 'AL050', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL050-SUB005-P2', 'AL050', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL050-SUB006-P1', 'AL050', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL050-SUB006-P2', 'AL050', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL051-SUB001-P1', 'AL051', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL051-SUB001-P2', 'AL051', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL051-SUB002-P1', 'AL051', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL051-SUB002-P2', 'AL051', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL051-SUB003-P1', 'AL051', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL051-SUB003-P2', 'AL051', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL051-SUB004-P1', 'AL051', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL051-SUB004-P2', 'AL051', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL051-SUB005-P1', 'AL051', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL051-SUB005-P2', 'AL051', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL051-SUB006-P1', 'AL051', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL051-SUB006-P2', 'AL051', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL052-SUB001-P1', 'AL052', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL052-SUB001-P2', 'AL052', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL052-SUB002-P1', 'AL052', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL052-SUB002-P2', 'AL052', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL052-SUB003-P1', 'AL052', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL052-SUB003-P2', 'AL052', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL052-SUB004-P1', 'AL052', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL052-SUB004-P2', 'AL052', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL052-SUB005-P1', 'AL052', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL052-SUB005-P2', 'AL052', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL052-SUB006-P1', 'AL052', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL052-SUB006-P2', 'AL052', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL053-SUB001-P1', 'AL053', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL053-SUB001-P2', 'AL053', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL053-SUB002-P1', 'AL053', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL053-SUB002-P2', 'AL053', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL053-SUB003-P1', 'AL053', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL053-SUB003-P2', 'AL053', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL053-SUB004-P1', 'AL053', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL053-SUB004-P2', 'AL053', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL053-SUB005-P1', 'AL053', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL053-SUB005-P2', 'AL053', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL053-SUB006-P1', 'AL053', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL053-SUB006-P2', 'AL053', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL054-SUB001-P1', 'AL054', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL054-SUB001-P2', 'AL054', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL054-SUB002-P1', 'AL054', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL054-SUB002-P2', 'AL054', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL054-SUB003-P1', 'AL054', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL054-SUB003-P2', 'AL054', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL054-SUB004-P1', 'AL054', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL054-SUB004-P2', 'AL054', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL054-SUB005-P1', 'AL054', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL054-SUB005-P2', 'AL054', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL054-SUB006-P1', 'AL054', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL054-SUB006-P2', 'AL054', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL055-SUB001-P1', 'AL055', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL055-SUB001-P2', 'AL055', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL055-SUB002-P1', 'AL055', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9),
('AL055-SUB002-P2', 'AL055', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL055-SUB003-P1', 'AL055', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL055-SUB003-P2', 'AL055', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL055-SUB004-P1', 'AL055', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL055-SUB004-P2', 'AL055', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL055-SUB005-P1', 'AL055', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9),
('AL055-SUB005-P2', 'AL055', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL055-SUB006-P1', 'AL055', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 7.8, 7.8, 7.8, 7.8, 7.8, 7.8),
('AL055-SUB006-P2', 'AL055', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9),
('AL056-SUB001-P1', 'AL056', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL056-SUB001-P2', 'AL056', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL056-SUB002-P1', 'AL056', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL056-SUB002-P2', 'AL056', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL056-SUB003-P1', 'AL056', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL056-SUB003-P2', 'AL056', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL056-SUB004-P1', 'AL056', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL056-SUB004-P2', 'AL056', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL056-SUB005-P1', 'AL056', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL056-SUB005-P2', 'AL056', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL056-SUB006-P1', 'AL056', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL056-SUB006-P2', 'AL056', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL057-SUB001-P1', 'AL057', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL057-SUB001-P2', 'AL057', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL057-SUB002-P1', 'AL057', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL057-SUB002-P2', 'AL057', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL057-SUB003-P1', 'AL057', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL057-SUB003-P2', 'AL057', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL057-SUB004-P1', 'AL057', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL057-SUB004-P2', 'AL057', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL057-SUB005-P1', 'AL057', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL057-SUB005-P2', 'AL057', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL057-SUB006-P1', 'AL057', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL057-SUB006-P2', 'AL057', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL058-SUB001-P1', 'AL058', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL058-SUB001-P2', 'AL058', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL058-SUB002-P1', 'AL058', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL058-SUB002-P2', 'AL058', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL058-SUB003-P1', 'AL058', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL058-SUB003-P2', 'AL058', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL058-SUB004-P1', 'AL058', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL058-SUB004-P2', 'AL058', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL058-SUB005-P1', 'AL058', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL058-SUB005-P2', 'AL058', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL058-SUB006-P1', 'AL058', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL058-SUB006-P2', 'AL058', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL059-SUB001-P1', 'AL059', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL059-SUB001-P2', 'AL059', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL059-SUB002-P1', 'AL059', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL059-SUB002-P2', 'AL059', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL059-SUB003-P1', 'AL059', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL059-SUB003-P2', 'AL059', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL059-SUB004-P1', 'AL059', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL059-SUB004-P2', 'AL059', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL059-SUB005-P1', 'AL059', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL059-SUB005-P2', 'AL059', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL059-SUB006-P1', 'AL059', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL059-SUB006-P2', 'AL059', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL060-SUB001-P1', 'AL060', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL060-SUB001-P2', 'AL060', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL060-SUB002-P1', 'AL060', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL060-SUB002-P2', 'AL060', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL060-SUB003-P1', 'AL060', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL060-SUB003-P2', 'AL060', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL060-SUB004-P1', 'AL060', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL060-SUB004-P2', 'AL060', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.3, 8.3, 8.3, 8.3, 8.3, 8.3),
('AL060-SUB005-P1', 'AL060', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.0, 8.0, 8.0, 8.0, 8.0, 8.0),
('AL060-SUB005-P2', 'AL060', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 7.9, 7.9, 7.9, 7.9, 7.9, 7.9),
('AL060-SUB006-P1', 'AL060', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL060-SUB006-P2', 'AL060', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL061-SUB001-P1', 'AL061', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL061-SUB001-P2', 'AL061', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL061-SUB002-P1', 'AL061', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL061-SUB002-P2', 'AL061', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL061-SUB003-P1', 'AL061', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL061-SUB003-P2', 'AL061', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL061-SUB004-P1', 'AL061', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL061-SUB004-P2', 'AL061', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL061-SUB005-P1', 'AL061', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL061-SUB005-P2', 'AL061', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL061-SUB006-P1', 'AL061', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL061-SUB006-P2', 'AL061', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL062-SUB001-P1', 'AL062', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL062-SUB001-P2', 'AL062', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL062-SUB002-P1', 'AL062', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL062-SUB002-P2', 'AL062', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL062-SUB003-P1', 'AL062', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL062-SUB003-P2', 'AL062', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL062-SUB004-P1', 'AL062', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL062-SUB004-P2', 'AL062', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL062-SUB005-P1', 'AL062', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL062-SUB005-P2', 'AL062', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL062-SUB006-P1', 'AL062', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 10.0, 10.0, 10.0, 10.0, 10.0, 10.0),
('AL062-SUB006-P2', 'AL062', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL063-SUB001-P1', 'AL063', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 0.1, 0.1, 0.1, 0.1, 0.1, 0.1),
('AL063-SUB001-P2', 'AL063', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.9, 8.9, 8.9, 8.9, 8.9, 8.9),
('AL063-SUB002-P1', 'AL063', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL063-SUB002-P2', 'AL063', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL063-SUB003-P1', 'AL063', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.0, 9.0, 9.0, 9.0, 9.0, 9.0),
('AL063-SUB003-P2', 'AL063', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL063-SUB004-P1', 'AL063', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL063-SUB004-P2', 'AL063', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL063-SUB005-P1', 'AL063', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL063-SUB005-P2', 'AL063', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.1, 9.1, 9.1, 9.1, 9.1, 9.1),
('AL063-SUB006-P1', 'AL063', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL063-SUB006-P2', 'AL063', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7),
('AL064-SUB001-P1', 'AL064', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 9.8, 9.8, 9.8, 9.8, 9.8, 9.8),
('AL064-SUB001-P2', 'AL064', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL064-SUB002-P1', 'AL064', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL064-SUB002-P2', 'AL064', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL064-SUB003-P1', 'AL064', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL064-SUB003-P2', 'AL064', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 9.3, 9.3, 9.3, 9.3, 9.3, 9.3),
('AL064-SUB004-P1', 'AL064', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL064-SUB004-P2', 'AL064', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 9.5, 9.5, 9.5, 9.5, 9.5, 9.5),
('AL064-SUB005-P1', 'AL064', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 9.6, 9.6, 9.6, 9.6, 9.6, 9.6),
('AL064-SUB005-P2', 'AL064', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 9.2, 9.2, 9.2, 9.2, 9.2, 9.2),
('AL064-SUB006-P1', 'AL064', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 9.4, 9.4, 9.4, 9.4, 9.4, 9.4),
('AL064-SUB006-P2', 'AL064', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 9.7, 9.7, 9.7, 9.7, 9.7, 9.7),
('AL065-SUB001-P1', 'AL065', 'SUB001', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL065-SUB001-P2', 'AL065', 'SUB001', 'Parcial 2', 'Enero – Abril 2025', 8.6, 8.6, 8.6, 8.6, 8.6, 8.6),
('AL065-SUB002-P1', 'AL065', 'SUB002', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL065-SUB002-P2', 'AL065', 'SUB002', 'Parcial 2', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL065-SUB003-P1', 'AL065', 'SUB003', 'Parcial 1', 'Enero – Abril 2025', 8.5, 8.5, 8.5, 8.5, 8.5, 8.5),
('AL065-SUB003-P2', 'AL065', 'SUB003', 'Parcial 2', 'Enero – Abril 2025', 8.2, 8.2, 8.2, 8.2, 8.2, 8.2),
('AL065-SUB004-P1', 'AL065', 'SUB004', 'Parcial 1', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL065-SUB004-P2', 'AL065', 'SUB004', 'Parcial 2', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL065-SUB005-P1', 'AL065', 'SUB005', 'Parcial 1', 'Enero – Abril 2025', 8.4, 8.4, 8.4, 8.4, 8.4, 8.4),
('AL065-SUB005-P2', 'AL065', 'SUB005', 'Parcial 2', 'Enero – Abril 2025', 8.1, 8.1, 8.1, 8.1, 8.1, 8.1),
('AL065-SUB006-P1', 'AL065', 'SUB006', 'Parcial 1', 'Enero – Abril 2025', 8.8, 8.8, 8.8, 8.8, 8.8, 8.8),
('AL065-SUB006-P2', 'AL065', 'SUB006', 'Parcial 2', 'Enero – Abril 2025', 8.7, 8.7, 8.7, 8.7, 8.7, 8.7);

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
('IDGS 8-3', 'IDGS 8-3', 'IDGS', '8°', 'Enero – Abril 2025', 'Aula TI-206', 'Matutino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventory_items`
--

CREATE TABLE `inventory_items` (
  `id` varchar(20) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `categoria` varchar(100) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL,
  `responsable` varchar(150) DEFAULT NULL,
  `status` enum('Disponible','En uso','Prestado','En reparación','Baja') NOT NULL DEFAULT 'Disponible',
  `valor` varchar(30) DEFAULT NULL,
  `qr` varchar(30) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventory_items`
--

INSERT INTO `inventory_items` (`id`, `nombre`, `categoria`, `ubicacion`, `responsable`, `status`, `valor`, `qr`, `created_at`) VALUES
('INV-2026-PC01', 'PC de trabajo #1', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC01', '2026-08-15 20:37:01'),
('INV-2026-PC02', 'PC de trabajo #2', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC02', '2026-08-15 20:37:01'),
('INV-2026-PC03', 'PC de trabajo #3', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC03', '2026-08-15 20:37:01'),
('INV-2026-PC04', 'PC de trabajo #4', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC04', '2026-08-15 20:37:01'),
('INV-2026-PC05', 'PC de trabajo #5', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC05', '2026-08-15 20:37:01'),
('INV-2026-PC06', 'PC de trabajo #6', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC06', '2026-08-15 20:37:01'),
('INV-2026-PC07', 'PC de trabajo #7', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC07', '2026-08-15 20:37:01'),
('INV-2026-PC08', 'PC de trabajo #8', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC08', '2026-08-15 20:37:01'),
('INV-2026-PC09', 'PC de trabajo #9', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC09', '2026-08-15 20:37:01'),
('INV-2026-PC10', 'PC de trabajo #10', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC10', '2026-08-15 20:37:01'),
('INV-2026-PC11', 'PC de trabajo #11', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC11', '2026-08-15 20:37:01'),
('INV-2026-PC12', 'PC de trabajo #12', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC12', '2026-08-15 20:37:01'),
('INV-2026-PC13', 'PC de trabajo #13', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC13', '2026-08-15 20:37:01'),
('INV-2026-PC14', 'PC de trabajo #14', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC14', '2026-08-15 20:37:01'),
('INV-2026-PC15', 'PC de trabajo #15', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC15', '2026-08-15 20:37:01'),
('INV-2026-PC16', 'PC de trabajo #16', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC16', '2026-08-15 20:37:01'),
('INV-2026-PC17', 'PC de trabajo #17', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC17', '2026-08-15 20:37:01'),
('INV-2026-PC18', 'PC de trabajo #18', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC18', '2026-08-15 20:37:01'),
('INV-2026-PC19', 'PC de trabajo #19', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC19', '2026-08-15 20:37:01'),
('INV-2026-PC20', 'PC de trabajo #20', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC20', '2026-08-15 20:37:01'),
('INV-2026-PC21', 'PC de trabajo #21', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC21', '2026-08-15 20:37:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `loans`
--

CREATE TABLE `loans` (
  `id` varchar(20) NOT NULL,
  `book_id` varchar(20) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `fecha_prestamo` date NOT NULL,
  `fecha_limite` date NOT NULL,
  `fecha_devolucion` date DEFAULT NULL,
  `status` enum('Vigente','Vencido','Devuelto') NOT NULL DEFAULT 'Vigente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
(61, 'IDGS 8-1', 'Lunes', '07:00 – 08:40', 'SUB007', 'Aula TI-204'),
(62, 'IDGS 8-1', 'Lunes', '08:40 – 10:20', 'SUB008', 'Aula TI-204'),
(63, 'IDGS 8-1', 'Lunes', '10:20 – 12:00', 'SUB009', 'Aula TI-204'),
(64, 'IDGS 8-1', 'Lunes', '12:20 – 14:00', 'SUB010', 'Aula TI-204'),
(65, 'IDGS 8-1', 'Martes', '07:00 – 08:40', 'SUB011', 'Aula TI-204'),
(66, 'IDGS 8-1', 'Martes', '08:40 – 10:20', 'SUB012', 'Aula TI-204'),
(67, 'IDGS 8-1', 'Martes', '10:20 – 12:00', 'SUB007', 'Aula TI-204'),
(68, 'IDGS 8-1', 'Martes', '12:20 – 14:00', 'SUB008', 'Aula TI-204'),
(69, 'IDGS 8-1', 'Miércoles', '07:00 – 08:40', 'SUB009', 'Aula TI-204'),
(70, 'IDGS 8-1', 'Miércoles', '08:40 – 10:20', 'SUB010', 'Aula TI-204'),
(71, 'IDGS 8-1', 'Miércoles', '10:20 – 12:00', 'SUB011', 'Aula TI-204'),
(72, 'IDGS 8-1', 'Miércoles', '12:20 – 14:00', 'SUB012', 'Aula TI-204'),
(73, 'IDGS 8-1', 'Jueves', '07:00 – 08:40', 'SUB007', 'Aula TI-204'),
(74, 'IDGS 8-1', 'Jueves', '08:40 – 10:20', 'SUB008', 'Aula TI-204'),
(75, 'IDGS 8-1', 'Jueves', '10:20 – 12:00', 'SUB009', 'Aula TI-204'),
(76, 'IDGS 8-1', 'Jueves', '12:20 – 14:00', 'SUB010', 'Aula TI-204'),
(77, 'IDGS 8-1', 'Viernes', '07:00 – 08:40', 'SUB011', 'Aula TI-204'),
(78, 'IDGS 8-1', 'Viernes', '08:40 – 10:20', 'SUB012', 'Aula TI-204'),
(79, 'IDGS 8-2', 'Lunes', '07:00 – 08:40', 'SUB013', 'Móvil / Lab TI'),
(80, 'IDGS 8-2', 'Lunes', '08:40 – 10:20', 'SUB014', 'Móvil / Lab TI'),
(81, 'IDGS 8-2', 'Lunes', '10:20 – 12:00', 'SUB015', 'Móvil / Lab TI'),
(82, 'IDGS 8-2', 'Lunes', '12:20 – 14:00', 'SUB016', 'Móvil / Lab TI'),
(83, 'IDGS 8-2', 'Martes', '07:00 – 08:40', 'SUB017', 'Móvil / Lab TI'),
(84, 'IDGS 8-2', 'Martes', '08:40 – 10:20', 'SUB018', 'Móvil / Lab TI'),
(85, 'IDGS 8-2', 'Martes', '10:20 – 12:00', 'SUB013', 'Móvil / Lab TI'),
(86, 'IDGS 8-2', 'Martes', '12:20 – 14:00', 'SUB014', 'Móvil / Lab TI'),
(87, 'IDGS 8-2', 'Miércoles', '07:00 – 08:40', 'SUB015', 'Móvil / Lab TI'),
(88, 'IDGS 8-2', 'Miércoles', '08:40 – 10:20', 'SUB016', 'Móvil / Lab TI'),
(89, 'IDGS 8-2', 'Miércoles', '10:20 – 12:00', 'SUB017', 'Móvil / Lab TI'),
(90, 'IDGS 8-2', 'Miércoles', '12:20 – 14:00', 'SUB018', 'Móvil / Lab TI'),
(91, 'IDGS 8-2', 'Jueves', '07:00 – 08:40', 'SUB013', 'Móvil / Lab TI'),
(92, 'IDGS 8-2', 'Jueves', '08:40 – 10:20', 'SUB014', 'Móvil / Lab TI'),
(93, 'IDGS 8-2', 'Jueves', '10:20 – 12:00', 'SUB015', 'Móvil / Lab TI'),
(94, 'IDGS 8-2', 'Jueves', '12:20 – 14:00', 'SUB016', 'Móvil / Lab TI'),
(95, 'IDGS 8-2', 'Viernes', '07:00 – 08:40', 'SUB017', 'Móvil / Lab TI'),
(96, 'IDGS 8-2', 'Viernes', '08:40 – 10:20', 'SUB018', 'Móvil / Lab TI'),
(97, 'IDGS 8-3', 'Lunes', '07:00 – 08:40', 'SUB001', 'Aula TI-206'),
(98, 'IDGS 8-3', 'Lunes', '08:40 – 10:20', 'SUB002', 'Aula TI-206'),
(99, 'IDGS 8-3', 'Lunes', '10:20 – 12:00', 'SUB003', 'Aula TI-206'),
(100, 'IDGS 8-3', 'Lunes', '12:20 – 14:00', 'SUB004', 'Aula TI-206'),
(101, 'IDGS 8-3', 'Martes', '07:00 – 08:40', 'SUB005', 'Aula TI-206'),
(102, 'IDGS 8-3', 'Martes', '08:40 – 10:20', 'SUB006', 'Aula TI-206'),
(103, 'IDGS 8-3', 'Martes', '10:20 – 12:00', 'SUB001', 'Aula TI-206'),
(104, 'IDGS 8-3', 'Martes', '12:20 – 14:00', 'SUB002', 'Aula TI-206'),
(105, 'IDGS 8-3', 'Miércoles', '07:00 – 08:40', 'SUB003', 'Aula TI-206'),
(106, 'IDGS 8-3', 'Miércoles', '08:40 – 10:20', 'SUB004', 'Aula TI-206'),
(107, 'IDGS 8-3', 'Miércoles', '10:20 – 12:00', 'SUB005', 'Aula TI-206'),
(108, 'IDGS 8-3', 'Miércoles', '12:20 – 14:00', 'SUB006', 'Aula TI-206'),
(109, 'IDGS 8-3', 'Jueves', '07:00 – 08:40', 'SUB001', 'Aula TI-206'),
(110, 'IDGS 8-3', 'Jueves', '08:40 – 10:20', 'SUB002', 'Aula TI-206'),
(111, 'IDGS 8-3', 'Jueves', '10:20 – 12:00', 'SUB003', 'Aula TI-206'),
(112, 'IDGS 8-3', 'Jueves', '12:20 – 14:00', 'SUB004', 'Aula TI-206'),
(113, 'IDGS 8-3', 'Viernes', '07:00 – 08:40', 'SUB005', 'Aula TI-206'),
(114, 'IDGS 8-3', 'Viernes', '08:40 – 10:20', 'SUB006', 'Aula TI-206');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_tickets`
--

CREATE TABLE `service_tickets` (
  `id` varchar(20) NOT NULL,
  `folio` varchar(30) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria` enum('Trámite escolar','Soporte / Incidencia') NOT NULL,
  `fecha` date NOT NULL,
  `status` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `service_tickets`
--

INSERT INTO `service_tickets` (`id`, `folio`, `student_id`, `tipo`, `descripcion`, `categoria`, `fecha`, `status`) VALUES
('TK-1000', 'SE-2026-0300', 'AL006', 'Constancia de estudios', NULL, 'Trámite escolar', '2026-08-01', 'En proceso'),
('TK-1001', 'SE-2026-0301', 'AL007', 'Incidencia de aula', NULL, 'Soporte / Incidencia', '2026-08-02', 'En proceso'),
('TK-1002', 'SE-2026-0302', 'AL008', 'Historial académico', NULL, 'Trámite escolar', '2026-08-03', 'Entregado'),
('TK-1003', 'SE-2026-0303', 'AL009', 'Soporte técnico', NULL, 'Soporte / Incidencia', '2026-08-04', 'Abierto'),
('TK-1004', 'SE-2026-0304', 'AL010', 'Baja temporal', NULL, 'Trámite escolar', '2026-08-05', 'En proceso'),
('TK-1005', 'SE-2026-0305', 'AL011', 'Credencial', NULL, 'Soporte / Incidencia', '2026-08-06', 'Resuelto'),
('TK-1006', 'SE-2026-0306', 'AL012', 'Kardex', NULL, 'Trámite escolar', '2026-08-07', 'Entregado'),
('TK-1007', 'SE-2026-0307', 'AL013', 'Incidencia de aula', NULL, 'Soporte / Incidencia', '2026-08-08', 'En proceso'),
('TK-1008', 'SE-2026-0308', 'AL014', 'Carta de pasante', NULL, 'Trámite escolar', '2026-08-01', 'En proceso'),
('TK-1009', 'SE-2026-0309', 'AL015', 'Soporte técnico', NULL, 'Soporte / Incidencia', '2026-08-02', 'Abierto'),
('TK-1010', 'SE-2026-0310', 'AL016', 'Constancia de estudios', NULL, 'Trámite escolar', '2026-08-03', 'Entregado'),
('TK-1011', 'SE-2026-0311', 'AL017', 'Credencial', NULL, 'Soporte / Incidencia', '2026-08-04', 'Resuelto'),
('TK-1012', 'SE-2026-0312', 'AL018', 'Historial académico', NULL, 'Trámite escolar', '2026-08-05', 'En proceso'),
('TK-1013', 'SE-2026-0313', 'AL019', 'Incidencia de aula', NULL, 'Soporte / Incidencia', '2026-08-06', 'En proceso'),
('TK-1014', 'SE-2026-0314', 'AL020', 'Baja temporal', NULL, 'Trámite escolar', '2026-08-07', 'Entregado'),
('TK-1015', 'SE-2026-0315', 'AL021', 'Soporte técnico', NULL, 'Soporte / Incidencia', '2026-08-08', 'Abierto'),
('TK-1017', 'SE-2026-0317', 'AL064', 'Reportar problema', 'Presentamos un problema con la docente Eutilia Guadalupe...', 'Soporte / Incidencia', '2026-08-16', 'Abierto');

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
  `contrasena` varchar(255) NOT NULL DEFAULT '12345678',
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

INSERT INTO `students` (`id`, `no`, `expediente`, `nombre`, `group_id`, `email`, `contrasena`, `status`, `career_id`, `cuatrimestre`, `periodo`, `promedio`, `asistencia`) VALUES
('AL001', 1, '23304095', 'ARELLANO MUÑOZ ANGEL ROBERTO', 'IDGS 8-1', 'arellano.roberto@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL002', 2, '23304050', 'ATIENZO CENICEROS JOSE HARVEY', 'IDGS 8-1', 'atienzo.harvey@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL003', 3, '23304030', 'DELGADILLO DIAZ ERIC JOEL', 'IDGS 8-1', 'delgadillo.joel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 100),
('AL004', 4, '23304053', 'FELIX GONZALEZ AARÓN ALBERTO', 'IDGS 8-1', 'felix.alberto@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 100),
('AL005', 5, '23304076', 'GONZÁLEZ MARÍN KEVIN ALBERTO', 'IDGS 8-1', 'gonzalez.alberto@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 100),
('AL006', 6, '23304056', 'HIGUERA ORTIZ EBER', 'IDGS 8-1', 'higuera.eber@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 100),
('AL007', 7, '23304033', 'LOPEZ COTA BENJAMIN', 'IDGS 8-1', 'lopez.benjamin@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 100),
('AL008', 8, '23304048', 'MARTINEZ ALCANTAR JUAN JOSE', 'IDGS 8-1', 'martinez.jose@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 100),
('AL009', 9, '23304013', 'MARTINEZ GARCIA RICARDO', 'IDGS 8-1', 'martinez.ricardo@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 100),
('AL010', 10, '23304027', 'MICHEL TELLO YAHIR ROMAN', 'IDGS 8-1', 'michel.roman@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 100),
('AL011', 11, '23304015', 'MONREAL GAMEZ JOSE ARMANDO', 'IDGS 8-1', 'monreal.armando@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 100),
('AL012', 12, '23304079', 'MORENO FIGUEROA EVI AIRAM', 'IDGS 8-1', 'moreno.airam@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 100),
('AL013', 13, '23304054', 'MUNGARRO LOPEZ BIHANKA YAZZMIN', 'IDGS 8-1', 'mungarro.yazzmin@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 100),
('AL014', 14, 'S/E-014', 'MUÑOZ PEREA ALEXIS ANTEUS', 'IDGS 8-1', 'munoz.anteus@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 100),
('AL015', 15, '22304038', 'MUÑOZ PEREA JULIAN ANTHUA', 'IDGS 8-1', 'munoz.anthua@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 100),
('AL016', 16, '23304080', 'NUÑEZ RAMIREZ BRYAN DE JESUS', 'IDGS 8-1', 'nunez.jesus@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 100),
('AL017', 17, '23304017', 'OCHOA MORA URIEL', 'IDGS 8-1', 'ochoa.uriel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 100),
('AL018', 18, '23304046', 'ORTUÑO ALVARADO JONATHAN ANTONIO', 'IDGS 8-1', 'ortuno.antonio@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL019', 19, '23304060', 'PÉREZ ÁLVAREZ LUÍS RAMÓN', 'IDGS 8-1', 'perez.ramon@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL020', 20, '23304012', 'RODRIGUEZ VERA ALVARO ALOISSES', 'IDGS 8-1', 'rodriguez.aloisses@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 50),
('AL021', 21, '23304044', 'SALAZAR NEGRETE ISMAEL', 'IDGS 8-1', 'salazar.ismael@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 100),
('AL022', 22, '23304026', 'SÁNCHEZ PLANTILLAS MIGUEL', 'IDGS 8-1', 'sanchez.miguel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 100),
('AL023', 23, '22304029', 'URIARTE CAZARES JULIAN', 'IDGS 8-1', 'uriarte.julian@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 100),
('AL024', 24, '23304052', 'VARGAS ANTOLIN RAMON ALEXANDRO', 'IDGS 8-1', 'vargas.alexandro@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 100),
('AL025', 25, '23304086', 'VEJAR ESTRADA JOSÉ MANUEL', 'IDGS 8-1', 'vejar.manuel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 100),
('AL026', 1, '23304025', 'CASTELLANOS LEYVA EZEQUIEL', 'IDGS 8-2', 'castellanos.ezequiel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL027', 2, '23304023', 'CUADRAS AVILÉZ KASSANDRA', 'IDGS 8-2', 'cuadras.kassandra@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL028', 3, '23304096', 'HERNANDEZ ACOSTA HECTOR MANUEL', 'IDGS 8-2', 'hernandez.manuel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 100),
('AL029', 4, '23304005', 'HERNANDEZ DUARTE ALBERTO IÑAKI', 'IDGS 8-2', 'hernandez.inaki@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 100),
('AL030', 5, '23304014', 'HERRERA SOSA RODOLFO ADRIAN', 'IDGS 8-2', 'herrera.adrian@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 100),
('AL031', 6, '22304023', 'KIM RODRIGUEZ LLUVIA YUKIE', 'IDGS 8-2', 'kim.yukie@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 100),
('AL032', 7, '23304031', 'LEÓN ALMAZÁN LUIS ÁNGEL', 'IDGS 8-2', 'leon.angel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 100),
('AL033', 8, '23304035', 'LEON GERMAN EDUARDO ALONSO', 'IDGS 8-2', 'leon.alonso@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 100),
('AL034', 9, '23304078', 'MEDINA RIVERA ESTEBAN', 'IDGS 8-2', 'medina.esteban@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 100),
('AL035', 10, '23304034', 'MEDINA ZAVALA BRYAN FERNANDO', 'IDGS 8-2', 'medina.fernando@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 100),
('AL036', 11, '23304008', 'OLMEDO GARCIA VIVIANA ANAHI', 'IDGS 8-2', 'olmedo.anahi@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 100),
('AL037', 12, '23304009', 'PEREZ FRAUSTO JESHUA EMMANUEL', 'IDGS 8-2', 'perez.emmanuel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 100),
('AL038', 13, '23304082', 'RAMÍREZ CÁRDENAS AXEL', 'IDGS 8-2', 'ramirez.axel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 100),
('AL039', 14, '22304042', 'RAMÍREZ LICÓN JORGE ALBERTO', 'IDGS 8-2', 'ramirez.alberto@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 100),
('AL040', 15, '23304092', 'RESENDIZ CORONA ELIN ALEKSEY', 'IDGS 8-2', 'resendiz.aleksey@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 100),
('AL041', 16, '23304001', 'SAMANIEGO SANCHEZ LEVI ENRIQUE', 'IDGS 8-2', 'samaniego.enrique@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 100),
('AL042', 17, '23304047', 'SANCHEZ CELIS BLANCA ISABEL', 'IDGS 8-2', 'sanchez.isabel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 100),
('AL043', 18, '23304039', 'SANTILLAN BARRÓN JUAN GUILLERMO', 'IDGS 8-2', 'santillan.guillermo@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL044', 19, '23304093', 'SOTO PEÑUELA JESÚS DAVID', 'IDGS 8-2', 'soto.david@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL045', 1, '23304063', 'ACOSTA ARREGUIN ROMAN', 'IDGS 8-3', 'acosta.roman@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL046', 2, '23304059', 'ALCALA FELIX VLADIMIR EMANUEL', 'IDGS 8-3', 'alcala.emanuel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL047', 3, '23304028', 'ARMENTA MUNOZ OSKAR', 'IDGS 8-3', 'armenta.oskar@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 100),
('AL048', 4, '23304007', 'BARRIOS SECUNDINO JOE BRAYAN', 'IDGS 8-3', 'barrios.brayan@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 100),
('AL049', 5, '23304071', 'CARDENAS TIRADO MIGUEL ANGEL', 'IDGS 8-3', 'cardenas.angel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.1, 100),
('AL050', 6, '23304077', 'GRIJALVA MURRIETA ALVARO ALAN', 'IDGS 8-3', 'grijalva.alan@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.8, 100),
('AL051', 7, '23304065', 'GUTIERREZ CARDENAS MARTIN ALFREDO', 'IDGS 8-3', 'gutierrez.alfredo@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.8, 100),
('AL052', 8, '23304069', 'HERNANDEZ URIBE GABRIEL ARMANDO', 'IDGS 8-3', 'hernandez.armando@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.5, 100),
('AL053', 9, '23304049', 'HUIZAR RAMIREZ DEREK', 'IDGS 8-3', 'huizar.derek@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.5, 100),
('AL054', 10, '23304040', 'JIMENEZ JARAMILLO AXEL ALAN', 'IDGS 8-3', 'jimenez.alan@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.2, 100),
('AL055', 11, '23304064', 'LARA TORRES ADRIAN FELIPE', 'IDGS 8-3', 'lara.felipe@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.2, 100),
('AL056', 12, '23304061', 'LOPEZ GAMEZ JESUS RODOLFO', 'IDGS 8-3', 'lopez.rodolfo@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.9, 100),
('AL057', 13, '23304062', 'LOPEZ PADILLA LUIS FERNANDO', 'IDGS 8-3', 'lopez.fernando@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.6, 100),
('AL058', 14, '23304018', 'MONTANO GASPAR RENE', 'IDGS 8-3', 'montano.rene@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.6, 100),
('AL059', 15, '23304066', 'MORALES HIGUERA CHRISTIAN DE JESUS', 'IDGS 8-3', 'morales.jesus@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.3, 100),
('AL060', 16, '22304066', 'RAMIREZ BRAULIO', 'IDGS 8-3', 'ramirez.braulio@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.3, 100),
('AL061', 17, '23304020', 'SILVA TALAMANTES KEVIN URIEL', 'IDGS 8-3', 'silva.uriel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.0, 100),
('AL062', 18, '23304085', 'VALENZUELA VERDUGO JOSUE MISRAIM', 'IDGS 8-3', 'valenzuela.misraim@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.7, 100),
('AL063', 19, '23304006', 'VALLEJO PUENTE CARLOS MANUEL', 'IDGS 8-3', 'vallejo.manuel@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.7, 100),
('AL064', 20, '23304051', 'VELAZQUEZ FLORES FERNANDO', 'IDGS 8-3', 'velazquez.fernando@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 9.4, 100),
('AL065', 21, '23304057', 'VILLAGRANA CORDOVA EDGAR FERMIN', 'IDGS 8-3', 'villagrana.fermin@alumnos.utslrc.edu.mx', '12345678', 'Activo', 'IDGS', '8°', 'Enero – Abril 2025', 8.4, 100);

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
('SUB001', 'Seguridad en el Desarrollo de Aplicaciones', 'IDGS 8-3', 'DOC001', 'Ramón Eduardo Mercado Carreón', 0, 0, NULL, 0),
('SUB002', 'Inglés VII', 'IDGS 8-3', 'DOC002', 'Norma Beatriz Flores Núñez', 0, 0, NULL, 0),
('SUB003', 'Planeación y Organización del Trabajo', 'IDGS 8-3', 'DOC003', 'Eutilia Guadalupe Olivares Velázquez', 0, 0, NULL, 0),
('SUB004', 'Administración de Base de Datos', 'IDGS 8-3', 'DOC004', 'Julia Elizabeth García Herrera', 0, 0, NULL, 0),
('SUB005', 'Matemáticas para Ingeniería II', 'IDGS 8-3', 'DOC005', 'Jordy Zaid Quintero Díaz', 0, 0, NULL, 0),
('SUB006', 'Desarrollo Web Profesional', 'IDGS 8-3', 'DOC006', 'Aurelio Arturo Flores Quirarte', 0, 0, NULL, 0),
('SUB007', 'Seguridad en el Desarrollo de Aplicaciones', 'IDGS 8-1', 'DOC001', 'Ramón Eduardo Mercado Carreón', 0, 0, NULL, 0),
('SUB008', 'Inglés VII', 'IDGS 8-1', 'DOC002', 'Norma Beatriz Flores Núñez', 0, 0, NULL, 0),
('SUB009', 'Planeación y Organización del Trabajo', 'IDGS 8-1', 'DOC003', 'Eutilia Guadalupe Olivares Velázquez', 0, 0, NULL, 0),
('SUB010', 'Administración de Base de Datos', 'IDGS 8-1', 'DOC004', 'Julia Elizabeth García Herrera', 0, 0, NULL, 0),
('SUB011', 'Matemáticas para Ingeniería II', 'IDGS 8-1', 'DOC005', 'Jordy Zaid Quintero Díaz', 0, 0, NULL, 0),
('SUB012', 'Desarrollo Web Profesional', 'IDGS 8-1', 'DOC006', 'Aurelio Arturo Flores Quirarte', 0, 0, NULL, 0),
('SUB013', 'Seguridad en el Desarrollo de Aplicaciones', 'IDGS 8-2', 'DOC001', 'Ramón Eduardo Mercado Carreón', 0, 0, NULL, 0),
('SUB014', 'Inglés VII', 'IDGS 8-2', 'DOC002', 'Norma Beatriz Flores Núñez', 0, 0, NULL, 0),
('SUB015', 'Planeación y Organización del Trabajo', 'IDGS 8-2', 'DOC003', 'Eutilia Guadalupe Olivares Velázquez', 0, 0, NULL, 0),
('SUB016', 'Administración de Base de Datos', 'IDGS 8-2', 'DOC004', 'Julia Elizabeth García Herrera', 0, 0, NULL, 0),
('SUB017', 'Matemáticas para Ingeniería II', 'IDGS 8-2', 'DOC005', 'Jordy Zaid Quintero Díaz', 0, 0, NULL, 0),
('SUB018', 'Desarrollo Web Profesional', 'IDGS 8-2', 'DOC006', 'Aurelio Arturo Flores Quirarte', 0, 0, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submissions`
--

CREATE TABLE `submissions` (
  `id` varchar(30) NOT NULL,
  `assignment_id` varchar(20) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `status` enum('Pendiente','Entregado','Con retraso','Revisado') NOT NULL DEFAULT 'Pendiente',
  `comentario` text DEFAULT NULL,
  `archivo_nombre` varchar(255) DEFAULT NULL,
  `archivo_ruta` varchar(500) DEFAULT NULL,
  `calificacion` decimal(4,1) DEFAULT NULL,
  `entregado_at` datetime DEFAULT NULL,
  `revisado_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `submissions`
--

INSERT INTO `submissions` (`id`, `assignment_id`, `student_id`, `status`, `comentario`, `archivo_nombre`, `archivo_ruta`, `calificacion`, `entregado_at`, `revisado_at`) VALUES
('TR-0002-AL001', 'TR-0002', 'AL001', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL002', 'TR-0002', 'AL002', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL003', 'TR-0002', 'AL003', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL004', 'TR-0002', 'AL004', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL005', 'TR-0002', 'AL005', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL006', 'TR-0002', 'AL006', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL007', 'TR-0002', 'AL007', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL008', 'TR-0002', 'AL008', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL009', 'TR-0002', 'AL009', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL010', 'TR-0002', 'AL010', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL011', 'TR-0002', 'AL011', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL012', 'TR-0002', 'AL012', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL013', 'TR-0002', 'AL013', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL014', 'TR-0002', 'AL014', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL015', 'TR-0002', 'AL015', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL016', 'TR-0002', 'AL016', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL017', 'TR-0002', 'AL017', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL018', 'TR-0002', 'AL018', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL019', 'TR-0002', 'AL019', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL020', 'TR-0002', 'AL020', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL021', 'TR-0002', 'AL021', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL022', 'TR-0002', 'AL022', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL023', 'TR-0002', 'AL023', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL024', 'TR-0002', 'AL024', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0002-AL025', 'TR-0002', 'AL025', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL045', 'TR-0003', 'AL045', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL046', 'TR-0003', 'AL046', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL047', 'TR-0003', 'AL047', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL048', 'TR-0003', 'AL048', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL049', 'TR-0003', 'AL049', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL050', 'TR-0003', 'AL050', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL051', 'TR-0003', 'AL051', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL052', 'TR-0003', 'AL052', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL053', 'TR-0003', 'AL053', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL054', 'TR-0003', 'AL054', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL055', 'TR-0003', 'AL055', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL056', 'TR-0003', 'AL056', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL057', 'TR-0003', 'AL057', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL058', 'TR-0003', 'AL058', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL059', 'TR-0003', 'AL059', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL060', 'TR-0003', 'AL060', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL061', 'TR-0003', 'AL061', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL062', 'TR-0003', 'AL062', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL063', 'TR-0003', 'AL063', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0003-AL064', 'TR-0003', 'AL064', 'Revisado', NULL, NULL, NULL, 10.0, '2026-08-15 19:46:51', '2026-08-15 19:47:35'),
('TR-0003-AL065', 'TR-0003', 'AL065', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL045', 'TR-0004', 'AL045', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL046', 'TR-0004', 'AL046', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL047', 'TR-0004', 'AL047', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL048', 'TR-0004', 'AL048', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL049', 'TR-0004', 'AL049', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL050', 'TR-0004', 'AL050', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL051', 'TR-0004', 'AL051', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL052', 'TR-0004', 'AL052', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL053', 'TR-0004', 'AL053', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL054', 'TR-0004', 'AL054', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL055', 'TR-0004', 'AL055', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL056', 'TR-0004', 'AL056', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL057', 'TR-0004', 'AL057', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL058', 'TR-0004', 'AL058', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL059', 'TR-0004', 'AL059', 'Revisado', 'Piche practica babosa de dos pesos.', NULL, NULL, 10.0, '2026-08-16 19:40:01', '2026-08-16 19:50:19'),
('TR-0004-AL060', 'TR-0004', 'AL060', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL061', 'TR-0004', 'AL061', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL062', 'TR-0004', 'AL062', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL063', 'TR-0004', 'AL063', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL064', 'TR-0004', 'AL064', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0004-AL065', 'TR-0004', 'AL065', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL001', 'TR-0005', 'AL001', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL002', 'TR-0005', 'AL002', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL003', 'TR-0005', 'AL003', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL004', 'TR-0005', 'AL004', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL005', 'TR-0005', 'AL005', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL006', 'TR-0005', 'AL006', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL007', 'TR-0005', 'AL007', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL008', 'TR-0005', 'AL008', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL009', 'TR-0005', 'AL009', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL010', 'TR-0005', 'AL010', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL011', 'TR-0005', 'AL011', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL012', 'TR-0005', 'AL012', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL013', 'TR-0005', 'AL013', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL014', 'TR-0005', 'AL014', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL015', 'TR-0005', 'AL015', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL016', 'TR-0005', 'AL016', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL017', 'TR-0005', 'AL017', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL018', 'TR-0005', 'AL018', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL019', 'TR-0005', 'AL019', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL020', 'TR-0005', 'AL020', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL021', 'TR-0005', 'AL021', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL022', 'TR-0005', 'AL022', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL023', 'TR-0005', 'AL023', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL024', 'TR-0005', 'AL024', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL),
('TR-0005-AL025', 'TR-0005', 'AL025', 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submission_attachments`
--

CREATE TABLE `submission_attachments` (
  `id` varchar(40) NOT NULL,
  `submission_id` varchar(30) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `stored_path` varchar(500) NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `size_bytes` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `submission_attachments`
--

INSERT INTO `submission_attachments` (`id`, `submission_id`, `original_name`, `stored_path`, `mime_type`, `size_bytes`, `created_at`) VALUES
('42452a0f-6148-404e-82f6-34eeb7b3c172', 'TR-0004-AL059', 'Practica5 (1) (2).pdf', 'submissions\\TR-0004\\1786934401032-5117823c-Practica5 _1_ _2_.pdf', 'application/pdf', 248767, '2026-08-16 19:40:01'),
('758ec8b6-57cc-467c-b2d8-724a8255eb0b', 'TR-0003-AL064', 'Practica 1- IAST (1).pdf', 'C:\\Users\\ferba\\Desktop\\ADondeLoMando\\utslrc-sistema-fusionado\\backend\\uploads\\submissions\\TR-0003\\1786848411086-9da3dd66-Practica 1- IAST _1_.pdf', 'application/pdf', 629179, '2026-08-15 19:46:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `teachers`
--

CREATE TABLE `teachers` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `grado` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `contrasena` varchar(255) NOT NULL DEFAULT '12345678',
  `available_slots` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `teachers`
--

INSERT INTO `teachers` (`id`, `nombre`, `grado`, `email`, `contrasena`, `available_slots`) VALUES
('DOC001', 'Ramón Eduardo Mercado Carreón', NULL, NULL, '12345678', NULL),
('DOC002', 'Norma Beatriz Flores Núñez', NULL, NULL, '12345678', NULL),
('DOC003', 'Eutilia Guadalupe Olivares Velázquez', NULL, NULL, '12345678', NULL),
('DOC004', 'Julia Elizabeth García Herrera', NULL, NULL, '12345678', NULL),
('DOC005', 'Jordy Zaid Quintero Díaz', NULL, NULL, '12345678', NULL),
('DOC006', 'Aurelio Arturo Flores Quirarte', NULL, NULL, '12345678', NULL);

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
('DOC001', 'IDGS 8-3'),
('DOC002', 'IDGS 8-1'),
('DOC002', 'IDGS 8-2'),
('DOC002', 'IDGS 8-3'),
('DOC003', 'IDGS 8-1'),
('DOC003', 'IDGS 8-2'),
('DOC003', 'IDGS 8-3'),
('DOC004', 'IDGS 8-1'),
('DOC004', 'IDGS 8-2'),
('DOC004', 'IDGS 8-3'),
('DOC005', 'IDGS 8-1'),
('DOC005', 'IDGS 8-2'),
('DOC005', 'IDGS 8-3'),
('DOC006', 'IDGS 8-1'),
('DOC006', 'IDGS 8-2'),
('DOC006', 'IDGS 8-3');

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vinculacion`
--

CREATE TABLE `vinculacion` (
  `id` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `expediente` varchar(20) NOT NULL,
  `contrasena` varchar(255) NOT NULL DEFAULT '12345678'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vinculacion`
--

INSERT INTO `vinculacion` (`id`, `nombre`, `correo`, `expediente`, `contrasena`) VALUES
('VIN001', 'Vinculación', 'vinculacion@utslrc.edu.mx', 'vinculacion', 'vinculacion123');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administradores`
--
ALTER TABLE `administradores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `expediente` (`expediente`);

--
-- Indices de la tabla `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indices de la tabla `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indices de la tabla `assignment_attachments`
--
ALTER TABLE `assignment_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assignment_id` (`assignment_id`);

--
-- Indices de la tabla `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_alumno_materia_fecha` (`student_id`,`subject_id`,`fecha`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indices de la tabla `attendance_summary`
--
ALTER TABLE `attendance_summary`
  ADD PRIMARY KEY (`student_id`);

--
-- Indices de la tabla `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `isbn` (`isbn`);

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
-- Indices de la tabla `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `qr` (`qr`);

--
-- Indices de la tabla `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `student_id` (`student_id`);

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
-- Indices de la tabla `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_assignment_student` (`assignment_id`,`student_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indices de la tabla `submission_attachments`
--
ALTER TABLE `submission_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `submission_id` (`submission_id`);

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
-- Indices de la tabla `vinculacion`
--
ALTER TABLE `vinculacion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `expediente` (`expediente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `schedule_slots`
--
ALTER TABLE `schedule_slots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `announcements_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `announcements_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignments_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `assignment_attachments`
--
ALTER TABLE `assignment_attachments`
  ADD CONSTRAINT `assignment_attachments_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD CONSTRAINT `attendance_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_records_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_records_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_records_ibfk_4` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE;

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
-- Filtros para la tabla `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

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
-- Filtros para la tabla `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `submission_attachments`
--
ALTER TABLE `submission_attachments`
  ADD CONSTRAINT `submission_attachments_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`) ON DELETE CASCADE;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
