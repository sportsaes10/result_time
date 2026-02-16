-- Ejecuta este script en el Editor SQL de Supabase para agregar las nuevas columnas

ALTER TABLE atletas 
ADD COLUMN tipo_documento text,
ADD COLUMN numero_documento text,
ADD COLUMN fecha_nacimiento date,
ADD COLUMN edad int,
ADD COLUMN departamento text,
ADD COLUMN municipio text,
ADD COLUMN localidad text;
