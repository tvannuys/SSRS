--
-- James Tuttle
-- 1/30/2012
--
--------------------------------------------------------------------------------------------

-- Transfers Recevied by WITHOUT Pallet Tag 
--
 WITH CTE AS (
	--SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#) AS PltCnt,  usxemp# AS [User], emname AS Name
	SELECT COUNT(*) AS NonPlt,
		usxemp# AS [User],
		emname AS Name
		FROM OPENQUERY(GSFL2K,'SELECT usxemp#,
							  emname,
							  itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
							AND xe.itdate >= ''2011-10-01''
							AND xe.itdate <= ''2011-10-31'' 
							AND hst.olrtyp = ''X''
							AND xe.itcut != ''Y''
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
SELECT CTE.[User], CTE.Name, CTE.NonPlt AS XE_Recv_Lines
FROM CTE
GROUP BY CTE.[User], CTE.NonPlt ,CTE.Name
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,'SELECT itpco,
							  itploc,
							  ITICO,
							  ITILOC,
							  olrco,
							  olrloc,
							  olrord,
							  olrrel,
							  olritm,
							  olrseq,
							  olrtyp,
							  olrusr,
							  itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
							AND xe.itdate >= ''2011-10-01''
							AND xe.itdate <= ''2011-10-31'' 
							AND hst.olrtyp = ''X''
							AND xe.itcut != ''Y''
							AND xe.itxpal = 0
							AND ux.usxemp# = 1641	
						')
*/
--------------------------------------------------------------------------------------------