const path = require('path');
const XLSX = require('xlsx');

import Product from "../models/product";

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');
const fs = require('fs');

// Configure AWS client
const s3Client = new S3Client({
    region: 'your-region', // e.g., 'us-east-1'
    credentials: {
        accessKeyId: 'your-access-key-id',
        secretAccessKey: 'your-secret-access-key'
    }
});

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

