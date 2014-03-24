/*********************************************************************************
**																				**
** SR# 17979																	**
** Programmer: James Tuttle		Date: 03/21/2014								**
** ---------------------------------------------------------------------------- **
** Purpose:		We are interested in getting a report created that would show   **
**		us prices charged for displays so we can see where we may				**
**		need to bump up prices to be closer to the cost that we pay for them so **
**		we aren’t losing money.  This is what we would need.					**				
**																				**
**		Dori A																	**
**																				**
**																				**
**																				**
**********************************************************************************/

--CREATE PROC uspNewDisplayChargesReport AS
 BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohord#
			,MONTH(ohodat) || ''/'' || DAY(ohodat) || ''/'' || YEAR(ohodat) AS Order_Date
			,ohcust
			,cmname
			,olitem
			,oldesc
			,'''' AS sellPrice
			,'' '' AS unitPrice
			,smno
			,smname

	FROM oohead oh
	LEFT JOIN ooline ol ON (ol.olco = oh.ohco
		    AND ol.olloc = oh.ohloc
		    AND ol.olord# = oh.ohord#
		    AND ol.olrel# = oh.ohrel#
		    AND ol.olcust = oh.ohcust)
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust 
	LEFT JOIN salesman sm ON sm.smno = ol.olslmn
	LEFT JOIN itemmast im ON ol.olitem = im.imitem

	WHERE im.imclas = ''DI''

	')
END




	