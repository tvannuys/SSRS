

CREATE PROC [KPIchart_InvAdj50_CurrentDetails] AS 
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc = 50