if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

import "regenerator-runtime";
const express = require('express');
const Redis = require('redis');
const mongoose = require('mongoose');

const ErrorLogNode = require('./models/ErrorLogNode');
const ErrorLogFlask = require('./models/ErrorLogFlask');

const redisClient = Redis.createClient({
    url: process.env.REDIS_URL
});

redisClient.connect().then(() => {
    console.log('Connected to Redis');
}).catch((err) => {
    console.error('Redis Client Error:', err);
});

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


const app = express();

app.use(express.json({ limit: '1mb' }));

app.post('/log/node', async (req, res) => {
    const logData = req.body;

    try {
        await redisClient.set(`error:${Date.now()}`, JSON.stringify(logData));

        await ErrorLogNode.create(logData);

        res.sendStatus(200);
    } catch (error) {
        console.error('Failed to store error log:', error);
        res.sendStatus(500);
    }
});

app.post('/log/flask', async (req, res) => {
    const logData = req.body;

    try {
        await redisClient.set(`error:${Date.now()}`, JSON.stringify(logData));

        await ErrorLogFlask.create(logData);

        res.sendStatus(200);
    } catch (error) {
        console.error('Failed to store error log:', error);
        res.sendStatus(500);
    }
});

app.get('/logs/mongo', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const skip = (page - 1) * limit;

        const logs = await ErrorLogNode.find()
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit);

        const total = await ErrorLogNode.countDocuments();

        res.json({
            logs,
            currentPage: page,
            totalPages: Math.ceil(total / limit),
            totalLogs: total
        });
    } catch (error) {
        console.error('Failed to fetch MongoDB logs:', error);
        res.sendStatus(500);
    }
});

app.get('/logs/redis', async (req, res) => {
    try {
        // Get all the keys matching error:*
        const keys = await redisClient.keys('error:*');

        // Get all logs for these keys
        const logs = await Promise.all(
            keys.map(async (key) => {
                const log = await redisClient.get(key);
                return {
                    timestamp: parseInt(key.split(':')[1]),
                    ...JSON.parse(log)
                };
            })
        );

        //helps us sort by timestamp in descending time order, so basicalkly the most recent error first. we[ll improve later
        logs.sort((a, b) => b.timestamp - a.timestamp);

        res.json(logs);
    } catch (error) {
        console.error('Failed to fetch Redis logs:', error);
        res.sendStatus(500);
    }
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK' });
});

const PORT = process.env.PORT || 3032;

app.listen(PORT, () => {
    console.log(`Error logging server running on port ${PORT}`);
});

process.on('SIGTERM', async () => {
    console.log('SIGTERM received, shutting down gracefully');
    await redisClient.quit();
    await mongoose.connection.close();
    process.exit(0);
});