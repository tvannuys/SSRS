drop table #temptotalAct
drop table #Temptotalhours  

SELECT p.company
      ,p.location
--      ,p.Dept
--      ,p.RFUser
--      ,p.Metric
--      ,CONVERT(float, p.Value) as Value
      ,p.rfdate
--      ,p.Daily
      ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
      ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
      ,u.EMPLOYEENAME
      ,SUM(CONVERT(float, p.Value)) as TotalActivities

into #TempTotalAct

FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
WHERE RFDate between '10/15/2011' and GETDATE()
      AND (Metric like 'weight%')
--      OR Metric like 'hours%')
      AND Metric not like 'WCC Avg Time%'
      
      
group by p.company
      ,p.location
--      ,p.Dept
--      ,p.RFUser
--      ,p.Metric
--      ,CONVERT(float, p.Value) 
      ,p.rfdate
--      ,p.Daily
      ,DATENAME(DW,p.rfdate) 
      ,DATEPART(M,p.rfdate) 
      ,DATEPART(WK,p.rfdate) 
      ,DATEPART(YY,p.rfdate) 
      ,u.EMPLOYEENAME

      
ORDER BY DATEPART(wK,p.rfdate)
            ,RFDate
            ,company
            ,location
            
/**********************************************************/

SELECT p.company
      ,p.location
--      ,p.Dept
--      ,p.RFUser
--      ,p.Metric
--      ,CONVERT(float, p.Value) as Value
      ,p.rfdate
--      ,p.Daily
      ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
      ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
      ,u.EMPLOYEENAME
      ,SUM(CONVERT(float, p.Value)) as TotalHours

into #TempTotalHours      

FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
WHERE RFDate between '10/15/2011' and GETDATE()
--      AND (Metric like 'weight%')
      and Metric like 'hours%'
      AND Metric not like 'WCC Avg Time%'
      
      
group by p.company
      ,p.location
--      ,p.Dept
      
--      ,p.Metric
--      ,CONVERT(float, p.Value) 
      ,p.rfdate
--      ,p.Daily
      ,DATENAME(DW,p.rfdate) 
      ,DATEPART(M,p.rfdate) 
      ,DATEPART(WK,p.rfdate) 
      ,DATEPART(YY,p.rfdate) 
      ,u.EMPLOYEENAME

      
ORDER BY DATEPART(wK,p.rfdate)
            ,RFDate
            ,company
            ,location
            
            
/***********************************************************/

select t1.Company,t1.EMPLOYEENAME,t1.Month,t1.Year,t1.Day,t1.TotalHours,
isnull(t2.TotalActivities,0) as Activities

from #TempTotalHours T1
left join #TempTotalAct T2 on (t1.Company = t2.Company and
								t1.Day = t2.Day and
								
								t1.EMPLOYEENAME = t2.EMPLOYEENAME and
								
								t1.Month = t2.Month and
								t1.RFDate = t2.RFDate and
								t1.Week = t2.Week and
								t1.Year = t2.Year)
								