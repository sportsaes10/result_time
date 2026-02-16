# 🛡️ Auditoría de Seguridad - Informe Previo a Publicación

Este documento detalla los hallazgos de seguridad y las recomendaciones urgentes antes de hacer pública la aplicación.

## 🚨 Hallazgos Críticos (Bloqueantes)

### 1. Panel de Administración Expuesto sin Autenticación

**Gravedad: CRÍTICA**

- **Archivo**: `admin.html`
- **Problema**: Cualquier persona que conozca la URL `tudominio.com/admin.html` puede entrar. No hay ningún sistema de login.
- **Riesgo**: Un atacante podría:
  - Cambiar el nombre del evento.
  - **Eliminar campos** del formulario de registro.
  - **Archivar el evento**, ocultando todos los resultados y reseteando el sistema en pleno evento.
- **Acción Requerida**: Implementar autenticación obligatoria (Supabase Auth) para acceder a esta página.

### 2. Políticas de Seguridad (RLS) en Base de Datos

**Gravedad: ALTA**

- **Problema**: Los scripts SQL revisados no incluyen definiciones de políticas de seguridad (Row Level Security - RLS).
- **Riesgo**: Si RLS está desactivado en Supabase, cualquier usuario con la clave pública (`anon_key`) puede leer **y modificar** toda la base de datos. Si está activado pero mal configurado (ej: `TO anon USING (true)`), el efecto es el mismo.
- **Acción Requerida**: Activar RLS en todas las tablas y crear políticas específicas:
  - `resultados` / `atletas`: Lectura pública (`SELECT`), pero Escritura/Modificación restringida.

## ⚠️ Hallazgos Medios

### 3. Vulnerabilidad XSS (Cross-Site Scripting)

**Gravedad: MEDIA**

- **Archivos**: `athletes.html`, `results.html`, `ranking.html`
- **Problema**: Se utiliza `.innerHTML` para insertar datos de nombres de atletas y clubes directamente en el DOM.
  - Ejemplo: `div.innerHTML = ... ${a.nombres} ...`
- **Riesgo**: Un usuario malintencionado podría registrarse con un nombre como `<img src=x onerror=alert('Hacked')>` y ejecutar código en el navegador de quien vea el ranking (incluido el administrador).
- **Acción Requerida**: Usar `.textContent` para insertar texto o sanitizar las entradas.

### 4. Exposición de Claves

**Gravedad: BAJA (Informativo)**

- **Archivo**: `config.js`
- **Análisis**: Se expone `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
- **Veredicto**: **Es normal** en aplicaciones SPA / Jamstack. Es seguro **SIEMPRE Y CUANDO** las reglas RLS (Punto 2) estén bien configuradas en el servidor. Si RLS falla, exponer estas claves es fatal.

---

## 🛠️ Plan de Remediación Recomendado

### Paso 1: Proteger Admin (Inmediato)

Si no se quiere implementar un sistema de login completo ya mismo, como medida de **emergencia** temporal:

1.  Renombrar `admin.html` a algo secreto (ej: `gestor_panel_x9z.html`).
2.  (Mejor) Implementar un login básico con Supabase Auth.

### Paso 2: Aplicar Reglas RLS en Supabase

Ejecutar el siguiente script SQL en Supabase para cerrar las puertas:

```sql
-- Activar RLS
ALTER TABLE atletas ENABLE ROW LEVEL SECURITY;
ALTER TABLE resultados ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracion_evento ENABLE ROW LEVEL SECURITY;

-- 1. Lectura Pública (Ranking y Listas)
CREATE POLICY "Lectura pública atletas" ON atletas FOR SELECT USING (true);
CREATE POLICY "Lectura pública resultados" ON resultados FOR SELECT USING (true);
CREATE POLICY "Lectura pública config" ON configuracion_evento FOR SELECT USING (true);

-- 2. Escritura (Registro) - Permitir a cualquiera INSERTAR (para que funcione el registro público)
-- NOTA: Esto permite spam, pero es necesario si el registro no requiere login.
CREATE POLICY "Registro público atletas" ON atletas FOR INSERT WITH CHECK (true);
CREATE POLICY "Registro público resultados" ON resultados FOR INSERT WITH CHECK (true);

-- 3. Protección de Modificación/Borrado
-- Solo permitir UPDATE/DELETE a usuarios autenticados (Admins)
CREATE POLICY "Solo admin modifica atletas" ON atletas FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Solo admin borra atletas" ON atletas FOR DELETE TO authenticated USING (true);
-- Repetir para resultados y configuración
```

### Paso 3: Sanitizar Frontend

Cambiar las inyecciones de HTML inseguras.
**Antes:**

```javascript
div.innerHTML = `<div>${a.nombres}</div>`;
```

**Después:**

```javascript
const divName = document.createElement("div");
divName.textContent = a.nombres;
div.appendChild(divName);
```
