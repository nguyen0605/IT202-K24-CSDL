use ss5;

CREATE TABLE Customer(
	customer_id INT AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    city VARCHAR(255) UNIQUE,
    status ENUM('active','inactive'),
    
    PRIMARY KEY (customer_id)
);

SELECT * FROM customer;

SELECT * FROM Customer WHERE city = 'TP. Hồ Chí Minh';

SELECT * FROM Customer WHERE status = 'active' AND city = 'Hà Nội' ;

SELECT * FROM Customer ORDER BY full_name ASC;