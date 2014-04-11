


CREATE PROC [KPIchart_InvAdj80_PriorDetails80] AS
SELECT * 
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2013' AND '01/31/2013' 
		AND Loc IN (80,81,54) 