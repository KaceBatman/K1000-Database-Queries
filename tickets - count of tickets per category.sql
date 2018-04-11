SELECT HD_QUEUE.NAME as Queue, HD_CATEGORY.NAME AS Category, 
(SELECT COUNT(ID) FROM HD_TICKET where 
HD_CATEGORY_ID = HD_CATEGORY.ID 
and HD_TICKET.CREATED > DATE_SUB(NOW(), INTERVAL 1 MONTH)GROUP BY HD_CATEGORY.ID) as Tickets, 
USER.FULL_NAME as "Default Owner"
FROM HD_CATEGORY

LEFT JOIN HD_QUEUE on HD_QUEUE.ID = HD_CATEGORY.HD_QUEUE_ID
LEFT JOIN USER on USER.ID = HD_CATEGORY.DEFAULT_OWNER_ID


GROUP BY HD_CATEGORY.ID
ORDER BY HD_QUEUE.NAME, HD_CATEGORY.NAME

