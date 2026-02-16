// Configuración central de Supabase
// IMPORTANTE: Reemplaza los valores con tus credenciales reales

const SUPABASE_URL = "https://xqppzsyhvlvoowmdgsdm.supabase.co"; // Ej: https://xyz.supabase.co
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxcHB6c3lodmx2b293bWRnc2RtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5OTA3MzQsImV4cCI6MjA4NjU2NjczNH0.gqUAVfeOa9-yaGVFKNZQ6CaVd-IRuui88bH86NYYZVQ"; // Ej: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

// Detectar entorno
const IS_LOCAL = window.location.hostname === 'localhost' ||
                 window.location.hostname === '127.0.0.1';

// Usar configuración según entorno
if (IS_LOCAL) {
    console.log('🚀 EJECUTANDO EN MODO LOCAL - Forzando uso de Supabase');
    window.dataSource = 'supabase';
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    console.log("Supabase inicializado exitosamente en modo local");
} else {
    console.log('Modo PRODUCCIÓN - Usando Supabase');
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
