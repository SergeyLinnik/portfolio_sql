SELECT 
    pharmacy_name,
    SUM(price * count) AS total_revenue
FROM 
    pharma_orders
GROUP BY 
    pharmacy_name
HAVING 
    SUM(price * count) > 1800000
ORDER BY 
    total_revenue DESC;