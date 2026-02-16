-- 1. Agregar control de evento activo y campos dinámicos a la configuración
ALTER TABLE configuracion_evento 
ADD COLUMN IF NOT EXISTS configuracion_fields JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS evento_activo_id UUID,
ADD COLUMN IF NOT EXISTS filtros_ranking JSONB DEFAULT '[]'::jsonb;

-- 2. Crear tabla de eventos (Histórico / Archivo)
CREATE TABLE IF NOT EXISTS eventos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Vincular Atletas y Resultados a un Evento
ALTER TABLE atletas 
ADD COLUMN IF NOT EXISTS evento_id UUID REFERENCES eventos(id);

ALTER TABLE resultados 
ADD COLUMN IF NOT EXISTS evento_id UUID REFERENCES eventos(id);

-- 4. Datos Iniciales: Crear un primer evento y asignarlo
DO $$
DECLARE
    v_evento_id UUID;
BEGIN
    -- Crear evento inicial si no existe ninguno
    IF NOT EXISTS (SELECT 1 FROM eventos) THEN
        INSERT INTO eventos (nombre, fecha, activo) 
        VALUES ('Evento Inicial', CURRENT_DATE, true)
        RETURNING id INTO v_evento_id;
        
        -- Asignar este evento a la configuración
        UPDATE configuracion_evento SET evento_activo_id = v_evento_id;

        -- Migrar datos huérfanos a este evento
        UPDATE atletas SET evento_id = v_evento_id WHERE evento_id IS NULL;
        UPDATE resultados SET evento_id = v_evento_id WHERE evento_id IS NULL;
    END IF;
END $$;

-- 5. Configuración por defecto de campos (Solo si está vacío o es el array vacío por defecto)
UPDATE configuracion_evento 
SET configuracion_fields = '[
  {"key": "dorsal", "label": "Dorsal", "type": "text", "required": true, "system": true, "show_in_ranking": true},
  {"key": "nombres", "label": "Nombres", "type": "text", "required": true, "system": true, "show_in_ranking": true},
  {"key": "apellidos", "label": "Apellidos", "type": "text", "required": true, "system": true, "show_in_ranking": true},
  {"key": "genero", "label": "Género", "type": "select", "options": ["M","F"], "required": true, "system": true, "show_in_ranking": true, "is_filter": true},
  {"key": "categoria", "label": "Categoría", "type": "select", "options": ["Elite","Novatos","Master"], "required": true, "system": false, "show_in_ranking": true, "is_filter": true},
  {"key": "club", "label": "Club", "type": "text", "required": false, "system": false, "show_in_ranking": false},
  {"key": "email", "label": "Email", "type": "email", "required": false, "system": false, "show_in_ranking": false},
  {"key": "telefono", "label": "Teléfono", "type": "tel", "required": false, "system": false, "show_in_ranking": false},
  {"key": "fecha_nacimiento", "label": "Fecha Nacimiento", "type": "date", "required": false, "system": false, "show_in_ranking": false},
  {"key": "tipo_documento", "label": "Tipo Doc.", "type": "select", "options": ["CC","TI","CE","PAS"], "required": false, "system": false, "show_in_ranking": false},
  {"key": "numero_documento", "label": "No. Documento", "type": "text", "required": false, "system": false, "show_in_ranking": false},
  {"key": "departamento", "label": "Departamento", "type": "text", "required": false, "system": false, "show_in_ranking": false},
  {"key": "municipio", "label": "Municipio", "type": "text", "required": false, "system": false, "show_in_ranking": false}
]'::jsonb
WHERE configuracion_fields IS NULL OR configuracion_fields = '[]'::jsonb;
