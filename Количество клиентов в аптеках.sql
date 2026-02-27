SELECT 
    po.pharmacy_name,
    COUNT(DISTINCT po.customer_id) AS unique_customers
FROM 
    pharma_orders po
    JOIN customers c ON po.customer_id = c.customer_id
GROUP BY 
    po.pharmacy_name
ORDER BY 
    unique_customers DESC;