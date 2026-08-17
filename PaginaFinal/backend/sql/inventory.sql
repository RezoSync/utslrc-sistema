-- Migración: módulo de Inventarios (activos institucionales)
-- Ejecutar una sola vez sobre la base de datos ya importada (baseDeDatosActual.sql).
-- Ejemplo: mysql -u root -p utslrc_sistema < sql/inventory.sql

CREATE TABLE IF NOT EXISTS `inventory_items` (
  `id` varchar(20) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `categoria` varchar(100) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL,
  `responsable` varchar(150) DEFAULT NULL,
  `status` enum('Disponible','En uso','Prestado','En reparación','Baja') NOT NULL DEFAULT 'Disponible',
  `valor` varchar(30) DEFAULT NULL,
  `qr` varchar(30) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `qr` (`qr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Datos de ejemplo (los mismos que antes existían como demo estático en el frontend,
-- ahora viven en la base de datos real). Puedes borrarlos o editarlos libremente.
INSERT INTO `inventory_items` (`id`, `nombre`, `categoria`, `ubicacion`, `responsable`, `status`, `valor`, `qr`) VALUES
('INV-2026-PC01', 'PC de trabajo #1', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC01'),
('INV-2026-PC02', 'PC de trabajo #2', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC02'),
('INV-2026-PC03', 'PC de trabajo #3', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC03'),
('INV-2026-PC04', 'PC de trabajo #4', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC04'),
('INV-2026-PC05', 'PC de trabajo #5', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC05'),
('INV-2026-PC06', 'PC de trabajo #6', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC06'),
('INV-2026-PC07', 'PC de trabajo #7', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC07'),
('INV-2026-PC08', 'PC de trabajo #8', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC08'),
('INV-2026-PC09', 'PC de trabajo #9', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC09'),
('INV-2026-PC10', 'PC de trabajo #10', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC10'),
('INV-2026-PC11', 'PC de trabajo #11', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC11'),
('INV-2026-PC12', 'PC de trabajo #12', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC12'),
('INV-2026-PC13', 'PC de trabajo #13', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC13'),
('INV-2026-PC14', 'PC de trabajo #14', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC14'),
('INV-2026-PC15', 'PC de trabajo #15', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC15'),
('INV-2026-PC16', 'PC de trabajo #16', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC16'),
('INV-2026-PC17', 'PC de trabajo #17', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC17'),
('INV-2026-PC18', 'PC de trabajo #18', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC18'),
('INV-2026-PC19', 'PC de trabajo #19', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC19'),
('INV-2026-PC20', 'PC de trabajo #20', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC20'),
('INV-2026-PC21', 'PC de trabajo #21', 'Cómputo', 'UD1-A6', 'IDGS 8-3', 'Disponible', '$12,000', 'QR-PC21')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);
