SELECT "user@email.com" AS NOTIFY, HD_TICKET.*  FROM ORG1.HD_TICKET
WHERE OWNER_ID = 0
and TIME_CLOSED = "0000-00-00 00:00:00"
and TIME_OPENED > '1 days';