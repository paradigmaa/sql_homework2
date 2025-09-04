DO
$$
    DECLARE
total_rows integer := 50000000; -- Сколько всего строк хотим (50 млн)
        batch_size integer := 100000; -- Размер одной пачки (100k строк)
        batches    integer := total_rows / batch_size; -- Сколько всего пачек
BEGIN
FOR i IN 1..batches
            LOOP
                -- Вставляем одну пачку данных
                INSERT INTO orders (customer_id, product_id, created_at, amount, status)
SELECT
    -- 100 тысяч разных покупателей
    floor(random() * 100000 + 1)::int,
                    -- 500 разных товаров
    floor(random() * 500 + 1)::int,
                    -- Случайная дата за последние 3 года
    NOW() - (random() * (interval '1095 days')),
    -- Сумма от 100 до 10 000 рублей
    (random() * 9900 + 100)::numeric(10, 2),
                    -- Статус заказа
    CASE
        WHEN random() < 0.7 THEN 'completed'
        WHEN random() < 0.9 THEN 'processing'
        ELSE 'cancelled'
        END
FROM generate_series(1, batch_size);

-- Выводим прогресс каждые 5 пачек (каждые 500k строк)
IF i % 5 = 0 THEN
                    RAISE NOTICE 'Вставлено % млн строк', (i * batch_size) / 1000000.0;
END IF;

                -- Фиксируем каждую пачку отдельно
COMMIT;
END LOOP;

        RAISE NOTICE 'Готово! Вставлено всех строк: %', total_rows;
END
$$;


DO
$$
    DECLARE
total_rows integer := 50000000; -- 50 млн строк
        batch_size integer := 100000;   -- Размер пачки
        batches    integer := total_rows / batch_size;
BEGIN
FOR i IN 1..batches LOOP
            INSERT INTO orders (customer_id, product_id, created_at, amount, status)
SELECT
    floor(random() * 100000 + 1)::int,
    floor(random() * 500 + 1)::int,
                -- 80% данных - в 2025 году, 20% - равномерно за 2 года до и после
    CASE
        WHEN random() < 0.8 THEN
            '2025-01-01'::timestamp + (random() * interval '365 days')
                    ELSE
                        NOW() - (random() * (interval '1460 days'))
END,
                (random() * 9900 + 100)::numeric(10, 2),
                CASE
                    WHEN random() < 0.7 THEN 'completed'
                    WHEN random() < 0.9 THEN 'processing'
                    ELSE 'cancelled'
END
FROM generate_series(1, batch_size);

            IF i % 5 = 0 THEN
                RAISE NOTICE 'Вставлено % млн строк', (i * batch_size) / 1000000.0;
END IF;

COMMIT;
END LOOP;
        RAISE NOTICE 'Готово! Вставлено всех строк: %', total_rows;
END
$$;




INSERT INTO customers (name, email)
SELECT
    'Customer_' || seq::TEXT AS name,
    'customer_' || seq || '@example.com' AS email
FROM generate_series(1, 100000) AS seq;

INSERT INTO products (name, price)
SELECT
    'Product_' || seq::TEXT AS name,
    round((random() * 990 + 10)::numeric, 2) AS price  -- Цена от 10 до 1000
FROM generate_series(1, 500) AS seq;