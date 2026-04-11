// Configuración central de Supabase - Cargada de forma segura desde servidor/variables de entorno

async function initializeSupabaseConfig() {
    try {
        // Intentar cargar credenciales desde el servidor (método seguro)
        const response = await fetch('/api/config');
        if (response.ok) {
            const config = await response.json();
            window.SUPABASE_URL = config.supabaseUrl;
            window.SUPABASE_ANON_KEY = config.supabaseAnonKey;
            console.log("✅ Configuración cargada desde servidor");
        } else {
            throw new Error('No se pudo cargar configuración del servidor');
        }
    } catch (error) {
        console.error("⚠️ No se pudo cargar config del servidor:", error);
        // Fallback: usar variables de entorno globales si están disponibles
        window.SUPABASE_URL = window.SUPABASE_URL || "";
        window.SUPABASE_ANON_KEY = window.SUPABASE_ANON_KEY || "";
    }

    // Lógica de detección de ambiente
    if (window.location.hostname === 'localhost' && window.location.port === '3006') {
        console.log("🛠️ EJECUTANDO EN AMBIENTE LOCAL - Usando API Local");
        window.dataSource = 'local';
        window.apiBaseUrl = `http://${window.location.host}`;
    } else {
        console.log("🌐 EJECUTANDO EN MODO PRODUCCIÓN - Usando Supabase");
        window.dataSource = 'supabase';
    }

    // Inicializar cliente de Supabase
    if (window.supabase && window.SUPABASE_URL && window.SUPABASE_ANON_KEY) {
        window.supabaseClient = window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY);
        console.log("✅ Supabase inicializado exitosamente");
    } else {
        console.error("❌ Supabase JS Library no encontrada o credenciales no disponibles");
    }
}

// Inicializar cuando el documento esté listo
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeSupabaseConfig);
} else {
    initializeSupabaseConfig();
}
