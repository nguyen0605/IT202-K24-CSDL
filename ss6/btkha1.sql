CREATE DATABASE ss6;
use ss6;

CREATE TABLE Customers(
	customer_id INT AUTO_INCREMENT primary key,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE Orders(
	order_id INT auto_increment,
    customer_id INT NOT NULL,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO customers (full_name, city) VALUES
('Nguyễn Văn An', 'TP.HCM'),
('Trần Thị Bích', 'Hà Nội'),
('Lê Minh Khang', 'Đà Nẵng'),
('Phạm Ngọc Lan', 'Cần Thơ'),
('Võ Hoàng Long', 'Hải Phòng');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2026-01-02', 'pending'),
(102, 1, '2026-01-05', 'completed'),
(103, 2, '2026-01-06', 'cancelled'),
(104, 3, '2026-01-10', 'completed'),
(105, 5, '2026-01-12', 'pending');

SELECT order_id, order_date, status, customers.full_name as Customer_name
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

SELECT customers.full_name as Customer_name, COUNT(orders.order_id) AS total_orders
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.full_name;

SELECT customers.full_name as Customer_name, COUNT(orders.order_id) AS total_orders
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.full_name
HAVING COUNT(orders.order_id) > 0;