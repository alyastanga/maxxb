-- ==========================================
-- DATABASE GRANTS: MAXXBRANDS ERP SYSTEM
-- Purpose: Resolve ORA-01031 (Insufficient Privileges)
-- Instruction: Run this script as a DBA (e.g., SYS or SYSTEM)
-- ==========================================

-- 1. Core Session & Space Privileges
GRANT CREATE SESSION TO MAXXBRANDS;
ALTER USER MAXXBRANDS QUOTA UNLIMITED ON USERS;
GRANT UNLIMITED TABLESPACE TO MAXXBRANDS;

-- 2. Object Creation Privileges
GRANT CREATE TABLE TO MAXXBRANDS;
GRANT CREATE SEQUENCE TO MAXXBRANDS;
GRANT CREATE VIEW TO MAXXBRANDS;
GRANT CREATE TRIGGER TO MAXXBRANDS;
GRANT CREATE PROCEDURE TO MAXXBRANDS;

-- 3. Advanced Management (Optional but recommended for ERP owners)
GRANT ALTER ANY TABLE TO MAXXBRANDS;
GRANT DROP ANY TABLE TO MAXXBRANDS;
GRANT CREATE ANY INDEX TO MAXXBRANDS;

-- 4. Audit & Metadata Access
GRANT SELECT ANY DICTIONARY TO MAXXBRANDS;

-- NOTE: If you are logged in as a *different* user and trying to 
-- create objects *inside* the MAXXBRANDS schema, you need:
-- GRANT CREATE ANY TABLE TO [your_user];
-- GRANT CREATE ANY SEQUENCE TO [your_user];

COMMIT;

-- VERIFICATION CMD:
-- SELECT * FROM user_sys_privs;
