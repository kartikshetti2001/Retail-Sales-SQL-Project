-- Total sales per product
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- Top customers by spending
SELECT c.name,
       SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Monthly revenue
SELECT MONTH(o.order_date) AS month,
       SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY MONTH(o.order_date);

-- Top product per category
SELECT category, product_name, total_sales
FROM (
    SELECT p.category,
           p.product_name,
           SUM(oi.quantity * p.price) AS total_sales,
           RANK() OVER (PARTITION BY p.category
                        ORDER BY SUM(oi.quantity * p.price) DESC) AS rnk
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rnk = 1;
