--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--
-- Receipts of POs by Lines NON Roll Goods
-- Directs Excluded
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
						INNER JOIN transfer xe
							ON (ir.irco = xe.itico
								AND ir.irloc = xe.itiloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
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
							AND ir.irsrc = ''H''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal != 0
							AND im.imfcrg != ''Y''
						')
GROUP BY usxemp#, emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE.[User], CTE.Name, CTE.NonPlt AS Lines
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
							  irooco,
							  iroolo,
							  irord#,
							  irrel#,
							  iritem,
							  irqty,
							  irky,
							  irsrc,
							  iruser,
							  itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irooco = xe.itco
								AND ir.iroolo = xe.itloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
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
							AND ir.irsrc = ''H''
							AND xe.itxpal != 0
							AND im.imfcrg != ''Y''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
						/*	AND ux.usxemp# = 1776	*/
							AND ir.iritem = ''GR0440B''
						')
*/
--------------------------------------------------------------------------------------------