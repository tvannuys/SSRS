


CREATE PROC [KPIchart_InvAdj4_CurrentDetails]  AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc IN (4,44,64) 