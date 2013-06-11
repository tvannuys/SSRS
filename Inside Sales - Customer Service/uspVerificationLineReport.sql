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
	'SELECT oh.ohco				As Comp
		  ,oh.ohord#						AS OrderNbr
		  ,oh.ohrel#						AS RelNbr
		  ,oh.ohuser						AS CreatedBy
		  ,ohemds							AS SubTotal
		  ,MONTH(ohodat) || 
			 ''/'' || DAY(ohodat)|| 
			 ''/'' || YEAR(ohodat)			AS orderDate

	FROM oohead oh
	LEFT JOIN ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#
						AND oh.ohcust = ol.olcust)
						
	WHERE ol.olitem IN (''VERIFICATION'',''VERIFICATIONPM'',''VERIFICATIONSAF'')
	
	ORDER BY oh.ohco
			,oh.ohuser
			,oh.ohord#	
	')
END


-- uspVerificationLineReport
	