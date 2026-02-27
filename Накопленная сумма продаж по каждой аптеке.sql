SELECT 
    pharmacy_name,
    report_date,
    price * count AS daily_sales,
    SUM(price * count) OVER(
        PARTITION BY pharmacy_name 
        ORDER BY report_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM 
    pharma_orders
ORDER BY 
    pharmacy_name, 
    report_date;