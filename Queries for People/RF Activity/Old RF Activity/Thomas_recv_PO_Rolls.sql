--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--
-- Receipts of POs by Roll Good Lines
-- Directs excluded
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


 WITH CTE AS (
	--SELECT COUNT(usxemp#) OVER(PARTITION BY usxemp#) AS PltCnt,  usxemp# AS [User], emname AS Name
	SELECT COUNT(*) AS NonPlt,
		usxemp# AS [User],
		emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#,
							  emname
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
							AND ir.irdate >= ''2011-10-01''
							AND ir.irdate <= ''2011-10-31'' 
							AND ir.irsrc = ''P''
							AND ir.irdirs != ''Y''
							AND im.imfcrg = ''Y''	
							

						')
GROUP BY usxemp#, emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE.[User], CTE.Name, CTE.NonPlt AS PO_Roll_Goods
FROM CTE
GROUP BY CTE.[User], CTE.NonPlt ,CTE.Name
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT irco,
							  irloc,
							  iritem,
							  irky,
							  irsrc,
							  iruser
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
							AND ir.irdate >= ''2011-10-01''
							AND ir.irdate <= ''2011-10-31'' 
							AND ir.irsrc = ''P''
							AND ir.irdirs != ''Y''
							AND im.imfcrg = ''Y''
							/*AND ux.usxemp# = 1626 */
						')
*/
--------------------------------------------------------------------------------------------