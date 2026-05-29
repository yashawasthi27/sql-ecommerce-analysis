# 🛒 Retail Sales Performance Analysis — SQL Project

**Tool:** PostgreSQL | **Author:** Yash Awasthi | **Domain:** E-Commerce / Retail Analytics

---

## 📌 Project Overview

This project performs end-to-end business analysis on a simulated Indian e-commerce dataset using **PostgreSQL**. The goal is to extract actionable insights on revenue trends, customer behavior, product performance, and churn — answering real business questions a Data Analyst would face on the job.

---

## 🗃️ Database Schema

```
customers     → 200 customers across 12 Indian cities
categories    → 6 product categories
products      → 36 products with pricing
orders        → 400 orders (2022–2024)
order_items   → 1000+ line items
```

**Entity Relationship:**
```
customers ──< orders ──< order_items >── products >── categories
```

---

## ❓ Business Questions Answered

| # | Question | SQL Concepts |
|---|----------|-------------|
| 1 | Overall revenue, orders & customer overview | Aggregates, COUNT DISTINCT |
| 2 | Monthly revenue trend (2022–2024) | DATE_TRUNC, GROUP BY |
| 3 | Month-over-Month revenue growth % | CTE, Window Function (LAG) |
| 4 | Top 10 best-selling products by revenue | JOIN, GROUP BY, LIMIT |
| 5 | Revenue & sales share by category | CTE, SUM OVER (%) |
| 6 | Top 3 products per category | CTE, DENSE_RANK OVER PARTITION |
| 7 | Top 10 customers by lifetime value | JOIN, GROUP BY, Aggregates |
| 8 | Customer segmentation (one-time / repeat / loyal) | Subquery, CASE WHEN |
| 9 | Churned customers (no orders in 6 months) | HAVING, INTERVAL, Date Filter |
| 10 | City-wise revenue performance | JOIN, GROUP BY |
| 11 | Cumulative revenue by month | CTE, SUM OVER (running total) |
| 12 | Order status & cancellation rate | GROUP BY, COUNT OVER (%) |

---

## 💡 Key Insights

- 📈 **Top Category:** Electronics drove the highest revenue, contributing ~28% of total sales
- 🏆 **Best-Selling Product:** Wireless Bluetooth Earbuds led in both units sold and revenue
- 👥 **Customer Segments:** ~42% one-time buyers — significant re-engagement opportunity
- 📉 **Churn:** Identified customers with no orders in 6+ months for targeted re-marketing
- 🌆 **Top Cities:** Mumbai, Bengaluru, and Delhi accounted for 40%+ of total revenue
- 📅 **Growth Trend:** Consistent MoM revenue growth observed through 2023–2024

---

## 🚀 How to Run

**Step 1 — Create the database in pgAdmin:**
```sql
CREATE DATABASE ecommerce_analysis;
```

**Step 2 — Run schema file:**
```
Open schema.sql in pgAdmin Query Tool → Run (F5)
```

**Step 3 — Load the data:**
```
Open data.sql → Run (F5)
```

**Step 4 — Run analysis queries:**
```
Open analysis.sql → Run queries one by one (select + F5)
```

---

## 🛠️ Skills Demonstrated

- Complex **JOINs** (multi-table)
- **CTEs** (Common Table Expressions)
- **Window Functions** — `LAG`, `RANK`, `DENSE_RANK`, `SUM OVER`, `COUNT OVER`
- **Subqueries** — inline and correlated
- **Date Functions** — `DATE_TRUNC`, `TO_CHAR`, `INTERVAL`
- **Aggregations** — `SUM`, `AVG`, `COUNT DISTINCT`
- **Business KPIs** — CLV, MoM Growth, Churn Rate, Cancellation Rate

---

## 📁 Project Structure

```
📦 sql-ecommerce-analysis
 ┣ 📄 schema.sql       → Table definitions (DDL)
 ┣ 📄 data.sql         → Seed data (~1400 rows)
 ┣ 📄 analysis.sql     → 12 business analysis queries
 ┗ 📄 README.md        → Project documentation
```

---

## 🔗 Connect

**LinkedIn:** [linkedin.com/in/yashawasthi27](https://linkedin.com/in/yashawasthi27)<br>
**GitHub:** [github.com/yashawasthi27](https://github.com/yashawasthi27)<br>
**Portfolio:** [yashawasthi27.github.io/Portfolio](https://yashawasthi27.github.io/Portfolio/)
