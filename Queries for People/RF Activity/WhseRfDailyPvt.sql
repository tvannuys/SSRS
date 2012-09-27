
--ALTER PROC [dbo].[JT_WhseRfDaily] AS

SELECT RFDate [Date]
	,Location AS Loc
	,CAST(ISNULL(SUM(CASE WHEN metric = 'CUTS' THEN Value END),0) as DECIMAL(10,0)) AS [CUTS]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Rolls Moved' THEN Value END),0) as DECIMAL(10,0)) AS[Rolls Moved]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Staged' THEN Value END),0) as DECIMAL(10,0)) AS [Staged]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Shipped' THEN Value END),0) as DECIMAL(10,0)) AS [Shipped]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'RF W/Call' THEN Value END),0) as DECIMAL(10,0)) AS [RF W/Call]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Tran Recv' THEN Value END),0) as DECIMAL(10,0)) AS [Tran Recv]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Inv Moves' THEN Value END),0) as DECIMAL(10,0)) AS [Inv Moves]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Consol' THEN Value END),0) as DECIMAL(10,0)) AS [Consol]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Term Update' THEN Value END),0) as DECIMAL(10,0)) AS [Term Update]
	,CAST(ISNULL(SUM(CASE WHEN metric = 'Inv Recv' THEN Value END),0) as DECIMAL(10,0)) AS [Inv Recv]

FROM
		( SELECT p.RFDATE
				,p.Location
				,p.Metric
				,p.Value 
			FROM WarehouseProductivity_Daily p
			left join WarehouseUsers_Daily u ON u.OLRUSR = p.RFUser
			WHERE RFDate = CONVERT(DATE,DATEADD(DAY,-1,GETDATE()))--'04/12/2012'
				and (Metric not like 'weight%' AND Metric <> 'Hours')
				and p.Location = 50
		) pvt
GROUP BY pvt.RFDate
		,pvt.Location
		,pvt.Metric


