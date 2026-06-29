-- ============================================================
-- Retail Sales & Inventory Analytics System
-- Purpose: This project creates a MySQL database for a retail
-- store and uses SQL queries to analyze sales, inventory,
-- customers, employees, suppliers, and store performance.
-- ============================================================

CREATE DATABASE retail_analytics;
USE retail_analytics;

-- ============================================================
-- SECTION 1: CREATE TABLES
-- This section creates the database structure.
-- Each table stores one type of business information.
-- ============================================================

-- Stores product categories such as Produce, Dairy, Bakery, etc...
CREATE TABLE categories (
	category_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each category
    category_name VARCHAR(100) NOT NULL -- Name of the category
);

-- Stores supplier information for companies that provide products
CREATE TABLE suppliers (
	supplier_id INT AUTO_INCREMENT PRIMARY KEY, 
    supplier_name VARCHAR(150) NOT NULL, 
    contact_email VARCHAR(150), -- Supplier contact email
    city VARCHAR(100) -- Supplier City
);

-- Stores product information, including price, cost, category, and supplier
CREATE TABLE products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT, -- Links product to a category
    supplier_id INT, -- Links product to a supplier
    unit_price DECIMAL(10,2) NOT NULL, -- Selling price of the product
    cost_price DECIMAL(10,2) NOT NULL, -- Cost to the business
    reorder_level INT NOT NULL, -- Minimum stock level before reorder is needed

    -- Foreign keys connect this table to categories and suppliers
    FOREIGN KEY (category_id) REFERENCES categories(category_id), 
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Stores retail store locations
CREATE TABLE stores (
	store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Stores employee information and connects each employee to a store
CREATE TABLE employees (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(100), -- Creates a role for the employee
    store_id INT, -- Store where the employee works
    
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Stores customer information
CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150),
    city VARCHAR(100),
    join_date DATE
);

-- Stores each sale transaction
CREATE TABLE sales (
	sale_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT, -- Customer who made the purchase
    employee_id INT, -- Employee who processed the sale
    store_id INT, -- Store where the sale happened
    sale_date DATE NOT NULL, -- Date of the sale
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Stores the individual products included in each sale
-- This is important because one sale can include multiple products
CREATE TABLE sale_items (
	sale_item_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT, -- Links item to a sale transaction
    product_id INT, -- Product that was sold
    quantity INT NOT NULL, -- Number of units sold
    unit_price_at_sale DECIMAL(10,2) NOT NULL, -- Price at the time of the sale
    
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Stores inventory levels for each product at each store
CREATE TABLE  inventory (
	inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT,
    product_id INT, -- Product being tracked
    quantity_in_stock INT NOT NULL, 
    
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA
-- ============================================================

-- Add product categories
INSERT INTO categories (category_name) VALUES
('Produce'),
('Dairy'),
('Bakery'),
('Beverages'),
('Frozen Foods'),
('Snacks'),
('Meat'),
('Pantry');

-- Add suppliers
INSERT INTO suppliers (supplier_name, contact_email, city) VALUES
('FreshFarm Distributors', 'orders@freshfarm.com', 'Toronto'),
('Golden Dairy Co.', 'sales@goldendairy.com', 'Mississauga'),
('BakeHouse Wholesale', 'info@bakehouse.com', 'Brampton'),
('North Beverage Supply', 'support@northbev.com', 'Toronto'),
('FrozenPro Foods', 'orders@frozenpro.com', 'Vaughan');

-- Add store locations
INSERT INTO stores (store_name, city) VALUES
('Downtown Market', 'Toronto'),
('Westside Grocery', 'Mississauga'),
('North Plaza Foods', 'Vaughan');

-- Add employees and connect them to store locations using store id
INSERT INTO employees (first_name, last_name, role, store_id) VALUES
('Ali', 'Khan', 'Cashier', 1),
('Maria', 'Lopez', 'Cashier', 1),
('Daniel', 'Chen', 'Supervisor', 2),
('Sarah', 'Patel', 'Cashier', 2),
('Omar', 'Hassan', 'Cashier', 3),
('Emily', 'Brown', 'Supervisor', 3);

-- Adds products and connects each product to a category and supplier
INSERT INTO products (product_name, category_id, supplier_id, unit_price, cost_price, reorder_level) VALUES
('Bananas', 1, 1, 1.29, 0.70, 40),
('Apples', 1, 1, 3.99, 2.10, 35),
('Milk 2L', 2, 2, 5.49, 3.20, 25),
('Greek Yogurt', 2, 2, 6.99, 4.00, 20),
('White Bread', 3, 3, 3.49, 1.80, 30),
('Croissants', 3, 3, 5.99, 3.10, 15),
('Orange Juice', 4, 4, 4.99, 2.70, 25),
('Sparkling Water', 4, 4, 6.49, 3.60, 20),
('Frozen Pizza', 5, 5, 7.99, 4.80, 18),
('Ice Cream', 5, 5, 6.99, 3.90, 15),
('Potato Chips', 6, 4, 3.99, 1.90, 35),
('Chicken Breast', 7, 1, 12.99, 8.50, 12),
('Rice 5kg', 8, 1, 14.99, 9.20, 10);

-- Add customers
INSERT INTO customers (first_name, last_name, email, city, join_date) VALUES
('John', 'Smith', 'john.smith@email.com', 'Toronto', '2024-01-10'),
('Aisha', 'Ahmed', 'aisha.ahmed@email.com', 'Mississauga', '2024-02-15'),
('Michael', 'Lee', 'michael.lee@email.com', 'Toronto', '2024-03-20'),
('Priya', 'Sharma', 'priya.sharma@email.com', 'Vaughan', '2024-04-05'),
('David', 'Wilson', 'david.wilson@email.com', 'Brampton', '2024-05-12'),
('Fatima', 'Ali', 'fatima.ali@email.com', 'Toronto', '2024-05-25');

-- Add sale transactions
-- Each row represents one sale made by a customer, processed by an employee, at a store
INSERT INTO sales (customer_id, employee_id, store_id, sale_date) VALUES
(1, 1, 1, '2024-06-01'),
(2, 2, 1, '2024-06-02'),
(3, 3, 2, '2024-06-05'),
(4, 4, 2, '2024-06-10'),
(5, 5, 3, '2024-06-15'),
(6, 6, 3, '2024-06-18'),
(1, 1, 1, '2024-07-01'),
(2, 3, 2, '2024-07-04'),
(3, 5, 3, '2024-07-08'),
(4, 2, 1, '2024-07-12');

-- Add products sold in each transaction
-- A sale id can appear multiple times because one sale can include multiple products
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price_at_sale) VALUES
(1, 1, 6, 1.29),
(1, 3, 2, 5.49),
(1, 5, 1, 3.49),
(2, 7, 2, 4.99),
(2, 11, 3, 3.99),
(2, 4, 1, 6.99),
(3, 12, 2, 12.99),
(3, 13, 1, 14.99),
(3, 2, 4, 3.99),
(4, 9, 2, 7.99),
(4, 10, 1, 6.99),
(4, 8, 2, 6.49),
(5, 6, 4, 5.99),
(5, 3, 1, 5.49),
(5, 1, 10, 1.29),
(6, 12, 1, 12.99),
(6, 7, 3, 4.99),
(6, 11, 2, 3.99),
(7, 13, 2, 14.99),
(7, 2, 5, 3.99),
(7, 5, 2, 3.49),
(8, 4, 3, 6.99),
(8, 10, 2, 6.99),
(8, 8, 1, 6.49),
(9, 12, 3, 12.99),
(9, 9, 2, 7.99),
(9, 11, 4, 3.99),
(10, 1, 8, 1.29),
(10, 6, 2, 5.99),
(10, 7, 2, 4.99);

-- Add inventory records
INSERT INTO inventory (store_id, product_id, quantity_in_stock) VALUES
(1, 1, 120),
(1, 2, 80),
(1, 3, 20),
(1, 4, 18),
(1, 5, 60),
(1, 6, 12),
(1, 7, 35),
(1, 8, 16),
(1, 9, 14),
(1, 10, 10),
(1, 11, 75),
(1, 12, 9),
(1, 13, 8),
(2, 1, 90),
(2, 2, 70),
(2, 3, 28),
(2, 4, 22),
(2, 5, 45),
(2, 6, 20),
(2, 7, 40),
(2, 8, 18),
(2, 9, 12),
(2, 10, 9),
(2, 11, 55),
(2, 12, 15),
(2, 13, 11),
(3, 1, 110),
(3, 2, 60),
(3, 3, 24),
(3, 4, 19),
(3, 5, 38),
(3, 6, 10),
(3, 7, 30),
(3, 8, 25),
(3, 9, 20),
(3, 10, 8),
(3, 11, 65),
(3, 12, 10),
(3, 13, 7);

-- ============================================================
-- SECTION 3: CHECK TABLE ROW COUNTS
-- ============================================================

SELECT COUNT(*) AS total_categories FROM categories;
SELECT COUNT(*) AS total_suppliers FROM suppliers;
SELECT COUNT(*) AS total_stores FROM stores;
SELECT COUNT(*) AS total_employees FROM employees;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_sales FROM sales;
SELECT COUNT(*) AS total_sale_items FROM sale_items;
SELECT COUNT(*) AS total_inventory_records FROM inventory;

-- ============================================================
-- SECTION 4: BUSINESS ANALYSIS QUERIES
-- These queries answer business questions using JOINs,
-- aggregation, grouping, filtering, and calculations.
-- ============================================================

-- Shows which products generated the most revenue
SELECT
	p.product_name,
    SUM(si.quantity) AS total_units_sold,
    SUM(si.quantity * si.unit_price_at_sale) AS total_revenue
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Shows which product categories generated the most revenue
SELECT 
	c.category_name,
    SUM(si.quantity) AS total_units_sold,
    SUM(si.quantity * si.unit_price_at_sale) AS total_revenue
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Shows monthly sales trends by grouping sales by year and month
SELECT 
	DATE_FORMAT(s.sale_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    SUM(si.quantity * si.unit_price_at_sale) AS monthly_revenue
FROM sales s
JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m')
ORDER BY sales_month;

-- Compares revenue by store location
SELECT
	st.store_name,
    st.city,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    SUM(si.quantity * si.unit_price_at_sale) AS total_revenue
FROM stores st
JOIN sales s ON st.store_id = s.store_id
JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY st.store_name, st.city
ORDER BY total_revenue DESC;

-- Shows employee sales performance based on revenue processed
SELECT 
	e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.role,
    st.store_name,
    COUNT(DISTINCT s.sale_id) AS transactions_processed,
    SUM(si.quantity * si.unit_price_at_sale) AS revenue_processed
FROM employees e
JOIN stores st ON e.store_id = st.store_id
JOIN sales s ON e.employee_id = s.employee_id
JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY e.employee_id, employee_name, e.role, st.store_name
ORDER BY revenue_processed DESC;

-- Labels inventory as either "Reorder Needed" or "Stock OK"
SELECT 
	st.store_name,
    p.product_name,
    i.quantity_in_stock,
    p.reorder_level,
    CASE
		WHEN i.quantity_in_stock < p.reorder_level THEN 'Reorder Needed'
        ELSE 'Stock OK'
	END AS inventory_status
FROM inventory i
JOIN stores st ON i.store_id = st.store_id
JOIN products p ON i.product_id = p.product_id
ORDER BY inventory_status DESC, i.quantity_in_stock ASC;

-- Shows only products that are below the reorder level
SELECT
	st.store_name,
    p.product_name,
    i.quantity_in_stock,
    p.reorder_level,
    p.reorder_level - i.quantity_in_stock AS units_below_reorder_level
FROM inventory i
JOIN stores st ON i.store_id = st.store_id
JOIN products p ON i.product_id = p.product_id
WHERE i.quantity_in_stock < p.reorder_level
ORDER BY units_below_reorder_level DESC;

-- Shows customer spending and total number of orders
SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(DISTINCT s.sale_id) AS total_orders,
    SUM(si.quantity * si.unit_price_at_sale) AS total_spent
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY c.customer_id, customer_name, c.city
ORDER BY total_spent DESC;

-- Estimates profit by product using selling price minus cost price
SELECT
	p.product_name,
    SUM(si.quantity) AS units_sold,
    SUM(si.quantity * si.unit_price_at_sale) AS revenue,
    SUM(si.quantity * p.cost_price) AS estimated_cost,
    SUM(si.quantity * (si.unit_price_at_sale - p.cost_price)) AS estimated_profit
FROM sale_items si
JOIN products p ON si.product_id = p.product_id
GROUP BY p.product_name
ORDER BY estimated_profit DESC;

-- Shows which suppliers contributed the most revenue through their products
SELECT 
	sup.supplier_name,
    COUNT(DISTINCT p.product_id) AS products_supplied,
    SUM(si.quantity * si.unit_price_at_sale) AS revenue_generated
FROM suppliers sup
JOIN products p ON sup.supplier_id = p.supplier_id
JOIN sale_items si ON p.product_id = si.product_id
GROUP BY sup.supplier_name
ORDER BY revenue_generated DESC;

-- =============================================================
-- SECTION 5: CREATE VIEWS
-- Views save useful queries so they can be reused like tables.
-- =============================================================

-- Creates a saved sales summary report
CREATE VIEW sales_summary AS
SELECT
	s.sale_id,
    s.sale_date,
    st.store_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(si.quantity * si.unit_price_at_sale) AS sale_total
FROM sales s
JOIN stores st ON s.store_id = st.store_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY
	s.sale_id,
    s.sale_date,
    st.store_name,
    customer_name,
    employee_name;

-- Creates a saved low-stock report
CREATE VIEW low_stock_report AS
SELECT
	st.store_name,
    p.product_name,
    i.quantity_in_stock,
    p.reorder_level,
    p.reorder_level - i.quantity_in_stock AS units_needed
FROM inventory i
JOIN stores st ON i.store_id = st.store_id
JOIN products p ON i.product_id = p.product_id
WHERE i.quantity_in_stock < p.reorder_level;

-- ============================================================
-- SECTION 6: CREATE STORED PROCEDURE
-- A stored procedure is a saved query that can accept input.
-- This one accepts a store name and returns daily revenue.
-- ============================================================

DELIMITER //
CREATE PROCEDURE GetStoreSales(IN storeName VARCHAR(150))
BEGIN
	SELECT
    st.store_name,
    s.sale_date,
    SUM(si.quantity * si.unit_price_at_sale) AS daily_revenue
FROM stores st
JOIN sales s ON st.store_id = s.store_id
JOIN sale_items si ON s.sale_id = si.sale_id
WHERE st.store_name = storeName
GROUP BY st.store_name, s.sale_date
ORDER BY s.sale_date;
END //
DELIMITER ; 

-- ============================================================
-- SECTION 7: FINAL SUMMARY REPORTS
-- These queries summarize the overall project results.
-- ============================================================

SELECT
	COUNT(DISTINCT s.sale_id) AS total_transactions,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT st.store_id) AS total_stores,
    SUM(si.quantity) AS total_units_sold,
    SUM(si.quantity * si.unit_price_at_sale) AS total_revenue,
    SUM(si.quantity * (si.unit_price_at_sale - p.cost_price)) AS estimated_profit
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN stores st ON s.store_id = st.store_id
JOIN sale_items si ON s.sale_id = si.sale_id
JOIN products p ON si.product_id = p.product_id;

SELECT
	s.sale_id,
    s.sale_date,
    st.store_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    p.product_name,
    si.quantity,
    si.unit_price_at_sale,
    si.quantity * si.unit_price_at_sale AS line_total
FROM sales s
JOIN stores st ON s.store_id = st.store_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN sale_items si ON s.sale_id = si.sale_id
JOIN products p ON si.product_id = p.product_id
ORDER BY s.sale_id, p.product_name;

-- ============================================================
-- SECTION 8: OPTIONAL TESTING QUERIES
-- ============================================================

-- Shows all tables in the database
SHOW TABLES;

-- Displays all raw records from each table for checking
SELECT * FROM categories;
SELECT * FROM suppliers;
SELECT * FROM stores;
SELECT * FROM employees;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;
SELECT * FROM sale_items;
SELECT * FROM inventory;

-- Tests the views
SELECT * FROM sales_summary;
SELECT * FROM low_stock_report;

-- Tests the stored procedure using one store name
CALL GetStoreSales('North Plaza Foods');

-- Shows both regular tables and view
SHOW FULL TABLES;