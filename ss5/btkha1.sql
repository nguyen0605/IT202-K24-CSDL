USE ss5;

CREATE TABLE product(
	product_id INT AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status ENUM('active', 'inactive'),
    
    PRIMARY KEY (product_id)
);

SELECT * FROM product;

SELECT * FROM product WHERE status = 'active';

SELECT * FROM product WHERE price > 1000000;

SELECT * FROM product WHERE status = 'active' ORDER BY price ASC;
