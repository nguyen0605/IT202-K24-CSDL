use ss5;

CREATE TABLE Orders(
	order_id INT auto_increment,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

SELECT * FROM Orders WHERE status = 'completed';

SELECT * FROM Orders WHERE total_amount > 5000000;

SELECT * FROM Orders ORDER BY order_date DESC LIMIT 5;

SELECT * FROM Orders WHERE status = 'completed' ORDER BY total_amount DESC;