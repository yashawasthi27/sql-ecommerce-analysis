-- ============================================================
--  E-Commerce Sales Analysis — Business Intelligence Queries
--  Author  : Yash Awasthi
--  Tool    : PostgreSQL
--  Dataset : ~200 customers | 36 products | 400 orders | 1000+ items
-- ============================================================


-- ============================================================
-- Q1. Total Revenue, Orders & Customers Overview
--     Concept: Aggregate Functions, COUNT DISTINCT
-- ============================================================
SELECT
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    COUNT(DISTINCT o.customer_id)                     AS total_customers,
    SUM(oi.quantity * oi.unit_price)                  AS gross_revenue,
    ROUND(AVG(o.total_amount), 2)                     AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'cancelled';


-- ============================================================
-- Q2. Monthly Revenue Trend (2023 - 2024)
--     Concept: DATE_TRUNC, GROUP BY, ORDER BY
-- ============================================================
SELECT
    TO_CHAR(DATE_TRUNC('month', order_date), 'Mon YYYY') AS month,
    COUNT(order_id)                                       AS total_orders,
    ROUND(SUM(total_amount), 2)                           AS monthly_revenue
FROM orders
WHERE status != 'cancelled'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);


-- ============================================================
-- Q3. Month-over-Month Revenue Growth (%)
--     Concept: CTE, Window Function (LAG)
-- ============================================================
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)   AS month,
        ROUND(SUM(total_amount), 2)       AS revenue
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY 1
)
SELECT
    TO_CHAR(month, 'Mon YYYY')                                      AS month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)                              AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2
    )                                                               AS mom_growth_pct
FROM monthly
ORDER BY month;


-- ============================================================
-- Q4. Top 10 Best-Selling Products by Revenue
--     Concept: JOIN, GROUP BY, ORDER BY, LIMIT
-- ============================================================
SELECT
    p.product_name,
    c.category_name,
    SUM(oi.quantity)                      AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN orders      o  ON oi.order_id  = o.order_id
JOIN products    p  ON oi.product_id = p.product_id
JOIN categories  c  ON p.category_id = c.category_id
WHERE o.status != 'cancelled'
GROUP BY p.product_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- Q5. Revenue & Sales Share by Category
--     Concept: CTE, Window Function (SUM OVER), Percentage
-- ============================================================
WITH cat_sales AS (
    SELECT
        c.category_name,
        SUM(oi.quantity)                          AS units_sold,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM order_items oi
    JOIN orders     o ON oi.order_id  = o.order_id
    JOIN products   p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    WHERE o.status != 'cancelled'
    GROUP BY c.category_name
)
SELECT
    category_name,
    units_sold,
    revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER (), 2) AS revenue_share_pct
FROM cat_sales
ORDER BY revenue DESC;


-- ============================================================
-- Q6. Top 3 Products per Category (by Revenue)
--     Concept: CTE, Window Function (RANK / DENSE_RANK)
-- ============================================================
WITH product_revenue AS (
    SELECT
        c.category_name,
        p.product_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY c.category_name
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS rank_in_category
    FROM order_items oi
    JOIN orders     o ON oi.order_id  = o.order_id
    JOIN products   p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    WHERE o.status != 'cancelled'
    GROUP BY c.category_name, p.product_name
)
SELECT category_name, rank_in_category, product_name, revenue
FROM product_revenue
WHERE rank_in_category <= 3
ORDER BY category_name, rank_in_category;


-- ============================================================
-- Q7. Top 10 Customers by Lifetime Value (CLV)
--     Concept: JOIN, GROUP BY, Aggregates
-- ============================================================
SELECT
    cu.customer_id,
    cu.full_name,
    cu.city,
    COUNT(DISTINCT o.order_id)            AS total_orders,
    ROUND(SUM(o.total_amount), 2)         AS lifetime_value,
    ROUND(AVG(o.total_amount), 2)         AS avg_order_value
FROM customers  cu
JOIN orders     o ON cu.customer_id = o.customer_id
WHERE o.status != 'cancelled'
GROUP BY cu.customer_id, cu.full_name, cu.city
ORDER BY lifetime_value DESC
LIMIT 10;


-- ============================================================
-- Q8. Customer Segmentation — One-Time vs Repeat Buyers
--     Concept: Subquery, CASE, GROUP BY
-- ============================================================
SELECT
    customer_type,
    COUNT(*)                                  AS customer_count,
    ROUND(AVG(total_orders), 1)               AS avg_orders,
    ROUND(AVG(total_spent), 2)                AS avg_lifetime_value
FROM (
    SELECT
        customer_id,
        COUNT(order_id)       AS total_orders,
        SUM(total_amount)     AS total_spent,
        CASE
            WHEN COUNT(order_id) = 1 THEN 'One-Time Buyer'
            WHEN COUNT(order_id) BETWEEN 2 AND 4 THEN 'Repeat Buyer'
            ELSE 'Loyal Customer'
        END AS customer_type
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id
) seg
GROUP BY customer_type
ORDER BY avg_lifetime_value DESC;


-- ============================================================
-- Q9. Churned Customers (No Orders in Last 6 Months)
--     Concept: Subquery, NOT IN, MAX, Date Filtering
-- ============================================================
SELECT
    cu.customer_id,
    cu.full_name,
    cu.city,
    MAX(o.order_date)   AS last_order_date,
    COUNT(o.order_id)   AS total_orders
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.status != 'cancelled'
GROUP BY cu.customer_id, cu.full_name, cu.city
HAVING MAX(o.order_date) < CURRENT_DATE - INTERVAL '6 months'
ORDER BY last_order_date;


-- ============================================================
-- Q10. City-wise Revenue Performance
--      Concept: JOIN, GROUP BY, ORDER BY
-- ============================================================
SELECT
    cu.city,
    cu.state,
    COUNT(DISTINCT o.order_id)             AS total_orders,
    COUNT(DISTINCT cu.customer_id)         AS unique_customers,
    ROUND(SUM(o.total_amount), 2)          AS total_revenue,
    ROUND(AVG(o.total_amount), 2)          AS avg_order_value
FROM customers cu
JOIN orders    o ON cu.customer_id = o.customer_id
WHERE o.status != 'cancelled'
GROUP BY cu.city, cu.state
ORDER BY total_revenue DESC;


-- ============================================================
-- Q11. Running Total Revenue (Cumulative) by Month
--      Concept: CTE, Window Function (SUM OVER with ORDER)
-- ============================================================
WITH monthly_rev AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        ROUND(SUM(total_amount), 2)     AS monthly_revenue
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY 1
)
SELECT
    TO_CHAR(month, 'Mon YYYY')                                AS month,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2)     AS cumulative_revenue
FROM monthly_rev
ORDER BY month;


-- ============================================================
-- Q12. Order Status Distribution & Cancellation Rate
--      Concept: GROUP BY, CASE, Percentage Calculation
-- ============================================================
SELECT
    status,
    COUNT(*)                                         AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM orders
GROUP BY status
ORDER BY order_count DESC;
