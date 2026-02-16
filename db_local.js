const { Pool } = require('pg');

// Configuración de la base de datos local
const dbConfig = {
    user: 'postgres',           // Tu usuario de PostgreSQL
    host: 'localhost',          // Servidor local
    database: 'resultados_deportivos', // Nombre de la BD
    password: 'giobdpost01*',           // CAMBIAR POR TU CONTRASEÑA
    port: 5432,                 // Puerto por defecto
};

const pool = new Pool(dbConfig);

module.exports = {
    query: (text, params) => pool.query(text, params),
    pool
};
