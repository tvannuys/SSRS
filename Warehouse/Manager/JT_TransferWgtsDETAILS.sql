
CREATE PROC JT_TransferWgtsDETAILS AS
	SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT irooco AS Co
			,iroolo	AS Loc
			,irord#
			,CEILING(SUM(irqty * imwght)) AS Weight

	FROM itemrech ir
	LEFT JOIN itemmast im ON ir.iritem = im.imitem
	
	WHERE irdate >= CURRENT_DATE - 1 DAYS
		AND irloc IN (50, 41, 57)	
		AND irsrc = ''W'' 
		AND irqty > 0
		
	GROUP BY irooco 
			,iroolo
			,irord#

	ORDER BY irooco
			,iroolo
	')