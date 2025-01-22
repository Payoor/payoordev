import winston from "winston";

const winstonLogger = winston.createLogger({
    format: winston.format.json(),
    transports: [
        ...(process.env.NODE_ENV !== 'production' ? [new winston.transports.Console()] : []),
        new winston.transports.Http({
            host: process.env.ERROR_SERVER_HOST || 'localhost',
            port: process.env.ERROR_SERVER_PORT || 3032,
            path: '/log',
            ssl: false,
            batch: true,
            batchCount: 10,
            batchInterval: 5000
        })
    ]
});

export default winstonLogger;