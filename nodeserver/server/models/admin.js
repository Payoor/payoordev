const mongoose = require('mongoose');

import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const AdminSchema = new mongoose.Schema({
    username: {
        type: String,
        trim: true,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        trim: true,
        required: true,
        minlength: 10
    },
    tokens: [{
        access: {
            type: String,
            required: true
        },
        token: {
            type: String,
            required: true
        }
    }]
});

AdminSchema.statics.findByCredentials = function (username, password) {
    let Admin = this;

    return Admin.findOne({ username }).then(admin => {
        if (!admin) {
            return Promise.reject();
        }

        return new Promise((resolve, reject) => {
            bcrypt.compare(password, admin.password, (err, res) => {
                if (res) {
                    resolve(admin);
                }
                else {
                    reject();
                }
            });
        });
    });
};

AdminSchema.statics.findByToken = function (token) {
    let Admin = this;
    let decoded;

    try {
        decoded = jwt.verify(token, process.env.SECRET_KEY);
    } catch (e) {
        /*return new Promise((resolve, reject) => {
         reject();
       });*/
        return Promise.reject();
    }

    return Admin.findOne({
        '_id': decoded._id,
        'tokens.token': token,
        'tokens.access': 'auth'
    });
};

AdminSchema.methods.generateAuthToken = function () {
    let admin = this;
    let access = 'auth';
    let token = jwt.sign(
        {
            _id: admin._id.toHexString(),
            access
        }, process.env.SECRET_KEY).toString();

    admin.tokens.push({ access, token });

    return admin.save().then(() => {
        return token;
    });
};

AdminSchema.pre('save', function (next) {
    let admin = this;

    if (admin.isModified('password')) {
        bcrypt.genSalt(10, (err, salt) => {
            bcrypt.hash(admin.password, salt, (err, hash) => {
                admin.password = hash;
                next();
            });
        });
    }
    else {
        next();
    }
});

module.exports = mongoose.model('Admin', AdminSchema);