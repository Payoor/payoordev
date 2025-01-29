// 1. Environment and imports
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}

import "regenerator-runtime";
import path from 'path';
import cors from 'cors';
import bodyParser from 'body-parser';
import fs from 'fs';

const express = require('express');
const app = express();
const server = require('http').createServer(app);
const mongoose = require('mongoose');
const crypto = require('crypto');

// 2. Import models
import File from './models/file';
import Product from './models/product';

// 3. Import routes
import adminRoute from './routes/adminRoute';
import messageRoute from './routes/messageRoute';
import conversationRoute from './routes/conversationRoute';
import authRoute from './routes/authRoute';
import paymentRoute from './routes/paymentRoute';
import orderRoute from './routes/orderRoute';
import transactionRoute from './routes/transactionRoute';

// 4. Import middleware and services
import verifyToken from './services/payoor/verifyToken';
import corsOriginArray from './corsOriginArray';
import { initSocket } from './services/payoor/chatWithAdminSocketInit';
import errorHandler from './middleware/errorHandler';
import requestLogger from './middleware/requestLogger';

// 5. Constants and configurations
const PORT = process.env.PORT;
const uploadDir = path.resolve(__dirname, '..', '.', 'uploads');

// 6. Ensure upload directory exists
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

console.log(process.env.NODE_ENV)

const corsOptions = {
  origin: function (origin, callback) {
    console.log("Origin attempting to connect:", origin);
    const allowedOrigins = process.env.NODE_ENV === 'production'
      ? corsOriginArray.production
      : corsOriginArray.development;

    if (!origin || allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      console.log("Origin rejected:", origin);
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['POST', 'OPTIONS', 'GET', 'PATCH', 'DELETE'],
  credentials: true,
  allowedHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept', 'Authorization']
};

app.use(cors(corsOptions));

// 8. Global middleware (order matters!)
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({
  limit: '1mb',
  extended: true,
  type: (req) => {
    return !req.headers['content-type']?.includes('multipart/form-data');
  }
}));
app.use(requestLogger);

// 9. Routes
app.use(adminRoute);
app.use(conversationRoute);
app.use(messageRoute);
app.use(authRoute);
app.use(paymentRoute);
app.use(orderRoute);
app.use(transactionRoute);

// 10. File upload route
app.post('/upload', verifyToken, async (req, res) => {
  try {
    const { image, filename } = req.body;
    const { authData } = req;

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
    console.log('error:', error);
    res.status(500).send('Server error');
  }
});

// 11. Error handling middleware (should be last)
app.use(errorHandler);

// 12. Database utilities
async function dropIndex(indexName) {
  try {
    await Product.collection.dropIndex(indexName);
    console.log(`Index ${indexName} dropped successfully`);
  } catch (err) {
    console.error(`Error dropping index ${indexName}:`, err);
  }
}

// 13. Database connection
mongoose.connect(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
  .then(() => {
    console.log(`database connection on ${process.env.MONGO_URL}`);
    // dropIndex('filepath_1');
  })
  .catch((error) => {
    console.error('Error connecting to MongoDB:', error);
  });

// 14. Start server
server.listen(PORT, (error) => {
  if (error) {
    return console.error('Error starting server:', error);
  }
  console.log(`Server started on port ${PORT}`);
});

// 15. Initialize WebSocket
initSocket(server);