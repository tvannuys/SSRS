USE [GartmanReport]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[KPIchartHours80] AS 
BEGIN
/*-----------
SELECT  SUM(CAST(Value  AS decimal)) AS TotalHours
    
  FROM [GartmanReport].[dbo].[WarehouseProductivity]
  WHERE Metric LIKE 'Hour%'
	AND Location IS NOT NULL
	AND (RFUser LIKE '[WC]%'
		OR RFUser LIKE	'[_1]%'
		OR RFUser LIKE '[_2]%')
	AND Location IN (80,81,54) 
	AND CONVERT(varchar(10),RFDate) BETWEEN '01/01/2014' AND '01/31/20114'


---------------------------------------------------------------------------------------*/
--
-- DETAILS
--

SELECT  
--[Company]
      --,[Location]
      --,[RFDate]
      --,[Dept]
      --,[RFUser]
      --,[Metric]
      --,[Daily]
      ROUND(SUM(CONVERT(float,[Value])),2) AS TotalTime
  FROM [GartmanReport].[dbo].[WarehouseProductivity]
  WHERE Metric LIKE 'Hour%'
	AND Location IS NOT NULL
	AND (RFUser LIKE '[WC]%'
		OR RFUser LIKE	'[_1]%'
		OR RFUser LIKE '[_2]%')
	AND Location IN (80,81,54) 

--GROUP BY  [Company]
--      ,[Location]
--      ,[RFDate]
--      ,[Dept]
--      ,[RFUser]
--      ,[Metric]
--      ,[Daily]
	-------------------------------------------------------------------------*/
	END
	-- KPIchartHours
GO


