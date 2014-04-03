/*********************************************************************************
**																				**
** SR# 19686																	**
** Programmer: James Tuttle	Date: 04/03/2014									**
** ---------------------------------------------------------------------------- **
** Purpose:		Hi, I need a report that mimics this one below… except I just	**
**			 want date range and vendor… and only orders sold to account		**
**			 1004551 Sample Production											**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

CREATE PROC uspInvoicedOrdersSamplesProduction 
		@OrdStartDate varchar(10)
		,@OrdEndDate varchar(10)			
		,@Vendor varchar(6) 
		
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
		AND sh.cust = ''1004551''
		
	'') 

	'
END 
EXEC(@sql)
GO

-- 

-- uspInvoicedOrdersSamplesProduction '01/15/2013','05/15/2013',40001,


