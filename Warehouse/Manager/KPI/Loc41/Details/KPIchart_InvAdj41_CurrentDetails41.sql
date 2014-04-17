

CREATE PROC	[KPIchart_InvAdj41_PriorDetails41]	AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2013' AND '01/31/2013' 
		AND Loc IN (52,41,57)