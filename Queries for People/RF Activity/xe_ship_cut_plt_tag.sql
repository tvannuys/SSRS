------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE receive Rolls by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- 
DELETE WarehouseProductivity 
WHERE Metric = 'XE Rolls Ship by Plt Tag'
GO

WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, olrdat ) AS PltCnt			
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,'XE Rolls Ship by Plt Tag' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,'SELECT usxemp#
							  ,emname
							  ,itxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
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
						    AND hst.olrdat >= ''2011-10-15''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''T''
							AND xe.itcut = ''Y''
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						')
GROUP BY usxemp# 
	,itxpal 
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
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
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
	FROM OPENQUERY(GSFL2K,'SELECT itpco
							  ,itploc
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
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
						    AND hst.olrdat >= ''2011-10-15''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''T''
							/* AND hst.olrord = 853016	*/
							AND xe.itxpal != 0
							AND xe.itcut = ''Y''
							AND ux.usxemp# = 2016		
						')
*/
--------------------------------------------------------------------------------------------