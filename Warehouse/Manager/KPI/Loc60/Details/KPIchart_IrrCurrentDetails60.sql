


CREATE PROC KPIchart_IrrCurrentDetails60 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2014' AND '01/31/2014' 
		AND ErrorLocation IN (60,41,59)