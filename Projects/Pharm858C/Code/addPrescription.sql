/* 
 * Project: Pharm858C 
 * This code is an extension for Pharm858C DB
 * 
 * File: Adding a prescription (George) (addPrescription.sql)
 * Description: Takes the prescription and adds it into the Prescription book (table). If the customer does not exist, a new
 * profile is created. The drugs are added on the customer's file and if the drug alreay exists, it will not add a duplicate. As well as, 
 * if the doctor provided a drug brand instead of a drug type, George will access the drug book (table) for the drug type.
 * 
 * Author: Lovely Fernandez (LF)
 * Date: 25/10/2023 
 */

-- Creating a procedure that will add the prescription into the Prescription Book (table)
drop procedure addprescription;

create or replace procedure addprescription(
	cName customer.cust_name%TYPE,
    cAddress customer.cust_add%type,
    dName doctor.doc_name%TYPE,
    dAddress doctor.doc_add%type,
	drugs jsonb,
	medcard customer.med_card%type default null
)
AS $$
declare
	cID integer;
	drID integer;
	drug_record jsonb;
	drug_brand text;
	drug_type text default null;
    drug_dosage INTEGER;
    drug_days INTEGER;
begin
	-- Check if customer does not exist, if not, create customer and return customer id
	if not customer_Exists(cName)then
        INSERT INTO customer (cust_name, med_card, cust_add)
    	VALUES (cName, medCard, cAddress)
    	RETURNING cust_id INTO cID;
    ELSE
        -- If customer exists, return customer id to cID
        SELECT cust_id INTO cID FROM customer WHERE cust_name = cName;
    END IF;
   
   	-- Check if doctor exists
   	IF not doctor_Exists(dName) THEN
    	RAISE EXCEPTION 'Doctor does not exist';
    ELSE
        -- If doctor exists, return customer id
        SELECT doc_id INTO drID FROM doctor WHERE doc_name = dName;
    END IF;
	
	-- Adding the drugs
	FOR drug_record IN SELECT * FROM jsonb_array_elements(drugs)
    loop	    
	    -- Extract drug details from the JSON object
	    drug_brand := drug_record->>'drug_brand'; -- Extract the drug brand
        drug_type := drug_record->>'drug_type'; -- Extract the drug type
        drug_dosage := (drug_record->>'dosage')::INTEGER; -- Extract the dosage and convert to integer
        drug_days := (drug_record->>'days')::INTEGER; -- Extract the number of days and convert to integer
        
        -- If the brand name is provided instead of drug type, check drug type
        if drug_type is null then
        	select drug_name into drug_type
        	from drug_type dt 
        	join brand b using (brand_id)
        	where drug_brand = brand_name; 
        	
        	if not drug_exists_drugbook(drug_type) then
	        	raise exception 'No drug available for the Brand';  
	        end if;
        end if;
       
        -- If the customer has a new drug, add it else it exists previously, dont add it
   		if not drug_exists_cust(drug_type, cID) then
   			-- Adding the drug on customer's prescription
	        INSERT INTO prescription (cust_id, doc_id, drug_type, dosage, duration)
	        VALUES (cID, drID, drug_type, drug_dosage, drug_days);
	    else 
	    	raise notice 'Drug already exists';
	    end if;
    END LOOP;
   
exception 
when others then 
	RAISE INFO 'Error Name:%',SQLERRM;
	RAISE INFO 'Error State:%', SQLSTATE;
END;
$$ LANGUAGE plpgsql;

-- Testing Code
-- Call <procedure>('Customer Name', 'Customer Adress', 'Doctor Name', 'Doctor Address', 'List the Drugs [{},{},{}]', 'Medical Card')
CALL addprescription('Zaa5', 'Avenue 3', 'Dr. Lucas', 'Street 34', '[{"drug_brand": "PainAway", "dosage": "8", "days": 23}]', 'E7073020664');
CALL addprescription('MaT', 'Avenue 3', 'Dr. Lucas', 'Street 34', '[{"drug_type": "Paracetamol", "dosage": "8", "days": 23}]', 'E7073020664');

select * from prescription_log;

select presc_id, cust_name, cust_add, doc_name, doc_add, brand_name, drug_type, dosage, duration, med_card 
from prescription p
join customer c using (cust_id)
join doctor d using (doc_id)
join drug_type dt on (dt.drug_name = p.drug_type)
join brand using (brand_id);

select * from customer;




