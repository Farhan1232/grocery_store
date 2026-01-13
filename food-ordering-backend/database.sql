-- Create Database
CREATE DATABASE IF NOT EXISTS food_ordering_db;
USE food_ordering_db;

-- Drop tables if they exist (for clean installation)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image VARCHAR(500),
  quantity INT DEFAULT 100,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table
CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert sample women accessories products
INSERT INTO products (name, description, price, image, quantity) VALUES
('Ladies Handbag', 'Elegant leather handbag for women with spacious compartments', 49.99, 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400', 100),

('Women Wrist Watch', 'Luxury analog wrist watch for women with stainless steel strap', 34.99, 'https://images.unsplash.com/photo-1519744792095-2f2205e87b6f?w=400', 100),

('Sunglasses', 'Stylish UV-protected sunglasses for women', 19.99, 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400', 100),

('Fashion Necklace', 'Beautiful gold-plated necklace for party and casual wear', 24.99, 'https://images.unsplash.com/photo-1617038260897-b52a8c2e04a8?w=400', 100),

('Earrings Set', 'Elegant earrings set perfect for weddings and events', 14.99, 'https://images.unsplash.com/photo-1600180758890-6b94519a4f91?w=400', 100),

('Women Wallet', 'Compact leather wallet designed for women', 22.99, 'https://images.unsplash.com/photo-1622560480654-d96214fdc887?w=400', 100),

('Bracelet', 'Stylish charm bracelet for modern women', 12.99, 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?w=400', 100),

('Hair Accessories Set', 'Trendy hair clips and bands set for daily use', 9.99, 'https://images.unsplash.com/photo-1616627980991-9dfb76e8864c?w=400', 100);

-- Insert a test user (password is 'test123' hashed with bcrypt)
-- You can use this to test login without registering
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Verify tables were created
SHOW TABLES;

-- Display sample data
SELECT 'Users Table:' as '';
SELECT * FROM users;

SELECT 'Products Table:' as '';
SELECT * FROM products;

SELECT 'Orders Table:' as '';
SELECT * FROM orders;

SELECT 'Order Items Table:' as '';
SELECT * FROM order_items;