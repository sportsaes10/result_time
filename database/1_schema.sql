-- ============================================================================
-- SCRIPT DE CREACIÓN DE ESQUEMA - SISTEMA DE RESULTADOS DEPORTIVOS
-- ============================================================================
-- Descripción: Script DDL completo para crear la estructura de base de datos
-- Versión: 1.0
-- Fecha: 2026-01-20
-- ============================================================================

-- Habilitar extensión para generar UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- TABLA: configuracion_evento
-- Descripción: Configuración general de eventos deportivos
-- ============================================================================
CREATE TABLE IF NOT EXISTS configuracion_evento (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre_evento TEXT NOT NULL,
    fecha_evento DATE,
    campos_registro JSONB DEFAULT '{"club": true, "email": true, "dorsal": true, "telefono": false}'::jsonb,
    columnas_leaderboard JSONB DEFAULT '["posicion", "dorsal", "nombre", "tiempo", "categoria"]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE configuracion_evento IS 'Almacena la configuración de eventos deportivos';
COMMENT ON COLUMN configuracion_evento.campos_registro IS 'Configuración JSON de campos visibles en el formulario de registro';
COMMENT ON COLUMN configuracion_evento.columnas_leaderboard IS 'Configuración JSON de columnas a mostrar en la tabla de clasificación';

-- ============================================================================
-- TABLA: pruebas
-- Descripción: Define las pruebas o competencias disponibles
-- ============================================================================
CREATE TABLE IF NOT EXISTS pruebas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    distancia_metros INTEGER,
    hora_salida TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE pruebas IS 'Catálogo de pruebas deportivas (ej: 5K, 10K, Media Maratón)';
COMMENT ON COLUMN pruebas.distancia_metros IS 'Distancia de la prueba en metros';

-- ============================================================================
-- TABLA: categorias
-- Descripción: Categorías de competencia por edad y género
-- ============================================================================
CREATE TABLE IF NOT EXISTS categorias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    prueba_id UUID REFERENCES pruebas(id) ON DELETE CASCADE,
    rango_edad_min INTEGER,
    rango_edad_max INTEGER,
    genero TEXT CHECK (genero IN ('M', 'F', 'Mixto')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE categorias IS 'Categorías de competencia (Elite, Novatos, Master, etc.)';
COMMENT ON COLUMN categorias.rango_edad_min IS 'Edad mínima para esta categoría';
COMMENT ON COLUMN categorias.rango_edad_max IS 'Edad máxima para esta categoría';

-- Índice para búsquedas por prueba
CREATE INDEX IF NOT EXISTS idx_categorias_prueba ON categorias(prueba_id);

-- ============================================================================
-- TABLA: atletas
-- Descripción: Registro completo de participantes
-- ============================================================================
CREATE TABLE IF NOT EXISTS atletas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dorsal TEXT NOT NULL,
    nombres TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    club TEXT,
    fecha_nacimiento DATE,
    genero TEXT CHECK (genero IN ('M', 'F')),
    email TEXT,
    telefono TEXT,
    prueba_id UUID REFERENCES pruebas(id) ON DELETE SET NULL,
    categoria_id UUID REFERENCES categorias(id) ON DELETE SET NULL,
    categoria TEXT,
    tipo_documento TEXT,
    numero_documento TEXT,
    edad INTEGER,
    departamento TEXT,
    municipio TEXT,
    localidad TEXT,
    estado_pago BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE atletas IS 'Registro de atletas participantes en eventos deportivos';
COMMENT ON COLUMN atletas.dorsal IS 'Número de dorsal asignado al atleta';
COMMENT ON COLUMN atletas.categoria IS 'Categoría del atleta (puede ser texto libre: Elite, Novatos, Master, etc.)';
COMMENT ON COLUMN atletas.estado_pago IS 'Indica si el atleta ha completado el pago de inscripción';

-- Índices para optimización de consultas
CREATE INDEX IF NOT EXISTS idx_atletas_dorsal ON atletas(dorsal);
CREATE INDEX IF NOT EXISTS idx_atletas_categoria ON atletas(categoria);
CREATE INDEX IF NOT EXISTS idx_atletas_genero ON atletas(genero);
CREATE INDEX IF NOT EXISTS idx_atletas_prueba ON atletas(prueba_id);
CREATE INDEX IF NOT EXISTS idx_atletas_numero_documento ON atletas(numero_documento);

-- ============================================================================
-- TABLA: resultados
-- Descripción: Tiempos y resultados de cada atleta
-- ============================================================================
CREATE TABLE IF NOT EXISTS resultados (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    atleta_id UUID UNIQUE NOT NULL REFERENCES atletas(id) ON DELETE CASCADE,
    tiempo_final INTERVAL,
    tiempo_ms INTEGER,
    timestamp_meta TIMESTAMPTZ,
    estado TEXT DEFAULT 'finalizado',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE resultados IS 'Resultados y tiempos de los atletas en las competencias';
COMMENT ON COLUMN resultados.tiempo_final IS 'Tiempo final en formato interval (HH:MM:SS.ms)';
COMMENT ON COLUMN resultados.tiempo_ms IS 'Tiempo en milisegundos para ordenamiento eficiente';
COMMENT ON COLUMN resultados.timestamp_meta IS 'Marca de tiempo exacta al cruzar la meta';
COMMENT ON COLUMN resultados.estado IS 'Estado del resultado: finalizado, descalificado, DNS, DNF';

-- Índices para optimización de consultas
CREATE INDEX IF NOT EXISTS idx_resultados_atleta ON resultados(atleta_id);
CREATE INDEX IF NOT EXISTS idx_resultados_tiempo_ms ON resultados(tiempo_ms);
CREATE INDEX IF NOT EXISTS idx_resultados_estado ON resultados(estado);

-- ============================================================================
-- VISTAS ÚTILES
-- ============================================================================

-- Vista: Ranking completo con información del atleta
CREATE OR REPLACE VIEW v_ranking_completo AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY r.tiempo_ms ASC NULLS LAST) as posicion,
    a.dorsal,
    a.nombres,
    a.apellidos,
    a.genero,
    a.categoria,
    a.club,
    a.departamento,
    a.municipio,
    r.tiempo_final,
    r.tiempo_ms,
    r.timestamp_meta,
    r.estado
FROM atletas a
LEFT JOIN resultados r ON a.id = r.atleta_id
ORDER BY r.tiempo_ms ASC NULLS LAST;

COMMENT ON VIEW v_ranking_completo IS 'Vista con ranking completo de atletas ordenados por tiempo';

-- Vista: Ranking por categoría
CREATE OR REPLACE VIEW v_ranking_por_categoria AS
SELECT 
    a.categoria,
    ROW_NUMBER() OVER (PARTITION BY a.categoria ORDER BY r.tiempo_ms ASC NULLS LAST) as posicion_categoria,
    a.dorsal,
    a.nombres,
    a.apellidos,
    a.genero,
    r.tiempo_final,
    r.tiempo_ms
FROM atletas a
LEFT JOIN resultados r ON a.id = r.atleta_id
WHERE a.categoria IS NOT NULL
ORDER BY a.categoria, r.tiempo_ms ASC NULLS LAST;

COMMENT ON VIEW v_ranking_por_categoria IS 'Ranking de atletas agrupado por categoría';

-- Vista: Estadísticas generales
CREATE OR REPLACE VIEW v_estadisticas_evento AS
SELECT 
    COUNT(DISTINCT a.id) as total_atletas,
    COUNT(DISTINCT r.id) as total_finalizados,
    COUNT(DISTINCT CASE WHEN a.genero = 'M' THEN a.id END) as total_hombres,
    COUNT(DISTINCT CASE WHEN a.genero = 'F' THEN a.id END) as total_mujeres,
    COUNT(DISTINCT a.categoria) as total_categorias,
    MIN(r.tiempo_ms) as mejor_tiempo_ms,
    AVG(r.tiempo_ms) as tiempo_promedio_ms,
    MAX(r.tiempo_ms) as peor_tiempo_ms
FROM atletas a
LEFT JOIN resultados r ON a.id = r.atleta_id;

COMMENT ON VIEW v_estadisticas_evento IS 'Estadísticas generales del evento deportivo';

-- ============================================================================
-- SCRIPT COMPLETADO
-- ============================================================================
-- Total de tablas creadas: 5
-- Total de vistas creadas: 3
-- Total de índices creados: 9
-- ============================================================================
