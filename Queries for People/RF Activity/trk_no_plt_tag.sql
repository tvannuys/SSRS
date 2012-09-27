
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck by item ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = 'Truck Items Non Plt Tag'
GO

-- NO Pallet Tag
 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,'Truck Items Non Plt Tag' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#
							  ,emname
							  ,olrico
							  ,olrilo
							  ,slxpal
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''2011-10-15''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''T''
							AND sl.slcut != ''Y''
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''1'',''6'')
						
						')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
							AND hst.olrdat >= ''2011-10-15''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''T''
							AND sl.slcut != ''Y''
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''1'',''6'')
							/*AND  ux.usxemp#= 1412 */
							/*AND hst.olrord = 848887*/
							
							
						')
*/
--------------------------------------------------------------------------------------------