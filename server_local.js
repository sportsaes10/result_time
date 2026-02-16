const http = require('http');
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');

const PORT = 3005;

// Configuración de la base de datos local (Ajustar contraseña si es necesario)
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'resultados_deportivos',
    password: 'giobdpost01*',           // CAMBIAR POR TU CONTRASEÑA
    port: 5432,
});

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

const server = http.createServer(async (req, res) => {
    console.log(`${req.method} ${req.url}`);

    // Endpoint API para obtener atletas localmente
    if (req.url === '/api/get-athletes' && req.method === 'GET') {
        try {
            const result = await pool.query('SELECT * FROM atletas ORDER BY dorsal');
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(result.rows));
            return;
        } catch (err) {
            console.error(err);
            res.writeHead(500);
            res.end(JSON.stringify({ error: 'Error en la base de datos local' }));
            return;
        }
    }

    // Endpoint API para obtener ranking localmente
    if (req.url === '/api/get-ranking' && req.method === 'GET') {
        try {
            const result = await pool.query('SELECT * FROM v_ranking_completo');
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(result.rows));
            return;
        } catch (err) {
            console.error(err);
            res.writeHead(500);
            res.end(JSON.stringify({ error: 'Error en la base de datos local' }));
            return;
        }
    }

    // Servir archivos estáticos
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
    console.log(`\n🚀 Servidor LOCAL corriendo en http://localhost:${PORT}`);
    console.log(`\nModo: Puente PostgreSQL Local activado`);
    console.log(`\nPáginas disponibles:`);
    console.log(`  - http://localhost:${PORT}/athletes.html`);
    console.log(`  - http://localhost:${PORT}/results.html`);
    console.log(`  - http://localhost:${PORT}/ranking.html`);
    console.log(`\nAPI Endpoints:`);
    console.log(`  - http://localhost:${PORT}/api/get-athletes`);
    console.log(`  - http://localhost:${PORT}/api/get-ranking`);
    console.log(`\nPresiona Ctrl+C para detener el servidor\n`);
});
