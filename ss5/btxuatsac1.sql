use ss5;

SELECT * FROM Orders ORDER BY order_date DESC LIMIT 5;

SELECT * FROM Orders ORDER BY order_date DESC LIMIT 5 OFFSET 5;

SELECT * FROM Orders WHERE status <> 'cancelled';