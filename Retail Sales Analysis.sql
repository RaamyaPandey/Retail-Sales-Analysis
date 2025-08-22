
-- Total revenue per invoice 
CREATE TABLE invoice_revenue AS
SELECT invoice,
       SUM(quantity * price) AS revenue
FROM (
    SELECT invoice, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT invoice, quantity, price FROM retail_sales_2010
) AS all_sales
GROUP BY invoice
ORDER BY revenue DESC;

ALTER TABLE invoice_revenue
MODIFY COLUMN revenue DECIMAL(12,2);

Select* from invoice_revenue;

-- Top 10 revenue-generating products
CREATE TABLE top_products AS
SELECT stockcode, description,
       SUM(quantity * price) AS total_revenue
FROM (
    SELECT stockcode, description, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT stockcode, description, quantity, price FROM retail_sales_2010
) AS all_sales
GROUP BY stockcode, description
ORDER BY total_revenue DESC
LIMIT 10;

ALTER TABLE top_products
MODIFY COLUMN total_revenue DECIMAL(12,2);

select*from top_products;

-- Revenue by country
CREATE TABLE revenue_by_country AS
SELECT country,
       SUM(quantity * price) AS total_revenue
FROM (
    SELECT country, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT country, quantity, price FROM retail_sales_2010
) AS all_sales
GROUP BY country
ORDER BY total_revenue DESC;

ALTER TABLE revenue_by_country
MODIFY COLUMN total_revenue DECIMAL(12,2);

Select* from revenue_by_country;

-- Revenue by customer 
CREATE TABLE revenue_by_customer AS
SELECT customer_id,
       SUM(quantity * price) AS total_revenue,
       COUNT(DISTINCT invoice) AS total_orders
FROM (
    SELECT customer_id, invoice, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT customer_id, invoice, quantity, price FROM retail_sales_2010
) AS all_sales
GROUP BY customer_id
ORDER BY total_revenue DESC;

ALTER TABLE revenue_by_customer
MODIFY COLUMN total_revenue DECIMAL(12,2);

Select* from revenue_by_customer;

-- Customer Transaction Join
CREATE TABLE customer_sales_summary AS
SELECT cs.customer_id,
       SUM(cs.quantity * cs.price) AS total_sales,
       SUM(CAST(ct.`ï»¿Transaction Date` AS DOUBLE)) AS total_transaction_amount
FROM (
    SELECT customer_id, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT customer_id, quantity, price FROM retail_sales_2010
) AS cs
LEFT JOIN customer_transaction ct
ON cs.customer_id = ct.`Customer ID`
GROUP BY cs.customer_id
ORDER BY total_sales DESC;

Select* from customer_sales_summary;

-- Top-Selling Products by Quantity

CREATE TABLE top_selling_products AS
SELECT stockcode, description,
       SUM(quantity) AS total_quantity
FROM (
    SELECT stockcode, description, quantity FROM retail_sales_2009
    UNION ALL
    SELECT stockcode, description, quantity FROM retail_sales_2010
) AS all_sales
GROUP BY stockcode, description
ORDER BY total_quantity DESC
LIMIT 10;

Select* from top_selling_products;

-- Monthly Revenue Trend
CREATE TABLE monthly_revenue AS
SELECT YEAR(invoicedate) AS year,
       MONTH(invoicedate) AS month,
       SUM(quantity * price) AS revenue
FROM (
    SELECT 
        STR_TO_DATE(invoicedate, '%d-%m-%Y %H:%i') AS invoicedate,
        CAST(quantity AS DOUBLE) AS quantity,
        CAST(REPLACE(REPLACE(price, '?', ''), ',', '') AS DOUBLE) AS price
    FROM retail_sales_2009
    UNION ALL
    SELECT 
        STR_TO_DATE(invoicedate, '%d-%m-%Y %H:%i') AS invoicedate,
        CAST(quantity AS DOUBLE) AS quantity,
        CAST(REPLACE(REPLACE(price, '?', ''), ',', '') AS DOUBLE) AS price
    FROM retail_sales_2010
) AS all_sales
GROUP BY year, month
ORDER BY year, month;

ALTER TABLE monthly_revenue
MODIFY COLUMN revenue DECIMAL(12,2);

Select* from monthly_revenue;

-- Low-Selling Products
CREATE TABLE low_selling_products AS
SELECT stockcode, description,
       SUM(quantity) AS total_quantity
FROM (
    SELECT stockcode, description, quantity FROM retail_sales_2009
    UNION ALL
    SELECT stockcode, description, quantity FROM retail_sales_2010
) AS all_sales
GROUP BY stockcode, description
HAVING SUM(quantity) < 50
ORDER BY total_quantity ASC;

Select* from low_selling_products;

-- Daily Revenue Trend
CREATE TABLE daily_revenue AS
SELECT invoicedate,
       SUM(quantity * price) AS revenue
FROM (
    SELECT invoicedate, quantity, price FROM retail_sales_2009
    UNION ALL
    SELECT invoicedate, quantity, price FROM retail_sales_2010
) AS all_sales
GROUP BY invoicedate
ORDER BY invoicedate;

ALTER TABLE daily_revenue
MODIFY COLUMN revenue DECIMAL(12,2);

Select* from  daily_revenue;

