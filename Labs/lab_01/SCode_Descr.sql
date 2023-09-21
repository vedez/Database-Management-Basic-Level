-- Creating Queries for DB on Builder
-- Author: L Fernandez (zedev)
-- Date: 20/09/23

-- First Submission

-- NOTES: Docker and DBeaver used throughout these labs

-- Get the stock codes and descriptions of all stock items that are making a profit (unit price > cost price).
Select stock_code StockCode, Stock_Description StockDescription from b2_stock where Unit_Price > UnitCostPrice;


-- List the names of all suppliers who supply no stock items.
Select Supplier_Name SupplierName, stock_level StockLevel from B2_SUPPLIER full outer join b2_stock using (supplier_ID) where stock_level is null; 

-- Get the customer_name for customers who bought either a 'Phillips screwdriver', or a 'Box of 6" screws'
select customer_name CustomerName, stock_description StockDescription from b2_customer, b2_stock where stock_description = 'Phillips screwdriver' or stock_description = 'Box of 6" screws';

-- Second Submission