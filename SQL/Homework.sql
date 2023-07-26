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

/* 6 not working
select p.product_id, sum(i.quantity) from products p inner join Inventories i on (p.product_id = i.product_id)
group by p.product_id, sum(i.quantity);*/ 

/* 7 not working due to this*/ 

/* 8 ????*/
select name from customers where credit_limit > 3000;
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