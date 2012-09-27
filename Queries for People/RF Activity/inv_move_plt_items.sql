--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Move items by pallet tag
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
 DELETE WarehouseProductivity 
WHERE Metric = 'Inv Move Items by Plt Tag'
GO

 WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, irdate) AS PltCnt
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,'Inv Move Items by Plt Tag' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
							  ,itxpal
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
						    AND ir.irdate >= ''2011-10-15''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''H''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal != 0
							AND im.imfcrg != ''Y''
						')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
	  ,itxpal
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
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
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
							  ,irooco
							  ,iroolo
							  ,irord#
							  ,irrel#
							  ,iritem
							  ,irqty
							  ,irky
							  ,irsrc
							  ,iruser
							  ,itxpal
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
						    AND ir.irdate >= ''2011-10-17''
						    AND ir.irdate <= ''2011-10-17''
							AND ir.irsrc = ''H''
							AND xe.itxpal != 0
							AND im.imfcrg != ''Y''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND ux.usxemp# = 1992	
						/*	AND ir.iritem = ''GR0440B''*/
						')
*/
--------------------------------------------------------------------------------------------