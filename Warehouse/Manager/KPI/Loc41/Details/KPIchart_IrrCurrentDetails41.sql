


CREATE PROC KPIchart_IrrCurrentDetails41 AS
SELECT *
	FROM IRRReportData
	WHERE OrderDate BETWEEN '01/01/2014' AND '01/31/2014' 
		AND ErrorLocation IN (41,57,52)