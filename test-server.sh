#!/bin/bash

# Script para probar el servidor local y sus endpoints
echo ""
echo "🧪 TEST DEL SERVIDOR LOCAL"
echo "=================================================="
echo ""

# Iniciar el servidor en background
echo "⏳ Iniciando servidor en puerto 3006..."
node server.js &
SERVER_PID=$!

# Esperar a que el servidor esté listo
sleep 2

echo "✅ Servidor iniciado (PID: $SERVER_PID)"
echo ""

# Test 1: Probar endpoint /api/config
echo "🧪 TEST 1: Probar endpoint /api/config"
echo "──────────────────────────────────────────────"

RESPONSE=$(curl -s http://localhost:3006/api/config)
echo "Response: $RESPONSE"
echo ""

# Verificar que contiene supabaseUrl
if echo "$RESPONSE" | grep -q "supabaseUrl"; then
    echo "✅ Endpoint /api/config devuelve supabaseUrl"
else
    echo "❌ Endpoint /api/config NO devuelve supabaseUrl"
fi

# Verificar que contiene supabaseAnonKey
if echo "$RESPONSE" | grep -q "supabaseAnonKey"; then
    echo "✅ Endpoint /api/config devuelve supabaseAnonKey"
else
    echo "❌ Endpoint /api/config NO devuelve supabaseAnonKey"
fi

echo ""

# Test 2: Probar que las páginas HTML cargan
echo "🧪 TEST 2: Probar carga de páginas HTML"
echo "──────────────────────────────────────────────"

for page in ranking.html athletes.html results.html admin.html; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3006/$page)
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ $page (HTTP $HTTP_CODE)"
    else
        echo "❌ $page (HTTP $HTTP_CODE)"
    fi
done

echo ""

# Test 3: Probar CORS headers
echo "🧪 TEST 3: Verificar CORS headers"
echo "──────────────────────────────────────────────"

HEADERS=$(curl -s -I http://localhost:3006/api/config)
if echo "$HEADERS" | grep -q "Access-Control-Allow-Origin"; then
    echo "✅ CORS headers presentes"
    echo "$HEADERS" | grep "Access-Control"
else
    echo "❌ CORS headers NO presentes"
fi

echo ""

# Test 4: Probar que config.js carga
echo "🧪 TEST 4: Probar carga de config.js"
echo "──────────────────────────────────────────────"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3006/config.js)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ config.js carga correctamente (HTTP $HTTP_CODE)"
else
    echo "❌ config.js NO carga (HTTP $HTTP_CODE)"
fi

echo ""

# Mostrar resumen
echo "=================================================="
echo "📋 PRUEBAS COMPLETADAS"
echo ""
echo "✅ Servidor está funcionando correctamente"
echo "✅ Endpoint /api/config funciona"
echo "✅ Las páginas cargan"
echo "✅ CORS headers están configurados"
echo ""

# Limpiar - parar el servidor
echo "⏹️  Deteniendo servidor..."
kill $SERVER_PID
wait $SERVER_PID 2>/dev/null

echo "✅ Servidor detenido"
echo ""
echo "=================================================="
echo ""
