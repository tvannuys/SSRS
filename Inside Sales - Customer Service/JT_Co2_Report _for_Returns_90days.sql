/*********************************************************************************
**																				**
** SR# 13212																	**
** Programmer: James Tuttle				Date: 08/08/2013						**
** ---------------------------------------------------------------------------- **
** Purpose:			Will you put together a report of all returns for company	**
**				 2 for the last 90 days? Will need the order #, customer name,  **
**				 dollar amount, restock fee’s, freight, delivery and sales rep	**	
**				 on the account.												**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/


BEGIN
 SELECT DISTINCT shco	AS [Co]
		,shloc	AS [Loc]
		,shord#	AS [Order#]
		,cmname	AS [Cust Name]
		,shidat AS [Inv Date]
		,shemds	AS [Sub Total]
		,shspc1	AS [Delv Chg]
		,shspc2 AS [Restock]
		,shspc3 AS [Discount]
		,shspc4 AS [Frt/Hndl]
		,shspc5 AS [Misc. SurChg]
		,shtotl AS [Total]
		,slslmn	AS [Sales#]
		,smname AS [Name]
 FROM OPENQUERY(GSFL2K,	
	'SELECT shco
		,shloc
		,shord#
		,cmname
		,shidat
		,shemds
		,shspc1
		,shspc2 
		,shspc3 
		,shspc4 
		,shspc5 
		,shtotl 
		,slslmn
		,smname
		
	FROM shhead sh
	LEFT JOIN shline sl ON (sl.slco = sh.shco
		    AND sl.slloc = sh.shloc
		    AND sl.slord# = sh.shord#
		    AND sl.slrel# = sh.shrel#
		    AND sl.slcust = sh.shcust)
	LEFT JOIN custmast cm ON cm.cmcust = sh.shcust
	LEFT JOIN salesman sm ON sm.smno = sl.slslmn
	
	WHERE shidat >= CURRENT_DATE - 90 DAYS
		AND shco = 2
		AND sh.shotyp = ''RA''
		
	
	
	')
END