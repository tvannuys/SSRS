
-- James Tuttle
-- 08/20/2012
-- SR-4131
/*-----------------------------------------------------------------
Create a SSRS for all Claims and Freight Claims
older than 3 weeks to date ran
-----------------------------------------------------------------*/

CREATE PROC JT_3week_older_claims_by_vendor AS
SELECT *
FROM OPENQUERY(GSFL2K,
 'SELECT ohco AS Co
		,ohloc AS Loc
		,olvend AS Vend#
		,vmname AS Vendor_Name
		,SUM(olecst) AS ext_cost
 FROM oohead oh
 JOIN ooline ol
	ON (oh.ohco = ol.olco
		AND oh.ohloc = ol.olloc
		AND oh.ohord# = ol.olord#
		AND oh.ohrel# = ol.olrel#)
JOIN vendmast vm ON ol.olvend = vm.vmvend
JOIN custmast cm ON oh.ohcust = cm.cmcust
WHERE oh.ohodat < CURRENT_DATE - 21 DAYS 
	AND oh.ohotyp IN(''CL'',''FR'')
	AND ol.olvend != ''40000''
GROUP BY oh.ohco
		,oh.ohloc
		,ol.olvend
		,vm.vmname
ORDER BY oh.ohco
		,oh.ohloc
		,ol.olvend
 ')


/*----------------------------------------------------------------------------
--------- DETAILS
SELECT *
FROM OPENQUERY(GSFL2K,
 'SELECT ohco AS Co
		,ohloc AS Loc
		,ohord# AS Order#
		,MONTH(ohodat) || ''/'' || DAY(ohodat) || ''/'' || YEAR(ohodat) AS Date_Created
		,olvend AS Vend#
		,vmname AS Vendor_Name
		,ohcust AS Customer#
		,cmname AS Customer_Name
		,olitem AS Item
		,oldesc As Description
		,olcost AS Item_Cost
		,olqord AS Quantity	
		,olecst AS ext_cost
 FROM oohead oh
 JOIN ooline ol
	ON (oh.ohco = ol.olco
		AND oh.ohloc = ol.olloc
		AND oh.ohord# = ol.olord#
		AND oh.ohrel# = ol.olrel#)
JOIN vendmast vm ON ol.olvend = vm.vmvend
JOIN custmast cm ON oh.ohcust = cm.cmcust
WHERE oh.ohodat < CURRENT_DATE - 21 DAYS 
	AND oh.ohotyp IN(''CL'',''FR'')
	AND ol.olvend != ''40000''
	AND ol.olvend = ''21861''
ORDER BY oh.ohco
		,oh.ohloc
		,ol.olvend
 ')
--------------------------------------------------------------*/

