# One of the SQL homeworks which I completed during my studies at HTL Leonding.

Tasks
1. Select all unique product names.
2. Select locations which do have at least one warehouse.
3. Select locations which do not have a warehouse and don’t have a state defined.
4. Select locations in the United States and sort them by their postal code in descending order.
5. Select for every location the name of the warehouse or none if there isn’t one.
6. Select for all products the total quantity stored at all warehouses, sorted by product id.
7. Take the previous query and extend it to only include products with a total quantity between
250 and 350; also replace the product id with the product name and order by quantity
ascending.
8. For every customer with a credit limit > 3000 select the company name and the relation
of its credit limit compared to the average one of all other customers in percent with two
decimal places (e.g. 195.28%).
9. Select those customers which would achieve a credit limit of more than 4500 if their limit
is increased by 30% but which did not have a limit > 4500 to start with.
10. For those contacts which have a phone number starting with ’+86’ set the customer id to
null.
11. Remove those contacts which do not have a customer id set.
12. Add a new order for a customer with at least one item – to make it easier you may assume
that you are the only user performing operations. Then select the newly inserted order and
items

```
/* 1 */ 
SELECT DISTINCT product_name
FROM Products;
/* 2 */ 
Select l.location_id, address, postal_code,city,state,country_id
from Locations l
inner join Warehouses w on (l.location_id = w.location_id);
/* 3 */ 
Select l.location_id, address, postal_code,city,state,country_id
from Locations l
left join Warehouses w on (w.location_id != l.location_id)
where l.state is null;
/* 4 */ 
select location_id, address, postal_code,city,state,country_id
from locations
where country_id = 'US'
order by postal_code desc;
/* 5 */ 
Select w.warehouse_name
from Warehouses w
join locations l on (l.location_id = w.location_id);

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

select * from orders o join order_items oi on (oi.order_id = o.order_id) where o.order_id = 106; ```
