
/*****************************************************************************************************
**																									**
** SR# 16971																						**
** Programmer: James Tuttle		Date: 01/06/2014													**
** ------------------------------------------------------------------------------------------------ **
** Purpose:		Get the daily transfer weights for all companies and locations						**
**				and Email Ric S.																	**
**																									**
**																									**
**																									**
**																									**
******************************************************************************************************/

ALTER PROC JT_TransferWgts AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT irooco AS Co
			,iroolo	AS Loc
			,CEILING(SUM(irqty * imwght)) AS Weight

	FROM itemrech ir
	LEFT JOIN itemmast im ON ir.iritem = im.imitem
	
	WHERE irdate >= CURRENT_DATE - 1 DAYS
		AND irloc IN (50, 41, 57)	
		AND irsrc = ''W'' 
		AND irqty > 0

	GROUP BY irooco
		,iroolo

	ORDER BY irooco
			,iroolo

	')
END

	

	/*-------------------------------------------------------
============ D E T A I L S ==================================

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
---------------------------------------------------------------
*/
