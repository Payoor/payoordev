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


export default adminRoute;