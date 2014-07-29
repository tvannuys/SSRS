

CREATE PROC KPIchart_IrrPriorDetails41 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2013' AND '01/31/2013'
		AND ErrorLocation IN (41,57,52) 