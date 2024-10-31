const path = require('path');
const XLSX = require('xlsx');

import Product from "../models/product";
import Image from "../models/image";

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const { S3Client, PutObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');

const s3Client = new S3Client({
    region: process.env.AWSS3REGION,
    credentials: {
        accessKeyId: process.env.AWSACCESSKEY,
        secretAccessKey: process.env.AWSSECRETACCESSKEY
    }
});

/**
 * @param {string} bucketName - The name of the S3 bucket
 * @param {string} filePath - Local path of the file to upload
 * @param {string} key - The key (path) where the file will be stored in S3
 */

class AdminController {

    async uploadExcelSheet(req, res) {
        try {
            if (!req.file) {
                return res.status(400).json({ message: 'No file uploaded' });
            }

            const filepath = req.file.path;
            const excelSheetData = readExcelSheetFromFromPath(req.file.path);
            await processExcelSheetData(excelSheetData, filepath);

            res.status(200).send({ message: "Excel sheet uploaded successfully" });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error })
        }
    }

    async getProducts(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;

            const skip = (page - 1) * limit;

            const products = await Product.find().skip(skip).limit(limit).lean();
            const formattedProducts = products.map(({ _id, data }) => ({ _id, ...data }));

            const totalCount = await Product.countDocuments();

            res.status(200).send({
                message: "Products retrieved",
                page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount,
                products: formattedProducts
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getProduct(req, res) {
        try {
            const { id } = req.query;

            if (!id) {
                return res.status(400).send({ message: "Product ID is required" });
            }

            const product = await Product.findById(id).lean(); // Use lean() for a plain JavaScript object

            if (!product) {
                return res.status(404).send({ message: "Product not found" });
            }

            const { _id, data, images } = product;

            res.status(200).send({ _id, ...data, images });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }


    async updateProduct(req, res) {
        try {
            const { id } = req.query;
            const updateData = req.body;
            const options = { new: true };

            if (typeof updateData !== 'object' || Array.isArray(updateData)) {
                return res.status(400).send({ message: "Invalid update data provided" });
            }

            const updatedProduct = await Product.findByIdAndUpdate(
                id,
                { $set: { data: updateData } },
                options
            ).lean();

            if (!updatedProduct) {
                return res.status(404).send({ message: "Product not found" });
            }

            const formattedProduct = { _id: updatedProduct._id, ...updatedProduct.data };

            res.status(200).send({ message: "Product updated", product: formattedProduct });

        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async deleteProduct(req, res) {
        try {
            const { id } = req.query;

            if (!id) {
                return res.status(400).send({ message: "Product ID is required" });
            }

            const deletedProduct = await Product.findByIdAndDelete(id).lean();

            if (!deletedProduct) {
                return res.status(404).send({ message: "Product not found" });
            }

            res.status(200).send({ message: "Product deleted successfully", product: deletedProduct });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async uploadProductImage(req, res) {
        try {
            if (!req.file) {
                return res.status(400).json({ error: 'No file uploaded' });
            }

            const { id } = req.query;

            const file = req.file;
            const fileName = generateUniqueFileName(file.originalname);

            const uploadParams = {
                Bucket: 'payoorimages',
                Key: `products/${fileName}`,
                Body: file.buffer,
                ContentType: file.mimetype
            };

            const command = new PutObjectCommand(uploadParams);
            const s3Response = await s3Client.send(command);

            const imageUrl = `https://payoorimages.s3.ap-southeast-2.amazonaws.com/products/${fileName}`;

            const image = new Image({
                imageUrl,
                product: id
            });

            await image.save();

            res.status(200).send({ message: "product image uploaded successfully", image });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getProductImages(req, res) {
        try {
            const { id } = req.query;

            const images = await Image.find({ product: id });

            res.status(200).send({ message: "images found", images, total: images.length });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async deleteProductImage(req, res) {
        try {
            const { id } = req.query;

            if (!id) {
                return res.status(400).json({ message: 'Image ID is required' });
            }

            const image = await Image.findOne({ _id: id });

            if (!image) {
                return res.status(404).json({ message: 'Image not found' });
            }

            const key = image.imageUrl.split('.com/').pop();

            const deleteCommand = new DeleteObjectCommand({
                Bucket: 'payoorimages',
                Key: key
            });

            await s3Client.send(deleteCommand);

            await Image.findOneAndDelete({ _id: id });

            res.status(200).json({
                message: 'Image deleted successfully',
                deletedImage: image
            });

        } catch (error) {
            console.log(error);

            if (error.name === 'CastError') {
                return res.status(400).json({ message: 'Invalid image ID format' });
            }

            if (error.$metadata?.httpStatusCode) {
                return res.status(error.$metadata.httpStatusCode).json({
                    message: 'Error deleting image from storage',
                    error: error.message
                });
            }


            res.status(500).send({
                message: 'Error deleting image',
                error: error.message
            });
        }
    }
}

export default new AdminController();

function readExcelSheetFromFromPath(filepath) {
    const filePath = path.resolve(filepath);
    const workbook = XLSX.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const excelSheetData = XLSX.utils.sheet_to_json(worksheet);

    return excelSheetData;
}

async function processExcelSheetData(excelSheetData, filepath) {
    for (const index in excelSheetData) {
        const productData = new Product({ filepath, data: excelSheetData[index] });

        await productData.save();
    }
}

const generateUniqueFileName = (originalname) => {
    const timestamp = Date.now();
    const extension = originalname.split('.').pop();
    return `${timestamp}-${Math.random().toString(36).substring(2, 15)}.${extension}`;
};

