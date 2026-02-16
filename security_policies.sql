-- ==========================================
-- SCRIPT DE SEGURIDAD (RLS) - SPORTSAES
-- Ejecuta este script en el SQL Editor de Supabase
-- ==========================================

-- 1. Activar RLS en tablas principales
ALTER TABLE atletas ENABLE ROW LEVEL SECURITY;
ALTER TABLE resultados ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracion_evento ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos ENABLE ROW LEVEL SECURITY;

-- 2. Políticas para 'atletas'
-- Creada: Cualquiera puede ver (Ranking Público)
CREATE POLICY "Public Read Athletes" ON atletas FOR SELECT USING (true);
-- Creada: Cualquiera puede insertar (Registro Público sin login)
CREATE POLICY "Public Insert Athletes" ON atletas FOR INSERT WITH CHECK (true);
-- Creada: Solo admin puede modificar
CREATE POLICY "Admin Update Athletes" ON atletas FOR UPDATE TO authenticated USING (true);
-- Creada: Solo admin puede borrar
CREATE POLICY "Admin Delete Athletes" ON atletas FOR DELETE TO authenticated USING (true);

-- 3. Políticas para 'resultados'
CREATE POLICY "Public Read Results" ON resultados FOR SELECT USING (true);
CREATE POLICY "Public Insert Results" ON resultados FOR INSERT WITH CHECK (true);
CREATE POLICY "Admin Update Results" ON resultados FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Admin Delete Results" ON resultados FOR DELETE TO authenticated USING (true);

-- 4. Políticas para 'configuracion_evento' & 'eventos'
CREATE POLICY "Public Read Config" ON configuracion_evento FOR SELECT USING (true);
CREATE POLICY "Admin All Config" ON configuracion_evento FOR ALL TO authenticated USING (true);

CREATE POLICY "Public Read Events" ON eventos FOR SELECT USING (true);
CREATE POLICY "Admin All Events" ON eventos FOR ALL TO authenticated USING (true);

-- Fin del script
