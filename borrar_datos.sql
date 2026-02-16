-- Script para borrar todos los registros y atletas
-- ¡PRECAUCIÓN!: Esto eliminará todos los datos permanentemente.

-- 1. Borrar resultados primero (por integridad referencial)
TRUNCATE TABLE resultados RESTART IDENTITY CASCADE;

-- 2. Borrar atletas
TRUNCATE TABLE atletas RESTART IDENTITY CASCADE;

-- Opcional: Si tienes una tabla de 'pruebas' y también quieres limpiarla
-- TRUNCATE TABLE pruebas RESTART IDENTITY CASCADE;

-- Mensaje de confirmación: La base de datos está limpia y lista para nuevas pruebas.
