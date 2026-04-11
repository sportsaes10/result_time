// Configuración central de Supabase
const SUPABASE_URL = "https://xqppzsyhvlvoowmdgsdm.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_uGEesrlmccscFr5k5fBjtg_yaG0pERt"; 

// Lógica de detección de ambiente para pruebas
if (window.location.hostname === 'localhost' && window.location.port === '3006') {
    console.log("🛠️ EJECUTANDO EN AMBIENTE LOCAL - Usando API Local");
    window.dataSource = 'local';
    window.apiBaseUrl = `http://${window.location.host}`;
} else {
    console.log("🌐 EJECUTANDO EN MODO PRODUCCIÓN - Usando Supabase");
    window.dataSource = 'supabase';
}

if (window.supabase) {
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    console.log("Supabase inicializado exitosamente");
} else {
    console.error("Supabase JS Library no encontrada");
}
