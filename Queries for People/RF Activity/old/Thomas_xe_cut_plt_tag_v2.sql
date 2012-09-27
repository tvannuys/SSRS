

-- Gather COUNTS for CUTS = Y 
-- Group by USER & Pallet Tag #


WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#) AS PltCnt,  
		usxemp# AS [User], 
		olrusr, 
		olrilo,
		olrico,convert(datetime,olrdat,101) as RFDate
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#,
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
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						')
GROUP BY usxemp#, itxpal, emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE.olrolo, CTE.[User], CTE.Name, CTE.PltCnt as Cuts_PltCnt
FROM CTE
GROUP BY CTE.[User], CTE.PltCnt ,CTE.Name
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
							/* AND hst.olrord = 853016	*/
							AND xe.itxpal != 0
							AND xe.itcut = ''Y''
							AND ux.usxemp# = 1026	
						')
*/
--------------------------------------------------------------------------------------------