# One of the SQL homeworks which I completed during my studies at HTL Leonding.

1. Select all unique product names.
      ```SELECT DISTINCT product_name FROM Products; ``` 
3. Select locations which do have at least one warehouse.
      ```Select l.location_id, address, postal_code,city,state,country_id from Locations l inner join Warehouses w on (l.location_id = w.location_id);```

4. Select locations which do not have a warehouse and don’t have a state defined.
      ``` Select l.location_id, address, postal_code,city,state,country_id from Locations l left join Warehouses w on (w.location_id != l.location_id) where l.state is null;```

5. Select locations in the United States and sort them by their postal code in descending order.
      ```Select w.warehouse_name from Warehouses w join locations l on (l.location_id = w.location_id);```

8. Select for every location the name of the warehouse or none if there isn’t one.
9. Select for all products the total quantity stored at all warehouses, sorted by product id.
10. Take the previous query and extend it to only include products with a total quantity between
250 and 350; also replace the product id with the product name and order by quantity
ascending.
11. For every customer with a credit limit > 3000 select the company name and the relation
of its credit limit compared to the average one of all other customers in percent with two
decimal places (e.g. 195.28%).
12. Select those customers which would achieve a credit limit of more than 4500 if their limit
is increased by 30% but which did not have a limit > 4500 to start with.
13. For those contacts which have a phone number starting with ’+86’ set the customer id to
null.
14. Remove those contacts which do not have a customer id set.
15. Add a new order for a customer with at least one item – to make it easier you may assume
that you are the only user performing operations. Then select the newly inserted order and
items.
