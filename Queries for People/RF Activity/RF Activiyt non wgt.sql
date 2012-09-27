
/* Non Weighted Data for DAILY Report */

SELECT p.company
	,p.location
	,p.Dept
	,p.RFUser
	,p.Metric
	,p.Daily
	,p.Value
	,p.rfdate
	,DATENAME(DW,p.rfdate) as [Day]
	,DATEPART(M,p.rfdate) as Month
	,DATEPART(WK,p.rfdate) as [Week]
	,DATEPART(YY,p.rfdate) as [Year]
	,u.EMPLOYEENAME
FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
left join WarehouseUsers u on u.OLRUSR = p.RFUser
WHERE RFDate between '10/15/2011' and GETDATE()
	and (Metric not like 'weight%' AND Metric <> 'Hours')
	AND daily IS NOT NULL
ORDER BY DATEPART(wK,p.rfdate)
		,RFDate
		,company
		,location
		,RFUser