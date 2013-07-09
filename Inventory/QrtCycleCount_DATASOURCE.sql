


SELECT
  CycleCountReport.Co
  ,CycleCountReport.Loc
  ,DATEPART(qq,CycleCountReport.[Date]) AS Qtr
  ,DATEPART(yy,CycleCountReport.[Date]) AS Yr
  ,CycleCountReport.Measurement
  ,CycleCountReport.[Value]

FROM
  CycleCountReport

-- SELECT * FROM CycleCountReport

-- JT_CC_QTR '10/01/2012','12/31/2012'