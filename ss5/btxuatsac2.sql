use ss5;

SELECT * FROM product WHERE status = 'active' and price BETWEEN 1000000 AND 3000000;

SELECT * FROM product ORDER BY price ASC;

SELECT * FROM product LIMIT 10 OFFSET 0;
SELECT * FROM product LIMIT 10 OFFSET 10;