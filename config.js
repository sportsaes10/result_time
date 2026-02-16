// Configuración central de Supabase
const SUPABASE_URL = "https://xqppzsyhvlvoowmdgsdm.supabase.co"; 
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxcHB6c3lodmx2b293bWRnc2RtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5OTA3MzQsImV4cCI6MjA4NjU2NjczNH0.gqUAVfeOa9-yaGVFKNZQ6CaVd-IRuui88bH86NYYZVQ"; 

// En Vercel/Producción siempre usamos Supabase directo
console.log("🌐 EJECUTANDO EN MODO PRODUCCIÓN - Usando Supabase");
window.dataSource = 'supabase';

if (window.supabase) {
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    console.log("Supabase inicializado exitosamente");
} else {
    console.error("Supabase JS Library no encontrada");
}
