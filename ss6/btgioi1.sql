use ss6;

-- Tính tổng doanh thu theo từng ngày
SELECT order_date, SUM(total_amount) AS total_by_day
FROM orders
GROUP BY order_date;

-- Tính số lượng đơn hàng theo từng ngày
SELECT order_date, Count(order_id) AS total_order
FROM orders
GROUP BY order_date;

-- Chỉ hiển thị các ngày có doanh thu > 10.000.000
SELECT order_date, SUM(total_amount) AS total_by_day
FROM orders
GROUP BY order_date
HAVING total_by_day >10000000;

SELECT * FROM orders;