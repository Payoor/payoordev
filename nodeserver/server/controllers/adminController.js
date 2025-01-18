const path = require('path');
const XLSX = require('xlsx');

import Product from "../models/product";
import Image from "../models/image";
import Admin from "../models/admin";
import User from "../models/user";
import Transaction from "../models/transaction";
import Order from "../models/order";
import NewProduct from "../models/newProduct";
import ProductVariant from "../models/productVariant";


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

    async deleteAllProducts(req, res) {
        try {
            const result = await Product.deleteMany({});

            if (result.deletedCount === 0) {
                return res.status(404).json({
                    success: false,
                    message: "No products found to delete"
                });
            }

            return res.status(200).json({
                success: true,
                message: `Successfully deleted ${result.deletedCount} products`,
                deletedCount: result.deletedCount
            });
        } catch (error) {
            console.error('Error in deleteAllProducts:', error);

            return res.status(500).json({
                success: false,
                message: "Error deleting products",
                error: error.message
            });
        }
    }

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

    async addProduct(req, res) {
        try {
            const productName = req.body.productName;

            if (!productName) {
                return res.status(400).json({
                    success: false,
                    message: "Product name is required."
                });
            }

            const product = new NewProduct({
                name: productName
            });
            
            await product.save();

            res.status(201).send({
                success: true,
                message: "Product created successfully!",
                product: product
            });

        } catch (error) {
            res.status(400).json({
                success: false,
                error: 'Failed to add product',
                details: error.message
            });
        }
    }

    async addProductVariants(req, res) {
        try {
            const productId = req.query.id;
            const { unit, price, isAvailable } = req.body;

            const product = await NewProduct.findById(productId);

            if (!product) {
                return res.status(404).json({
                    success: false,
                    message: "Product not found"
                })
            }

            if (!unit || !price || !isAvailable) {
                return res.status(400).json({
                    success: false,
                    message: "Values for fields (unit, price and isAvailable) are required."
                })
            }

            const productVariant = new ProductVariant({
                productId: product._id,
                unit: unit,
                price: price,
                availablility: isAvailable
            });

            await productVariant.save();

            return res.status(201).json({
                success: true,
                message: "Product variant added successfully",
                productVariant: productVariant
            });

        } catch (error) {
            res.status(400).json({
                success: false,
                error: 'Failed to add product variant',
                details: error.message
            });
        }
    }

    async getProducts(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const skip = (page - 1) * limit;
            const search = req.query.search || "";

            const query = {};
            if (search) {
                query.name = { $regex: search, $options: "i" };
            }

            const products = await NewProduct.find(query, { __v: 0 })
            .skip(skip)
            .limit(limit)
            .lean();

            const productIds = products.map((product) => product._id);

            const variants = await ProductVariant.find({
                productId: { $in: productIds },
            }, { __v: 0 }).lean();

            const productsWithVariants = products.map((product) => ({
                ...product,
                variants: variants.filter(
                    (variant) => variant.productId.toString() === product._id.toString()
                ),
            }));

            const totalCount = await NewProduct.countDocuments(query);

            res.status(200).send({
                message: "Products retrieved",
                page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount,
                products: productsWithVariants
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

            const product = await NewProduct.findById(id).lean(); // Use lean() for a plain JavaScript object

            if (!product) {
                return res.status(404).send({ message: "Product not found" });
            }

            const productVariants = await ProductVariant.find({ productId: product._id }, { _id: 0,  __v: 0, productId: 0 }).lean();

            const { _id, name, images } = product;

            res.status(200).send({ _id, name, images, variants: productVariants });

        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async updateProduct(req, res) {
        try {
            const { id } = req.query;
            const { name, generatedDescription, generatedCategories, variants } = req.body;
            const options = { new: true };

            const product = await NewProduct.findById(id, {__v: 0});
            if (!product) {
                return res.status(404).json({ 
                    success: false,
                    message: 'Product not found' 
                });
            }

            product.name = name ?? product.name;
            product.generatedDescription = generatedDescription ?? product.generatedDescription;
            product.generatedCategories = generatedCategories ?? product.generatedCategories;

            await product.save();

            for (let variantData of variants) {
                const { _id, unit, price, availability } = variantData;

                const variant = await ProductVariant.findById(_id);
                if (!variant) {
                    return res.status(404).json({ 
                        success: false,
                        message: 'Product variant not found' 
                    });
                }

                variant.unit = unit ?? unit;
                variant.price = price ?? price;
                variant.availability = availability ?? availability;

                await variant.save();
            }

            const updatedVariants = await ProductVariant.find({ productId: product._id }, { __v: 0 }).lean();

            const updatedProduct = {
                ...product.toObject(),
                variants: updatedVariants
            };

            res.status(200).json({
                message: 'Product updated',
                product: updatedProduct
            });

        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async deleteProduct(req, res) {
        try {
            const productId = req.query.id;

            const product = await NewProduct.findById(productId);
            if (!product) {
                return res.status(404).send({ message: "Product not found" });
            }

            await NewProduct.findByIdAndDelete(productId).lean();

            await ProductVariant.deleteMany({ productId });

            res.status(200).send({ message: "Product deleted successfully", product: product });

        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async deleteProductVariant(req, res) {
        try {
            const variantId = req.query.id;

            const variant = await ProductVariant.findById(variantId);
            if (!variant) {
                return res.status(404).json({ message: 'Variant not found' });
            }

            await ProductVariant.findByIdAndDelete(variantId);

            res.status(200).json({ message: 'Variant deleted successfully', variant: variant });

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

    async createAdmin(req, res) {
        try {
            const { username, password } = req.body;

            // Validate input
            if (!username || !password) {
                return res.status(400).json({ error: 'Username and password are required' });
            }

            // Check if admin already exists
            const existingAdmin = await Admin.findOne({ username });
            if (existingAdmin) {
                return res.status(400).json({ error: 'Username already exists' });
            }

            // Create new admin
            const admin = new Admin({
                username,
                password
            });

            // Save admin and generate token
            await admin.save();
            const token = await admin.generateAuthToken();

            res.status(201).json({ admin, token });
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }

    async signInAdmin(req, res) {
        try {
            const { username, password } = req.body;

            // Validate input
            if (!username || !password) {
                return res.status(400).json({ error: 'Username and password are required' });
            }

            // Find admin by credentials
            const admin = await Admin.findByCredentials(username, password);
            const token = await admin.generateAuthToken();

            res.json({ admin, token });
        } catch (error) {
            res.status(401).json({ error: 'Invalid login credentials' });
        }
    }

    async deleteAdmin(req, res) {
        try {
            const { adminId } = req.params;

            // Check if trying to delete self
            if (adminId === req.admin._id.toString()) {
                return res.status(400).json({
                    error: 'Cannot delete your own admin account'
                });
            }

            // Count total admins
            const adminCount = await Admin.countDocuments({});
            if (adminCount <= 1) {
                return res.status(400).json({
                    error: 'Cannot delete the last admin account'
                });
            }

            // Find and delete the admin
            const adminToDelete = await Admin.findById(adminId);

            if (!adminToDelete) {
                return res.status(404).json({
                    error: 'Admin not found'
                });
            }

            await Admin.findByIdAndDelete(adminId);

            res.json({
                message: 'Admin deleted successfully',
                deletedAdmin: adminToDelete.username
            });
        } catch (error) {
            res.status(400).json({
                error: 'Failed to delete admin',
                details: error.message
            });
        }
    }

    // Optional: Add a method to get all admins for reference
    async getAllAdmins(req, res) {
        try {
            const admins = await Admin.find({}, 'username _id');
            res.json(admins);
        } catch (error) {
            res.status(400).json({
                error: 'Failed to fetch admins',
                details: error.message
            });
        }
    }

    async getUsers(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;

            const skip = (page - 1) * limit;
            const search = req.query.search || "";

            const query = {};
            if (search) {
                query.name = { $regex: search, $options: "i" }
            }

            const users = await User.find(query, '_id email name phoneNumber').skip(skip).limit(limit).lean();
            const totalCount = await User.countDocuments(query);

            res.status(200).send({
                message: "Users retrieved",
                page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount,
                users: users
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getUser(req, res) {
        try {
            const { id } = req.query;

            if (!id) {
                return res.status(400).send({ message: "User ID is required" });
            }

            const user = await User.findById(id).lean();

            if (!user) {
                return res.status(404).send({ message: "User not found" });
            }

            const userResponse = {
                name: user.name,
                email: user.email,
                phoneNumber: user.phoneNumber,
                isVerified: user.isVerified,
                hasBeenWelcomed: user.hasBeenWelcomed,
            };

            const response = {
                success: true,
                data: {
                    message: 'User found',
                    user: userResponse
                }
            };

            res.status(200).send(response);

        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getTransactions(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;
            const search = req.query.search || "";
            const status = req.query.status || "";

            const query = {};
            if (status) {
                query.status = status;
            }

            if (search) {
                const initiators = await User.find(
                    { name: { $regex: search, $options: "i" } },
                    { _id: 1 }
                );
                const initiatorIds = initiators.map(user => user._id);

                if (initiatorIds.length) {
                    query.initiatorId = { $in: initiatorIds };
                }
            }

            const transactions = await Transaction.find(query, { __v: 0, updatedAt: 0 })
                .populate('initiatorId', 'name -_id')
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .lean();
            const totalCount = await Transaction.countDocuments(query);

            res.status(200).send({
                message: "Transactions retrieved",
                page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount,
                transactions: transactions
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getTransaction(req, res) {
        try {
            const transactionId = req.query.id;

            if (!transactionId) {
                return res.status(400).send({ message: "Transaction ID is required" });
            }

            const transaction = await Transaction.findById(transactionId, { __v: 0, updatedAt: 0 }).lean();

            if (!transaction) {
                return res.status(404).json({
                    success: false,
                    message: 'Transaction not found'
                });
            }

            res.status(200).send({
                success: true,
                data: {
                    message: 'Transaction found',
                    transaction: transaction
                }
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getUserTransactions(req, res) {
        try {
            const userId = req.query.userId;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;

            const skip = (page - 1) * limit;

            const transactions = await Transaction.find({ initiatorId: userId }, { __v: 0, updatedAt: 0 })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .lean();
            const totalCount = transactions.length;

            res.status(200).send({
                message: "Transactions retrieved",
                page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount,
                transactions: transactions
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }

    async getOrders(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;
            const search = req.query.search || "";
            const status = req.query.status || "";


            const query = {};
            if (status) {
                query.status = status;
            }

            if (search) {
                const users = await User.find(
                    { name: { $regex: search, $options: "i" } },
                    { _id: 1 }
                );
                const userIds = users.map(user => user._id);

                if (userIds.length) {
                    query.userId = { $in: userIds };
                }
            }

            const orders = await Order.find(query, { __v: 0 })
            .populate('userId', 'name -_id')
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit);

            const total = await Order.countDocuments(query);

            res.status(200).json({
                message: 'Orders retrieved',
                page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: orders,
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching orders',
                error: error.message
            });
        }
    }

    async getUserOrders(req, res) {
        try {
            const userId = req.query.userId;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const orders = await Order.find({ userId: userId }, { __v: 0 })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = orders.length;

            res.status(200).json({
                message: 'Orders retrieved',
                page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: orders,
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching orders',
                error: error.message
            });
        }
    }

    async getOrder(req, res) {
        try {
            const orderId = req.query.id;

            const order = await Order.findById(orderId)
                .populate('userId', 'name email');

            if (!order) {
                return res.status(404).json({
                    success: false,
                    message: 'Order not found'
                });
            }

            res.status(200).json({
                success: true,
                data: order
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching order',
                error: error.message
            });
        }
    }

    async deleteOneUser(req, res) {
        try {
            const { userId } = req.query;

            const deletedUser = await User.findByIdAndDelete(userId);

            if (!deletedUser) {
                return res.status(404).json({ message: 'User not found' });
            }

            res.status(200).json({ message: 'User deleted successfully' });
        } catch (error) {
            res.status(500).json({ message: 'Error deleting user', error: error.message });
        }
    }

    async getDashboardAggregateData(req, res) {
        try {
            const availableProductsCount = await Product.countDocuments({ "data.availability": "YES" });
            const pendingOrdersCount = await Order.countDocuments({status: 'pending'});
            const completedOrdersCount = await Order.countDocuments({status: 'completed'});
            const pendingTransactionsCount = await Transaction.countDocuments({status: 'pending'});
            const verifiedTransactionsCount = await Transaction.countDocuments({status: 'verified'});
            const usersCount = await User.countDocuments();

            res.status(200).send({
                message: "Dashboard data retrieved",
                numberOfAvailableProducts: availableProductsCount,
                numberOfPendingOrders: pendingOrdersCount,
                numberOfCompletedOrders: completedOrdersCount,
                numberOfPendingTransactions: pendingTransactionsCount,
                numberOfVerifiedTransactions: verifiedTransactionsCount,
                numberOfUsers: usersCount
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({ message: 'Error retrieving dashboard data', error: error.message });
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

