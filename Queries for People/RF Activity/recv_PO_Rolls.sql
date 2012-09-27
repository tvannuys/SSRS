--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Receipts of POs by Roll Good Lines
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = 'POs Recvd by Rolls'
GO

 WITH CTE AS (
	SELECT COUNT(iritem) AS Lines
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,'POs Recvd by Rolls' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''2011-10-15'' 
						    AND ir.irdate  <= current_date 
							AND ir.irsrc = ''P''
							AND ir.irdirs != ''Y''
							AND im.imfcrg = ''Y''			
						')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
		,CTE.RFDate

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT irco
							  ,irloc
							  ,iritem
							  ,irky
							  ,irsrc
							  ,iruser
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''2011-10-15''
						    AND ir.irdate  <= current_date  
							AND ir.irsrc = ''P''
							AND ir.irdirs != ''Y''
							AND im.imfcrg = ''Y''
							/*AND ux.usxemp# = 1626 */
						')
*/
--------------------------------------------------------------------------------------------