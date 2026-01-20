use ss7;

SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
	SELECT AVG(total_per_customer)
    FROM (
        SELECT SUM(total_amount) AS total_per_customer
        FROM orders
        GROUP BY customer_id
    ) t
)
