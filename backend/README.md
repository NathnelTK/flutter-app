# Mini Market Backend

Node.js/Express backend API for the Mini Market Flutter application with SQLite.

## Features

- **RESTful API** for product and cart management
- **SQLite** database for persistent storage in `mini-market.sqlite`
- **CORS** enabled for cross-origin requests
- **Complete CRUD operations** for products
- **Shopping cart functionality**
- **Data validation and error handling**

## Prerequisites

- Node.js (v18 or higher)
- npm or yarn package manager

## Installation

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start the API:
  ```bash
  npm start
  ```

The database file and the six seed products are created automatically on first start. Set `DATABASE_PATH` in `.env` to use another SQLite file.

## Running the Backend

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on `http://localhost:5000`

## API Endpoints

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create new product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

### Cart
- `GET /api/cart` - Get all cart items
- `POST /api/cart` - Add item to cart
- `PUT /api/cart/:id` - Update cart item quantity
- `DELETE /api/cart/:id` - Remove item from cart
- `DELETE /api/cart` - Clear all cart items

### Health Check
- `GET /api/health` - Check server status

## Sample Product Object
```json
{
  "title": "Smartphone",
  "price": 299.99,
  "category": "smartphones",
  "description": "Latest smartphone with advanced features",
  "icon": "smartphone",
  "backgroundColor": "#D4D9F7"
}
```

## Sample Cart Item Object
```json
{
  "productId": "64a1b2c3d4e5f6a7b8c9d0e1",
  "quantity": 2
}
```

## Testing the API

### Using cURL
```bash
# Get all products
curl http://localhost:5000/api/products

# Create new product
curl -X POST http://localhost:5000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Product",
    "price": 99.99,
    "category": "electronics",
    "description": "Test description"
  }'

# Add to cart
curl -X POST http://localhost:5000/api/cart \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "64a1b2c3d4e5f6a7b8c9d0e1",
    "quantity": 1
  }'
```

### Using Postman
1. Import the collection from `postman_collection.json`
2. Set environment variables if needed

## Project Structure
```
backend/
├── server.js           # Main server file
├── package.json        # Dependencies and scripts
├── .env.example       # Environment variables template
├── .env               # Environment variables (create from example)
└── README.md          # This file
```

## Database Schema

### Products Table
```javascript
{
  title: String,
  price: Number,
  category: String,
  description: String,
  icon: String,
  backgroundColor: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Cart Items Table
```javascript
{
  productId: ObjectId,
  quantity: Number,
  createdAt: Date
}
```

## Troubleshooting

### MongoDB Connection Issues
1. Ensure MongoDB is running: `mongod --version`
2. Check if port 27017 is available
3. Verify connection string in `.env`

### Port Already in Use
Change PORT in `.env` or kill the process:
```bash
# Find process using port 5000
netstat -ano | findstr :5000

# Kill process (Windows)
taskkill /PID <PID> /F
```

## Deployment

### Heroku
```bash
# Add Heroku remote
heroku create

# Add MongoDB addon
heroku addons:create mongolab

# Deploy
git push heroku main

# View logs
heroku logs --tail
```

### Vercel/AWS/Azure
- Build script: `npm start`
- Configure environment variables
- Set PORT variable for cloud platform

## License

MIT
