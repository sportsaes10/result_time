# 🔒 Configuración de Seguridad - Result Time App

## Resumen de Cambios de Seguridad

Se ha implementado un sistema seguro para manejar credenciales de Supabase:

✅ Credenciales **NO ESTÁN** en el código versionado
✅ Credenciales se cargan desde variables de entorno
✅ Endpoint `/api/config` protegido en servidor
✅ Fallback automático para ambiente local
✅ Archivo `.env.example` documentado

---

## 🚀 Configuración para Desarrollo Local

### Paso 1: Crear archivo `.env.local`

```bash
# En la raíz del proyecto, crear archivo: .env.local
SUPABASE_URL=https://xqppzsyhvlvoowmdgsdm.supabase.co
SUPABASE_ANON_KEY=tu_clave_aqui
```

⚠️ **IMPORTANTE:** Este archivo está en `.gitignore` y NUNCA será versionado.

### Paso 2: Instalar dependencias

```bash
npm install
```

### Paso 3: Ejecutar servidor local

```bash
node server.js
```

El servidor ahora:
- Carga variables de `.env.local` con `dotenv`
- Expone endpoint `/api/config` que devuelve credenciales
- `config.js` hace fetch a ese endpoint automáticamente

---

## 🔧 Configuración para Vercel (Producción)

### Paso 1: En el Dashboard de Vercel

1. Ve a tu proyecto: https://vercel.com/dashboard
2. Selecciona el proyecto `result-time`
3. Ve a **Settings** → **Environment Variables**

### Paso 2: Agregar Variables de Entorno

Crea estas dos variables:

```
Nombre: SUPABASE_URL
Valor: https://xqppzsyhvlvoowmdgsdm.supabase.co
Aplicar a: Production (y Preview si quieres)
```

```
Nombre: SUPABASE_ANON_KEY
Valor: sb_publishable_uGEesrlmccscFr5k5fBjtg_yaG0pERt
Aplicar a: Production (y Preview si quieres)
```

### Paso 3: Re-deployar

Después de agregar variables de entorno:
- Vercel automáticamente re-deployará tu sitio
- Las credenciales se cargarán desde `/api/config`

---

## 🔍 Cómo Funciona el Flujo de Seguridad

```
┌─────────────────────────────────────────────────────────────┐
│ NAVEGADOR                                                   │
├─────────────────────────────────────────────────────────────┤
│ 1. Carga ranking.html                                      │
│ 2. Ejecuta config.js                                       │
│ 3. config.js hace fetch('/api/config')                     │
└─────────────┬──────────────────────────────────────────────┘
              │
              │ HTTP GET /api/config
              ▼
┌─────────────────────────────────────────────────────────────┐
│ SERVIDOR NODE.JS                                            │
├─────────────────────────────────────────────────────────────┤
│ 1. Lee env var: process.env.SUPABASE_URL                   │
│ 2. Lee env var: process.env.SUPABASE_ANON_KEY              │
│ 3. Devuelve JSON: {supabaseUrl, supabaseAnonKey}           │
└─────────────┬──────────────────────────────────────────────┘
              │
              │ JSON response
              ▼
┌─────────────────────────────────────────────────────────────┐
│ NAVEGADOR                                                   │
├─────────────────────────────────────────────────────────────┤
│ 1. Recibe credenciales                                     │
│ 2. window.supabaseClient = supabase.createClient(...)      │
│ 3. Ahora puede hacer queries a Supabase                    │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Ventajas de esta Implementación

| Aspecto | Antes | Ahora |
|--------|-------|-------|
| **Credenciales en código** | ❌ Sí, en config.js | ✅ No, en variables de entorno |
| **Versionadas en Git** | ❌ Sí | ✅ No (en .gitignore) |
| **Cambiar sin deploy** | ❌ No | ✅ Sí (solo en Vercel) |
| **Seguridad local** | ❌ Débil | ✅ Archivo .env.local privado |
| **Documentación** | ❌ No | ✅ Sí (.env.example) |

---

## 🚨 Checklist de Seguridad

- [ ] `.env.local` creado localmente (no en repo)
- [ ] `npm install` ejecutado para instalar dotenv
- [ ] Variables de entorno añadidas en Vercel
- [ ] Vercel re-deployó el sitio
- [ ] Credenciales antiguas revocadas en Supabase (si es necesario)
- [ ] `/api/config` devuelve credenciales correctas
- [ ] `config.js` carga sin errores en consola

---

## 📞 Troubleshooting

### Error: "Supabase JS Library no encontrada o credenciales no disponibles"

**Solución:**
1. Verifica que Supabase JS se cargó desde CDN (línea 9 de HTML)
2. Verifica `/api/config` devuelve valores válidos
3. Espera a que `config.js` termine de cargar antes de usar `window.supabaseClient`

### Error 404 en `/api/config`

**Solución:**
1. Asegúrate que `server.js` está actualizado con el endpoint
2. Reinicia el servidor local: `node server.js`
3. Verifica que el servidor está corriendo en puerto 3006

### En Vercel: Credenciales vacías

**Solución:**
1. Verifica que las variables de entorno existen en Vercel
2. Haz un re-deploy manual desde Vercel dashboard
3. Revisa los logs de Vercel para ver si hay errores

---

## 📚 Referencias

- [Vercel Environment Variables](https://vercel.com/docs/projects/environment-variables)
- [Supabase Client Initialization](https://supabase.com/docs/reference/javascript/initializing)
- [dotenv NPM Package](https://www.npmjs.com/package/dotenv)

**Última actualización:** 2026-04-10
**Versión:** 1.0 - Seguridad mejorada
