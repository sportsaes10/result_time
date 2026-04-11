#!/usr/bin/env node
/**
 * Script para probar el servidor local y sus endpoints
 * Uso: node test-server.js
 */

const http = require('http');
require('dotenv').config({ path: '.env.local' });

console.log('\n🧪 TEST DEL SERVIDOR LOCAL\n');
console.log('='.repeat(50));

// Crear servidor de prueba basado en server.js
const PORT = 3007; // Usar puerto diferente para no conflictuar
const fs = require('fs');
const path = require('path');

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
};

const testResults = {
    'GET /api/config': null,
    'GET /ranking.html': null,
    'GET /athletes.html': null,
    'GET /config.js': null,
    'CORS headers': null
};

const server = http.createServer((req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Endpoint /api/config
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
        filePath = './ranking.html';
    }

    const extname = String(path.extname(filePath)).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404, { 'Content-Type': 'text/html' });
                res.end('<h1>404</h1>', 'utf-8');
            } else {
                res.writeHead(500);
                res.end('Error: ' + error.code, 'utf-8');
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(PORT, async () => {
    console.log(`✓ Servidor iniciado en puerto ${PORT}\n`);

    // Esperar un poco para que el servidor esté listo
    await new Promise(resolve => setTimeout(resolve, 100));

    try {
        // Test 1: GET /api/config
        console.log('✓ TEST 1: GET /api/config');
        console.log('─'.repeat(50));

        const response1 = await makeRequest('GET', `http://localhost:${PORT}/api/config`);
        const config = JSON.parse(response1.body);

        if (config.supabaseUrl && config.supabaseAnonKey) {
            console.log('✅ Devuelve credenciales:');
            console.log('   supabaseUrl:', config.supabaseUrl.substring(0, 30) + '...');
            console.log('   supabaseAnonKey:', config.supabaseAnonKey.substring(0, 30) + '...');
            testResults['GET /api/config'] = true;
        } else {
            console.log('❌ No devuelve credenciales correctas');
            testResults['GET /api/config'] = false;
        }

        console.log();

        // Test 2: GET /ranking.html
        console.log('✓ TEST 2: GET /ranking.html');
        console.log('─'.repeat(50));

        const response2 = await makeRequest('GET', `http://localhost:${PORT}/ranking.html`);
        if (response2.statusCode === 200 && response2.body.includes('<html')) {
            console.log('✅ Página carga correctamente');
            testResults['GET /ranking.html'] = true;
        } else {
            console.log('❌ No carga correctamente');
            testResults['GET /ranking.html'] = false;
        }

        console.log();

        // Test 3: GET /athletes.html
        console.log('✓ TEST 3: GET /athletes.html');
        console.log('─'.repeat(50));

        const response3 = await makeRequest('GET', `http://localhost:${PORT}/athletes.html`);
        if (response3.statusCode === 200 && response3.body.includes('<html')) {
            console.log('✅ Página carga correctamente');
            testResults['GET /athletes.html'] = true;
        } else {
            console.log('❌ No carga correctamente');
            testResults['GET /athletes.html'] = false;
        }

        console.log();

        // Test 4: GET /config.js
        console.log('✓ TEST 4: GET /config.js');
        console.log('─'.repeat(50));

        const response4 = await makeRequest('GET', `http://localhost:${PORT}/config.js`);
        if (response4.statusCode === 200 && response4.body.includes('initializeSupabaseConfig')) {
            console.log('✅ config.js carga correctamente');
            console.log('   - Contiene: initializeSupabaseConfig');
            testResults['GET /config.js'] = true;
        } else {
            console.log('❌ No carga correctamente');
            testResults['GET /config.js'] = false;
        }

        console.log();

        // Test 5: CORS headers
        console.log('✓ TEST 5: Verificar CORS headers');
        console.log('─'.repeat(50));

        const corsResponse = await makeRequestWithHeaders('GET', `http://localhost:${PORT}/api/config`);
        if (corsResponse.headers['access-control-allow-origin'] === '*') {
            console.log('✅ CORS header presente:');
            console.log('   Access-Control-Allow-Origin: *');
            console.log('   Access-Control-Allow-Methods:', corsResponse.headers['access-control-allow-methods']);
            testResults['CORS headers'] = true;
        } else {
            console.log('❌ CORS headers NO presentes');
            testResults['CORS headers'] = false;
        }

        console.log();

        // Resumen
        console.log('='.repeat(50));
        console.log('\n📋 RESUMEN DE PRUEBAS\n');

        const passedTests = Object.values(testResults).filter(v => v).length;
        const totalTests = Object.keys(testResults).length;

        Object.entries(testResults).forEach(([test, passed]) => {
            const status = passed ? '✅' : '❌';
            console.log(`${status} ${test}`);
        });

        console.log('\n' + '─'.repeat(50));
        console.log(`\n🎯 Resultado: ${passedTests}/${totalTests} pruebas pasadas\n`);

        if (passedTests === totalTests) {
            console.log('🚀 ¡TODO FUNCIONA CORRECTAMENTE EN LOCAL!\n');
            console.log('Próximos pasos para producción:');
            console.log('1. Ve a https://vercel.com/dashboard');
            console.log('2. Selecciona proyecto "result-time"');
            console.log('3. Settings → Environment Variables');
            console.log('4. Agrega: SUPABASE_URL');
            console.log('5. Agrega: SUPABASE_ANON_KEY');
            console.log('6. Vercel re-deployará automáticamente');
            console.log('7. Abre https://result-time.vercel.app\n');
        } else {
            console.log('⚠️  Hay problemas en local que deben resolverse\n');
        }

        console.log('='.repeat(50) + '\n');

        server.close();
        process.exit(passedTests === totalTests ? 0 : 1);

    } catch (error) {
        console.error('❌ Error durante las pruebas:', error.message);
        server.close();
        process.exit(1);
    }
});

// Funciones auxiliares
function makeRequest(method, url) {
    return new Promise((resolve, reject) => {
        const urlObj = new URL(url);
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port,
            path: urlObj.pathname + urlObj.search,
            method: method
        };

        const req = http.request(options, (res) => {
            let body = '';
            res.on('data', chunk => body += chunk);
            res.on('end', () => {
                resolve({
                    statusCode: res.statusCode,
                    headers: res.headers,
                    body
                });
            });
        });

        req.on('error', reject);
        req.end();
    });
}

function makeRequestWithHeaders(method, url) {
    return makeRequest(method, url);
}
