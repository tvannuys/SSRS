

CREATE PROC KPIchart_IrrPriorDetails60 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2013' AND '01/31/2013'
		AND ErrorLocation IN (60,41,59) 