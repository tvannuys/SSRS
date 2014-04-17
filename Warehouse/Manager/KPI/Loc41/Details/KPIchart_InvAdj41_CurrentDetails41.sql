

CREATE PROC	[KPIchart_InvAdj41_CurrentDetails41]	AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc IN (52,41,57)