-- Custom inventory rule contains Stata license information
SELECT M.NAME, GROUP_CONCAT(SOFTWARE.DISPLAY_NAME),
case
	when STR_FIELD_VALUE like "%zrdy%" THEN "IC Standalone"
    when STR_FIELD_VALUE like "%5xi1%" THEN "SE Standalone"
    when STR_FIELD_VALUE like "%0tf$%" THEN "IC Lab"
END AS "License Type",
STR_FIELD_VALUE as "License File"

FROM ORG1.MACHINE_CUSTOM_INVENTORY MCI
JOIN MACHINE M on MCI.ID = M.ID
JOIN MACHINE_SOFTWARE_JT on MACHINE_SOFTWARE_JT.MACHINE_ID = M.ID
JOIN SOFTWARE on SOFTWARE.ID = MACHINE_SOFTWARE_JT.SOFTWARE_ID and SOFTWARE.DISPLAY_NAME like "Stata%"
WHERE MCI.SOFTWARE_ID = 103784
GROUP BY M.ID
ORDER BY M.NAME
