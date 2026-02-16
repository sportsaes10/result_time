# Guía de Instalación Local - PostgreSQL

## Requisitos Previos

- Windows 10/11
- Permisos de administrador
- Conexión a internet para descargar PostgreSQL

## Paso 1: Instalar PostgreSQL

### Opción A: Instalador Oficial (Recomendado)

1. **Descargar PostgreSQL:**
   - Visitar: https://www.postgresql.org/download/windows/
   - Descargar la versión 15 o superior (recomendado: PostgreSQL 16)
   - Ejecutar el instalador `postgresql-16.x-windows-x64.exe`

2. **Configuración durante la instalación:**
   - **Installation Directory:** Dejar por defecto (`C:\Program Files\PostgreSQL\16`)
   - **Components:** Seleccionar todos (PostgreSQL Server, pgAdmin 4, Stack Builder, Command Line Tools)
   - **Data Directory:** Dejar por defecto
   - **Password:** Establecer contraseña para el usuario `postgres` (¡IMPORTANTE: recordarla!)
   - **Port:** 5432 (por defecto)
   - **Locale:** Spanish, Colombia o Default locale

3. **Verificar instalación:**
   ```powershell
   # Abrir PowerShell y ejecutar:
   psql --version
   ```
   Debería mostrar: `psql (PostgreSQL) 16.x`

### Opción B: Usando Chocolatey

```powershell
# Ejecutar PowerShell como Administrador
choco install postgresql
```

## Paso 2: Crear la Base de Datos

1. **Abrir pgAdmin 4** (instalado con PostgreSQL)
   - Buscar "pgAdmin 4" en el menú de Windows
   - Conectar con el servidor local usando la contraseña configurada

2. **Crear la base de datos:**
   - Click derecho en "Databases" → "Create" → "Database"
   - **Database name:** `resultados_deportivos`
   - **Owner:** postgres
   - Click "Save"

**Alternativa por línea de comandos:**
```powershell
# Abrir PowerShell
psql -U postgres -c "CREATE DATABASE resultados_deportivos;"
```

## Paso 3: Ejecutar Scripts de Migración

### Método 1: Usando pgAdmin 4

1. Abrir pgAdmin 4
2. Conectar a la base de datos `resultados_deportivos`
3. Click en "Tools" → "Query Tool"
4. Abrir el archivo `database/setup_local.sql`
5. Click en el botón "Execute" (▶)

### Método 2: Usando línea de comandos (Recomendado)

```powershell
# Navegar al directorio del proyecto
cd "d:\02 APPS\08 Resultados\database"

# Ejecutar el script maestro
psql -U postgres -d resultados_deportivos -f setup_local.sql
```

**Salida esperada:**
```
============================================================================
CONFIGURACIÓN DE BASE DE DATOS LOCAL - SISTEMA DE RESULTADOS DEPORTIVOS
============================================================================

Paso 1/4: Creando esquema de base de datos...
CREATE EXTENSION
CREATE TABLE
CREATE TABLE
...
Paso 2/4: Insertando datos de atletas...
Total de atletas insertados: 196
...
Paso 3/4: Insertando datos de resultados...
Total de resultados insertados: 103
Integridad referencial verificada: OK
...
INSTALACIÓN COMPLETADA EXITOSAMENTE
============================================================================
```

## Paso 4: Configurar la Aplicación

### Crear archivo de configuración local

Crear el archivo `config_local.js` en la raíz del proyecto:

```javascript
// Configuración para PostgreSQL local
const POSTGRES_CONFIG = {
    host: 'localhost',
    port: 5432,
    database: 'resultados_deportivos',
    user: 'postgres',
    password: 'TU_CONTRASEÑA_AQUI' // Reemplazar con tu contraseña
};

// Esta configuración se usará cuando se detecte entorno local
if (typeof module !== 'undefined' && module.exports) {
    module.exports = POSTGRES_CONFIG;
}
```

### Modificar config.js para soportar modo local

Agregar al inicio de `config.js`:

```javascript
// Detectar entorno
const IS_LOCAL = window.location.hostname === 'localhost' || 
                 window.location.hostname === '127.0.0.1';

// Usar configuración según entorno
if (IS_LOCAL) {
    console.log('Modo LOCAL detectado - usando PostgreSQL local');
    // Configuración para PostgreSQL local se manejará desde el backend
} else {
    console.log('Modo PRODUCCIÓN - usando Supabase');
    // Configuración actual de Supabase
}
```

> [!WARNING]
> **Limitación importante:** El cliente de Supabase en el navegador no puede conectarse directamente a PostgreSQL local. Se requiere crear un backend intermedio (API REST) para manejar las consultas.

## Paso 5: Verificar la Instalación

### Verificación en PostgreSQL

```sql
-- Conectar a la base de datos
psql -U postgres -d resultados_deportivos

-- Verificar tablas
\dt

-- Verificar datos
SELECT COUNT(*) FROM atletas;  -- Debe retornar: 196
SELECT COUNT(*) FROM resultados;  -- Debe retornar: 103

-- Ver ranking
SELECT * FROM v_ranking_completo LIMIT 10;

-- Salir
\q
```

### Verificación de estadísticas

```sql
SELECT * FROM v_estadisticas_evento;
```

**Resultado esperado:**
```
total_atletas | total_finalizados | total_hombres | total_mujeres | total_categorias | mejor_tiempo_ms | tiempo_promedio_ms | peor_tiempo_ms
--------------+-------------------+---------------+---------------+------------------+-----------------+--------------------+----------------
196          | 103               | XX            | XX            | X                | XXXXX           | XXXXX              | XXXXX
```

## Paso 6: Opciones para Conectar la Aplicación Web

### Opción A: Crear API REST con Node.js (Recomendado)

Crear `server_postgres.js`:

```javascript
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const port = 3001;

// Configuración de PostgreSQL
const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'resultados_deportivos',
    user: 'postgres',
    password: 'TU_CONTRASEÑA_AQUI'
});

app.use(cors());
app.use(express.json());

// Endpoint: Obtener todos los atletas
app.get('/api/atletas', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM atletas ORDER BY dorsal');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Endpoint: Obtener ranking
app.get('/api/ranking', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM v_ranking_completo');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(port, () => {
    console.log(`API REST corriendo en http://localhost:${port}`);
});
```

**Instalar dependencias:**
```powershell
npm install express pg cors
```

**Ejecutar:**
```powershell
node server_postgres.js
```

### Opción B: Continuar usando Supabase

Mantener Supabase para producción y usar PostgreSQL local solo para desarrollo/pruebas.

## Solución de Problemas

### Error: "psql: command not found"

**Solución:** Agregar PostgreSQL al PATH:
1. Buscar "Variables de entorno" en Windows
2. Editar "Path" en Variables del sistema
3. Agregar: `C:\Program Files\PostgreSQL\16\bin`
4. Reiniciar PowerShell

### Error: "password authentication failed"

**Solución:** Verificar la contraseña del usuario postgres:
```powershell
psql -U postgres
# Ingresar la contraseña configurada durante la instalación
```

### Error: "database does not exist"

**Solución:** Crear la base de datos manualmente:
```powershell
psql -U postgres -c "CREATE DATABASE resultados_deportivos;"
```

### Error al ejecutar scripts: "permission denied"

**Solución:** Ejecutar PowerShell como Administrador.

## Backup y Restauración

### Crear backup

```powershell
# Backup completo
pg_dump -U postgres resultados_deportivos > backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql

# Backup solo esquema
pg_dump -U postgres --schema-only resultados_deportivos > schema_backup.sql

# Backup solo datos
pg_dump -U postgres --data-only resultados_deportivos > data_backup.sql
```

### Restaurar backup

```powershell
# Restaurar desde backup
psql -U postgres resultados_deportivos < backup_20260120_153000.sql
```

## Próximos Pasos

1. ✅ PostgreSQL instalado y configurado
2. ✅ Base de datos creada con datos migrados
3. ⏳ Decidir estrategia de conexión (API REST vs Supabase)
4. ⏳ Actualizar frontend para usar nueva fuente de datos
5. ⏳ Probar funcionalidad completa

## Recursos Adicionales

- **Documentación PostgreSQL:** https://www.postgresql.org/docs/
- **pgAdmin 4 Docs:** https://www.pgadmin.org/docs/
- **Node.js pg library:** https://node-postgres.com/

---

> [!TIP]
> Para desarrollo local, se recomienda usar **pgAdmin 4** para visualizar y gestionar los datos de manera gráfica.
