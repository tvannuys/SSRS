USE [GartmanReport]
GO


/*********************************************************************************
**																				**
** SR# 14499																	**
** Programmer: James Tuttle	Date:09/25/2013										**
** ---------------------------------------------------------------------------- **
** Purpose:																		**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/


ALTER PROC [dbo].[JT_WCC_User_Details_loc50] 
		    @FromDate varchar(10)
		   ,@ToDate varchar(10)
		   ,@CSV varchar(15)
AS
BEGIN
DECLARE @sql varchar(3000) = '
SELECT LTRIM(SUBSTRING(emname,CHARINDEX('' '', emname)+1, LEN(emname))) AS [First]
	  ,SUBSTRING(emname,1, CHARINDEX('' '',emname)-1)					  AS [Last]
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
	WHERE rfloc IN(SELECT * FROM dbo.udfCSVToList(''' + @CSV + ''')) 
	
	'
END
EXEC (@sql)
GO
------->>>    JT_WCC_User_Details_loc50 '09/30/2013','09/30/2013','42'

/*
------------------------- DETAILS -----------------------------------------------

SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT	rfloc
									 
									,emname
									,rfoord#
									,rfoitem	
								
							FROM rfwillchst wc
							LEFT JOIN userxtra ux ON ux.usxid = wc.rfouser
							LEFT JOIN prempm em on em.ememp# = ux.usxemp#
							
							WHERE rfloc = 60
								AND rfodate >= ''09/30/2013''
								AND rfodate <= ''09/30/2013''
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							
							
							
							ORDER BY emname
								
					')
------------------------------------------------------------------------------------------ */
