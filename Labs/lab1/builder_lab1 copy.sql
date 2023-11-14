-- Lab 1 Practicing SQL
-- Author L Fernandez
-- Date : 02/10/23


-- a. Get the stock codes and descriptions of all stock items that are selling at aloss (i.e. Unit price < unitCostPrice)
select stock_code StockCode, stock_description Description from b2_stock 
where (unit_price < unitcostprice);

-- b. Get the stock codes and descriptions of all stock items that need to be reordered (i.e. stock_level <= reorder_level).
select stock_code StockCode, stock_description Description from b2_stock 
where (stock_level <= reorder_level);

-- c. List the names of all customers who have no orders.
select customer_name name from b2_corder
right join b2_customer
using (customer_id)
where corderno is NULL;

-- d. Get the description of any stock item that John Flaherty bought.
select customer_name, stock_description from b2_stock
join b2_corderline using (stock_code)
join b2_corder using (corderno)
join b2_customer using (customer_id)
where customer_name = 'John Flaherty'
order by stock_description;

-- e. Get the customer_id for customers who bought stock code A101 or A111
select stock_code, customer_name, customer_id from b2_corder
join b2_customer using (customer_id)
join b2_corderline using (corderno)
where stock_code = 'A101' or stock_code = 'A111';

-- f. Get the customer_id for customers who bought A101 and A111.
select customer_id from b2_corder
join b2_customer using (customer_id)
join b2_corderline using (corderno)
where stock_code = 'A101' or stock_code = 'A111'
group by customer_id having count(customer_id) > 1;

-- g. Get the names of all staff members who took payment from customer Mary Martin.
select staff_name from b2_corder
join b2_staff on (staffpaid = staff_no)
join b2_customer bc using (customer_id)
where customer_name = 'Mary Martin';

-- h. Get the names of all staff members who issued goods supplied by Buckleys.
select distinct staff_name from b2_corder
join b2_staff on (staffissued = staff_no)
join b2_corderline using(corderno)
join b2_stock using (stock_code)
join b2_supplier using (supplier_id)
where supplier_name = 'Buckleys';

-- i. List the supplier_id and supplierorderno for all orders that were delivered late (5 days) or not at all.
select supplier_id, sorderno from b2_supplier
right join b2_sorder using (supplier_id)
where delivereddate is null or (sorderdate < (delivereddate - 5));

-- j. Display the customer order number (corderno), stock_code and cost (unit_price * quantityrequired) of every order line (corderline) on every customer order (corder).
select corderno, stock_code, (unit_price*quantityrequired) cost  from b2_corderline
join b2_stock using (stock_code)
join b2_corder using (corderno);

-- k. Display the customer order number (corderno), and total cost of that order, for every order.
select corderno, sum(unit_price) Total from b2_stock 
join b2_corderline using (stock_code)
group by corderno
order by corderno;