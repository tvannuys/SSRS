USE [GartmanReport]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[KPIchart_InvAdj12] AS
BEGIN	
--====================================================================================================================
--
-- C for Current time period =========================================================================================
--

/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_C'))
		BEGIN
			DROP TABLE #WCC_C
		END;
	WITH CTE_C AS	-- Current year and month
	(
	SELECT SUM(TotalCost) AS CntC
	FROM InventoryAdjustmentsWH
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2014' AND '01/31/2014' 
		AND Loc IN (12,22,69) )

	SELECT CntC as C_cnt, NULL as P_cnt
	INTO #WCC_C

	FROM CTE_C
--==================================================================================================================
--
-- P for Prior time period =========================================================================================
--
/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_P'))
		BEGIN
			DROP TABLE #WCC_P
		END;	

	WITH CTE_P AS
	(SELECT SUM(TotalCost) AS CntP
	FROM InventoryAdjustmentsWH
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2013' AND '01/31/2013' 
		AND Loc IN (12,22,69) )

	SELECT CntP as P_cnt, NULL as C_cnt
	INTO #WCC_P

	FROM CTE_P


--==================================================================================================================
-- UPSERT 
--==================================================================================================================
	MERGE #WCC_C as T1			-- table one with the Current time fram
	USING #WCC_P as T2			-- table two with the Prior time frame feeding table 1 with UPDATE or INSERT
	ON T1.C_cnt = T2.P_cnt 		-- alias the two tables 
	WHEN MATCHED THEN			-- if a match on xxxxx UPDATE fields from table 2 feed
		UPDATE SET T1.C_cnt = T2.P_cnt 
	WHEN NOT MATCHED THEN		-- if xxxxx not present INSERT the fields from table 2 feed
		INSERT ( P_cnt)
		VALUES ( T2.P_cnt);
		
		
	SELECT * FROM #WCC_C

END

GO


