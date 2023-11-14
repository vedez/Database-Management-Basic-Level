/* Practice Sheet in Week 2 PwP - Lecture */
-- Author: L Fernandez | zedev
-- Date: 03/10/2023

-- 1. Select each supplier name and the stock_code and stock_description of each stock item that supplier supplies.
select supplier_name, stock_code, stock_description 
from b2_stock 
join b2_supplier using (supplier_id)
order by supplier_name;

-- 2. Select each supplier name and average unit_price of stock that supplier supplies.
select supplier_name, avg(unit_price) average
from b2_stock 
join b2_supplier using (supplier_id)
group by supplier_name;

-- 3. Select each supplier name, the stock_code, stock_description, unit_price and average unit_price for that supplier for each stock item that supplier supplies
select supplier_name, stock_code, stock_description, unit_price, 
avg(unit_price) over (partition by supplier_name)
from b2_stock 
join b2_supplier using (supplier_id);

-- 4. Select each supplier name, the stock_code, stock_description, unit_price and rank of that price for that supplier for each stock item at supplier supplies.
select supplier_name, stock_code, stock_description, unit_price,
rank() over (partition by supplier_name order by unit_price)
from b2_stock 
join b2_supplier using (supplier_id);

-- 5. As above, but dense_rank()
select supplier_name, stock_code, stock_description, unit_price,
dense_rank() over (partition by supplier_name order by unit_price)
from b2_stock 
join b2_supplier using (supplier_id);


-- 6. Use lag() and lead() to compare item prices from a supplier.
select supplier_name, stock_description, unit_price,
-- using lag()
lag (unit_price, 1) over (partition by supplier_name order by unit_price) "Previous Price",
(unit_price - lag (unit_price, 1) over (partition by supplier_name order by unit_price)) "Difference (Previous)",
-- using lead()
lead (unit_price, 1) over (partition by supplier_name order by unit_price) "Next Price",
(unit_price - lead (unit_price, 1) over (partition by supplier_name order by unit_price)) "Difference (Next)"
from b2_stock 
join b2_supplier using (supplier_id);


-- 7. Use first_value() and last_value() to find highest and lowest unit_price per supplier.
SELECT supplier_name, stock_description, unit_price,
-- using first_value()
FIRST_VALUE (unit_price) over (PARTITION BY supplier_name ORDER BY unit_price) AS lowest_price_per_group,
-- using last_value()
LAST_VALUE (unit_price) OVER (PARTITION BY supplier_name ORDER BY unit_price 
RANGE BETWEEN UNBOUNDED preceding AND UNBOUNDED FOLLOWING) AS highest_price_per_group
FROM b2_stock
JOIN b2_supplier USING (supplier_id);
