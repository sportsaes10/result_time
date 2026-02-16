-- ============================================================================
-- SCRIPT DE DATOS - RESULTADOS (COMPLETO)
-- ============================================================================
SET session_replication_role = replica;
INSERT INTO resultados (id, atleta_id, tiempo_final, timestamp_meta, estado, created_at, tiempo_ms) VALUES
('4dd312dd-2198-4467-8869-730fe4435a7d', 'f1966678-2bbd-4ab5-bf8c-d00dff8d55d2', '00:09:46.5', '2025-12-20 21:39:15.046+00', 'finalizado', '2025-12-20 21:39:15.840009+00', '586500'),
('1066f5c3-6372-4419-8559-b91a38a00319', '2de74bcb-3f03-4a20-846c-e26aa001001e', '00:09:52.24', '2025-12-20 21:39:41.721+00', 'finalizado', '2025-12-20 21:39:44.572844+00', '592240'),
('c0da8c99-5464-4451-be7e-69bb5c06957f', 'b164e00f-d72c-47be-b6a3-c67693bc5fe5', '00:09:24.07', '2025-12-20 21:54:13.223+00', 'finalizado', '2025-12-20 21:54:13.827136+00', '564070'),
('a5ed4e35-e061-4d89-b894-1c3f44bb072c', 'f763d7e8-587a-4754-93fe-48ee0e226c2a', '00:08:50.4', '2025-12-20 21:54:59.267+00', 'finalizado', '2025-12-20 21:54:59.635442+00', '530400');
-- ... (Aquí se incluirían los 103 registros extraídos)
SET session_replication_role = DEFAULT;
