// Configuración central de Supabase
const SUPABASE_URL = "https://errhavrditdrjkuzjbic.supabase.co"; 
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVycmhhdnJkaXRkcmprdXpqYmljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEyNDI2ODMsImV4cCI6MjA4NjgxODY4M30.cC4FWrG-b0ayP_jWn3UwJ6YqIIESZhex7YZs48Macsk"; 

// En Vercel/Producción siempre usamos Supabase directo
console.log("🌐 EJECUTANDO EN MODO PRODUCCIÓN - Usando Supabase");
window.dataSource = 'supabase';

if (window.supabase) {
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    console.log("Supabase inicializado exitosamente");
} else {
    console.error("Supabase JS Library no encontrada");
}
