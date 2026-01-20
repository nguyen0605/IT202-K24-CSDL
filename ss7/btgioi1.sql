use ss7;

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-12-01', 1200000.00),
(2, '2025-12-03',  350000.00),
(3, '2025-12-10',  999999.00),
(1, '2025-12-15',  150000.00),
(4, '2026-01-05', 2500000.00),
(2, '2026-01-08',  450000.00);

SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE total_amount > (SELECT avg(total_amount) FROM orders);