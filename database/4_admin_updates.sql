-- Agregar columna para el logo
ALTER TABLE configuracion_evento 
ADD COLUMN IF NOT EXISTS logo_url TEXT;

-- Asegurar que existe al menos una configuración por defecto
INSERT INTO configuracion_evento (nombre_evento, fecha_evento, campos_registro, columnas_leaderboard)
SELECT 'Evento Deportivo', CURRENT_DATE, 
    '{"club": true, "email": true, "dorsal": true, "telefono": true, "genero": true, "categoria": true}'::jsonb,
    '["posicion", "dorsal", "nombre", "tiempo", "categoria"]'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM configuracion_evento);
