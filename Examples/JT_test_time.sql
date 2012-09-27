
-- Test CURRENT TIME to order time

SELECT *
FROM OPENQUERY (GSFL2K, '
SELECT  ohord#, cast(REPLACE( cast((current_time - 1 HOURS) AS varchar(8)), ''.'', '''' ) as integer )   AS cur_time, 
	ohtime AS order_time 
FROM oohead
WHERE ohloc = 12
	AND ohdate = CURRENT_DATE


')
WHERE order_time < cur_time
--FETCH FIRST 5 ROWS ONLY




