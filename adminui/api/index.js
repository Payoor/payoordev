import { getDefaultHeader, getFileHeader, getUserHeader, serverUrl } from "./config";
import $http from './http'


export const userSignUp = (data) => $http.post(`${serverUrl}/auth/signup`, data);

export const generateUserJWT = (userId) => $http.post(`${serverUrl}/auth/genjwt?id=${userId}`);

export const getUserDetails = () => $http.get(`${serverUrl}/auth/getvaliduser`, getUserHeader());

// Admin Management
export const adminLogin = (data) => $http.post(`${serverUrl}/admin/login`, data);

export const getAllAdmins = () => $http.get(`${serverUrl}/admins`, getDefaultHeader());

export const createAdmin = (data) => $http.post(`${serverUrl}/admin/create`, data, getDefaultHeader());

export const removeAdmin = (adminId) => $http.delete(`${serverUrl}/admin/${adminId}`, getDefaultHeader());


// Product Manangement
export const uploadExcelSheet = (data) => $http.post(`${serverUrl}/admin/upload/products/excel`, data, getFileHeader());

export const addProduct = (data) => $http.post(`${serverUrl}/admin/create/product`, data, getDefaultHeader());

export const addProductVariant = (productId, data) => $http.post(`${serverUrl}/admin/add/product-variant?id=${productId}`, data, getDefaultHeader());

export const getAllProducts = ({page, limit, search}) => $http.get(`${serverUrl}/admin/get/products?page=${page}&limit=${limit}&search=${search}`, getDefaultHeader());

export const getSingleProduct = (productId) => $http.get(`${serverUrl}/admin/get/product?id=${productId}`, getDefaultHeader());

export const getProductImages = (productId) => $http.get(`${serverUrl}/admin/product/images?id=${productId}`, getDefaultHeader());

export const updateProductDetails = (productId, data) => $http.patch(`${serverUrl}/admin/update/product?id=${productId}`, data, getDefaultHeader());

export const uploadProductImage = (productId, data) => $http.post(`${serverUrl}/admin/upload/product/image?id=${productId}`, data, getFileHeader());

export const removeProductImage = ({ imageId, isVariant }) => $http.delete(`${serverUrl}/admin/product/image?id=${imageId}&isVariant=${isVariant}`, getFileHeader());

export const removeProduct = (productId) => $http.delete(`${serverUrl}/admin/delete/product?id=${productId}`, getDefaultHeader());


// Payment
export const generatePaymentLink = (data) => $http.post(`${serverUrl}/paystack/generate-payment-link`, data, getDefaultHeader());

export const verifyPayment = (data) => $http.post(`${serverUrl}/paystack/verify-payment`, data, getDefaultHeader());


// User Management
export const getUsers = ({page, limit, search}) => $http.get(`${serverUrl}/admin/get/users?page=${page}&limit=${limit}&search=${search}`, getDefaultHeader());

export const getUser = (userId) => $http.get(`${serverUrl}/admin/get/user?id=${userId}`, getDefaultHeader());


// Order Management
export const getOrders = ({page, limit, search, status}) => $http.get(`${serverUrl}/admin/get/orders?page=${page}&limit=${limit}&search=${search}&status=${status}`, getDefaultHeader());

export const getUserOrders = (userId, page, limit) => $http.get(`${serverUrl}/admin/get/user-orders?userId=${userId}&page=${page}&limit=${limit}`, getDefaultHeader());

export const getOrder = (orderId) => $http.get(`${serverUrl}/admin/get/order?id=${orderId}`, getDefaultHeader());


// Transaction Management
export const getTransactions = ({page, limit, search, status}) => $http.get(`${serverUrl}/admin/get/transactions?page=${page}&limit=${limit}&search=${search}&status=${status}`, getDefaultHeader());

export const getUserTransactions = (userId, page, limit) => $http.get(`${serverUrl}/admin/get/user-transactions?userId=${userId}&page=${page}&limit=${limit}`, getDefaultHeader());

export const getTransaction = (transactionId) => $http.get(`${serverUrl}/admin/get/transaction?id=${transactionId}`, getDefaultHeader());


// Messages management
export const getConversation = (userId) => $http.get(`${serverUrl}/messages?roomId=${userId}`, getDefaultHeader());


export const getDashboardStats = () => $http.get(`${serverUrl}/admin/get/dashboard-stats`, getDefaultHeader());
