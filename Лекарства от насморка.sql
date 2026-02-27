SELECT 
    LOWER(TRIM(drug)) AS drug_name,
    SUM(price * count) AS total_sales,
    ROUND(100.0 * SUM(price * count) / (
        SELECT SUM(price * count)
        FROM pharma_orders
        WHERE LOWER(drug) LIKE '%Аква%'
    ), 2) AS share_percent
FROM pharma_orders
WHERE LOWER(drug) LIKE '%Аква%'
GROUP BY LOWER(TRIM(drug))
ORDER BY total_sales DESC;