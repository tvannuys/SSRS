


ALTER PROC JT_CC_QTR 



@StartDate varchar(10)
, @EndDate varchar(10)

AS 
--	DECLARE @sql varchar(4000)

SET DATEFORMAT mdy		
DECLARE @sql varchar(max) 
SET @sql = ' 
SELECT
  CycleCountReport.Co
  ,CycleCountReport.Loc
  ,CycleCountReport.[Date]
  ,CycleCountReport.Measurement
  ,CycleCountReport.[Value]

FROM
  CycleCountReport
  
WHERE CycleCountReport.[Date] BETWEEN ''' + @StartDate  + ''' AND '''  + @EndDate  + '''

'

EXEC (@sql)

-- JT_CC_QTR '10/01/2012','12/31/2012'
  

