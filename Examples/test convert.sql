
/*select ohodat + 'xxx' as xyz from openquery(gsfl2k,'
select *
from oohead
WHERE ohodat = ''06/23/2011''')
*/
Declare @Q as varchar(1000)

Set @Q = 'select CONVERT(VARCHAR(10), ohodat, 126) + '' '' + CONVERT(VARCHAR(10), ohtime) as TimeStamp,
	ohord# from openquery(gsfl2k,''
select *
from oohead
WHERE ohodat = ''' 2011-06-23''' '')'
 
exec(@Q)
--CONVERT(VARCHAR(10), ohodat, 126) as xyz

-- ' + CONVERT(VARCHAR(10), ohtime,':','')


/*
Select CONVERT(VARCHAR(10), ohtime)
FROM OPENQUERY(gsfl2k,'
select * 
FROM oohead')
*/