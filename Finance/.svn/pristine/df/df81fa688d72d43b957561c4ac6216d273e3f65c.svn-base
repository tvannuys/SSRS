

--CREATE PROC / AS


/********************************************************************
*																	*
* James Tuttle		Date: 12/19/2011								*
* From 	VFP: DiscountsOnCreditMemos.prg								*
*-------------------------------------------------------------------*
*																	*
*********************************************************************/


------------------------------------------------------------------
-- Query and SUM apdamt in apdetail 30 days back
WITH CTE1 AS
(
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT apdven,
								apdvnm,
								apdinv,
								SUM(apdamt) as amount
						FROM apdetail
						WHERE apdidt > CURRENT_DATE - 30 DAYS
						GROUP BY apdvou,
								apdven,
								apdvnm,
								apdinv	
						')
),
-------------------------------------------------------------------
-- Query apdetail 30 days back
CTE2 As
(
SELECT * 
FROM OPENQUERY(GSFL2K, 'SELECT *
						FROM apdetail
						WHERE apdidt > CURRENT_DATE - 30 DAYS
						')
)
-------------------------------------------------------------------
-- Query the two prior Query (CTE) and format for reporting
SELECT CTE1.apdven as Vendor,
		CTE1.apdvnm as [Vendor Name],
		CTE1.apdinv as Invoice,
		CTE2.apdck# as [Check],
		(CTE2.apdamt * -1) as [Check Amt],
		(CTE2.apd$ds * -1) as [Discount Given Back],
		CONVERT(varchar,DATEPART(MM,CTE2.apdddt)) + '/' + 
			CONVERT(varchar,DATEPART(DD,CTE2.apdddt)) + '/' +
			CONVERT(varchar,DATEPART(YY,CTE2.apdddt)) as [Due Date],
		CONVERT(varchar,DATEPART(MM,CTE2.apdidt)) + '/' + 
			CONVERT(varchar,DATEPART(DD,CTE2.apdidt)) + '/' +
			CONVERT(varchar,DATEPART(YY,CTE2.apdidt)) as [Invoice Date],
		CONVERT(varchar,DATEPART(MM,CTE2.apdckd)) + '/' + 
			CONVERT(varchar,DATEPART(DD,CTE2.apdckd)) + '/' +
			CONVERT(varchar,DATEPART(YY,CTE2.apdckd)) as [Check Date],
		CTE2.apdco as Company,
		CTE2.apdloc as Location,
		CTE2.apdpo# as PO
FROM CTE1
JOIN CTE2 
ON CTE1.apdinv = CTE2.apdinv
WHERE CTE1.amount < 0
	AND CTE2.apd$ds < 0
	AND CTE2.apd$ds != .01
	AND CTE2.apdvoid != 'V'
	AND CTE2.apdven != 16037
	AND CTE2.apdven != 10131
    AND CTE2.apdddt > GETDATE() -7
-------------------------------------------------------------------