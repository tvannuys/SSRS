/*******************************************************************************
**	James Tuttle
**  10/17/2013
** -----------------------------------------------------------------------------
** Query as a Datasource for RF Daily Activity for management that will allow
** to select Employee Name, Total Hours, Total Actvites, and then have an average
** Calculated field in Excel Pivot Table.
********************************************************************************/
--------------------------------------------------------------------------------
--  CTE # 1 for all total activities [EXCEPT Total Hours]
--------------------------------------------------------------------------------
WITH CTE_TotalActivities AS (
	SELECT p.company
		  ,p.location
		  ,p.rfdate
		  ,DATENAME(DW,p.rfdate) as [Day]
		  ,DATEPART(M,p.rfdate) as [Month]
		  ,DATEPART(WK,p.rfdate) as [Week]
		  ,DATEPART(YY,p.rfdate) as [Year]
		  ,u.EMPLOYEENAME
		  ,SUM(CONVERT(float, p.Value)) as TotalActivities

	FROM WarehouseProductivity p WITH (INDEX
					(NCI_WarehouseProductivity_RFDate_Metric_Daily))
	LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
	WHERE RFDate BETWEEN '10/15/2011' AND GETDATE()
		  AND (Metric LIKE 'weight%')
		  AND Metric NOT LIKE 'WCC Avg Time%'
	            
	GROUP BY p.company
		  ,p.location
		  ,p.rfdate
		  ,DATENAME(DW,p.rfdate) 
		  ,DATEPART(M,p.rfdate) 
		  ,DATEPART(WK,p.rfdate) 
		  ,DATEPART(YY,p.rfdate) 
		  ,u.EMPLOYEENAME
 )
            
--------------------------------------------------------------------------------
--  CTE # 2 for Total Hours ONLY
--------------------------------------------------------------------------------

 ,CTE_TotalHours AS (
	SELECT p.company
		  ,p.location
		  ,p.rfdate
		  ,DATENAME(DW,p.rfdate) as [Day]
		  ,DATEPART(M,p.rfdate) as [Month]
		  ,DATEPART(WK,p.rfdate) as [Week]
		  ,DATEPART(YY,p.rfdate) as [Year]
		  ,u.EMPLOYEENAME
		  ,SUM(CONVERT(float, p.Value)) as TotalHours   

	FROM WarehouseProductivity p WITH (INDEX
					(NCI_WarehouseProductivity_RFDate_Metric_Daily))
	LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
	WHERE RFDate BETWEEN '10/15/2011' AND GETDATE()
		  AND Metric LIKE 'hours%'
		  AND Metric NOT LIKE 'WCC Avg Time%'
	          
	GROUP BY p.company
		  ,p.location
		  ,p.rfdate
		  ,DATENAME(DW,p.rfdate) 
		  ,DATEPART(M,p.rfdate) 
		  ,DATEPART(WK,p.rfdate) 
		  ,DATEPART(YY,p.rfdate) 
		  ,u.EMPLOYEENAME
 )
            
--------------------------------------------------------------------------------
--  Join the two CTEs to get the results into one
--------------------------------------------------------------------------------

SELECT t1.Company
	  ,t1.EMPLOYEENAME
	  ,t1.Month,t1.Year
	  ,t1.Day,t1.TotalHours
	  ,ISNULL(t2.TotalActivities,0) AS Activities

FROM CTE_TotalHours T1
LEFT JOIN CTE_TotalActivities T2 on (t1.Company = t2.Company 
									AND t1.Day = t2.Day 
									AND t1.EMPLOYEENAME = t2.EMPLOYEENAME
									AND t1.Month = t2.Month
									AND t1.RFDate = t2.RFDate
									AND t1.Week = t2.Week
									AND t1.Year = t2.Year)
--------------------------------------------------------------------------------
--    END    CTE Expressions 
--------------------------------------------------------------------------------								