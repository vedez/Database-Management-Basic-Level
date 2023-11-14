/* 
 * Project: Pharm858C 
 * This code is an extension for Pharm858C DB > GRANTS
 * 
 * File: GRANTs Management
 * Description: This file containes the permissions for other users to access the procedure addprescription()
 * 
 * Author: Lovely Fernandez (LF)
 * Date: 25/10/2023 
 */


set search_path to "Pharma858C";
show search_path;

create user Lovely with login password 'Lovely';

grant usage on schema "Pharm858C" to lovely;
grant insert on table "Pharm858C".customer to lovely;
grant insert on table "Pharm858C".prescription to lovely;
grant insert on table "Pharm858C".prescription_log to lovely;
grant insert on table "Pharm858C".drug_type to lovely;
grant insert on table "Pharm858C".brand to lovely;

grant select on table "Pharm858C".customer to lovely;
grant select on table "Pharm858C".doctor to lovely;
grant select on table "Pharm858C".prescription to lovely;
grant select on table "Pharm858C".drug_type to lovely;
grant select on table "Pharm858C".brand to lovely;

grant select on table "Pharm858C".prescription_log to lovely; -- Maybe
revoke select on table "Pharm858C".prescription_log from lovely; -- Maybe

grant update on sequence "Pharm858C".customer_cust_id_seq to lovely;
grant update on sequence "Pharm858C".prescription_presc_id_seq to lovely;

GRANT EXECUTE ON PROCEDURE "Pharm858C".addprescription(varchar(50), varchar(200), varchar(50), varchar(200), jsonb, varchar(50)) TO Lovely;
