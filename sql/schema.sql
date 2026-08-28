-- Clase 5 - Primer contacto con un motor de base de datos (MySQL)
-- Ejecuta este script en MySQL Workbench (o en la consola `mysql`) ANTES de correr el proyecto Java.
--
-- Si ya creaste la base `prog2_db` y la tabla `estudiantes` en la tarea de la Clase 3,
-- este script no te hara dano: usa IF NOT EXISTS y no duplica los datos de ejemplo
-- gracias a la restriccion UNIQUE sobre `carnet`.

CREATE DATABASE IF NOT EXISTS prog2_db;

USE prog2_db;

CREATE TABLE IF NOT EXISTS estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    carnet VARCHAR(20) NOT NULL UNIQUE
);

-- INSERT IGNORE: si el carnet ya existe (por ejemplo porque ya corriste este script
-- antes) MySQL ignora esa fila en lugar de lanzar un error de duplicado.
INSERT IGNORE INTO estudiantes (nombre, carnet) VALUES
    ('Ana Lopez', '2024001'),
    ('Carlos Perez', '2024002'),
    ('Maria Gonzalez', '2024003');
