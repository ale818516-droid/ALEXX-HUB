const express = require('express');
const app = express();

app.get('/', (req, res) => {
    // Cambia "tu_clave_secreta" por la contraseña o token que quieras usar
    const claveSecreta = req.query.key;
    const tokenValido = "tu_clave_secreta";

    // Si no ponen la clave correcta en el enlace, muestra el mensaje de acceso denegado
    if (claveSecreta !== tokenValido) {
        return res.send(`
            <!DOCTYPE html>
            <html>
            <head>
                <title>Acceso</title>
                <style>
                    body { background-color: #ffffff; font-family: monospace; padding: 5px; }
                    .denegado { font-size: 11px; color: #000000; }
                </style>
            </head>
            <body>
                <div class="denegado">-- ACCESO DENEGADO</div>
            </body>
            </html>
        `);
    }

    // Si la clave es correcta, aquí puedes mostrar tu contenido protegido o tu carga
    res.send('¡Bienvenido! Aquí va tu contenido protegido.');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
});
