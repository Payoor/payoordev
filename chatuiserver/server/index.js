if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

import "regenerator-runtime";
const express = require('express');
const app = express();
const server = require('http').createServer(app);
import path from 'path';

const PORT = process.env.PORT;
const FLUTTER_WEB_APP = path.join(__dirname, '../public', 'web');
app.use(express.static(FLUTTER_WEB_APP));

app.get('/', (req, res) => {
    const indexPath = path.join(FLUTTER_WEB_APP, 'index.html');

    res.sendFile(indexPath);
});

server.listen(PORT, (error) => {
    if (error) {
        return console.error('Error starting server:', error);
    }

    console.log(`Server started on port ${PORT}`);
});