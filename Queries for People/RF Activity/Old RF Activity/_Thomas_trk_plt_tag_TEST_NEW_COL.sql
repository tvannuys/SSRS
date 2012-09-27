
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- By Pallet Tag
-- partition off of usxemp# and olrdat
 WITH CTE AS (
	SELECT COUNT( slxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt  
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,'Truck Pallet Tag' as [type]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
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
							AND hst.olrdat >= ''2011-10-01''
							AND hst.olrdat <= ''2011-10-31'' 
							AND hst.olrtyp = ''T''
							AND sl.slcut != ''Y''
							AND sl.slxpal != 0
							AND sh.shviac NOT IN(''1'',''6'')				
						')
GROUP BY usxemp# 
	,slxpal 
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
SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[type] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[type]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT olrico
							  ,olrilo
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,olrdat
							  ,shviac
							  ,slxpal
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
							AND hst.olrdat >= ''2011-10-01''
							AND hst.olrdat <= ''2011-10-31'' 
							AND hst.olrtyp = ''T''
							AND sl.slxpal != 0
							AND sl.slcut != ''Y''
							AND  ux.usxemp#= 1579 
							/*AND hst.olrord = 848887*/
							AND sh.shviac NOT IN(''1'',''6'')					
						')
*/
--------------------------------------------------------------------------------------------