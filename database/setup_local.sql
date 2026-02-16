-- ============================================================================
-- SCRIPT MAESTRO DE CONFIGURACIÓN LOCAL
-- ============================================================================
-- Descripción: Script principal para configurar PostgreSQL local
-- Uso: psql -U postgres -d resultados_deportivos -f setup_local.sql
-- ============================================================================

\echo '============================================================================'
\echo 'CONFIGURACIÓN DE BASE DE DATOS LOCAL - SISTEMA DE RESULTADOS DEPORTIVOS'
\echo '============================================================================'
\echo ''

-- Configurar cliente
\set ON_ERROR_STOP on
\timing on

\echo 'Paso 1/4: Creando esquema de base de datos...'
\i 1_schema.sql

\echo ''
\echo 'Paso 2/4: Insertando datos de atletas...'
\i 2_data_atletas.sql

\echo ''
\echo 'Paso 3/4: Insertando datos de resultados...'
\i 3_data_resultados.sql

\echo ''
\echo 'Paso 4/4: Verificando instalación...'

-- Resumen de tablas
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Resumen de datos
\echo ''
\echo 'Resumen de datos:'
SELECT * FROM v_estadisticas_evento;

\echo ''
\echo '============================================================================'
\echo 'INSTALACIÓN COMPLETADA EXITOSAMENTE'
\echo '============================================================================'
\echo 'Base de datos: resultados_deportivos'
\echo 'Tablas creadas: 5'
\echo 'Vistas creadas: 3'
\echo ''
\echo 'Próximos pasos:'
\echo '1. Actualizar config.js para usar PostgreSQL local'
\echo '2. Reiniciar el servidor: node server.js'
\echo '3. Abrir http://localhost:3000/athletes.html'
\echo '============================================================================'
