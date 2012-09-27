

SELECT *
FROM OPENQUERY(GSFL2K,
'SELECT smno as Number
, smname as Name
FROM SALESMAN
')