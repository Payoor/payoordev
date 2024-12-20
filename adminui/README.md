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
  
  ### Events Emitted (User Side):
  - **`sendMessage`** (Emitted on message send): This event is emitted when the user sends a message. The message data includes the text, timestamp, sender ("user"), and the user's ID (userId).
  - **`userTyping`** (Emitted on typing start): This event is emitted when the user starts typing a message. It lets the admin know that the user is typing.
  - **`userStopTyping`** (Emitted on typing stop): This event is emitted when the user stops typing a message. It informs the admin that the user is no longer typing.
  
  ### Events Listened to (User Side):
  - **`receiveMessage`** (Received from server): This event is received whenever a new message arrives from the admin. It updates the chat window with the received message.
  - **`adminTyping`** (Received from server): This event is received when the admin starts typing a message. It updates the user interface to show an indicator that the admin is typing.
  - **`adminStopTyping`** (Received from server): This event is received when the admin stops typing a message. It removes the typing indicator from the user interface.

  ### Events Emitted (Admin Side):
  - **`joinRoom`** (Emitted on selecting a user): This event is emitted when the admin joins the chat room associated with a specific user's ID.
  - **`leaveRoom`** (Emitted on leaving a chat): This event is emitted when the admin leaves a user's chat room.
  - **`sendMessage`** (Emitted on message send): This event is emitted when the admin sends a message. The message data includes the text, timestamp, sender ("admin"), and the user's ID (userId).
  - **`adminTyping`** (Emitted on typing start): This event is emitted when the admin starts typing a message. It lets the user know that the admin is typing.
  - **`adminStopTyping`** (Emitted on typing stop): This event is emitted when the admin stops typing a message. It informs the user that the admin is no longer typing.
  
  ### Events Listened to (Admin Side):
  - **`updateUserList`** (Emitted on connection): This event is received whenever the list of connected users updates. It updates the user interface with the list of online users.
  - **`receiveMessage`** (Received from users): This event is received whenever a new message arrives from the user. It updates the chat window with the received message.
  - **`userTyping`** (Received from users): This event is received when a user starts typing a message. It updates the admin interface to show an indicator that the user is typing.
  - **`userStopTyping`** (Received from users): This event is received when a user stops typing a message. It removes the typing indicator from the admin interface.

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
