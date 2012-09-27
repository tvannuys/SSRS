
-- ALTER PROC JT_RF_WCC AS


-- Shipped
WITH CTE_T AS
(
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc =50
								AND rfodate = CURRENT_DATE
								AND rpstat = ''T''			
					')
)

SELECT LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2) as [Hour_T], COUNT(rfotime) as Lines_T
FROM CTE_T
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
order by [Hour_T];
GO


-- Stage
WITH CTE_S AS
(
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc =50
								AND rfodate = CURRENT_DATE
								AND rpstat = ''S''			
					')
)

SELECT LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2) as [Hour_S], COUNT(rfotime) as Lines_S
FROM CTE_S
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,rfotime), 6),2)
order by [Hour_S];
GO

SELECT CTE_T.Hour_T, CTE_T.Lines_T, CTE_S.Hour_S, CTE_S.Lines_S
FROM CTE_T
CROSS JOIN CTE_S
Go

