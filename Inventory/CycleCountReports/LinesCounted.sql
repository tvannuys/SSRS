/* Count the OOLRFUSR olrtyp 'I' transactions as lines counted */

-- Insert data into DB table on Server from AS400
INSERT dbo.CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT olrico			AS Co
		,olrilo			AS Loc
		,olrdat			AS [Date] 
		,'LinesCounted' AS Measurement
		,LinesCountedColumn
		
FROM OPENQUERY(GSFL2K,'

SELECT olrico
	,olrilo
	,olrdat
	,COUNT(olritm) AS LinesCountedColumn
 FROM oolrfuser hst
 WHERE hst.olrtyp = ''I''
	  AND hst.olrcyrc != ''Y''
	  AND hst.olrdat = CURRENT_DATE
	  AND hst.olrico IN (1,2)
	  AND hst.olrilo IN (4,44,64,50,52,41,57,60,42,59,80,81,84)
GROUP BY olrico
		,olrilo	 
		,olrdat 
')
