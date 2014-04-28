

/***************************************************
**	SR# 18650
**	James Tuttle
**	04/17/2014
**	------------------------------------------------
**	WCC Cuurent Month Details
**
****************************************************/

CREATE PROC KPIchartWCC_ShipCurrentDetails4 AS 

SELECT *
		FROM OPENQUERY (GSFL2K,'SELECT rfoitem,rpstat,rfodate,rfobin#
								FROM rfwillchst
								WHERE rfloc IN (4,44,64)
									AND rfodate BETWEEN ''01/01/2014'' AND ''01/31/2014'' 
									AND rpstat = ''T''
									AND rfobin# != ''SHIPD''			
						')
