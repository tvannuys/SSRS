

/***************************************************
**	SR# 18650
**	James Tuttle
**	04/17/2014
**	------------------------------------------------
**	WCC Cuurent Month Details
**
****************************************************/

CREATE PROC KPIchartWCC_ShipPriorDetails12 AS 

SELECT *
		FROM OPENQUERY (GSFL2K,'SELECT rfoitem,rpstat,rfodate,rfobin#
								FROM rfwillchst
								WHERE rfloc IN (12,22,69)
									AND rfodate BETWEEN ''01/01/2013'' AND ''01/31/2013'' 
									AND rpstat = ''T''
									AND rfobin# != ''SHIPD''			
						')
