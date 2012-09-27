--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--
-- Transfers CUTS not tied to a pallet tag
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- OOLRFHST = TRANSFER
 WITH CTE AS (
	--SELECT COUNT(usxemp#) OVER(PARTITION BY usxemp#) AS PltCnt,  usxemp# AS [User], emname AS Name
	SELECT COUNT(*) AS NonPlt,
		usxemp# AS [User],
		emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#,
							  emname,
							  itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
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
							AND xe.itcut = ''Y''
							AND xe.itxpal = 0
							/*AND hst.olrord = 857136*/
						')
GROUP BY usxemp#, emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE.[User], CTE.Name, CTE.NonPlt AS XE_Cuts
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
							  itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
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
							AND xe.itcut = ''Y''
							AND xe.itxpal = 0
							/*AND hst.olrord = 854483	*/ 
							/*AND ux.usxemp# = 1484		*/
						ORDER BY  olrusr
						')
*/
--------------------------------------------------------------------------------------------