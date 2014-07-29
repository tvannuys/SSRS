

CREATE PROC KPIchart_IrrPriorDetails50 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2013' AND '01/31/2013'
		AND ErrorLocation = 50