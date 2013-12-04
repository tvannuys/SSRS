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

-- SR#16301 James Tuttle 12/04/2013

ALTER PROC uspVerificationLineReportManager AS
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

	SELECT DISTINCT oh2.ohco				As Comp
		  ,oh2.ohord#						AS OrderNbr
	/*	  ,oh2.ohrel#						AS RelNbr	*/
		  ,oh2.ohuser						AS CreatedBy
		  ,SUM(oleprc)						AS SubTotal
		  ,MONTH(ohodat) || 
			 ''/'' || DAY(ohodat)|| 
			 ''/'' || YEAR(ohodat)			AS orderDate
	/*	  ,pbco								AS PoCo		*/
	/*	  ,pbloc							AS POLoc	*/
	/*	  ,pbpo#							AS PO#		*/
	/*	  ,MONTH(phdoi) || ''/''						*/
	/*		|| DAY(phdoi) || ''/'' ||					*/
	/*		YEAR(phdoi)						AS IssueDate*/
	/*	  ,MONTH(plpdat)|| ''/''						*/
	/*		|| DAY(plpdat)|| ''/'' ||					*/
	/*		YEAR(plpdat)					AS ProDate	*/
	/*	  ,MONTH(plddat)|| ''/'' ||						*/
	/*		DAY(plddat)|| ''/'' ||						*/
	/*		YEAR(plddat)					AS dueDate	*/

	FROM oohead oh2
	LEFT JOIN ooline ol2 ON (oh2.ohco = ol2.olco
						AND oh2.ohloc = ol2.olloc
						AND oh2.ohord# = ol2.olord#
						AND oh2.ohrel# = ol2.olrel#
						AND oh2.ohcust = ol2.olcust)
/*	LEFT JOIN poboline po ON (po.pboco = ol2.olco		*/
/*						AND po.pboloc = ol2.olloc		*/
/*						AND po.pboord = ol2.olord#		*/
/*						AND po.pborel = ol2.olrel#		*/
/*						AND po.pbitem = ol2.olitem)		*/
/*	LEFT JOIN poline pl ON (pl.plco = po.pbco			*/
/*						AND pl.plloc = po.pbloc			*/
/*						AND pl.plpo# = po.pbpo#			*/
/*						AND pl.plseq# = po.pbseq#		*/
/*						AND pl.plitem = po.pbitem)		*/
/*	LEFT JOIN pohead ph ON (ph.phco = pl.plco			*/
/*						AND ph.phloc = pl.plloc			*/
/*						AND ph.phpo# = pl.plpo#)		*/
						
	WHERE oh2.ohord# IN (SELECT Order FROM OO)
/*			AND pbpo# IS NOT NULL						*/
		
		
	
	GROUP BY oh2.ohco
			,oh2.ohord#
			,oh2.ohuser
			,ohodat
	/*		,ohemds			*/							
		
	ORDER BY oh2.ohco
			,oh2.ohuser

	')
END


-- uspVerificationLineReportManager
	