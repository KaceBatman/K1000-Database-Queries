-- Pulls data from Dell asset tables
-- Uses maximum warranty end date as some machines have multiple warranties
-- Restricted to a specific label 
SELECT DISTINCT(MACHINE.NAME),
MACHINE.OS_NAME,
MACHINE.CS_MODEL,
MACHINE.CS_MANUFACTURER,
DA.SHIP_DATE AS "Ship Date",
MAX(DW.END_DATE) AS "Warranty End Date",
DW.SERVICE_LEVEL_DESCRIPTION as "Service Level"
FROM MACHINE
LEFT JOIN DELL_ASSET DA on MACHINE.BIOS_SERIAL_NUMBER = DA.SERVICE_TAG
LEFT JOIN DELL_WARRANTY DW on MACHINE.BIOS_SERIAL_NUMBER = DW.SERVICE_TAG
JOIN MACHINE_LABEL_JT on MACHINE_LABEL_JT.MACHINE_ID = MACHINE.ID
JOIN LABEL on LABEL.ID = MACHINE_LABEL_JT.LABEL_ID
WHERE MACHINE.CS_MANUFACTURER like 'Dell%'
and LABEL.NAME = "Library Services"
GROUP BY MACHINE.NAME
ORDER BY `Warranty End Date`, MACHINE.NAME
