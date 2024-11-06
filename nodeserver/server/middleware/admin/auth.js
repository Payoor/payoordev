const jwt = require('jsonwebtoken');
const Admin = require('../../models/admin'); // Adjust path as needed

const authenticate = async (req, res, next) => {
    try {
        // First check if any admin exists in the system
        const adminExists = await Admin.findOne({});

        // If no admin exists, allow the request to proceed (for first admin creation)
        if (!adminExists && req.path === '/admin/create') {
            return next();
        }

        // If an admin exists, or if it's not an admin creation route,
        // proceed with normal authentication
        const token = req.header('Authorization')?.replace('Bearer ', '');

        if (!token) {
            throw new Error('No authentication token provided');
        }

        const admin = await Admin.findByToken(token);

        if (!admin) {
            throw new Error('Invalid authentication token');
        }

        req.token = token;
        req.admin = admin;
        next();
    } catch (error) {
        res.status(401).json({
            error: 'Please authenticate',
            details: error.message
        });
    }
};

// Optional: Separate middleware to check if it's the first admin
const isFirstAdmin = async (req, res, next) => {
    try {
        const adminExists = await Admin.findOne({});
        if (adminExists) {
            return res.status(403).json({
                error: 'Initial admin already exists. New admins must be created by an authenticated admin.'
            });
        }
        next();
    } catch (error) {
        res.status(500).json({ error: 'Server error while checking admin status' });
    }
};

module.exports = { authenticate, isFirstAdmin };

//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzJhZDk5MWE5MTFjMGFjZGQ0MGNiMTkiLCJhY2Nlc3MiOiJhdXRoIiwiaWF0IjoxNzMwODYxNDU3fQ.L_SlXdU_eMZwONwwqnNU9CJW-NpkHlFrgI_onGOYWA8