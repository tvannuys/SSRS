


CREATE PROC KPIchart_IrrCurrentDetails50 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2014' AND '01/31/2014' 
		AND ErrorLocation = 50