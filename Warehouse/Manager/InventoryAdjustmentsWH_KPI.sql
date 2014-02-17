USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[Inv_Adj_DATASOURCE]    Script Date: 2/17/2014 3:17:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- Inventory Adjustments Codes
-- 25 39 02


CREATE PROC [dbo].[Inv_Adj_DATASOURCE_KPI] AS

SELECT MAX(LEN(irco))			AS Co
		,MAX(LEN(irloc))		AS Loc
		,MAX(LEN(irreason))		AS ReasonCode
		,MAX(LEN(iritem))		AS Item
		,MAX(LEN(imdesc))		AS [Description]
		,MAX(LEN(irky))			AS IRTag
		,MAX(LEN(irDate))		AS [Date]
		,MAX(LEN([Month]))		AS [Month]
		,MAX(LEN([Year]))		AS [YEar]
		,MAX(LEN(irserl))		AS Serial
		,MAX(LEN(irdylt))		AS DyeLot
		,MAX(LEN(ircomt))		AS Comment
		,MAX(LEN(Each))			AS [Each]
		,MAX(LEN(UM))			AS [UM]
		,MAX(LEN(ircost))		AS Cost														
		,MAX(LEN(TotalCost))	AS [Total Cost]
		,MAX(LEN(iruser))		AS [User]

FROM OPENQUERY(GSFL2K,'
	SELECT irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,MONTH(irdate) || ''/'' || DAY(irdate) || ''/'' || YEAR(irdate) as irDate
		,MONTH(irdate) AS Month
		,YEAR(irdate) AS Year
		,irserl
		,irdylt
		,ircomt
		
/* ---- Show each or billable units	------------------------------------------------------- */
		,CASE
			WHEN irblu = 0
				THEN irqty
			ELSE irblu
		END AS Each
		
/* ---- Logic for using Unit Bill when adjustment done and the system converts outside on ITEMMAST else use ITEMMAST conversion ---- */		

		,CASE
			WHEN irblu = 0 THEN
			    CASE 
					WHEN (immd = ''M'' AND immd2 = '' '') 
						THEN CAST(ROUND((irqty * imfact) * ircost,3) AS decimal (18,2))
					WHEN (immd = ''M'' AND immd2 = ''D'') 
						THEN CAST(ROUND(((irqty * imfact) / imfac2) * ircost,3) AS decimal (18,2))
					END
			ELSE CAST(ROUND(irblu * ircost,3) AS decimal (18,2))
		 END AS TotalCost
		 
/* ---- If use billable units conversion then display the U/M by the conversion ELSE use the ITEMMAST conversion ---- */	
	 
      ,CASE 
            WHEN (irum1 = ''    '' AND irum2 = ''    '') 
                  THEN imum1
            ELSE irum2
      END AS UM
/* ------------------------------------------------------------------------------------------------------ */		 
		,imum1	
		,IRBLU
		,irum2
		,irqty
		,ircost
		,immd
		,immd2
		,imfact
		,imfac2
		,irum1
		,iruser

FROM itemrech ir
LEFT JOIN itemmast im ON im.imitem = ir.iritem

WHERE irloc IN(41, 50, 52, 57, 60, 42, 59, 04, 44, 64, 80, 81, 54, 12, 22, 69)
	AND irreason IN(''25'', ''39'', ''02'',''38'',''PI'')
	AND irdate >= (CURRENT_DATE + 1 DAYS - DAY(CURRENT_DATE + 1 MONTH)DAY  - 3 YEARS) 
	

GROUP BY irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,irdate
		,MONTH(irdate) 
		,YEAR(irdate)
		,irserl
		,irdylt
		,ircomt
		,irqty
		,ircost
		,irum1
		,iruser
		,immd
		,immd2
		,imfact
		,imfac2
		,IRBLU
		,irum2
		,imum1
	
ORDER BY irco
			,irloc
			,irdate
			,irreason 

')






GO

/* =============================================
USE 
GartmanReport
GO

-- Truncate table
TRUNCATE TABLE InventoryAdjustmentsWH
GO
 ============================================= */