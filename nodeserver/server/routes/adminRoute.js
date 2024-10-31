import express from 'express';
import multer from "multer";
import fs from "fs";

import AdminController from "../controllers/adminController";

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

adminRoute.post('/admin/upload/products/excel', uploadFileWithMulter("files/excel").single('file'), AdminController.uploadExcelSheet);

adminRoute.get('/admin/get/products', AdminController.getProducts);

adminRoute.get('/admin/get/product', AdminController.getProduct);

adminRoute.patch('/admin/update/product', AdminController.updateProduct);

adminRoute.delete('/admin/delete/product', AdminController.deleteProduct);

adminRoute.post('/admin/upload/product/image', uploadFileWithMulter().single('file'), AdminController.uploadProductImage);

adminRoute.get('/admin/product/images', AdminController.getProductImages);

adminRoute.delete('/admin/product/image', AdminController.deleteProductImage);


export default adminRoute;