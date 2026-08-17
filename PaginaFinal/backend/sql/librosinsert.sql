INSERT INTO books (id, isbn, titulo, autor, categoria, ejemplares, disponibles, portada, google_books_id) VALUES
('L-0001', '978-607-15-1234', 'Estructuras de Datos y Algoritmos', 'Aho, Hopcroft & Ullman', 'Programación', 6, 2, NULL, NULL),
('L-0002', '978-607-15-2211', 'Redes de Computadoras', 'Andrew S. Tanenbaum', 'Redes', 4, 4, NULL, NULL),
('L-0003', '978-607-15-3390', 'Bases de Datos: Diseño y Gestión', 'Ramez Elmasri', 'Bases de Datos', 5, 1, NULL, NULL),
('L-0004', '978-607-15-4471', 'Ingeniería de Software Moderna', 'Ian Sommerville', 'Software', 3, 0, NULL, NULL),
('L-0005', '978-607-15-5502', 'Metodología de la Investigación', 'Roberto Hernández Sampieri', 'General', 8, 5, NULL, NULL),
('L-0006', '978-607-15-6689', 'Seguridad Informática y Ciberseguridad', 'Álvaro Gómez Vieites', 'Seguridad', 3, 3, NULL, NULL),
('L-0007', '978-0-13-468599-1', 'Sistemas Operativos: Conceptos Fundamentales', 'Abraham Silberschatz', 'Sistemas Operativos', 4, 4, NULL, NULL),
('L-0008', '978-0-13-449411-4', 'Arquitectura de Computadoras', 'David A. Patterson & John L. Hennessy', 'Hardware', 3, 2, NULL, NULL),
('L-0009', '978-607-522-063-3', 'Fundamentos de Programación', 'Luis Joyanes Aguilar', 'Programación', 6, 6, NULL, NULL),
('L-0010', '978-607-15-1043', 'Cloud Computing: Conceptos y Arquitecturas', 'Thomas Erl', 'Cloud', 3, 1, NULL, NULL),
('L-0011', '978-1-4919-1899-3', 'Inteligencia Artificial: Un Enfoque Moderno', 'Stuart Russell & Peter Norvig', 'Inteligencia Artificial', 4, 4, NULL, NULL),
('L-0012', '978-607-15-0982', 'Desarrollo Web con JavaScript Moderno', 'Marijn Haverbeke', 'Desarrollo Web', 5, 3, NULL, NULL),
('L-0013', '978-607-15-2287', 'Gestión de Proyectos de TI', 'Roger S. Pressman', 'Gestión de Proyectos', 3, 3, NULL, NULL),
('L-0014', '978-607-15-3105', 'Minería de Datos y Big Data', 'Jiawei Han', 'Ciencia de Datos', 3, 0, NULL, NULL);

UPDATE books SET isbn = '9789684443457' WHERE id = 'L-0001'; -- Estructuras de Datos y Algoritmos (Aho, Hopcroft, Ullman)
UPDATE books SET isbn = '9786073208178' WHERE id = 'L-0002'; -- Redes de Computadoras (Tanenbaum, 5ta ed.)
UPDATE books SET isbn = '9788478290857' WHERE id = 'L-0003'; -- Fundamentos de Sistemas de Bases de Datos (Elmasri/Navathe)
UPDATE books SET isbn = '9786073206037' WHERE id = 'L-0004'; -- Ingeniería de Software (Sommerville, 9na ed.)
UPDATE books SET isbn = '9781456223960' WHERE id = 'L-0005'; -- Metodología de la Investigación (Hernández Sampieri, 6ta ed.)
UPDATE books SET isbn = '9788499640365', titulo = 'Enciclopedia de la Seguridad Informática' WHERE id = 'L-0006'; -- Gómez Vieites (2da ed.)
UPDATE books SET isbn = '9788448146412' WHERE id = 'L-0007'; -- Fundamentos de Sistemas Operativos (Silberschatz)
UPDATE books SET isbn = '9788429126204' WHERE id = 'L-0008'; -- Estructura y Diseño de Computadores (Patterson/Hennessy)
UPDATE books SET isbn = '9786071514684' WHERE id = 'L-0009'; -- Fundamentos de Programación (Joyanes Aguilar, 5ta ed.)
UPDATE books SET isbn = '9788420540030' WHERE id = 'L-0011'; -- Inteligencia Artificial: Un Enfoque Moderno (Russell/Norvig)


DELETE FROM books WHERE id IN ('L-0010', 'L-0013', 'L-0014');