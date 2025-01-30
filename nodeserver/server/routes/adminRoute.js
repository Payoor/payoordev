import express from 'express';
import multer from "multer";
import fs from "fs";

import AdminController from "../controllers/adminController";
import OrderController from '../controllers/orderController';
import verifyToken from '../services/payoor/verifyToken';

const { authenticate, isFirstAdmin } = require('../services/payoor/admin/auth');

const adminRoute = express();

function uploadFileWithMulter(storagepath = null) {
    if (!storagepath) {
        // Use memory storage if no path provided
        return multer({ storage: multer.memoryStorage() });
    }

    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
            if (!fs.existsSync(storagepath)) {
                fs.mkdirSync(storagepath, { recursive: true });
            }
            cb(null, storagepath);
        },
        filename: (req, file, cb) => {
            cb(null, `${Date.now()}-${file.originalname}`);
        }
    });

    return multer({ storage: storage });
}

adminRoute.post('/admin/create', authenticate, AdminController.createAdmin);

adminRoute.post('/admin/initialize', isFirstAdmin, AdminController.createAdmin);

adminRoute.delete('/admin/:adminId', authenticate, AdminController.deleteAdmin);

adminRoute.get('/admins', authenticate, AdminController.getAllAdmins);

adminRoute.post('/admin/login', AdminController.signInAdmin);

adminRoute.post('/admin/upload/products/excel', authenticate, uploadFileWithMulter("files/excel").single('file'), AdminController.uploadExcelSheet);

adminRoute.get('/admin/get/products', authenticate, AdminController.getProducts);

adminRoute.post('/admin/create/product', authenticate, AdminController.addProduct);

adminRoute.post('/admin/add/product-variant', authenticate, AdminController.addProductVariants);

adminRoute.get('/admin/get/product', authenticate, AdminController.getProduct);

adminRoute.patch('/admin/update/product', authenticate, AdminController.updateProduct);

adminRoute.delete('/admin/delete/product', authenticate, AdminController.deleteProduct);

adminRoute.delete('/admin/delete/product-variant', authenticate, AdminController.deleteProductVariant);

adminRoute.delete('/admin/delete/all/products', authenticate, AdminController.deleteAllProducts);

adminRoute.post('/admin/upload/product/image', authenticate, uploadFileWithMulter().single('file'), AdminController.uploadProductImage);

adminRoute.get('/admin/product/images', authenticate, AdminController.getProductImages);

adminRoute.delete('/admin/product/image', authenticate, AdminController.deleteProductImage);

adminRoute.get('/admin/get/users', authenticate, AdminController.getUsers);

adminRoute.get('/admin/get/user', authenticate, AdminController.getUser);

adminRoute.delete('/admin/delete/user/', authenticate, AdminController.deleteOneUser);

adminRoute.get('/admin/get/orders', authenticate, AdminController.getOrders);

adminRoute.get('/admin/get/user-orders', authenticate, AdminController.getUserOrders);

adminRoute.get('/admin/get/order', authenticate, AdminController.getOrder);

adminRoute.get('/admin/get/transactions', authenticate, AdminController.getTransactions);

adminRoute.get('/admin/get/user-transactions', authenticate, AdminController.getUserTransactions);

adminRoute.get('/admin/get/transaction', authenticate, AdminController.getTransaction);

adminRoute.get('/admin/get/transaction-and-order-details', verifyToken, AdminController.getTransactionStatusAndOrderDetails);

adminRoute.get('/admin/get/dashboard-stats', authenticate, AdminController.getDashboardAggregateData);

export default adminRoute;
