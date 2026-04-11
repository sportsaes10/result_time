#!/usr/bin/env node
/**
 * Script de prueba para verificar que la configuración de Supabase funciona correctamente
 * Uso: node test-config.js
 */

require('dotenv').config({ path: '.env.local' });

console.log('\n🧪 TEST DE CONFIGURACIÓN DE SUPABASE\n');
console.log('=' .repeat(50));

// Test 1: Verificar que dotenv cargó las variables
console.log('\n✓ TEST 1: Verificar variables de entorno');
console.log('─'.repeat(50));

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

if (supabaseUrl) {
    console.log('✅ SUPABASE_URL cargada:');
    console.log('   ' + supabaseUrl.substring(0, 30) + '...');
} else {
    console.log('❌ SUPABASE_URL NO cargada');
}

if (supabaseKey) {
    console.log('✅ SUPABASE_ANON_KEY cargada:');
    console.log('   ' + supabaseKey.substring(0, 30) + '...');
} else {
    console.log('❌ SUPABASE_ANON_KEY NO cargada');
}

// Test 2: Probar el endpoint /api/config
console.log('\n✓ TEST 2: Probar endpoint /api/config');
console.log('─'.repeat(50));

const http = require('http');
const url = require('url');
const fs = require('fs');
const path = require('path');

// Simular el endpoint como lo hace server.js
const config = {
    supabaseUrl: process.env.SUPABASE_URL,
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY
};

if (config.supabaseUrl && config.supabaseAnonKey) {
    console.log('✅ Endpoint /api/config devolvería:');
    console.log('   ', JSON.stringify(config, null, 2));
} else {
    console.log('❌ No se puede servir /api/config sin credenciales');
}

// Test 3: Verificar que config.js existe
console.log('\n✓ TEST 3: Verificar archivos necesarios');
console.log('─'.repeat(50));

const requiredFiles = [
    'config.js',
    'server.js',
    '.env.local',
    '.env.example',
    'SECURITY_SETUP.md',
    'ranking.html',
    'athletes.html',
    'results.html',
    'admin.html'
];

requiredFiles.forEach(file => {
    const exists = fs.existsSync(path.join(__dirname, file));
    const status = exists ? '✅' : '❌';
    console.log(`${status} ${file}`);
});

// Test 4: Validar contenido de config.js
console.log('\n✓ TEST 4: Validar contenido de config.js');
console.log('─'.repeat(50));

const configContent = fs.readFileSync('config.js', 'utf-8');
const checks = {
    'Carga segura desde /api/config': configContent.includes("fetch('/api/config')"),
    'NO contiene credenciales hardcodeadas': !configContent.includes('sb_publishable_'),
    'Inicialización async': configContent.includes('initializeSupabaseConfig'),
    'Fallback para credenciales': configContent.includes('window.SUPABASE_URL')
};

Object.entries(checks).forEach(([check, passed]) => {
    const status = passed ? '✅' : '❌';
    console.log(`${status} ${check}`);
});

// Test 5: Validar server.js
console.log('\n✓ TEST 5: Validar server.js');
console.log('─'.repeat(50));

const serverContent = fs.readFileSync('server.js', 'utf-8');
const serverChecks = {
    'Carga dotenv': serverContent.includes("require('dotenv')"),
    'Endpoint /api/config existe': serverContent.includes("req.url === '/api/config'"),
    'Devuelve JSON': serverContent.includes('JSON.stringify(config)'),
    'CORS headers': serverContent.includes('Access-Control-Allow-Origin')
};

Object.entries(serverChecks).forEach(([check, passed]) => {
    const status = passed ? '✅' : '❌';
    console.log(`${status} ${check}`);
});

// Test 6: .gitignore verification
console.log('\n✓ TEST 6: Verificar .gitignore');
console.log('─'.repeat(50));

const gitignoreContent = fs.readFileSync('.gitignore', 'utf-8');
const gitignoreChecks = {
    '.env está en gitignore': gitignoreContent.includes('.env'),
    '.env.local está en gitignore': gitignoreContent.includes('.env.local'),
    'node_modules está en gitignore': gitignoreContent.includes('node_modules')
};

Object.entries(gitignoreChecks).forEach(([check, passed]) => {
    const status = passed ? '✅' : '❌';
    console.log(`${status} ${check}`);
});

// Resumen final
console.log('\n' + '='.repeat(50));
console.log('\n📋 RESUMEN DE PRUEBAS\n');

const allTests = {
    'Variables de entorno cargadas': !!supabaseUrl && !!supabaseKey,
    'Endpoint /api/config preparado': !!config.supabaseUrl && !!config.supabaseAnonKey,
    'Archivos necesarios existen': requiredFiles.every(f => fs.existsSync(f)),
    'config.js seguro': Object.values(checks).every(v => v),
    'server.js correcto': Object.values(serverChecks).every(v => v),
    '.gitignore correcto': Object.values(gitignoreChecks).every(v => v)
};

const passedCount = Object.values(allTests).filter(v => v).length;
const totalCount = Object.keys(allTests).length;

Object.entries(allTests).forEach(([test, passed]) => {
    const status = passed ? '✅' : '❌';
    console.log(`${status} ${test}`);
});

console.log('\n' + '─'.repeat(50));
console.log(`\n🎯 Resultado: ${passedCount}/${totalCount} pruebas pasadas\n`);

if (passedCount === totalCount) {
    console.log('🚀 ¡TODO ESTÁ LISTO PARA PRODUCCIÓN!\n');
    console.log('Próximos pasos:');
    console.log('1. Configura variables en Vercel dashboard');
    console.log('2. Espera a que Vercel re-depliegue');
    console.log('3. Prueba en https://result-time.vercel.app\n');
} else {
    console.log('⚠️  Hay problemas que necesitan atención\n');
    console.log('Revisa los test fallidos arriba.\n');
}

console.log('=' .repeat(50) + '\n');
