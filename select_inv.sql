SELECT 
    itm.item_id AS "Item ID",
    itm.item_code AS "Item Code",
    itm.item_name AS "Item Name",
    typ.name AS "Type",
    itm.dimension AS "Dimension",
    loc.name AS "Location",
    -- Stock Level Calculation
    CASE 
        WHEN inv.qty_on_hand <= 0 THEN 'EMERGENCY'
        WHEN inv.qty_on_hand <= inv.min_threshold THEN 'CRITICAL'
        WHEN inv.qty_on_hand <= (inv.min_threshold * 1.5) THEN 'LOW'
        ELSE 'OPTIMAL'
    END AS "Stock Level",
    inv.qty_on_hand AS "Quantity",
    itm.srp AS "Price (SRP)"
FROM MAXXBRANDS.inventory inv
JOIN MAXXBRANDS.items itm ON inv.item_id = itm.item_id
JOIN MAXXBRANDS.item_types typ ON itm.type_id = typ.type_id
JOIN MAXXBRANDS.locations loc ON inv.location_id = loc.location_id
ORDER BY "Location" ASC, "Item Name" ASC;
