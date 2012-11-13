
/*==============================================================================
-- SR4989 
-- James Tuttle
-- 11/07/2012
--
-- Purpose:
--
--
--
--
--==============================================================================*/

--CREATE PROC JT_Open_Order_MKTG_Displays_Samples AS
BEGIN
SELECT ohotyp		AS Order_Type
	  ,cmslmn		AS Salesman
	  ,smname		AS Salesman_Name
	  ,Order_Date	AS Order_Date
	  ,ohvia		AS Via
	  ,olord#		AS Order#
	  ,cmcust		AS Customer#
	  ,cmname		AS Customer
	  ,olitem		AS Item
	  ,oldesc		AS [Description]
	  ,oliloc		AS loc
	  ,olqshp		AS QTY_Ship
	  ,olqbo		AS QTY_BO
	  ,Ship_Date	AS Ship_Date
	FROM OPENQUERY(GSFL2K, '
		SELECT ohotyp
			  ,cmslmn
			  ,smname
			  ,MONTH(ohodat)|| ''/'' || DAY(ohodat)|| ''/'' || YEAR(ohodat) as Order_Date
			  ,ohvia
			  ,olord#
			  ,cmcust
			  ,cmname
			  ,olitem
			  ,oldesc
			  ,oliloc
			  ,olqshp
			  ,olqbo
			  ,MONTH(ohsdat)|| ''/'' || DAY(ohsdat)|| ''/'' || YEAR(ohsdat) as Ship_Date
		FROM oohead oh
		JOIN ooline ol ON (oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#)
		JOIN itemmast im ON im.imitem = ol.olitem
		JOIN custmast cm ON cm.cmcust = ol.olcust 
		JOIN salesman sm ON cm.cmslmn = sm.smno
		WHERE oh.ohotyp IN(''DP'',''SA'')
			AND ol.olico = 1
		ORDER BY oh.ohodat DESC
		')

END


