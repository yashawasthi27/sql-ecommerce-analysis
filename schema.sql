-- ============================================================
--  E-Commerce Analytics Database — Schema
--  Author : Yash Awasthi
--  Tool   : PostgreSQL
-- ============================================================

DROP TABLE IF EXISTS order_items, orders, products, categories, customers;

CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) UNIQUE NOT NULL,
    city            VARCHAR(80),
    state           VARCHAR(80),
    registration_date DATE
);

CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL
);

CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    product_name  VARCHAR(150) NOT NULL,
    category_id   INT REFERENCES categories(category_id),
    price         NUMERIC(10,2) NOT NULL,
    stock_qty     INT DEFAULT 0
);

CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers(customer_id),
    order_date    DATE NOT NULL,
    status        VARCHAR(30),
    total_amount  NUMERIC(10,2)
);

CREATE TABLE order_items (
    item_id       SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    product_id    INT REFERENCES products(product_id),
    quantity      INT NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL
);
