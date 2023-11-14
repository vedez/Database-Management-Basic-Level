-- Advanced queries exercises for week 2 lab
-- Author: L Fernandez
-- Date: 03/10/2023
-- Disclaimer, code is untested due to re-doing these exercises on a personal pc
-- which is not connected to college servers therefore no DB. 

-- Set Up (This is commented as set up was done on college systems)
-- alter role "c2030xxxx" with password 'example';
-- set search_path = "sample"; -- tables exists in sample schema

-- 1. Name staff members who sold notepads
select staff_name from sh_sale 
join sh_staff using (staff_no)
join sh_stock using (stock_code)
where stock_name = 'notepads';

-- 2. Name staff members that sold nothing.
select staff_name from sh_sale
join sh_staff using (staff_no)
where quantity is null;

-- 3. Name staff members that sold both notepads and chocolate bars
select staff_name from sh_sale
join sh_staff using (staff_no)
join sh_stock using (stock_code)
where stock_name = 'notepads'
intersect -- aka AND
select staff_name from sh_sale
join sh_staff using (staff_no)
join sh_stock using (stock_code)
where stock_name = 'chocolate bars';

/*Sample Used fr. crisp template*/
select CN_NAME from crispeater where CP_NAME = 'Cheese and Onion'
INTERSECT -- AKA and
select CN_NAME from crispeater where CP_NAME = 'Buffalo';

-- 4. Name staff members that sold either notepads or chocolate bars, but not both
-- This can be simplified by using a view
-- Logic: Or - And = Or but not both aka XOR
select staff_name from sh_sale
	join sh_staff using (staff_no)
	join sh_stock using (stock_code)
		where stock_name = 'notepads'
union -- aka or
select staff_name from sh_sale
	join sh_staff using (staff_no)
	join sh_stock using (stock_code)
		where stock_name = 'chocolate bars'
except( -- not including (-)
select staff_name from sh_sale
	join sh_staff using (staff_no)
	join sh_stock using (stock_code)
		where stock_name = 'notepads'
intersect -- aka AND
select staff_name from sh_sale
	join sh_staff using (staff_no)
	join sh_stock using (stock_code)
		where stock_name = 'chocolate bars'
); -- closing except() and query ;

-- 5. Name staff members that only sold notepads.
select staff_name from sh_sale
join sh_staff using (staff_no)
join sh_stock using (stock_code)
where stock_name = 'notepads'
except
select staff_name from sh_sale
join sh_staff using (staff_no)
join sh_stock using (stock_code)
where stock_name <> 'notepads';

/*Sample Used fr. crisp template*/
select CN_NAME from crispeater where CP_NAME = 'Cheese and Onion'
except
select CN_NAME from crispeater where CP_NAME <> 'Cheese and Onion';


-- 6. Name staff members that have sold all stock.
select staff_name from sh_staff A
	where not exists (select * from sh_stock B
		where not exists (select * from sh_sale C
			where c.staff_no = a.staff_no and c.stock_code = b.stock_code));

/*Sample Used fr. crisp template*/
select CN_NAME from consumer A where not exists
  (select * from crisp_type B where not exists 
  (select * from has_eaten X
    where X.consumerid = A.consumerid
  and X.crispkey = B.crispkey));

-- 7. Name staff members that have sold all stock supplied by 'Cadbury'.
select staff_name from sh_staff A
	where not exists (select * from sh_stock B
		where not exists (select * from sh_sale C
			where c.staff_no = a.staff_no and c.stock_code = b.stock_code))
	join sh_sale B using (b.staff_no)
	join sh_stock C using (c.stock_code)
	join sh_supplier D using (d.supplier_id)
	where sname = 'Cadbury';

-- 8. Using a windows function, select the stock_name, category description (CatDescription), and price of each stock item, and average price of stock items in that category.
select stock_name, catdescription, price,
avg (price) over (partition by catdescription)
from sh_stock join sh_category using (catcode);

-- 9.  Using the 'lag' function, display each stock name, its category description, price, the price of the previous stock item in that category (ordered by price) and the difference between the price of the previous item and of this item. See 'Sample Windows Functions.sql' and this week's slides (Slide headed 'LAG') for inspiration.
select stock_name, catdescription, price,
lag (price, 1) over (partition by catdescription order by price) "Previous",
price - lag (price, 1) over (partition by catdescription order by price)
from sh_stock join sh_category using (catcode);








