import winstonLogger from '../configs/winstonLogger';

const errorHandler = (err, req, res, next) => {
    winstonLogger.error('Unhandled error:', {
        error: err.message,
        stack: err.stack,
        url: req.url,
        method: req.method,
        body: req.body
    });

    const statusCode = err.statusCode || 500;
    return res.status(statusCode).json({
        error: err.payoorDevErrorMessage ? err.payoorDevErrorMessage : 'Internal Server Error',
        message: err.message
    });
};

export default errorHandler;