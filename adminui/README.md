# administration

## Build Setup

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## Admin Management Route

### Admin Login
- **Route:** `/`
- **Description:** Contains a login form for admin authentication.

### Create Admin
- **Route:** `/create-admin`
- **Description:** Contains a form for the currently logged in admin to create a new admin.

### View Admins
- **Route:** `/admins`
- **Description:** Contains a table listing all created admins with each admin having an actions cell to trigger admin deletion.


## Product Management Route

### Add Products
- **Route:** `/add-products`
- **Description:** Contains a input field to upload an excel sheet containing the products to be added.

### View Products
- **Route:** `/all-products`
- **Description:** Contains a table listing all added products with each product having an actions cell to trigger following actions:
  - **Upload image:** Opens a modal containing a form to upload an image for a product.
  - **Delete product:** Opens a modal to confirm the decision to delete a product.
  - **View product:** Navigates to the single product page.

### View Product
- **Route:** `/all-products/_id`
- **Params:**
    - `id`: Product ID 
- **Description:** Displays details about the product including images.

## Chat
- **Route:** `/chat`
- **Description:** Displays a chat interface where admins get to communicate with users.

## Order Management
- **Route:** `/orders`
- **Description:** Displays a table listing all orders from customers, with each order having an action cell to trigger the folllowing action:
    - **View order details:** Navigates to a single order page showing extra information about the order.
  
## Transaction Management
- **Route:** `/transactions`
- **Description:** Displays a table listing all orders from customers.
  
## User Order Management
- **Route:** `/client/orders`
- **Description:** Displays a list of the authenticated user's orders.

## User Transaction Management
- **Route:** `/client/transactions`
- **Description:** Displays a list of the authenticated user's transactions.
