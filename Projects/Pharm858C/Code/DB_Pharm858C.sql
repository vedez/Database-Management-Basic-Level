-- Project: Pharm858C
-- Description: 
--     This file includes the code for creating the tables and populating them with data for Pharm858C database.
--
-- Authors: Lovely Fernandez (LF) & Paris Le (PL)
-- Date: 25/10/2023

commit;

-- LF: Responsible for creating the tables and adding restrictions on the attributes
-- Start of Creation Table

-- Dropping tables to make sure the table does not already exsit
drop table drug_type;
drop table sales;
drop table product;
drop table brand;
drop table supplier;
drop table prescription_log;
drop table prescription;
drop table doctor;
drop table customer;


-- Printing all Tables
SELECT *
FROM customer c
JOIN prescription p ON c.cust_id = p.cust_id
JOIN doctor d ON p.doc_id = d.doc_id
JOIN drug_type dt ON p.drug_type = dt.drug_name
JOIN brand b ON dt.brand_id = b.brand_id
JOIN supplier s ON b.supp_id = s.supp_id
JOIN product pr ON b.brand_id = pr.brand_id
JOIN sales sa ON p.presc_id = sa.presc_id;

SELECT *
FROM customer c
LEFT JOIN prescription p ON c.cust_id = p.cust_id
LEFT JOIN doctor d ON p.doc_id = d.doc_id
LEFT JOIN drug_type dt ON p.drug_type = dt.drug_name
LEFT JOIN brand b ON dt.brand_id = b.brand_id
LEFT JOIN supplier s ON b.supp_id = s.supp_id
LEFT JOIN product pr ON b.brand_id = pr.brand_id
LEFT JOIN sales sa ON p.presc_id = sa.presc_id
order by cust_name;


-- Creating the tables
-- 1. Customer Table
create table customer(
cust_id serial primary key, 
cust_name varchar(50) not null,
med_card varchar(50),
cust_add varchar(200)
);

-- 2. Doctor Table
create table doctor(
doc_id serial primary key,
doc_name varchar(50) not null,
doc_add varchar(200)
);

-- 3. Prescription Table
create table prescription(
presc_id serial primary key,
cust_id integer not null references customer,
doc_id integer not null references doctor,
drug_type varchar(50) not null,
dosage integer not null,
duration integer not null
);

-- 4. Supplier Table
create table supplier(
supp_id serial primary key,
supp_name varchar(50) not null,
supp_add varchar(200)
);

-- 5. Brand Table
create table brand(
brand_id serial primary key,
supp_id integer not null references supplier,
brand_name varchar(50) not null
);

-- 6. Product Table
create table product(
stock_code serial primary key,
brand_id integer not null references brand,
product_cost integer not null,
prod_description varchar(250),
pack_size integer not null, 
product_price integer not null
);

-- 7. Sales Table
create table sales(
presc_id integer not null references prescription,
stock_code integer not null references product,
prod_quantity integer not null,
purch_date date,
purch_time time
);

-- 8. Drug Type Table
create table drug_type(
brand_id integer not null references brand,
drug_name varchar(50) not null,
dispense_inst varchar(250) not null,
use_instruct varchar(250) not null
);

create table prescription_log (
  cust_id integer not null references customer,
  presc_id integer not null references prescription,
  add_by_username varchar(80),
  add_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- Example 1: Adding a Customer (Paris)
--insert into customer (cust_name, med_card, cust_add) values ('Paris', 'A3933239402', '123 Imaginary Lane');
--select * from customer;

-- LF: End of Creation Table


-- PL: Responsible for populating the table with data.
-- Start of Population
-- 1. Customer Table
insert into customer (cust_name, med_card, cust_add) values
('Paris', 'A3933239402', '17 Grafton Street'),
('Lovely', 'A3933239403', '10 Kevin Street'),
('Keith', 'A3933239404', '29 Leinster Road'),
('Luna', 'A3933239405', '12 St Agnes Road'),
('Patricia', 'A3933239406', '37 Merville Road');
select * from customer;

--delete from customer where cust_id = 12;
--DELETE FROM customer;
--SELECT setval('customer_cust_id_seq', 1, false);

-- 2. Doctor Table
insert into doctor (doc_name, doc_add) values 
('Dr. Hector','15 Foxborough Walk'),
('Dr. Lucas','30 Stillorgan Village'),
('Dr. Roxanne','89 Grafton Street');
select * from doctor;

--DELETE FROM doctor;
--SELECT setval('doctor_doc_id_seq', 1, false);

-- 3. Prescription Table
insert into prescription (cust_id, doc_id, drug_type, dosage, duration) values
(1, 1, 'Painkiller', 2, 7),
(2, 2, 'Amoxicillin', 1, 10),
(3, 3, 'Antihistamine', 3, 14),
(4, 1, 'Paracetamol', 2, 5),
(5, 2, 'Tramadol', 1, 7);
select * from prescription;

--insert into prescription (cust_id, doc_id, drug_type, dosage, duration) values (2, 1, 'Painkiller', 2, 7);

-- 4. Supplier Table
insert into supplier (supp_name, supp_add) values
('Health Pharmaceuticals', '29 Lucan Village'),
('Matter Medical Supplies', '45 Blackrock Street'),
('Bristol Myers Supplies', '40 Baggot Street'),
('AstraZeneca', '62 Anglesea'),
('Pfizer', '76 Grange Castle Road');
select * from supplier;

-- 5. Brand Table
insert into brand (supp_id, brand_name) values
(1, 'PainAway'),
(2, 'AmoxiCure'),
(3, 'AllerRelief'),
(4, 'Paracetamol'),
(5, 'Tramadol');
select * from brand;

--insert into brand (supp_id, brand_name) values (10, 'Panadol');

-- 6. Product Table
insert into product (brand_id, product_cost, prod_description, pack_size, product_price) values
(1, 10, 'Painkiller Tablets', 30, 15),
(2, 8, 'Antibiotic Capsules', 20, 12),
(3, 5, 'Allergy Relief Syrup', 15, 9),
(4, 6, 'Paracetamol Tablets', 25, 8),
(5, 12, 'Tramadol Capsules', 10, 20);
select * from product;

-- 7. Sales Table --LF: TO BE FIXED--
insert into sales (presc_id, stock_code, prod_quantity, purch_date, purch_time) values
(1, 1, 5, '2023-10-15', '15:30:00'),
(2, 2, 3, '2023-10-16', '10:45:00'),
(3, 3, 7, '2023-10-17', '14:15:00'),
(4, 4, 11, '2023-10-18', '11:20:00'),
(5, 5, 24, '2023-10-19', '16:45:00');
select * from sales;

-- 8. Drug Type Table
insert into drug_type (brand_id, drug_name, dispense_inst, use_instruct) values
(1, 'Painkiller', 'Take with water', 'For pain relief'),
(2, 'Amoxicillin', 'Take with food', 'For bacterial infections'),
(3, 'Antihistamine', 'Shake well before use', 'For allergy symptoms'),
(4, 'Paracetamol', 'Take with water', 'For pain and fever'),
(5, 'Tramadol', 'Take with or without food', 'For moderate to severe pain');
select * from drug_type;

--insert into drug_type (brand_id, drug_name, dispense_inst, use_instruct) values (26, 'Paracetamol', 'Example', 'Example');
-- PL: End of Population

