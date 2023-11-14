/* 
 * Project: Pharm858C 
 * This code is an extension for Pharm858C DB > Add Prescription Procedure
 * 
 * File: addPrescription.sql : Trigger for add prescription
 * Description: This trigger will run when a new row is added in prescription and will add the name of 
 *  the customer, prescription id, the user/staff who added the prescription and the date.
 * 
 * Author: Lovely Fernandez (LF)
 * Date: 25/10/2023 
 */

-- Creating the audit prescription
drop function audit_prescription cascade; 
CREATE or replace FUNCTION  audit_prescription() 
	RETURNS trigger AS $audit_supplier$
declare
    cID integer;
    pID integer;
    uname varchar(80);
    cdate date;
BEGIN
	select user into strict uname; -- inserting user name into uname
    select now() into strict cdate; -- now() date to cdate
   	
	-- Insert into prescription_log the customer name, prescription id, username and timestamp
	INSERT INTO prescription_log(cust_id, presc_id, add_by_username, add_timestamp) 
	VALUES (new.cust_id, new.presc_id, uname, cdate);
 	return new;
END;
$audit_supplier$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS audit_prescription ON prescription;
CREATE or replace TRIGGER audit_prescription after INSERT OR UPDATE ON prescription
FOR EACH ROW EXECUTE FUNCTION audit_prescription();

-- Checking the presciption log table
select c.cust_id, c.cust_name, p.presc_id, add_by_username, add_timestamp from prescription_log
join customer c using (cust_id)
join prescription p using (presc_id);


