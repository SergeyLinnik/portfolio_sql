WITH 
-- Временная таблица для аптеки Горздрав
gorzdrav_customers AS (
    SELECT
        c.customer_id,
        c.last_name || ' ' || c.first_name || COALESCE(' ' || c.second_name, '') AS full_name,
        COUNT(*) AS order_count,
        'Горздрав' AS pharmacy_name
    FROM
        pharma_orders po
        JOIN customers c ON po.customer_id = c.customer_id
    WHERE
        po.pharmacy_name = 'Горздрав'
    GROUP BY
        c.customer_id,
        c.last_name,
        c.first_name,
        c.second_name
    ORDER BY
        order_count DESC
    LIMIT 10
),

-- Временная таблица для аптеки Здравсити
zdravsiti_customers AS (
    SELECT
        c.customer_id,
        c.last_name || ' ' || c.first_name || COALESCE(' ' || c.second_name, '') AS full_name,
        COUNT(*) AS order_count,
        'Здравсити' AS pharmacy_name
    FROM
        pharma_orders po
        JOIN customers c ON po.customer_id = c.customer_id
    WHERE
        po.pharmacy_name = 'Здравсити'
    GROUP BY
        c.customer_id,
        c.last_name,
        c.first_name,
        c.second_name
    ORDER BY
        order_count DESC
    LIMIT 10
)

-- Объединение результатов
SELECT * FROM gorzdrav_customers
UNION ALL
SELECT * FROM zdravsiti_customers
ORDER BY
    pharmacy_name,
    order_count DESC;