import express from 'express';
import multer from "multer";

import AdminController from "../controllers/adminController";

const adminRoute = express();

function uploadFileWithMulter(storagepath) {
    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
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


export default adminRoute;