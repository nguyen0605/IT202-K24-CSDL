use ss7;

INSERT INTO customers (customer_name, email) VALUES
('Nguyễn An', 'an.nguyen@gmail.com'),
('Trần Bình', 'binh.tran@gmail.com'),
('Lê Chi', 'chi.le@gmail.com'),
('Phạm Dũng', 'dung.pham@gmail.com'),
('Hoàng Giang', 'giang.hoang@gmail.com'),
('Võ Huy', 'huy.vo@gmail.com'),
('Đỗ Khánh', 'khanh.do@gmail.com'),
('Bùi Minh', 'minh.bui@gmail.com');

INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-12-01', 1200000.00),
(102, 2, '2025-12-03',  350000.00),
(103, 3, '2025-12-10',  999999.00),
(104, 1, '2025-12-15',  150000.00),
(105, 4, '2026-01-05', 2500000.00),
(106, 2, '2026-01-08',  450000.00),
(107, 6, '2026-01-12',  780000.00),
(108, 8, '2026-01-18', 1600000.00);

SELECT customer_name, (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id) AS total_order
FROM customers;