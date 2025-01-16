# Admin API Documentation

## Base URL
```
/api/v1
```

## Authentication
Most endpoints require authentication using a Bearer token in the Authorization header:
```
Authorization: Bearer <your_token>
```

## Admin Management Endpoints

### Create Admin
Creates a new admin user. Only available when no admins exist in the system.

- **URL:** `/admin/create`
- **Method:** `POST`
- **Auth Required:** No (only for first admin), Yes (for subsequent admins)
- **Request Body:**
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **Success Response:**
  - **Code:** 201
  - **Content:**
    ```json
    {
      "admin": {
        "username": "string",
        "_id": "string"
      },
      "token": "string"
    }
    ```
- **Error Responses:**
  - **Code:** 400
    ```json
    {
      "error": "Username already exists"
    }
    ```
  - **Code:** 400
    ```json
    {
      "error": "Username and password are required"
    }
    ```

### Initialize First Admin
Special endpoint for creating the very first admin in the system.

- **URL:** `/admin/initialize`
- **Method:** `POST`
- **Auth Required:** No
- **Request Body:** Same as Create Admin
- **Success/Error Responses:** Same as Create Admin
- **Additional Error:**
  - **Code:** 403
    ```json
    {
      "error": "Initial admin already exists. New admins must be created by an authenticated admin."
    }
    ```

### Delete Admin
Removes an admin from the system. Cannot delete the last admin or self.

- **URL:** `/admin/:adminId`
- **Method:** `DELETE`
- **Auth Required:** Yes
- **URL Params:** `adminId=[string]`
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Admin deleted successfully",
      "deletedAdmin": "username"
    }
    ```
- **Error Responses:**
  - **Code:** 400
    ```json
    {
      "error": "Cannot delete your own admin account"
    }
    ```
  - **Code:** 400
    ```json
    {
      "error": "Cannot delete the last admin account"
    }
    ```

### Get All Admins
Retrieves a list of all admin users.

- **URL:** `/admins`
- **Method:** `GET`
- **Auth Required:** Yes
- **Success Response:**
  - **Code:** 200
    ```json
    [
      {
        "_id": "string",
        "username": "string"
      }
    ]
    ```

### Admin Login
Authenticates an admin and returns a token.

- **URL:** `/admin/login`
- **Method:** `POST`
- **Auth Required:** No
- **Request Body:**
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "admin": {
        "username": "string",
        "_id": "string"
      },
      "token": "string"
    }
    ```
- **Error Response:**
  - **Code:** 401
    ```json
    {
      "error": "Invalid login credentials"
    }
    ```

## Product Management Endpoints

### Upload Product Excel Sheet
Uploads and processes an Excel file containing product data.

- **URL:** `/admin/upload/products/excel`
- **Method:** `POST`
- **Auth Required:** Yes
- **Content-Type:** `multipart/form-data`
- **Request Body:**
  - `file`: Excel file
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Excel sheet uploaded successfully"
    }
    ```

### Create Product
Creates a new product.

- **URL:** `/admin/create/product`
- **Method:** `POST`
- **Auth Required:** Yes
- **Request Body:**
  ```json
  {
    "productName": "string"
  }
  ```
- **Success Response:**
  - **Code:** 201
    ```json
    {
      "message": "Product created successfully!"
    }
    ```

### Add Product Variant
Adds a variant of a product

- **URL:** `/admin/add/product-variant`
- **Method:** `POST`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product ID
- **Request Body:**
  ```json
  {
    "unit": "string",
    "price": "number",
    "isAvailable": "string",
  }
  ```
- **Success Response:**
  - **Code:** 201
    ```json
    {
      "message": "Product variant added successfully"
    }
    ```

### Get Products
Retrieves a paginated list of products.

- **URL:** `/admin/get/products`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Products retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "products": [
        {
          "_id": "string",
          ...productData
        }
      ]
    }
    ```

### Get Single Product
Retrieves details of a specific product.

- **URL:** `/admin/get/product`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...productData,
      "images": [...imageData]
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "Product not found"
    }
    ```

### Update Product
Updates a product's information.

- **URL:** `/admin/update/product`
- **Method:** `PATCH`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product ID
- **Request Body:** Object containing updated product data
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Product updated",
      "product": {
        "_id": "string",
        ...updatedProductData
      }
    }
    ```

### Delete Product
Removes a product from the system.

- **URL:** `/admin/delete/product`
- **Method:** `DELETE`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Product deleted successfully",
      "product": {
        "_id": "string",
        ...deletedProductData
      }
    }
    ```

### Delete Product Variant
Removes a product variant from the system.

- **URL:** `/admin/delete/product-variant`
- **Method:** `DELETE`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product variant ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Variant deleted successfully",
      "variant": {
        "_id": "string",
        ...deletedVariant
      }
    }
    ```

## Product Image Management

### Upload Product Image
Uploads an image for a specific product.

- **URL:** `/admin/upload/product/image`
- **Method:** `POST`
- **Auth Required:** Yes
- **Content-Type:** `multipart/form-data`
- **Query Params:**
  - `id`: Product ID
- **Request Body:**
  - `file`: Image file
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "product image uploaded successfully",
      "image": {
        "imageUrl": "string",
        "product": "string",
        "_id": "string"
      }
    }
    ```

### Get Product Images
Retrieves all images associated with a product.

- **URL:** `/admin/product/images`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Product ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "images found",
      "images": [
        {
          "imageUrl": "string",
          "product": "string",
          "_id": "string"
        }
      ],
      "total": number
    }
    ```

### Delete Product Image
Removes an image from a product.

- **URL:** `/admin/product/image`
- **Method:** `DELETE`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Image ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Image deleted successfully",
      "deletedImage": {
        "imageUrl": "string",
        "product": "string",
        "_id": "string"
      }
    }
    ```
- **Error Responses:**
  - **Code:** 404
    ```json
    {
      "message": "Image not found"
    }
    ```
  - **Code:** 400
    ```json
    {
      "message": "Invalid image ID format"
    }
    ```

## Error Handling

All endpoints may return these common error responses:

- **Unauthorized Error:**
  - **Code:** 401
    ```json
    {
      "error": "Please authenticate",
      "details": "error message"
    }
    ```

- **Server Error:**
  - **Code:** 500
    ```json
    {
      "message": "error message"
    }
    ```

## Order Management
### Get Orders (ADMIN)
Retrieves a paginated list of orders.

- **URL:** `/admin/get/orders`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Orders retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "orders": [
        {
          "_id": "string",
          ...orderData
        }
      ]
    }
    ```

### Get Orders (USER)
Retrieves a paginated list of orders.

- **URL:** `/user/get/orders`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Orders retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "orders": [
        {
          "_id": "string",
          ...orderData
        }
      ]
    }
    ```

### Get Single Order (ADMIN)
Retrieves details of a specific order.

- **URL:** `/admin/get/order`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Order ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...orderData,
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "Order not found"
    }
    ```

### Get Single Order (USER)
Retrieves details of a specific order.

- **URL:** `/user/get/order`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Order ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...orderData,
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "Order not found"
    }
    ```

## Transaction Management
### Get Transactions (ADMIN)
Retrieves a paginated list of transactions.

- **URL:** `/admin/get/transactions`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Transactions retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "transactions": [
        {
          "_id": "string",
          ...transactionData
        }
      ]
    }
    ```

### Get Transactions (USER)
Retrieves a paginated list of transactions.

- **URL:** `/user/get/transactions`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Transactions retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "transactions": [
        {
          "_id": "string",
          ...transactionData
        }
      ]
    }
    ```

### Get Single Transaction (ADMIN)
Retrieves details of a specific transaction.

- **URL:** `/admin/get/transaction`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Transaction ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...transactionData,
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "Transaction not found"
    }
    ```

### Get Single Transaction (USER)
Retrieves details of a specific transaction.

- **URL:** `/user/get/transaction`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: Transaction ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...transactionData,
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "Transaction not found"
    }
    ```

## User Management
### Get Users
Retrieves a paginated list of users.

- **URL:** `/admin/get/users`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `page` (optional, default: 1)
  - `limit` (optional, default: 10)
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "message": "Users retrieved",
      "page": number,
      "totalPages": number,
      "totalCount": number,
      "users": [
        {
          "_id": "string",
          ...userData
        }
      ]
    }
    ```

### Get Single User
Retrieves details of a specific user.

- **URL:** `/admin/get/user`
- **Method:** `GET`
- **Auth Required:** Yes
- **Query Params:**
  - `id`: User ID
- **Success Response:**
  - **Code:** 200
    ```json
    {
      "_id": "string",
      ...userData,
    }
    ```
- **Error Response:**
  - **Code:** 404
    ```json
    {
      "message": "User not found"
    }
    ```


## Sockect Events
### Events:
- **`connect`**: Emitted by the client when a successful connection to the server is established.
- **`disconnect`**: Emitted by the client when the connection to the server is closed.
- **`createRoom`**: Emitted by the user on initial connection to create a dedicated chat room for the user.
- **`joinRoom`**: Emitted by the admin when they join a specific user's chat room.
- **`leaveRoom`**: Emitted by the admin when they leave a user's chat room.
- **`sendMessage`**: Emitted by both the user and the admin when sending a message.
- **`userTyping`**: Emitted by the user when they start typing a message.
- **`userStopTyping`**: Emitted by the user when they stop typing a message.
- **`adminTyping`**: Emitted by the admin when they start typing a message.
- **`adminStopTyping`**: Emitted by the admin when they stop typing a message.
- **`updateUserList`**: Emitted by the server to update the list of connected users for all connected clients.

- **Data Structure:**
  - sendMessage data:
    - **`text`**: The message content.
    - **`clienttimestamp`**: Timestamp of the message.
    - **`sender`**: "user" or "admin".
    - **`userId`**: The ID of the user the message is intended for.

  - leaveRoom data:
    - **`currentRoom`**: The ID of the current room, which is also the ID of the user who created the room.


## Notes for Frontend Implementation

1. All authenticated requests must include the Bearer token in the Authorization header
2. File uploads must use `multipart/form-data` content type
3. Pagination is available for product listing
4. Image URLs are served from AWS S3 bucket
5. Excel sheet upload supports only the first sheet in the workbook
6. The system maintains at least one admin user at all times