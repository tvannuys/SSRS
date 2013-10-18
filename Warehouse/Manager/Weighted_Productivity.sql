-- Query for the datassource on RF Daily Activity
-- 

SELECT p.company
      ,p.location
      ,p.Dept
      ,p.RFUser
      ,p.Metric
      ,CONVERT(float, p.Value) as Value
      ,p.rfdate
      ,p.Daily
      ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
      ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
      ,u.EMPLOYEENAME
FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
WHERE RFDate between '10/15/2011' and GETDATE()
      AND (Metric like 'weight%'
      OR Metric like 'hours%')
      AND Metric not like 'WCC Avg Time%'
ORDER BY DATEPART(wK,p.rfdate)
            ,RFDate
            ,company
            ,location
            ,RFUser
