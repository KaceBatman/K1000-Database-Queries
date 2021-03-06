SELECT * FROM 
(SELECT MACHINE.NAME, MACHINE.CS_MANUFACTURER,
CASE 
    WHEN MACHINE.CS_MANUFACTURER like 'Apple%' THEN P.DATE_FIELD_VALUE
    WHEN MACHINE.CS_MANUFACTURER like 'Dell%' THEN DA.SHIP_DATE
END AS PURCHASE_DATE,
CASE 
    WHEN MACHINE.CS_MANUFACTURER like 'Apple%' THEN SUBSTR(W.STR_FIELD_VALUE, LOCATE("WarrantyExpires", W.STR_FIELD_VALUE)+24, 10)
    WHEN MACHINE.CS_MANUFACTURER like 'Dell%' THEN MAX(DW.END_DATE)
END AS WARRANTY_DATE,

group_concat(distinct LABEL.NAME separator ",") AS LABELS,
group_concat(distinct PARENTLABEL.NAME separator ",") AS PARENTLABELS
FROM ORG1.MACHINE
LEFT JOIN MACHINE_LABEL_JT ON (MACHINE_LABEL_JT.MACHINE_ID = MACHINE.ID)  
LEFT JOIN LABEL ON (LABEL.ID = MACHINE_LABEL_JT.LABEL_ID  AND LABEL.TYPE <> 'hidden')
LEFT JOIN LABEL_LABEL_JT on LABEL_LABEL_JT.CHILD_LABEL_ID = LABEL.ID
LEFT JOIN LABEL PARENTLABEL on (PARENTLABEL.ID = LABEL_LABEL_JT.LABEL_ID AND LABEL.TYPE <> 'hidden')
LEFT JOIN DELL_ASSET DA on MACHINE.BIOS_SERIAL_NUMBER = DA.SERVICE_TAG
LEFT JOIN DELL_WARRANTY DW on MACHINE.BIOS_SERIAL_NUMBER = DW.SERVICE_TAG
LEFT JOIN MACHINE_CUSTOM_INVENTORY P on MACHINE.ID = P.ID and SOFTWARE_ID = 25152
LEFT JOIN MACHINE_CUSTOM_INVENTORY W on W.ID = MACHINE.ID and W.SOFTWARE_ID = 59336
GROUP BY MACHINE.ID) as MACHINESWITHLABELS
WHERE PARENTLABELS not like '%Upgrade Status%'

ORDER BY NAME