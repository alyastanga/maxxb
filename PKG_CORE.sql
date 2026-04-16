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
        WHERE location_code = 'LOC-WHS-01' 
        AND ROWNUM = 1;
        
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RETURN NULL;
    END GET_DEFAULT_LOCATION_ID;

    FUNCTION GET_SYSTEM_USER_ID RETURN NUMBER RESULT_CACHE IS
        v_id NUMBER;
    BEGIN
        -- Find the primary administrator or system account user_id
        SELECT u.user_id INTO v_id 
        FROM MAXXBRANDS.users u
        JOIN MAXXBRANDS.employees e ON u.employee_id = e.employee_id
        WHERE e.last_name = 'Dela Cruz' -- Peter Dela Cruz (Admin)
        AND ROWNUM = 1;
        
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Fallback: return the first user_id available
            SELECT MIN(user_id) INTO v_id FROM MAXXBRANDS.users;
            RETURN COALESCE(v_id, 1);
    END GET_SYSTEM_USER_ID;

END PKG_CORE;
/
