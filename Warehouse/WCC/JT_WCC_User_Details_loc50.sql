ALTER PROC [dbo].[JT_WCC_User_Details_loc50] 
		    @FromDate varchar(10)
		   ,@ToDate varchar(10)
		   ,@CSV varchar(15)
AS
BEGIN
DECLARE @sql varchar(3000) = '
WITH CTE1 AS
(SELECT emname
	  ,LineCount
	  
	  
	FROM OPENQUERY (GSFL2K,''SELECT	emname
						   ,COUNT(rfoitem) AS LineCount	
						   ,rfloc	
								
							FROM rfwillchst wc
							LEFT JOIN userxtra ux ON ux.usxid = wc.rfouser
							LEFT JOIN prempm em on em.ememp# = ux.usxemp#
							
							WHERE  rfodate >= '+ '''' + '''' +  @FromDate + '''' + '''' + '
								AND rfodate <= '+ '''' + '''' + @ToDate + '''' + '''' + '
								AND rpstat = ''''T''''
								AND rfobin# != ''''SHIPD''''
							
							GROUP BY emname
									,rfloc

							
							ORDER BY COUNT(rfoitem)  DESC								
							'')
	/* @CSV to pass in a list of multiple PARMS from the SSRS */
	WHERE rfloc IN(SELECT * FROM dbo.udfCSVToList(''' + @CSV + '''))  )
	
	SELECT  LTRIM(SUBSTRING(emname,CHARINDEX('' '', emname)+1, LEN(emname))) AS First
		   ,SUBSTRING(emname,1, CHARINDEX('' '',emname)-1) AS LAst
	   	   ,SUM(LineCount) AS LineCount
   FROM CTE1 t1
   GROUP BY emname
	


	'
END
EXEC (@sql)
GO

--LTRIM(SUBSTRING(emname,CHARINDEX('' '', emname)+1, LEN(emname))) AS [First]		
--	   	   ,SUBSTRING(emname,1, CHARINDEX('' '',emname)-1)					  AS [Last]	

------->>>    JT_WCC_User_Details_loc50 '11/13/2013','11/13/2013','52,41,57'
