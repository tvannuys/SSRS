


CREATE PROC [KPIchart_InvAdj80_CurrentDetails80] AS
SELECT * 
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc IN (80,81,54) 