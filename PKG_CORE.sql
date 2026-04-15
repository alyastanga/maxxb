CREATE OR REPLACE PACKAGE MAXXBRANDS.PKG_CORE AS
    -- ==========================================
    -- MAXXBRANDS ERP: CORE UTILITIES
    -- Centralizing system parameters and resolution
    -- ==========================================

    -- Returns the ID of the location marked as 'is_default' (The Warehouse)
    FUNCTION GET_DEFAULT_LOCATION_ID RETURN NUMBER RESULT_CACHE;

    -- Returns a dedicated System Admin or Default Manager ID for automated logs
    FUNCTION GET_SYSTEM_USER_ID RETURN NUMBER RESULT_CACHE;

END PKG_CORE;
/

CREATE OR REPLACE PACKAGE BODY MAXXBRANDS.PKG_CORE AS

    FUNCTION GET_DEFAULT_LOCATION_ID RETURN NUMBER RESULT_CACHE IS
        v_id NUMBER;
    BEGIN
        SELECT location_id INTO v_id 
        FROM MAXXBRANDS.locations 
        WHERE is_default = 'Y' 
        AND ROWNUM = 1;
        
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RETURN NULL;
    END GET_DEFAULT_LOCATION_ID;

    FUNCTION GET_SYSTEM_USER_ID RETURN NUMBER RESULT_CACHE IS
        v_id NUMBER;
    BEGIN
        -- Find the primary administrator or system account
        SELECT employee_id INTO v_id 
        FROM MAXXBRANDS.employees 
        WHERE last_name = 'Delacruz' -- Peter Delacruz (Admin)
        AND ROWNUM = 1;
        
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 1; -- Fallback to first ID
    END GET_SYSTEM_USER_ID;

END PKG_CORE;
/
