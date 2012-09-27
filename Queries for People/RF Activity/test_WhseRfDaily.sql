

--ALTER PROC [dbo].[JT_WhseRfDaily] AS
select p.Metric
,CAST(SUM(p.Value)as decimal (10,0)) AS Total
from WarehouseProductivity_Daily p
left join WarehouseUsers_Daily u on u.OLRUSR = p.RFUser
where RFDate = CONVERT(DATE,DATEADD(DAY,-2,GETDATE()))--'04/12/2012'
	and (Metric not like 'weight%' AND Metric <> 'Hours')
	and p.Location = 50
group by p.Metric




