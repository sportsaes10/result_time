# 📡 MCP Vercel - Guía de Uso

**Estado:** ✅ Configurado y listo para usar  
**Ubicación:** `.claude/.mcp.json`  
**URL:** `https://mcp.vercel.com/mcp`

---

## 🎯 ¿Qué es el MCP de Vercel?

El Model Context Protocol (MCP) de Vercel permite a Claude interactuar con tu proyecto de Vercel sin necesidad de ir al dashboard manualmente.

**Ventajas:**
- ✅ Configurar variables de entorno desde Claude
- ✅ Ver estado de deployments
- ✅ Revisar logs en tiempo real
- ✅ Automatizar procesos de Vercel

---

## 📋 Comandos Disponibles

### 1. **Listar Proyectos**
```
Busca tus proyectos de Vercel configurados
```

### 2. **Ver Variables de Entorno**
```
Obtén lista de variables configuradas en un proyecto
```

### 3. **Agregar/Actualizar Variables**
```
Crea o modifica variables de entorno sin ir al dashboard
```

### 4. **Ver Deployments**
```
Consulta el historial de deployments y su estado
```

### 5. **Ver Logs**
```
Lee los logs del último deployment
```

---

## 🔐 Autenticación Requerida

Para que el MCP funcione, necesitas:

### Opción 1: Token de Vercel en Archivo Local (Recomendado)

**Crear archivo:** `.vercel-token` en la raíz del proyecto
```
tu_token_aqui
```

**⚠️ IMPORTANTE:** Este archivo debe estar en `.gitignore`

### Opción 2: Variable de Entorno

```bash
export VERCEL_TOKEN=tu_token_aqui
```

---

## 📍 Cómo Obtener tu Token de Vercel

1. **Ve a:** https://vercel.com/account/tokens
2. **Crea nuevo token:**
   - Nombre: `Claude Code`
   - Scope: `Full Access` (si lo requiere)
   - Expiration: `No expiration` o la que prefieras
3. **Copia el token** (solo aparecerá una vez)
4. **Pégalo en archivo `.vercel-token`**

---

## 🚀 Ejemplo de Uso

### Configurar Variables de Entorno con MCP

Una vez autenticado, puedo hacer:

```
Claude: "Configura las siguientes variables en el proyecto result-time de Vercel:
- SUPABASE_URL = https://xqppzsyhvlvoowmdgsdm.supabase.co
- SUPABASE_ANON_KEY = sb_publishable_uGEesrlmccscFr5k5fBjtg_yaG0pERt"
```

**Resultado:**
- ✅ Variables configuradas automáticamente
- ✅ Vercel inicia re-deploy
- ✅ Sin necesidad de ir al dashboard

---

## 🔧 Setup Actual

### Paso 1: Obtener Token
1. Abre https://vercel.com/account/tokens
2. Crea nuevo token
3. Copia el valor

### Paso 2: Guardar Token Localmente
```bash
# En la raíz del proyecto
echo "tu_token_aqui" > .vercel-token
```

### Paso 3: Actualizar .gitignore
```bash
# Verificar que está en .gitignore
cat .gitignore | grep vercel-token
```

Si NO está, agregar:
```
.vercel-token
```

### Paso 4: Confirmación
Una vez hecho esto, avísale a Claude que el token está listo y podemos:
- ✅ Configurar variables automáticamente
- ✅ Verificar estado del deployment
- ✅ Ver logs en tiempo real

---

## 📊 Estado Actual

```
MCP Vercel:         ✅ CONFIGURADO
Autenticación:      ⏳ PENDIENTE (Necesita token)
Capacidades:        ✅ DISPONIBLES
¿Listo para usar?   ⏳ Cuando agregues el token
```

---

## 🎯 Próximos Pasos

1. **Obtén tu token de Vercel** (link arriba)
2. **Crea archivo `.vercel-token`** con el token
3. **Confirma a Claude** que está listo
4. **Pídeme que configure las variables** de SUPABASE

**Ejemplo:** 
```
"Claude, he creado el archivo .vercel-token con mi token de Vercel.
Configura estas variables en el proyecto result-time:
- SUPABASE_URL
- SUPABASE_ANON_KEY"
```

---

## ⚠️ Seguridad

- ✅ Token local (nunca en GitHub)
- ✅ Archivo en .gitignore
- ✅ Tokens con expiración recomendada
- ✅ Token mínimo scope recomendado

---

## 📚 Enlaces Útiles

- **Vercel Tokens:** https://vercel.com/account/tokens
- **Vercel API Docs:** https://vercel.com/docs/api
- **MCP Documentation:** https://modelcontextprotocol.io

---

**Configuración realizada:** 2026-04-10  
**Estado:** Esperando token de Vercel
