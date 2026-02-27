WITH months AS (
    SELECT DISTINCT strftime('%Y-%m', report_date) AS month
    FROM pharma_orders
    WHERE city IN ('Москва', 'Санкт-Петербург')
),
msk_sales AS (
    SELECT 
        strftime('%Y-%m', report_date) AS month,
        SUM(price * count) AS sales_msk
    FROM pharma_orders
    WHERE city = 'Москва'
    GROUP BY month
),
spb_sales AS (
    SELECT 
        strftime('%Y-%m', report_date) AS month,
        SUM(price * count) AS sales_spb
    FROM pharma_orders
    WHERE city = 'Санкт-Петербург'
    GROUP BY month
)
SELECT 
    m.month,
    msk.sales_msk,
    spb.sales_spb,
    CASE 
        WHEN spb.sales_spb IS NULL OR spb.sales_spb = 0 THEN NULL
        ELSE ROUND((msk.sales_msk - spb.sales_spb) * 100.0 / spb.sales_spb, 2)
    END AS percent_diff_msk_vs_spb
FROM months m
LEFT JOIN msk_sales msk ON m.month = msk.month
LEFT JOIN spb_sales spb ON m.month = spb.month
ORDER BY m.month;