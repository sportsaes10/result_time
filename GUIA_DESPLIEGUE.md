# 🚀 Guía de Despliegue - Sistema de Resultados Deportivos

Esta guía te ayudará a publicar tu aplicación de forma **gratuita** en internet para que cualquiera pueda ver los resultados en vivo.

## Opción Recomendada: Vercel (Más fácil y rápido)

Vercel es excelente para sitios estáticos como este.

### Pasos:

1.  **Sube tu código a GitHub** (Si no lo has hecho):
    - Crea un repositorio en GitHub.
    - Sube todos los archivos de esta carpeta (`d:\02 APPS\08 Resultados`).

2.  **Crea una cuenta en Vercel**:
    - Ve a [vercel.com](https://vercel.com) y regístrate (puedes usar tu cuenta de GitHub).

3.  **Importar Proyecto**:
    - En el dashboard de Vercel, haz clic en **"Add New..."** -> **"Project"**.
    - Selecciona tu repositorio de GitHub.
    - Dale a **Import**.

4.  **Configuración**:
    - **Framework Preset**: Déjalo en `Other`.
    - **Build Command**: Déjalo vacío (es un sitio estático).
    - **Output Directory**: Déjalo vacío o pon `.` (punto).
    - **Environment Variables**: No necesitas configurar nada aquí porque `config.js` ya tiene las claves públicas de Supabase (son seguras de exponer).

5.  **Desplegar**:
    - Haz clic en **Deploy**.
    - ¡Listo! En unos segundos tendrás una URL tipo `tu-proyecto.vercel.app`.

---

## Opción 2: Netlify (Muy robusto)

Similar a Vercel, muy buena opción.

1.  Sube tu código a **GitHub**.
2.  Ve a [netlify.com](https://netlify.com) y regístrate.
3.  Haz clic en **"Add new site"** -> **"Import an existing project"**.
4.  Conecta con GitHub y selecciona tu repo.
5.  En **Build settings**, deja todo en blanco.
6.  Haz clic en **Deploy site**.

---

## Opción 3: GitHub Pages (Directo desde GitHub)

1.  En tu repositorio de GitHub, ve a **Settings**.
2.  En el menú lateral, busca **Pages**.
3.  En **Branch**, selecciona `main` (o `master`) y la carpeta `/root`.
4.  Haz clic en **Save**.
5.  En unos minutos, tu sitio estará en `https://tu-usuario.github.io/tu-repo/`.

> **Nota**: Si usas GitHub Pages, asegúrate de que el archivo `index.html` exista en la raíz (ya lo hemos creado).

---

## ⚠️ Importante sobre Base de Datos

Tu aplicación se conecta a **Supabase**. Asegúrate de que en Supabase (en la sección _Authentication_ -> _URL Configuration_ -> _Site URL_) agregues la URL de tu nuevo sitio desplegado (ej: `https://mi-torneo.vercel.app`) a la lista de **Redirect URLs** permitidas, aunque para lectura pública no suele ser estricto, es buena práctica.
