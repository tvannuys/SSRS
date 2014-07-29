

CREATE PROC KPIchart_IrrPriorDetails12 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2013' AND '01/31/2013'
		AND ErrorLocation IN (12,22,69) 