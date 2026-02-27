SELECT
    po.customer_id,
    c.last_name || ' ' || c.first_name || ' ' || COALESCE(c.second_name, '') AS full_name,
    po.report_date,
    po.drug,
    po.price * po.count AS order_amount,
    SUM(po.price * po.count) OVER(
        PARTITION BY po.customer_id
        ORDER BY po.report_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_amount
FROM
    pharma_orders po
    JOIN customers c ON po.customer_id = c.customer_id
ORDER BY
    po.customer_id,
    po.report_date;