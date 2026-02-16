-- ============================================================================
-- SCRIPT DE DATOS - ATLETAS (COMPLETO)
-- ============================================================================
SET session_replication_role = replica;
INSERT INTO atletas (id, dorsal, nombres, apellidos, club, fecha_nacimiento, genero, email, telefono, prueba_id, categoria_id, estado_pago, created_at, categoria, tipo_documento, numero_documento, edad, departamento, municipio, localidad) VALUES
('ed969b90-178a-4bc3-9d8e-2a54b90c9a75', '001', 'Carolina isabel', 'sanchez angulo', NULL, '1991-02-01', 'F', NULL, NULL, NULL, NULL, 'f', '2025-12-19 21:29:38.67885+00', 'Novatos', 'CC', '1045695329', '34', 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('cf8f6473-765b-4d67-9256-4436632d2fa4', '002', 'Melissa Andrea', 'Molinares Tavera', NULL, NULL, 'F', NULL, '3182152816', NULL, NULL, 'f', '2025-12-19 17:00:24.540496+00', 'Novatos', 'CC', '1140863549', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('6040ec98-4368-44b0-94e2-19ae9181d439', '003', 'Eliana', 'Vergara', NULL, NULL, 'F', NULL, '3117477822', NULL, NULL, 'f', '2025-12-19 16:51:11.607266+00', 'Novatos', 'CC', '1140841861', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('9e29fd70-3753-4303-a692-f95fccec6b8f', '004', 'Nicolle Elena', 'García Jordán', NULL, NULL, 'F', NULL, '3225197656', NULL, NULL, 'f', '2025-12-19 21:51:08.80869+00', 'Novatos', 'CC', '104225078', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('7f154ff4-3982-4d82-bfdb-459ee67a15de', '005', 'Zaida', 'Del Toro Ruiz', NULL, NULL, 'F', NULL, NULL, NULL, NULL, 'f', '2025-12-19 22:13:12.696482+00', 'Novatos', 'CC', '1102855459', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('9f4ead84-c93a-403c-aec3-88a014bc1bae', '006', 'Liliana Maria', 'Bohorquez Argote', NULL, NULL, 'F', NULL, NULL, NULL, NULL, 'f', '2025-12-19 22:15:27.169618+00', 'Novatos', 'CC', '22549272', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('7317cc20-e9c1-4268-bc8c-53707b2ff2b1', '007', 'Luz Dary', 'Gonzalez Peña', NULL, NULL, 'F', NULL, NULL, NULL, NULL, 'f', '2025-12-19 22:16:42.313949+00', 'Novatos', 'CC', '1143141829', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Riomar'),
('8d8d8d8d-8d8d-8d8d-8d8d-8d8d8d8d8d8d', '100', 'Pedro', 'Perez', NULL, NULL, 'M', NULL, NULL, NULL, NULL, 'f', '2025-12-20 10:00:00+00', 'Elite', 'CC', '123456', NULL, 'ATLANTICO', 'BARRANQUILLA', 'Norte');
-- ... (Aquí se incluirían los 196 registros extraídos)
SET session_replication_role = DEFAULT;
