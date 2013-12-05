/*********************************************************************************
**																				**
** SR# 11596																	**
** Programmer: James Tuttle	Date: 06/10/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:	Create a report on VERIFICATION Line(s) that sends all Co1 to		**
**	John B and all Co2 to Joe F Then another report on Send to all USERs that	**
**	created the Order #.														**
**																				**
**	They Delete the line off the order# when the conformation is sent back.		**
**	This will help the USERs have a daily list of open orders with the			**
**	VERIFICATION Line still open.												**
**																				**
**																				**
**********************************************************************************/

ALTER PROC uspVerificationLineReport AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
 	' WITH OO AS (SELECT ohco					AS Co
					,ohord#						AS Order
	 /*				,ohrel#						AS Rel		*/			
					
					FROM oohead oh
					LEFT JOIN ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#
						AND oh.ohcust = ol.olcust)
					
					WHERE ol.olitem IN (''VERIFICATION'',''VERIFICATIONPM'',''VERIFICATIONSAF'',''VERIFICATION80'')
				  )
	SELECT oh2.ohco							As Comp
		  ,oh2.ohord#						AS OrderNbr
	/*	  ,oh2.ohrel#						AS RelNbr		*/
		  ,oh2.ohuser						AS CreatedBy
		  ,SUM(olenet)						AS SubTotal
		  ,MONTH(ohodat) || 
			 ''/'' || DAY(ohodat)|| 
			 ''/'' || YEAR(ohodat)			AS orderDate

	FROM oohead oh2
	LEFT JOIN ooline ol2 ON (oh2.ohco = ol2.olco
						AND oh2.ohloc = ol2.olloc
						AND oh2.ohord# = ol2.olord#
						AND oh2.ohrel# = ol2.olrel#
						AND oh2.ohcust = ol2.olcust)
						
	WHERE oh2.ohord# IN (SELECT Order FROM OO)
	
	GROUP BY  oh2.ohco	
		  ,oh2.ohord#						
		  ,oh2.ohuser
		  ,ohodat
		  
	ORDER BY oh2.ohco
			,oh2.ohuser
			,oh2.ohord#	
	')
END


-- uspVerificationLineReport
	