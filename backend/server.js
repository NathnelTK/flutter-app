const express = require('express');
const cors = require('cors');
const initSqlJs = require('sql.js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;
const databasePath = process.env.DATABASE_PATH || path.join(__dirname, 'mini-market.sqlite');
const seedProducts = [
  ['Smartphone', 299.99, 'smartphones', 'Latest smartphone with advanced features', 'smartphone', '#D4D9F7'],
  ['Laptop', 899.99, 'computers', 'High-performance laptop for work and gaming', 'laptop', '#D4F1E8'],
  ['Headphones', 199.99, 'audio', 'Noise-cancelling wireless headphones', 'headphones', '#F5E1D4'],
  ['Camera', 499.99, 'electronics', 'Professional DSLR camera', 'camera_alt', '#E4D9F7'],
  ['Backpack', 59.99, 'accessories', 'Durable waterproof backpack', 'backpack', '#DCE8D4'],
  ['Jacket', 89.99, 'clothing', 'Warm winter jacket', 'checkroom', '#F5D9E8'],
];

function rowToObject(columns, values) {
  return Object.fromEntries(columns.map((column, index) => [column, values[index]]));
}

function query(database, sql, params = []) {
  const statement = database.prepare(sql);
  statement.bind(params);
  const rows = [];
  while (statement.step()) rows.push(rowToObject(statement.getColumnNames(), statement.get()));
  statement.free();
  return rows;
}

function execute(database, sql, params = []) {
  database.run(sql, params);
  const rows = query(database, 'SELECT last_insert_rowid() AS id');
  return rows[0].id;
}

function saveDatabase(database) {
  fs.writeFileSync(databasePath, Buffer.from(database.export()));
}

function productFromRow(row) {
  return row ? { ...row, _id: String(row.id) } : null;
}

function cartItemFromRow(row) {
  return row ? { _id: String(row.cartId), productId: productFromRow(row), quantity: row.quantity } : null;
}

async function startServer() {
  const SQL = await initSqlJs({
    locateFile: (file) => path.join(__dirname, 'node_modules', 'sql.js', 'dist', file),
  });
  const database = fs.existsSync(databasePath)
    ? new SQL.Database(fs.readFileSync(databasePath))
    : new SQL.Database();

  database.run(`
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      price REAL NOT NULL CHECK (price >= 0),
      category TEXT NOT NULL DEFAULT 'smartphones',
      description TEXT NOT NULL,
      icon TEXT NOT NULL DEFAULT 'smartphone',
      backgroundColor TEXT NOT NULL DEFAULT '#D4D9F7',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    CREATE TABLE IF NOT EXISTS cart_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productId INTEGER NOT NULL UNIQUE,
      quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
    );
  `);

  if (query(database, 'SELECT COUNT(*) AS count FROM products')[0].count === 0) {
    for (const product of seedProducts) {
      database.run(`INSERT INTO products (title, price, category, description, icon, backgroundColor) VALUES (?, ?, ?, ?, ?, ?)`, product);
    }
    saveDatabase(database);
    console.log(`Seeded ${seedProducts.length} products`);
  }

  const readProduct = (id) => query(database, 'SELECT * FROM products WHERE id = ?', [Number(id)])[0];
  const readCartItem = (id) => query(database, `SELECT c.id AS cartId, c.quantity, p.* FROM cart_items c JOIN products p ON p.id = c.productId WHERE c.id = ?`, [Number(id)])[0];

  app.use(cors());
  app.use(express.json());

  app.get('/api/products', (req, res) => {
    res.json(query(database, 'SELECT * FROM products ORDER BY createdAt DESC, id DESC').map(productFromRow));
  });

  app.get('/api/products/categories', (req, res) => {
    const categories = query(database, 'SELECT DISTINCT category FROM products ORDER BY category ASC')
      .map((row) => row.category);
    res.json(categories);
  });

  app.get('/api/products/:id', (req, res) => {
    const product = productFromRow(readProduct(req.params.id));
    if (!product) return res.status(404).json({ error: 'Product not found' });
    res.json(product);
  });

  app.post('/api/products', (req, res) => {
    try {
      const { title, price, category, description, icon, backgroundColor } = req.body;
      if (!title || price === undefined || !description) return res.status(400).json({ error: 'title, price, and description are required' });
      const id = execute(database, `INSERT INTO products (title, price, category, description, icon, backgroundColor) VALUES (?, ?, ?, ?, ?, ?)`, [title, Number(price), category || 'smartphones', description, icon || 'smartphone', backgroundColor || '#D4D9F7']);
      saveDatabase(database);
      res.status(201).json(productFromRow(readProduct(id)));
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });

  app.put('/api/products/:id', (req, res) => {
    try {
      const current = readProduct(req.params.id);
      if (!current) return res.status(404).json({ error: 'Product not found' });
      const { title, price, category, description, icon, backgroundColor } = req.body;
      database.run(`UPDATE products SET title = ?, price = ?, category = ?, description = ?, icon = ?, backgroundColor = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`, [title ?? current.title, price ?? current.price, category ?? current.category, description ?? current.description, icon ?? current.icon, backgroundColor ?? current.backgroundColor, Number(req.params.id)]);
      saveDatabase(database);
      res.json(productFromRow(readProduct(req.params.id)));
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });

  app.delete('/api/products/:id', (req, res) => {
    if (!readProduct(req.params.id)) return res.status(404).json({ error: 'Product not found' });
    database.run('DELETE FROM products WHERE id = ?', [Number(req.params.id)]);
    saveDatabase(database);
    res.json({ message: 'Product deleted successfully' });
  });

  app.get('/api/cart', (req, res) => {
    const items = query(database, `SELECT c.id AS cartId, c.quantity, p.* FROM cart_items c JOIN products p ON p.id = c.productId ORDER BY c.createdAt DESC, c.id DESC`);
    res.json(items.map(cartItemFromRow));
  });

  app.get('/api/cart/summary', (req, res) => {
    const summary = query(database, `
      SELECT COUNT(*) AS itemCount,
             COALESCE(SUM(c.quantity), 0) AS quantity,
             COALESCE(SUM(c.quantity * p.price), 0) AS total
      FROM cart_items c
      JOIN products p ON p.id = c.productId
    `)[0];
    res.json({
      itemCount: Number(summary.itemCount),
      quantity: Number(summary.quantity),
      total: Number(summary.total),
    });
  });

  app.post('/api/cart', (req, res) => {
    try {
      const productId = Number(req.body.productId);
      const quantity = Number(req.body.quantity || 1);
      if (!readProduct(productId)) return res.status(404).json({ error: 'Product not found' });
      if (!Number.isInteger(quantity) || quantity < 1) return res.status(400).json({ error: 'Quantity must be at least 1' });
      const existing = query(database, 'SELECT id FROM cart_items WHERE productId = ?', [productId])[0];
      if (existing) database.run('UPDATE cart_items SET quantity = quantity + ? WHERE id = ?', [quantity, existing.id]);
      else database.run('INSERT INTO cart_items (productId, quantity) VALUES (?, ?)', [productId, quantity]);
      saveDatabase(database);
      const cartItem = query(database, `SELECT c.id AS cartId, c.quantity, p.* FROM cart_items c JOIN products p ON p.id = c.productId WHERE c.productId = ?`, [productId])[0];
      res.status(201).json(cartItemFromRow(cartItem));
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });

  app.delete('/api/cart/:id', (req, res) => {
    if (!readCartItem(req.params.id)) return res.status(404).json({ error: 'Cart item not found' });
    database.run('DELETE FROM cart_items WHERE id = ?', [Number(req.params.id)]);
    saveDatabase(database);
    res.json({ message: 'Item removed from cart' });
  });

  app.put('/api/cart/:id', (req, res) => {
    const quantity = Number(req.body.quantity);
    if (!Number.isInteger(quantity) || quantity < 1) return res.status(400).json({ error: 'Quantity must be greater than 0' });
    if (!readCartItem(req.params.id)) return res.status(404).json({ error: 'Cart item not found' });
    database.run('UPDATE cart_items SET quantity = ? WHERE id = ?', [quantity, Number(req.params.id)]);
    saveDatabase(database);
    res.json(cartItemFromRow(readCartItem(req.params.id)));
  });

  app.delete('/api/cart', (req, res) => {
    database.run('DELETE FROM cart_items');
    saveDatabase(database);
    res.json({ message: 'Cart cleared successfully' });
  });

  app.post('/api/checkout', (req, res) => {
    const summary = query(database, `
      SELECT COUNT(*) AS itemCount,
             COALESCE(SUM(c.quantity), 0) AS quantity,
             COALESCE(SUM(c.quantity * p.price), 0) AS total
      FROM cart_items c
      JOIN products p ON p.id = c.productId
    `)[0];
    if (Number(summary.itemCount) === 0) return res.status(400).json({ error: 'Cart is empty' });

    database.run('DELETE FROM cart_items');
    saveDatabase(database);
    res.status(201).json({
      message: 'Checkout completed successfully',
      itemCount: Number(summary.itemCount),
      quantity: Number(summary.quantity),
      total: Number(summary.total),
    });
  });

  app.get('/api/health', (req, res) => res.json({ status: 'OK', database: 'sqlite', timestamp: new Date() }));

  app.listen(port, () => console.log(`SQLite API listening on port ${port}`));
}

startServer().catch((error) => {
  console.error('Unable to start server:', error);
  process.exit(1);
});
