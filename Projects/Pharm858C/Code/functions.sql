/* 
 * Project: Pharm858C 
 * This code is an extension for Pharm858C DB > Add Prescription Procedure
 * 
 * File: 
 *  1. Checking if customer exists (customer_exists())
 *  2. Checking if doctor exists (doctor_exists())
 *  3. Checking if drug exists in customer's file (drug_exists_cust())
 *  4. Checking if drug exists in drug book aka table (drug_exists_drugbook())
 *
 * Description: Checking if the entities used exists in the appropriate tables
 * Note: Files are taken from source code of the database
 *
 * Author: Lovely Fernandez (LF)
 * Date: 25/10/2023 
 */

-- 1. Checking if customer exists (customer_exists())
CREATE OR REPLACE FUNCTION "Pharm858C".customer_exists(p_cust_name character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_cust_name customer.cust_name%type;
BEGIN
    -- Retrieve customer name
    SELECT cust_name INTO strict v_cust_name FROM customer WHERE cust_name = p_cust_name LIMIT 1;
    RETURN true;
EXCEPTION 
    WHEN NO_DATA_FOUND then
        RETURN false;
END;
$function$
;

-- 2. Checking if doctor exists (doctor_exists())
CREATE OR REPLACE FUNCTION "Pharm858C".doctor_exists(p_doc_name character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_doc_name doctor.doc_name%type;
BEGIN
    SELECT doc_name INTO strict v_doc_name FROM doctor WHERE doc_name = p_doc_name LIMIT 1;
    RETURN true;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RETURN false;
END;
$function$
;

-- 3. Checking if drug exists in customer's file (drug_exists_cust())
CREATE OR REPLACE FUNCTION "Pharm858C".drug_exists_cust(drug character varying, c_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_drug_type prescription.drug_type%type default null;
   	v_cust_id customer.cust_id%type;
BEGIN
    SELECT drug_type INTO strict v_drug_type FROM prescription
    join customer using (cust_id)
    where drug_type = drug and cust_id = c_id limit 1;
    RETURN true;
EXCEPTION 
    WHEN NO_DATA_FOUND then
        RETURN false;
END;
$function$
;

-- 4. Checking if drug exists in drug book aka table (drug_exists_drugbook())
CREATE OR REPLACE FUNCTION "Pharm858C".drug_exists_drugbook(drug character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_drug_type prescription.drug_type%type;
begin
    SELECT drug_type INTO strict v_drug_type FROM prescription
    where drug_type = drug
   	limit 1;
    RETURN true;
EXCEPTION 
    WHEN NO_DATA_FOUND then
        RETURN false;
END;
$function$
;

