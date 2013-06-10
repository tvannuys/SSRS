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
	'SELECT ohco
		,ohord#
		,ohrel#
		,ohuser
		,MONTH(ohodat) || ''/'' || DAY(ohodat)|| ''/'' || YEAR(ohodat) AS orderDate
		,ohemds
		,pbpo#
		,MONTH(phdoi) || ''/'' || DAY(phdoi) || ''/'' || YEAR(phdoi) AS IssueDate
		,MONTH(plpdat)|| ''/'' || DAY(plpdat)|| ''/'' || YEAR(plpdat) AS ProDate
		,MONTH(plpdat)|| ''/'' || DAY(plpdat)|| ''/'' || YEAR(plpdat) AS dueDate
		
	FROM oohead oh
	LEFT JOIN ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#
						AND oh.ohcust = ol.olcust)
	LEFT JOIN poboline po ON (po.pboco = ol.olco
						AND po.pboloc = ol.olloc
						AND po.pboord = ol.olord#
						AND po.pborel = ol.olrel#
						AND po.pbitem = ol.olitem)
	LEFT JOIN poline pl ON (pl.plco = po.pbco
						AND pl.plloc = po.pbloc
						AND pl.plpo# = po.pbpo#
						AND pl.plseq# = po.pbseq#
						AND pl.plitem = po.pbitem)
	LEFT JOIN pohead ph ON (ph.phco = pl.plco
						AND ph.phloc = pl.plloc
						AND ph.phpo# = pl.plpo#)
						
	WHERE ol.olitem IN (''VERIFICATION'',''VERIFICATIONPM'',''VERIFICATIONSAF'')
	')
END