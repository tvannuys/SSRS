
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- CUSTOMER DELIVERYS 
-- Non XE on delivery truck
-- Looking in the SHLINE
-- Do we need to include OOLINE?

-- Looking for cuts in the SHLINE(SLCUT) since OOLRFHST Cuts do not record the flag 
--
-- Shipped | NO Cuts | NO Pallet Tag | VIA Code NOT 1 (Will Call) or 6 (Pre-pull W/Call)
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- NO Pallet Tag
 WITH CTE AS (--SELECT COUNT(usxemp#) OVER(PARTITION BY usxemp#) AS PltCnt,  usxemp# AS [User], emname AS Name
	SELECT COUNT(*) AS NonPlt,
		usxemp# AS [User],
		emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#,
							  emname,
							  slxpal
						FROM oolrfhst hst
						/*INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)*/
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
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''1'',''6'')
		
						
						')
GROUP BY usxemp#, emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE.[User], CTE.Name, CTE.NonPlt AS Trk_Lines
FROM CTE
GROUP BY CTE.[User], CTE.NonPlt ,CTE.Name
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT olrico,
							  olrilo,
							  olrord,
							  olrrel,
							  olritm,
							  olrseq,
							  olrtyp,
							  olrusr,
							  shviac,
							  slxpal
						FROM oolrfhst hst
						/*INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)*/
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
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''1'',''6'')
							/*AND  ux.usxemp#= 1412 */
							/*AND hst.olrord = 848887*/
							
							
						')
*/
--------------------------------------------------------------------------------------------