EXPLAIN ANALYZE
SELECT * FROM orders WHERE created_at >= '2025-01-01' AND created_at
    <'2025-02-01';

EXPLAIN ANALYZE
SELECT o.order_id, c.name, p.name, o.amount
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         JOIN products p ON o.product_id = p.product_id
WHERE o.created_at BETWEEN '2025-01-01' AND '2025-01-31';

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);


EXPLAIN ANALYZE
SELECT * FROM orders WHERE created_at >= '2025-01-01' AND created_at
    <'2025-01-03';

EXPLAIN ANALYZE
SELECT o.order_id, c.name, p.name, o.amount
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         JOIN products p ON o.product_id = p.product_id
WHERE o.created_at BETWEEN '2025-01-01' AND '2025-01-03';
