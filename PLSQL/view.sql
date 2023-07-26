CREATE OR REPLACE VIEW STOCK_VALUE_BY_COUNTRY AS
SELECT c.COUNTRY_ID as Country, COUNT(w.WAREHOUSE_ID)  as Warehouses, tsv.total_stock_value as Total_stock_value, ROUND(((100tsv.total_stock_value)/(SELECT SUM(total_stock_value) From total_stock_value)),2) as Percents FROM COUNTRIES c
LEFT OUTER JOIN LOCATIONS l on l.COUNTRY_ID = c.COUNTRY_ID
LEFT OUTER JOIN WAREHOUSES w on w.LOCATION_ID = l.LOCATION_ID
LEFT OUTER JOIN total_stock_value tsv on tsv.warehouse_id = w.warehouse_id
GROUP BY c.COUNTRY_ID, tsv.total_stock_value
ORDER BY warehouses desc
;

CREATE OR REPLACE VIEW total_stock_value AS
Select  i.warehouse_id, SUM((i.quantityp.list_price)) as total_stock_value from inventories i 
left join products p on(p.product_id=i.product_id)
group by i.warehouse_id
;