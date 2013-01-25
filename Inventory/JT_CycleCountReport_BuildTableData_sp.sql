
/*********************************************************
**														**
** SR# 3845 and SR# 7083								**
** Programmer: James Tuttle		Date: 01/15/2013		**
** ---------------------------------------------------- **
** Purpose:		Create an automated report for Inventory**
**	Control (Colleen B) so she is not having to collect	**
**	all the data. SQL will run a SP JT_CC_QTR to get 	**
**	the data from the SQL table that has a nightly Job	**
**	that runs to fill the tanle with the data:			**
**	JT_CycleCountReport_BuildTableData_sp				**
**********************************************************/






/* Count the ITEMRECH irsrc 'I' transactions as an exception */

-- Insert data into DB table on Server from AS400
INSERT CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT irco				AS Co
	,irloc				AS Loc
	,irdate				AS [Date]
	,'Exceptions'		AS Measurement
	,ExceptionCountColumn
	
FROM OPENQUERY(GSFL2K,'
 
SELECT irco
	,irloc 
	,irdate
	,COUNT(iritem) AS ExceptionCountColumn
FROM itemrech ir
WHERE ir.irsrc = ''I''
	  AND ir.irdate = CURRENT_DATE
	  AND ir.irco IN (1,2)
	  AND ir.irloc IN (4,44,64,50,52,41,57,60,42,59,80,81,84)
	  AND ir.irbin NOT LIKE ''SHW%''
GROUP BY irco
	,irloc
	,irdate
')

	
-------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------
/* Count the ITEMRECH irsrc 'I' transactions for total Net $ */

-- Insert data into DB table on Server from AS400
INSERT CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT irco				AS Co
	,irloc				AS Loc
	,irdate				AS [Date]
	,'Net'				AS Measurement
	,NetColumn
	
FROM OPENQUERY(GSFL2K,'
 
SELECT irco
	,irloc 
	,irdate
	,SUM(irqty * ircost) AS NetColumn
FROM itemrech ir
WHERE ir.irsrc = ''I''
	  AND ir.irdate = CURRENT_DATE
	  AND ir.irco IN (1,2)
	  AND ir.irloc IN (4,44,64,50,52,41,57,60,42,59,80,81,84)
	  AND ir.irbin NOT LIKE ''SHW%''
GROUP BY irco
	,irloc
	,irdate
')
-----------------------------------------------------------------------------------------------------------

-- SELECT * FROM CycleCountReport

-- TRUNCATE TABLE dbo.CycleCountReport

-- >= ''01/01/2012''

-- = CURRENT_DATE

------------------------------------------------------------------------------------------------------------