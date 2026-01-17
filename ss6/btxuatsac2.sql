use ss6;

SELECT p.product_name, SUM(oi.quantity) AS total_sold, SUM(oi.quantity * p.price) AS total_price, AVG(p.price)
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_price DESC
LIMIT 5