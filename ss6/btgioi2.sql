use ss6;

CREATE TABLE products(
	product_id INT auto_increment,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    
    PRIMARY KEY (product_id)
);

CREATE TABLE order_items(
	order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('Bàn phím cơ',        950000),
('Chuột gaming',       550000),
('Tai nghe',           750000),
('Màn hình 24 inch',  3200000),
('SSD 1TB',           2100000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 2),  -- 2 bàn phím cơ
(101, 2, 1),  -- 1 chuột
(102, 4, 1),  -- 1 màn hình
(103, 5, 2),  -- 2 SSD
(104, 3, 3),  -- 3 tai nghe
(105, 4, 2),  -- 2 màn hình
(105, 1, 1);  -- 1 bàn phím

-- Hiển thị mỗi sản phẩm đã bán được bao nhiêu sản phẩm
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM products P
INNER JOIN order_items oi 
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Tính doanh thu của từng sản phẩm
SELECT p.product_id, p.product_name, SUM(oi.quantity * p.price) AS revenue
FROM products P
INNER JOIN order_items oi 
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
SELECT p.product_id, p.product_name, SUM(oi.quantity * p.price) AS revenue
FROM products P
INNER JOIN order_items oi 
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING revenue > 5000000;