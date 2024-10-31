# Admin Product Management API Documentation

## Base URL
```
/admin
```

## Available Endpoints

### 1. Upload Products Excel Sheet
```http
POST /admin/upload/products/excel
```

**Request:**
- Content-Type: `multipart/form-data`
- Body:
  - `file`: Excel file (required)

**Response:**
```json
{
  "message": "Excel sheet uploaded successfully"
}
```

**Status Codes:**
- 200: Success
- 400: No file uploaded
- 500: Server error

### 2. Get Products List
```http
GET /admin/get/products
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Number of items per page (default: 10)

**Response:**
```json
{
  "message": "Products retrieved",
  "page": 1,
  "totalPages": 5,
  "totalCount": 48,
  "products": [
    {
      "_id": "product_id",
      ...productData
    }
  ]
}
```

**Status Codes:**
- 200: Success
- 500: Server error

### 3. Get Single Product
```http
GET /admin/get/product
```

**Query Parameters:**
- `id` (required): Product ID

**Response:**
```json
{
  "_id": "product_id",
  "images": [...],
  ...productData
}
```

**Status Codes:**
- 200: Success
- 400: Product ID missing
- 404: Product not found
- 500: Server error

### 4. Update Product
```http
PATCH /admin/update/product
```

**Query Parameters:**
- `id` (required): Product ID

**Request Body:**
- Object containing product data to update
```json
{
  "field1": "value1",
  "field2": "value2"
}
```

**Response:**
```json
{
  "message": "Product updated",
  "product": {
    "_id": "product_id",
    ...updatedProductData
  }
}
```

**Status Codes:**
- 200: Success
- 400: Invalid update data
- 404: Product not found
- 500: Server error

### 5. Delete Product
```http
DELETE /admin/delete/product
```

**Query Parameters:**
- `id` (required): Product ID

**Response:**
```json
{
  "message": "Product deleted successfully",
  "product": {
    "_id": "product_id",
    ...deletedProductData
  }
}
```

**Status Codes:**
- 200: Success
- 400: Product ID missing
- 404: Product not found
- 500: Server error

## Error Handling
All endpoints follow a consistent error response format:
```json
{
  "message": "Error description"
}
```

## Implementation Notes
1. All requests that require a product ID should pass it as a query parameter (`?id=...`)
2. Pagination is available for the products list endpoint
3. The Excel upload endpoint requires multipart/form-data with a file field named 'file'
4. Product updates should be sent as a plain object, not an array
5. All successful responses include a message field and the relevant data
