-- Script SQL para actualizar la base de datos
-- Ejecutar estos comandos en el SQL Editor de Supabase

-- 1. Agregar columna 'categoria' a la tabla 'atletas'
ALTER TABLE atletas 
ADD COLUMN IF NOT EXISTS categoria TEXT;

-- 2. Agregar columna 'tiempo_ms' a la tabla 'resultados'
ALTER TABLE resultados 
ADD COLUMN IF NOT EXISTS tiempo_ms INTEGER;

-- 3. Comentarios sobre las columnas (opcional, para documentación)
COMMENT ON COLUMN atletas.categoria IS 'Categoría del atleta: Sub-18, Élite, Master, Libre, etc.';
COMMENT ON COLUMN resultados.tiempo_ms IS 'Tiempo en milisegundos para ordenamiento eficiente';

-- 4. Crear índice para mejorar el rendimiento del ordenamiento
CREATE INDEX IF NOT EXISTS idx_resultados_tiempo_ms ON resultados(tiempo_ms);
CREATE INDEX IF NOT EXISTS idx_atletas_categoria ON atletas(categoria);
