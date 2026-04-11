/**
 * Vercel Serverless Function - /api/config
 *
 * Endpoint seguro para servir credenciales de Supabase desde variables de entorno
 * Las variables se deben configurar en Vercel Dashboard → Environment Variables
 */

export default function handler(req, res) {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Handle OPTIONS for CORS preflight
    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    // Handle GET request
    if (req.method === 'GET') {
        // Leer credenciales desde variables de entorno
        const supabaseUrl = process.env.SUPABASE_URL;
        const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

        // Validar que las variables existan
        if (!supabaseUrl || !supabaseAnonKey) {
            console.error('❌ Variables de entorno no configuradas en Vercel');
            console.error('   SUPABASE_URL:', supabaseUrl ? '✅' : '❌');
            console.error('   SUPABASE_ANON_KEY:', supabaseAnonKey ? '✅' : '❌');

            return res.status(500).json({
                error: 'Environment variables not configured',
                message: 'SUPABASE_URL and SUPABASE_ANON_KEY must be set in Vercel Environment Variables'
            });
        }

        // Devolver credenciales de forma segura
        return res.status(200).json({
            supabaseUrl: supabaseUrl,
            supabaseAnonKey: supabaseAnonKey
        });
    }

    // Método no permitido
    return res.status(405).json({ error: 'Method not allowed' });
}
