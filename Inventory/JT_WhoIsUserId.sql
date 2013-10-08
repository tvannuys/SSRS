/*********************************************************************************
**																				**
** SR# 14749																	**
** Programmer: James Tuttle			Date: 10/04/2013							**
** ---------------------------------------------------------------------------- **
** Purpose:		Key in a USER ID and see the first and last name				**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

AlTER PROC JT_WhoIsUserId 
	@userId AS varchar(10) 

AS
BEGIN
	-- Set to UPPER case since it will come through as case sensitive
	SET @userId = UPPER(@userId)
	
DECLARE @sql varchar(3000) = '


 SELECT LTRIM(SUBSTRING(emname,CHARINDEX('' '', emname)+1, LEN(emname))) AS [First]
	  ,SUBSTRING(emname,1, CHARINDEX('' '',emname)-1)					  AS [Last]
	  
 FROM OPENQUERY(GSFL2K,	
	''SELECT emname

	FROM userxtra ux
	LEFT JOIN prempm em ON ux.usxemp# = em.ememp#
	
	WHERE usxid = ' + '''' + '''' + @userId + '''' + '''' + '
	'')'
EXEC(@sql)

END
GO

-- JT_WhoIsUserId 'JTUt'