use ss5;

ALTER TABLE product
ADD sold_quantity INT NOT NULL DEFAULT 0;

SELECT * FROM product ORDER BY sold_quantity DESC LIMIT 10;

SELECT * FROM product ORDER BY sold_quantity DESC LIMIT 5 OFFSET 10;

SELECT * FROM product WHERE price < 2000000 ORDER BY sold_quantity DESC;