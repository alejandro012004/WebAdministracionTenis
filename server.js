const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// La carpeta generada por flutter build web
const buildPath = path.join(__dirname, 'build', 'web');

// Middleware para servir archivos estáticos
app.use(express.static(buildPath));

// Middleware para manejar el historial de routing (necesario por GoRouter)
app.get('*', (req, res) => {
  res.sendFile(path.join(buildPath, 'index.html'));
});

app.listen(port, () => {
  console.log(`Servidor de Flutter Web corriendo en el puerto ${port}`);
});