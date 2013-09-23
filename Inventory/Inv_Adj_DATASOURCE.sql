

-- Inventory Adjustments Codes
-- 25 39 02


ALTER PROC Inv_Adj_DATASOURCE AS

SELECT irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,irDate
		,[Month]
		,[Year]
		,irserl
		,irdylt
		,ircomt
		,irqty
		,IRBLU
		,ircost															
		,Total
		,irum1
		,iruser

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
		
		,CASE
			WHEN (immd = ''M'' AND immd2 = '' '') 
				THEN CAST(ROUND((irqty * imfact) * ircost,3) AS decimal (18,2))
			WHEN (immd = ''M'' AND immd2 = ''D'') 
				THEN CAST(ROUND(((irqty * imfact) / imfac2) * ircost,3) AS decimal (18,2))
			ELSE 0
		 END AS Total
		 
		,IRBLU
		 
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
	AND irreason IN(''25'', ''39'', ''02'',''38'')
	AND irdate = ''08/20/2013''

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
	
ORDER BY irco
			,irloc
			,irdate
			,irreason 

')




