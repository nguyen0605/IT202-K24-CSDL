use ss6;

ALTER TABLE orders
ADD total_amount decimal(10,2);

UPDATE orders SET total_amount = 200000  WHERE order_id = 101;
UPDATE orders SET total_amount = 150000  WHERE order_id = 102;
UPDATE orders SET total_amount = 176000  WHERE order_id = 103;
UPDATE orders SET total_amount = 515000  WHERE order_id = 104;
UPDATE orders SET total_amount = 1250000 WHERE order_id = 105;

-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
SELECT customers.customer_id, customers.full_name, SUM(orders.total_amount) AS total_spent
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;	

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
SELECT customers.customer_id, customers.full_name, MAX(orders.total_amount) AS max_order_value
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;	

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
SELECT customers.customer_id, customers.full_name, SUM(orders.total_amount) AS total_spent
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
ORDER BY total_spent DESC;
