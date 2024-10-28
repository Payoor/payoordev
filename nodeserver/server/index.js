if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}

import "regenerator-runtime";
const express = require('express');
const app = express();
const server = require('http').createServer(app);
const mongoose = require('mongoose');
const crypto = require('crypto');
import path from 'path';
import cors from 'cors';
import bodyParser from 'body-parser';
import fs from 'fs';

import verifyToken from './services/payoor/verifyToken';

import File from './models/file';

import adminRoute from './routes/adminRoute';
import messageRoute from './routes/messageRoute';
import conversationRoute from './routes/conversationRoute';
import authRoute from './routes/authRoute';

import corsOrginArray from './corsOriginArray';
import { initSocket } from './socketInit';

const corsOptions = {
  origin: corsOrginArray,
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.json());

app.use(adminRoute);
app.use(conversationRoute);
app.use(messageRoute);
app.use(authRoute);

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    res.header('Access-Control-Allow-Methods', 'POST');
    return res.status(200).json({});
  }
  next();
});

const PORT = process.env.PORT;
const FLUTTER_WEB_APP = path.join(__dirname, '../public', 'web');
app.use(express.static(FLUTTER_WEB_APP));

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

app.get('/', (req, res) => {
  const indexPath = path.join(FLUTTER_WEB_APP, 'index.html');

  res.sendFile(indexPath);
});

const uploadDir = path.resolve(__dirname, '..', '.', 'uploads');

// Ensure the upload directory exists
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

app.post('/upload', verifyToken, (req, res) => {
  try {
    const { image, filename } = req.body;

    const { authData } = req;

    // console.log(authData._id);

    if (!image || !filename) {
      return res.status(400).send('Image and filename are required');
    }

    const fileExtension = path.extname(filename);
    const uniqueFilename = `${crypto.randomBytes(16).toString('hex')}${fileExtension}`;

    const buffer = Buffer.from(image, 'base64');
    const filePath = path.join(uploadDir, uniqueFilename);

    const fileUrl = `uploads/${uniqueFilename}`;

    fs.writeFile(filePath, buffer, async (err) => {
      if (err) {
        console.error('Error saving file:', err);
        return res.status(500).send('Error saving file');
      }

      const newFile = new File({
        uploadedBy: authData._id,
        url: fileUrl,
        filePath
      });

      try {
        await newFile.save();
        res.status(200).json({ message: 'File uploaded successfully', fileUrl });
      } catch (dbError) {
        console.error('Error saving to database:', dbError);
        res.status(500).send('Error saving file information to database');
      }
    });
  } catch (error) {
    console.log('error:', error)
  }
});

server.listen(PORT, (error) => {
  if (error) {
    return console.error('Error starting server:', error);
  }

  console.log(`Server started on port ${PORT}`);
});

initSocket(server);

mongoose.connect(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
  .then(() => {
    console.log(`database connection on ${process.env.MONGO_URL}`)
  })
  .catch((error) => {
    console.error('Error connecting to MongoDB:', error);
  });