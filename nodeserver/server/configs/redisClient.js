const { createClient } = require('redis');

const redisClient = createClient({
    url: process.env.REDIS_URL,
    socket: {
        reconnectStrategy: (retries) => {
            if (retries > 10) {
                console.log('Too many retries on Redis. Moving on.');
                return new Error('Too many retries on Redis');
            }
            return Math.min(retries * 50, 1000);
        }
    }
});

redisClient.on('connect', () => {
    console.log('Redis client connected');
});

redisClient.on('error', (err) => {
    console.error('Redis Client Error:', err);
});

redisClient.on('reconnecting', () => {
    console.log('Redis client reconnecting');
});

redisClient.on('ready', () => {
    console.log('Redis client is ready');
});

redisClient.connect().then(() => {
    console.log('Connected to Redis');
}).catch((err) => {
    console.error('Redis Client Error:', err);
});

export default redisClient;