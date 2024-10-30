const path = require('path');
const XLSX = require('xlsx');

import Product from "../models/product";

class AdminController {

    async uploadExcelSheet(req, res) {
        try {
            const { schematype } = req.query;

            if (!req.file) {
                return res.status(400).json({ message: 'No file uploaded' });
            }

            console.log(schematype, req.file);
            const excelSheetData = readExcelSheetFromFromPath(req.file.path);
            await processExcelSheetData(excelSheetData);

            res.status(201).send({ message: "Excel sheet uploaded successfully" })
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error })
        }
    }

    async getProducts(req, res) {
        try {
            const products = await Product.find({});

            console.log(products);
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error })
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

async function processExcelSheetData(excelSheetData) {
    for (const index in excelSheetData) {
        const productData = new Product({ data: excelSheetData[index] });

        await productData.save();
    }
}

