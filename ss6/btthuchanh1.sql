CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,        -- Mã khách hàng
    customer_name VARCHAR(100),            -- Tên khách hàng
    email         VARCHAR(100),            -- Email
    city          VARCHAR(50)               -- Thành phố
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,          -- Mã sản phẩm
    product_name VARCHAR(100),              -- Tên sản phẩm
    price        DECIMAL(12,2),              -- Giá bán
    category     VARCHAR(50)                -- Loại sản phẩm
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,            -- Mã đơn hàng
    customer_id INT,                        -- Khách hàng đặt
    order_date  DATE,                       -- Ngày đặt hàng
    status      VARCHAR(30),                -- Trạng thái đơn
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,          -- Mã chi tiết đơn
    order_id      INT,                      -- Mã đơn hàng
    product_id    INT,                      -- Mã sản phẩm
    quantity      INT,                      -- Số lượng
    unit_price    DECIMAL(12,2),             -- Giá bán tại thời điểm đặt
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Nguyen Van An',  'an@gmail.com',   'Ha Noi'),
(2, 'Tran Thi Binh',  'binh@gmail.com', 'Da Nang'),
(3, 'Le Van Cuong',   'cuong@gmail.com','Ho Chi Minh'),
(4, 'Pham Thi Dao',   'dao@gmail.com',  'Ha Noi'),
(5, 'Hoang Van Em',   'em@gmail.com',   'Can Tho');

INSERT INTO products VALUES
(1, 'Laptop Dell',          20000000, 'Electronics'),
(2, 'iPhone 15',            25000000, 'Electronics'),
(3, 'Tai nghe Bluetooth',    1500000, 'Accessories'),
(4, 'Chuột không dây',        500000, 'Accessories'),
(5, 'Bàn phím cơ',           2000000, 'Accessories');

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 'Completed'),
(102, 2, '2025-01-06', 'Completed'),
(103, 3, '2025-01-07', 'Completed'),
(104, 1, '2025-01-08', 'Completed'),
(105, 4, '2025-01-09', 'Completed'),
(106, 5, '2025-01-10', 'Completed'),
(107, 2, '2025-01-11', 'Completed'),
(108, 3, '2025-01-12', 'Completed');

INSERT INTO order_items VALUES
-- Đơn 101
(1, 101, 1, 1, 20000000),
(2, 101, 3, 2, 1500000),

-- Đơn 102
(3, 102, 2, 1, 25000000),
(4, 102, 4, 1, 500000),

-- Đơn 103
(5, 103, 5, 2, 2000000),
(6, 103, 3, 1, 1500000),

-- Đơn 104
(7, 104, 1, 1, 20000000),
(8, 104, 5, 1, 2000000),

-- Đơn 105
(9, 105, 4, 3, 500000),

-- Đơn 106
(10, 106, 3, 5, 1500000),

-- Đơn 107
(11, 107, 2, 1, 25000000),
(12, 107, 3, 2, 1500000),

-- Đơn 108
(13, 108, 1, 1, 20000000),
(14, 108, 4, 2, 500000);

-- Cau 1:  Liệt kê danh sách các đơn hàng kèm theo tên khách hàng đã đặt đơn
SELECT order_id, customer_id
FROM orders;

-- Cau 2: Cho biết mỗi đơn hàng gồm những sản phẩm nào, kèm theo số lượng của từng sản phẩm.
SELECT o.order_id, p.product_name, oi.quantity
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
ORDER BY o.order_id;

-- Cau 3: Tính tổng số đơn hàng hiện có trong hệ thống.
SELECT COUNT(*) AS total_order
FROM orders;

-- Cau 4:  Tính tổng doanh thu của toàn bộ hệ thống.
SELECT SUM(quantity * unit_price) AS total_revenue FROM order_items;

-- Cau 5:  Cho biết tổng tiền của mỗi đơn hàng.
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS total_order_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- Cau 6:  Cho biết tổng số tiền mà mỗi khách hàng đã chi tiêu.
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name;

-- Cau 7:  Tính doanh thu theo từng sản phẩm.
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS total_product_revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- Cau 8:  Liệt kê các khách hàng có tổng chi tiêu lớn hơn 5.000.000.
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name
HAVING total_spent > 5000000;

-- Cau 9: Liệt kê các sản phẩm có tổng số lượng bán ra lớn hơn 100.
SELECT p.product_name, SUM(oi.quantity) as total_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity) >100;

-- Cau 10: Cho biết các thành phố có số lượng đơn hàng lớn hơn 5.
SELECT c.city, COUNT(o.order_id) AS total_sold_by_city
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) > 5;