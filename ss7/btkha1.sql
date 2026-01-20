CREATE DATABASE ss7;
use ss7;

CREATE TABLE customers(
	customer_id INT auto_increment PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Orders(
	order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_name, email) VALUES
('Nguyen An', 'an.nguyen@gmail.com'),
('Tran Binh', 'binh.tran@gmail.com'),
('Le Chi', 'chi.le@gmail.com'),
('Pham Dung', 'dung.pham@gmail.com'),
('Hoang Giang', 'giang.hoang@gmail.com'),
('Vo Huy', 'huy.vo@gmail.com'),
('Do Khanh', 'khanh.do@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-12-01', 1200000.00),
(1, '2025-12-15',  350000.00),
(2, '2025-12-20',  999999.00),
(3, '2026-01-05',  150000.00),
(4, '2026-01-06', 2500000.00),
(4, '2026-01-10',  450000.00),
(6, '2026-01-11',  890000.00),
(6, '2026-01-18',  210000.00);

SELECT customer_id, customer_name, email
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);