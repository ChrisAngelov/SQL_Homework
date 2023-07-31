/* 1 */ 
SELECT DISTINCT product_name FROM Products;
/* 2 */ 
Select l.location_id, address, postal_code,city,state,country_id from Locations l inner join Warehouses w on (l.location_id = w.location_id);
/* 3 */ 
Select l.location_id, address, postal_code,city,state,country_id from Locations l left join Warehouses w on (w.location_id != l.location_id) where l.state is null;
/* 4 */ 
select location_id, address, postal_code,city,state,country_id from locations where country_id = 'US' order by postal_code desc;
/* 5 */ 
Select w.warehouse_name from Warehouses w join locations l on (l.location_id = w.location_id);

/* 6*/ 
SELECT p.product_id, p.product_name, SUM(i.quantity) AS total_quantity
FROM products p
LEFT JOIN inventories i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;

/* 7 */ 
SELECT p.product_name, SUM(i.quantity) AS total_quantity
FROM products p
LEFT JOIN inventories i ON p.product_id = i.product_id
GROUP BY p.product_name
HAVING SUM(i.quantity) BETWEEN 250 AND 350
ORDER BY total_quantity ASC;
/* 8 */
SELECT 
    c1.name AS company_name,
    ROUND(((c1.credit_limit - avg_credit_limit) / avg_credit_limit) * 100, 2) AS credit_limit_relation
FROM
    customers c1
CROSS JOIN
    (SELECT AVG(credit_limit) AS avg_credit_limit FROM customers WHERE credit_limit <= 3000) avg_table
WHERE
    c1.credit_limit > 3000;

/* 9 */ 
select * from customers where credit_limit  < 4500 and credit_limit * 1.3 > 4500; 

/* 10 */ 
Update contacts set customer_id = NULL where phone like '+86%';
/* 11 */ 
DELETE FROM Contacts WHERE customer_id is null;
/* 12 */ 
INSERT INTO Orders VALUES (106,2,'pending', 5, '01-NOV-17');
INSERT INTO Order_items VALUES (106,20,21, 6, 200);

select * from orders o join order_items oi on (oi.order_id = o.order_id) where o.order_id = 106; 
