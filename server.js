// server.js - Servidor HTTP simple para desarrollo local
// Ejecutar con: node server.js

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

// Cargar variables de entorno si existen
require('dotenv').config();

const PORT = 3006;

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
    console.log(`${req.method} ${req.url}`);

    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Endpoint seguro para obtener configuración de Supabase desde variables de entorno
    if (req.url === '/api/config' && req.method === 'GET') {
        const config = {
            supabaseUrl: process.env.SUPABASE_URL,
            supabaseAnonKey: process.env.SUPABASE_ANON_KEY
        };
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(config), 'utf-8');
        return;
    }

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    let filePath = '.' + req.url;
    if (filePath === './') {
        filePath = './athletes.html';
    }

    const extname = String(path.extname(filePath)).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404, { 'Content-Type': 'text/html' });
                res.end('<h1>404 - Archivo no encontrado</h1>', 'utf-8');
            } else {
                res.writeHead(500);
                res.end('Error del servidor: ' + error.code, 'utf-8');
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(PORT, () => {
    console.log(`\n🚀 Servidor corriendo en http://localhost:${PORT}`);
    console.log(`\nPáginas disponibles:`);
    console.log(`  - http://localhost:${PORT}/athletes.html`);
    console.log(`  - http://localhost:${PORT}/results.html`);
    console.log(`  - http://localhost:${PORT}/ranking.html`);
    console.log(`\nPresiona Ctrl+C para detener el servidor\n`);
});
