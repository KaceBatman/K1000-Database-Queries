-- Report of both Dell and Apple hardware
-- Includes column for Purchase Date (for Apple based on custom inventory rule)
-- Includes column for replacement date based on chassis type
-- Limited to specific label 
-- Good example of the CASE function
SELECT DISTINCT(MACHINE.NAME), MACHINE.OS_NAME, MACHINE.CS_MANUFACTURER, MACHINE.CS_MODEL, MACHINE.CHASSIS_TYPE,
CASE
    WHEN MACHINE.CS_MANUFACTURER like 'Apple%' THEN STR_TO_DATE(substring_index(substring_index(STR_FIELD_VALUE, '<br/>', 2), ': ', -1), '%m/%d/%Y')
    WHEN MACHINE.CS_MANUFACTURER like 'Dell%' THEN DA.SHIP_DATE
END AS PURCHASE_DATE,
YEAR(CASE
    WHEN MACHINE.CHASSIS_TYPE = "desktop" and MACHINE.CS_MANUFACTURER like 'Apple%' THEN DATE_ADD(STR_TO_DATE(substring_index(substring_index(STR_FIELD_VALUE, '<br/>', 2), ': ', -1), '%m/%d/%Y'), INTERVAL 4 YEAR)
    WHEN MACHINE.CHASSIS_TYPE = "laptop" and MACHINE.CS_MANUFACTURER like 'Apple%' THEN DATE_ADD(STR_TO_DATE(substring_index(substring_index(STR_FIELD_VALUE, '<br/>', 2), ': ', -1), '%m/%d/%Y'), INTERVAL 3 YEAR)
    WHEN MACHINE.CHASSIS_TYPE = "desktop" and MACHINE.CS_MANUFACTURER like 'Dell%' THEN DATE_ADD(DA.SHIP_DATE, INTERVAL 4 YEAR)
    WHEN MACHINE.CHASSIS_TYPE = "laptop" and MACHINE.CS_MANUFACTURER like 'Dell%' THEN DATE_ADD(DA.SHIP_DATE, INTERVAL 3 YEAR)
    ELSE "Unknown"
END) AS REPLACEMENT_YEAR
FROM MACHINE
LEFT JOIN DELL_ASSET DA on MACHINE.BIOS_SERIAL_NUMBER = DA.SERVICE_TAG
LEFT JOIN MACHINE_CUSTOM_INVENTORY on MACHINE.ID = MACHINE_CUSTOM_INVENTORY.ID and SOFTWARE_ID = 86831
JOIN MACHINE_LABEL_JT on MACHINE_LABEL_JT.MACHINE_ID = MACHINE.ID
JOIN LABEL on LABEL.ID = MACHINE_LABEL_JT.LABEL_ID
WHERE (MACHINE.CS_MANUFACTURER like 'Apple%' or MACHINE.CS_MANUFACTURER like 'Dell%')
AND MACHINE.NAME not like '%BC'
AND LABEL.NAME = "Spanish and Portuguese"

ORDER BY PURCHASE_DATE, MACHINE.NAME
