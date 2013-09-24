

-- Inventory Adjustments Codes
-- 25 39 02


ALTER PROC Inv_Adj_DATASOURCE AS

-- commentied out fields. Was used for debugging and comparison

SELECT irco			AS Co
		,irloc		AS Loc
		,irreason	AS ReasonCode
		,iritem		AS Item
		,imdesc		AS [Description]
		,irky		AS IRTag
		,irDate		AS [Date]
		,[Month]
		,[Year]
		,irserl		AS Serial
		,irdylt		AS DyeLot
		,ircomt		AS Comment
		--,irqty	AS Qty
		,Qty
		,UM
		,imum1
		,irum1
		--,irblu	AS BillableUnits
		--,irum2	AS BillableUM
		,ircost		AS Cost														
		,TotalCost
		--,imum1
		,iruser		AS [User]

FROM OPENQUERY(GSFL2K,'
	SELECT irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,MONTH(irdate) || ''/'' || DAY(irdate) || ''/'' || YEAR(irdate) as irDate
		,MONTHNAME(irdate) AS Month
		,YEAR(irdate) AS Year
		,irserl
		,irdylt
		,ircomt
		
/* ---- Show each or billable units	------------------------------------------------------- */
		,CASE
			WHEN irblu = 0
				THEN irqty
			ELSE irblu
		END AS Qty
		
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
			WHEN irum1 IS NOT NULL 
				THEN irum2
			ELSE imum1
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

WHERE irloc IN(41, 50, 52, 57)
	AND irreason IN(''25'', ''39'', ''02'',''38'',''PI'')
	AND irdate >= (CURRENT_DATE + 1 DAYS - DAY(CURRENT_DATE + 1 MONTH)DAY) /* - 3 YEARS */
	
	/* AND irdate = ''08/20/2013'' */
	/*  AND iritem IN (''ARX20702'',''JTMIRA24X24ROSS'') */

GROUP BY irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,irdate
		,MONTHNAME(irdate) 
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




