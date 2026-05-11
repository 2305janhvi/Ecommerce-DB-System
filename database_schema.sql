-- =============================================
-- E-COMMERCE DATABASE SCHEMA
-- Author: Janhvi Mane
-- Description: Full schema including tables, 
--              constraints, and automation triggers.
-- =============================================

-- 1. CLEANUP (Optional: Purana data delete karne ke liye)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- 2. TABLES CREATION
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INT REFERENCES categories(category_id) ON DELETE SET NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock_count INT DEFAULT 0 CHECK (stock_count >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL
);

-- 3. AUTOMATION: STOCK UPDATE TRIGGER
-- Function to subtract stock
CREATE OR REPLACE FUNCTION update_stock_after_order()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET stock_count = stock_count - NEW.quantity
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger execution
CREATE TRIGGER trigger_update_stock
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_order();

-- 4. SEED DATA (Sample records for testing)
INSERT INTO categories (name) VALUES ('Electronics'), ('Fashion'), ('Home Decor');

INSERT INTO products (name, category_id, price, stock_count) VALUES 
('iPhone 15', 1, 80000.00, 10),
('Sony Headphones', 1, 15000.00, 20),
('Cotton T-Shirt', 2, 999.00, 50);

INSERT INTO users (full_name, email) VALUES 
('Rahul Sharma', 'rahul@example.com'),
('Priya Singh', 'priya@example.com');

-- 5. USEFUL ANALYTICS QUERIES (Bonus for Interview)
-- Query to see all orders with customer names
-- SELECT o.order_id, u.full_name, o.total_amount FROM orders o JOIN users u ON o.user_id = u.user_id;
