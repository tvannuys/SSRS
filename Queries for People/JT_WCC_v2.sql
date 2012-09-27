 
--ALTER PROC JT_WCC_v2 AS
/****************************************************************
* James TUttle	Date:09/08/2011									*
* ------------------------------------------------------------- *
*	This will collect all shipped and staged orders				*
*	from the RFWILLCHST File in Gartman - The data contains		*
*	all RF Will Call Console transactions (Staged, Shipped,		*
*	and Rejected).												*
*   From there it is Grouped by the hour and counted with CTE	*
*   then the MERGE to consolidate into one for reporting.		*
*																*
*****************************************************************/
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- THIS IS IN TEST PHASE 9/8/11 JAMES TUTTLE
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- DROP TABLE #WCC_T
-- DROP TABLE #WCC_S	

-- Collect status = 'T' SHIPPED
WITH CTE_T AS
(
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc =50
								AND rfodate = CURRENT_DATE - 1 DAYS
								AND rpstat = ''T''			
					')
)
SELECT LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2) as [hour], COUNT(rfotime) as t_cnt, NULL as s_cnt
INTO #WCC_T

FROM CTE_T
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
order by [hour];

					
--==================================================================================================================
	
-- Collect status = 'S' STAGED
WITH CTE_S AS
(
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc =50
								AND rfodate = CURRENT_DATE - 1 DAYS
								AND rpstat = ''S''			
					')
)
SELECT LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2) as [hour], NULL as t_cnt, COUNT(rfotime) as s_cnt
INTO #WCC_S

FROM CTE_S
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
order by [hour];	

--============================================
-- UPSERT 
--============================================
MERGE #WCC_T as T1			-- table one with the 'T' shipped by hour
USING #WCC_S as T2			-- table two with the 'S' Staged by hour feeding table 1 with UPDATE or INSERT
ON T1.hour = T2.hour		-- alias the two tables 
WHEN MATCHED THEN			-- if a match on hour UPDATE fields from table 2 feed
	UPDATE SET T1.hour = T2.hour, T1.s_cnt = T2.s_cnt 
WHEN NOT MATCHED THEN		-- if hour not present INSERT the fields from table 2 feed
	INSERT (hour, s_cnt)
	VALUES (T2.hour, T2.s_cnt);
	
	
SELECT * FROM #WCC_T
	
	
	
	
	
	