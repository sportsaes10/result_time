# ✅ CONFIGURACIÓN FINAL VERCEL - PASO A PASO

**Estado:** Token guardado y verificado  
**Próximo:** Configurar variables manualmente en dashboard

---

## 🎯 CONFIGURACIÓN MANUAL (5 MINUTOS)

### Paso 1: Abre Vercel Dashboard
```
https://vercel.com/dashboard
```

### Paso 2: Selecciona tu Proyecto
- Haz clic en: **result-time**

### Paso 3: Abre Settings
```
Proyecto → Settings → Environment Variables
```

### Paso 4: Agrega Variable 1

```
Nombre:   SUPABASE_URL
Valor:    https://xqppzsyhvlvoowmdgsdm.supabase.co
Aplicar:  ✓ Production
          ✓ Preview
          ✓ Development
```

**Presiona:** "Save"

### Paso 5: Agrega Variable 2

```
Nombre:   SUPABASE_ANON_KEY
Valor:    sb_publishable_uGEesrlmccscFr5k5fBjtg_yaG0pERt
Aplicar:  ✓ Production
          ✓ Preview
          ✓ Development
```

**Presiona:** "Save"

### Paso 6: Verifica que Aparecen

Deberías ver en la lista:
```
✓ SUPABASE_URL
✓ SUPABASE_ANON_KEY
```

### Paso 7: Espera Re-deploy

Vercel automáticamente:
- Detecta los cambios
- Inicia re-deploy
- Toma 2-5 minutos

---

## ✅ VERIFICACIÓN DESPUÉS DEL RE-DEPLOY

### 1. Espera el Deploy
- Ve a **Deployments** en Vercel
- Espera a que el deploy termine (status: ✅)

### 2. Abre tu App
```
https://result-time.vercel.app/ranking.html
```

### 3. Abre Developer Console (F12)
Busca estos mensajes:

✅ **ÉXITO:**
```
✅ Configuración cargada desde servidor
✅ Supabase inicializado exitosamente
```

❌ **ERROR (si ves esto):**
```
❌ Failed to load resource: /api/config 404
❌ No se pudo cargar configuración del servidor
```

### 4. Verifica Funcionalidad
- [x] Página de Ranking carga
- [x] Tabla de ranking visible
- [x] Sin errores en console
- [x] Conexión a Supabase exitosa

---

## 🎬 PANTALLA POR PANTALLA

### Dashboard Vercel
```
┌─────────────────────────────────────┐
│  Vercel Dashboard                   │
├─────────────────────────────────────┤
│ Projects                            │
│ ├─ result-time ← SELECCIONA ESTO   │
│ │  ├─ Deployments                  │
│ │  ├─ Settings ← VAS AQUÍ           │
│ │  │  ├─ Environment Variables ✓   │
│ │  │  │  ├─ SUPABASE_URL           │
│ │  │  │  └─ SUPABASE_ANON_KEY      │
└─────────────────────────────────────┘
```

### Environment Variables
```
┌──────────────────────────────────────┐
│ Environment Variables                │
├──────────────────────────────────────┤
│ Name          │ Value               │
├──────────────────────────────────────┤
│ SUPABASE_URL  │ https://...         │  ✓
├──────────────────────────────────────┤
│ SUPABASE_ANON │ sb_publishable_...  │  ✓
├──────────────────────────────────────┤
│ [Add Variable]                       │
└──────────────────────────────────────┘
```

---

## 📊 CHECKLIST FINAL

```
[ ] Abriste Vercel Dashboard
[ ] Seleccionaste proyecto "result-time"
[ ] Fuiste a Settings → Environment Variables
[ ] Agregaste SUPABASE_URL
[ ] Agregaste SUPABASE_ANON_KEY
[ ] Ambas variables muestran "Save" completado
[ ] Esperaste 2-5 minutos
[ ] El deploy en Vercel terminó (✅)
[ ] Abriste https://result-time.vercel.app/ranking.html
[ ] Viste en console: "✅ Configuración cargada"
[ ] Sin errores de 404 o credenciales
[ ] La tabla de ranking carga correctamente
```

---

## 🚀 SI TODO FUNCIONÓ

Felicitaciones! Tu aplicación ahora:

✅ Carga credenciales de forma segura desde Vercel  
✅ Se conecta a Supabase correctamente  
✅ Muestra el ranking en tiempo real  
✅ Permite registrar atletas y tiempos  
✅ Todo en PRODUCCIÓN y FUNCIONANDO

---

## ❌ SI ALGO FALLÓ

Si ves errores en console:

1. **404 en /api/config**
   - El re-deploy aún no termina
   - Espera 5 minutos más
   - Recarga la página

2. **Credenciales no disponibles**
   - Verifica que las variables están en Settings
   - Verifica que guardaste (Save button)
   - Re-deploy manualmente

3. **CORS error**
   - El vercel.json podría necesitar actualización
   - Sigue los pasos de nuevo

---

## 📞 RESUMEN DEL FLUJO ACTUAL

```
Local Development:
  ↓
Código seguro con variables de entorno
  ↓
GitHub Push (código limpio, sin secrets)
  ↓
Vercel Settings → Variables de entorno
  ↓
Vercel Re-deploy automático
  ↓
/api/config.js obtiene variables de Vercel
  ↓
config.js en navegador obtiene credenciales
  ↓
Supabase conectado
  ↓
✅ APLICACIÓN FUNCIONANDO
```

---

**Documento Creado:** 2026-04-10  
**Estado:** Listo para configuración final  
**Tiempo estimado:** 5 minutos (más 3-5 de re-deploy)
