


CREATE PROC [KPIchart_InvAdj12_CurrentDetails] AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc IN (12,22,69)