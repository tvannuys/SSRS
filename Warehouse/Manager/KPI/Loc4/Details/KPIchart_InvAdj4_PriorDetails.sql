


CREATE PROC [KPIchart_InvAdj4_PriorDetails]  AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2013' AND '01/31/2013' 
		AND Loc IN (4,44,64) 