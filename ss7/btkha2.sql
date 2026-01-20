use ss7;

CREATE TABLE products (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  name  VARCHAR(120) NOT NULL,
  price DECIMAL(12,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE order_items (
  order_id   INT NOT NULL,
  product_id INT NOT NULL,
  quantity   INT NOT NULL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, price) VALUES
('USB 32GB', 120000.00),
('Chuột Gaming', 350000.00),
('Bàn phím cơ', 990000.00),
('Tai nghe', 450000.00),
('Webcam', 600000.00),
('SSD 500GB', 1250000.00),
('Balo laptop', 300000.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 2),
(101, 2, 1),
(102, 3, 1),
(103, 2, 2),
(103, 4, 1),
(104, 6, 1),
(105, 1, 1);

SELECT id, name, price 
FROM products
WHERE id IN (SELECT product_id FROM order_items);