const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Ruta a la carpeta de archivos estáticos de Flutter
const buildPath = path.join(__dirname, 'build', 'web');

// 1. MIDDLEWARE: Servir todos los archivos estáticos de la carpeta 'build/web'
// Express busca aquí primero (ej: index.html, main.dart.js, assets/...)
app.use(express.static(buildPath));

// 2. FALLBACK: Para CUALQUIER otra petición que no haya sido un archivo estático
// y es manejada por el router de Flutter (GoRouter).
// Usamos el parámetro nombrado 'path' seguido de un comodín '?' para capturar todas las rutas.
// Esto es compatible con las reglas estrictas de path-to-regexp.
app.get('/*', (req, res) => {
    // Si la ruta solicitada no se encontró en express.static, asumimos que es una ruta de Flutter,
    // y enviamos el index.html para que GoRouter se encargue de cargar la vista correcta.
    res.sendFile(path.join(buildPath, 'index.html'));
});


app.listen(port, () => {
  console.log(`Servidor de Flutter Web corriendo en el puerto ${port}`);
});