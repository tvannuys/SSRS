/*********************************************************************************
**																				**
** SR# 11622																	**
** Programmer: James Tuttle	Date: 06/11/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:		We are working on a project this week to order Villa sample		**
**            updates for customers who already have samples of Villa.  Could	**
**			you create a report for us to use this week?  It’s a hot project	**
**			so we will need it quickly if you can.								**
**																				**	
**			1.	Use/Copy Promotional Report										**
**			2.	Include all existing fields										**
**			3.	Replace Product Code with Item Number							**
**			4.	Allow to search for multiple item numbers						**
**			5.	Include only orders that have been invoiced, no open orders		**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC uspInvoicedOrders 
		@OrdStartDate varchar(10)
		,@OrdEndDate varchar(10)			
		,@Vendor varchar(6) 
-- CSV is for the Item Number 
		,@CSV varchar(1000)
		
AS
BEGIN
 DECLARE @sql varchar(MAX)
 SET @sql = '
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT shord# AS Order
		,slcls# AS Item_Class
		,shinv# AS Invoice
		,MONTH(shidat) || ''''/'''' || DAY(shidat) || ''''/'''' || YEAR(shidat) AS Inv_Date
		,slvend AS Vendor
		,MONTH(shodat) || ''''/'''' || DAY(shodat) || ''''/'''' || YEAR(shodat) AS Order_Date
		,shcust AS Cust_Nbr
		,cmname AS Cust_Name
		,slprcd AS Product_cd
		,slitem AS Item_Nbr
		,sldesc AS Item_Desc
		,slblus AS Ship_Qty
		,slum2 AS UM
		,slpric AS Unit_Price
		,sleprc AS Ext_Price
		,smno AS Salesman_Nbr
		,smname AS Salesman

		
	FROM shhead sh
	LEFT JOIN shline sl ON (sh.shco = sl.slco
		AND sh.shloc = sl.slloc
		AND sh.shord# = sl.slord#
		AND sh.shrel# = sl.slrel#
		AND sh.shinv# = sl.slinv#)
	LEFT JOIN custmast cm ON cm.cmcust = sh.shcust
	LEFT JOIN salesman sm ON sm.smno = sl.slslmn
	
	WHERE sh.shodat >= ' + '''' + '''' + @OrdStartDate + '''' + '''' + '
		AND  sh.shodat <= ' + '''' + '''' + @OrdEndDate + '''' + '''' + '
		AND sl.slvend = ' + '''' + '''' + @Vendor + '''' + '''' + '
		
	'') 
WHERE Item_Nbr IN (SELECT * FROM dbo.udfCSVToList(''' + @CSV + '''))
	'
END 
EXEC(@sql)
GO

-- 

-- uspInvoicedOrders '01/15/2013','05/15/2013',40001,'TASGABRDVILLAASH,TASGABRDVILLAVICT'


