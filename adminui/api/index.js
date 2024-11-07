import { getDefaultHeader, getFileHeader, serverUrl } from "./config";
import $http from './http'

export const adminLogin = (data) => $http.post(`${serverUrl}/admin/login`, data);

export const uploadExcelSheet = (data) => $http.post(`${serverUrl}/admin/upload/products/excel`, data, getFileHeader());

export const getAllProducts = () => $http.get(`${serverUrl}/admin/get/products`, getDefaultHeader());

export const getSingleProduct = (productId) => $http.get(`${serverUrl}/admin/get/product?id=${productId}`, getDefaultHeader());

export const getProductImages = (productId) => $http.get(`${serverUrl}/admin/product/images?id=${productId}`, getDefaultHeader());

export const updateProductDetails = (productId, data) => $http.patch(`${serverUrl}/admin/update/product?id=${productId}`, data, getDefaultHeader());

export const uploadProductImage = (productId, data) => $http.post(`${serverUrl}/admin/upload/product/image?id=${productId}`, data, getFileHeader());

export const removeProduct = (productId) => $http.delete(`${serverUrl}/admin/delete/product?id=${productId}`, getDefaultHeader());
