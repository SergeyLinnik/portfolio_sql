WITH customer_ages AS (
    SELECT 
        customer_id,
        gender,
        CASE 
            WHEN date_of_birth IS NOT NULL THEN
                CAST((strftime('%Y', 'now') - strftime('%Y', date_of_birth)) -
                     (strftime('%m-%d', 'now') < strftime('%m-%d', date_of_birth)) AS INTEGER)
            ELSE NULL
        END AS age
    FROM customers
)
SELECT 
    CASE 
        -- Мужчины (приводим к нижнему регистру для надёжности)
        WHEN LOWER(c.gender) = 'муж' AND c.age < 30 THEN 'Мужчины младше 30'
        WHEN LOWER(c.gender) = 'муж' AND c.age BETWEEN 30 AND 45 THEN 'Мужчины 30-45'
        WHEN LOWER(c.gender) = 'муж' AND c.age > 45 THEN 'Мужчины старше 45'
        
        -- Женщины
        WHEN LOWER(c.gender) = 'жен' AND c.age < 30 THEN 'Женщины младше 30'
        WHEN LOWER(c.gender) = 'жен' AND c.age BETWEEN 30 AND 45 THEN 'Женщины 30-45'
        WHEN LOWER(c.gender) = 'жен' AND c.age > 45 THEN 'Женщины старше 45'
        
        -- Пол известен (не пустой), но не распознан (например, опечатка)
        WHEN c.gender IS NOT NULL AND c.gender != '' AND LOWER(c.gender) NOT IN ('муж', 'жен') AND c.age IS NOT NULL 
            THEN 'Пол указан, но не распознан, возраст известен'
        WHEN c.gender IS NOT NULL AND c.gender != '' AND LOWER(c.gender) NOT IN ('муж', 'жен') AND c.age IS NULL 
            THEN 'Пол указан, но не распознан, возраст неизвестен'
        
        -- Пол отсутствует (NULL или пустая строка), возраст известен
        WHEN (c.gender IS NULL OR c.gender = '') AND c.age IS NOT NULL THEN 'Пол не указан, возраст известен'
        -- Пол отсутствует, возраст неизвестен
        WHEN (c.gender IS NULL OR c.gender = '') AND c.age IS NULL THEN 'Нет данных о поле и возрасте'
        
        ELSE 'Прочие неизвестные'
    END AS customer_group,
    SUM(o.price * o.count) AS total_sales,
    ROUND(100.0 * SUM(o.price * o.count) / (SELECT SUM(price * count) FROM pharma_orders), 2) AS share_percent
FROM pharma_orders o
LEFT JOIN customer_ages c ON o.customer_id = c.customer_id
GROUP BY customer_group
ORDER BY total_sales DESC;