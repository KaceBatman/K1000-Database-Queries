SELECT T.ID,
C.NAME as CATEGORY,
ifnull(O.FULL_NAME ,'Unassigned') as OWNER_NAME,
S.FULL_NAME as SUBMITTER,
T.CREATED

FROM HD_TICKET T

LEFT JOIN USER O on O.ID = T.OWNER_ID
LEFT JOIN USER S on S.ID = T.SUBMITTER_ID
LEFT JOIN HD_CATEGORY C on C.ID = T.HD_CATEGORY_ID
WHERE DATE(T.CREATED) > NOW() - INTERVAL 7 DAY

ORDER BY CATEGORY, T.CREATED DESC