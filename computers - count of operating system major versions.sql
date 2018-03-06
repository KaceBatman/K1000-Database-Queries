SELECT FAMILY, MAJOR_VERSION, MINOR_VERSION, 
SUM((SELECT COUNT(ID) FROM MACHINE WHERE OS_ID = OPERATING_SYSTEMS.ID)) as COMPUTERS
FROM ORG1.OPERATING_SYSTEMS
GROUP BY FAMILY, MAJOR_VERSION, MINOR_VERSION
HAVING COMPUTERS > 0