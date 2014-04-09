USE [GartmanReport]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




 
CREATE PROC [dbo].[KPIchartWCC_Ship12] AS
	

BEGIN
---------------------------------
--
--	C = current time period
--
---------------------------------
/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_C'))
		BEGIN
			DROP TABLE #WCC_C
		END;
-- Collect status = 'T' SHIPPED
	WITH CTE_C AS
	(
		SELECT *
		FROM OPENQUERY (GSFL2K,'SELECT rfoitem,rpstat,rfodate,rfobin#
								FROM rfwillchst
								WHERE rfloc IN (12,22,69)
									AND rfodate BETWEEN ''01/01/2014'' AND ''01/31/2014'' 
									AND rpstat = ''T''
									AND rfobin# != ''SHIPD''			
						')
	)
	SELECT COUNT(rfoitem) as c_cnt, NULL as p_cnt
	INTO #WCC_C

	FROM CTE_C
	--GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
	--order by [hour];
--->	SELECT * FROM #WCC_C
						
--==================================================================================================================
---------------------------------
--
--	P = prior time period
--
---------------------------------
/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_P'))
		BEGIN
			DROP TABLE #WCC_P
		END;	
-- Collect status = 'T' SHIPPED
	WITH CTE_P AS
	(
		SELECT *
		FROM OPENQUERY (GSFL2K,'SELECT rfoitem,rpstat,rfodate,rfobin#
								FROM rfwillchst
								WHERE rfloc IN (12,22,69)
									AND rfodate BETWEEN ''01/01/2013'' AND ''01/31/2013'' 
									AND rpstat = ''T''
									AND rfobin# != ''SHIPD''			
						')
	)
	SELECT COUNT(rfoitem) as p_cnt, NULL as c_cnt
	INTO #WCC_P

	FROM CTE_P
	--GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
	--order by [hour];
--->	SELECT * FROM #WCC_P

--==================================================================================================================
-- UPSERT 
--==================================================================================================================
	MERGE #WCC_C as T1			-- table one with the C Current time period
	USING #WCC_P as T2			-- table two with the P for prior time period feeding table 1 with UPDATE or INSERT
	ON T1.c_cnt = T2.p_cnt		-- alias the two tables 
	WHEN MATCHED THEN			-- if a match on hour UPDATE fields from table 2 feed
		UPDATE SET T1.c_cnt = T2.c_cnt
	WHEN NOT MATCHED THEN		-- if hour not present INSERT the fields from table 2 feed
		INSERT ( p_cnt)
		VALUES (T2.p_cnt);
		
		
	SELECT * FROM #WCC_C
		
END	


GO


