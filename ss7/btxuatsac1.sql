use ss7;

SELECT customer_id, customer_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_per_customer)
        FROM (
            SELECT SUM(total_amount) AS total_per_customer
            FROM orders
            GROUP BY customer_id
        ) t
    )
);

