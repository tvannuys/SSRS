/*********************************************************************************
**																				**
** SR# 9382																		**
** Programmer: James Tuttle	Date: 4/10/2013										**
** ---------------------------------------------------------------------------- **
** Purpose:		From MS Access - HVE_BBoss Spiff Promo Staff Results			**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_BBoss_Spiff_Promo_Staff_Results 
	@StartDate AS varchar(10)
	,@EndDate AS varchar(10)
AS
BEGIN
 DECLARE @sql varchar(MAX)
 SET @sql = '
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT shord# AS Order
		,slcls# AS Item_Class
		,shinv# AS Invoice
		,shidat AS Inv_Date
		,slvend AS Vendor
		,shodat AS Order_Date
		,shpo# AS Cust_PO
		,shcust AS Cust_Nbr
		,cmname AS Cust_Name
		,slprcd AS Product_cd
		,slitem AS Item_Nbr
		,sldesc AS Item_Desc
		,slblus AS Ship_Qty
		,slum2 AS UM
		,slpric AS Unit_Price
		,sleprc AS Ext_Price
		,slcost AS Ship_Lines_Cost
		,slecst AS Ext_Cost
		,slencs AS Ext_Net_Cost
		,slesc1 AS Ext_Spec_Cost1
		,slesc2 AS Ext_Spec_Cost2
		,slesc3 AS Ext_Spec_Cost3
		,slesc4 AS Ext_Spec_Cost4
		,slesc5 AS Ext_Spec_Cost5
		,slloc AS Loc
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
	
	WHERE sh.shidat >= ' + '''' + '''' + @StartDate + '''' + '''' + '
		AND sh.shidat <= ' + '''' + '''' + @EndDate + '''' + '''' + '
		AND sl.slvend = 22859
	'')'
END
EXEC(@sql)
GO

/*------------------------------------------------------------------------------------------------------------------------------
SELECT GSFL2K_SHHEAD.[SHORD#], 
GSFL2K_SHLINE.[SLCLS#], 
GSFL2K_SHHEAD.[SHINV#] AS [Invoice Nbr], 
GSFL2K_SHHEAD.SHIDAT AS [Invoice Date], 
GSFL2K_SHLINE.SLVEND, 
GSFL2K_SHHEAD.SHODAT AS [Order Date], 
GSFL2K_SHHEAD.[SHPO#] AS [Cust PO#], 
GSFL2K_SHHEAD.SHCUST AS [Cust Nbr], 
GSFL2K_CUSTMAST.CMNAME AS [Cust Name], 
GSFL2K_SHLINE.SLPRCD, 
GSFL2K_SHLINE.SLITEM AS [Item Nbr], 
GSFL2K_SHLINE.SLDESC AS [Item Desc], 
GSFL2K_SHLINE.SLBLUS AS [Ship Qty], 
GSFL2K_SHLINE.SLUM2 AS [Unit of Measure], 
GSFL2K_SHLINE.SLPRIC AS [Unit Price], 
GSFL2K_SHLINE.SLEPRC AS [Extended Price], 
GSFL2K_SHLINE.SLCOST AS [Ship Lines Cost], 
GSFL2K_SHLINE.SLECST AS [Extended Cost], 
GSFL2K_SHLINE.SLENCS AS [Extended Net Cost], 
GSFL2K_SHLINE.SLESC1, 
GSFL2K_SHLINE.SLESC2, 
GSFL2K_SHLINE.SLESC3, 
GSFL2K_SHLINE.SLESC4, 
GSFL2K_SHLINE.SLESC5, 
GSFL2K_SHLINE.SLLOC, 
GSFL2K_SALESMAN.SMNAME, 
GSFL2K_SHLINE.SLVEND AS Vendor, 
GSFL2K_SALESMAN.SMNO

FROM GSFL2K_SALESMAN INNER JOIN ((GSFL2K_SHLINE INNER JOIN GSFL2K_SHHEAD ON (GSFL2K_SHLINE.SLCO = GSFL2K_SHHEAD.SHCO) 
	AND (GSFL2K_SHLINE.SLLOC = GSFL2K_SHHEAD.SHLOC) 
	AND (GSFL2K_SHLINE.[SLORD#] = GSFL2K_SHHEAD.[SHORD#]) 
	AND (GSFL2K_SHLINE.[SLREL#] = GSFL2K_SHHEAD.[SHREL#]) 
	AND (GSFL2K_SHLINE.[SLINV#] = GSFL2K_SHHEAD.[SHINV#])) 
INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_SHHEAD.SHCUST = GSFL2K_CUSTMAST.CMCUST) ON GSFL2K_SALESMAN.SMNO = GSFL2K_SHLINE.SLSLMN
WHERE (((GSFL2K_SHHEAD.SHIDAT) Between #11/1/2011# And #12/31/2011#) 
	AND ((GSFL2K_SHLINE.SLVEND)=22859) 
	AND ((GSFL2K_SHHEAD.SHODAT) Between #11/1/2011# And #12/31/2011#));
------------------------------------------------------------------------------------------------------------------------------*/


-- HVE_BBoss_Spiff_Promo_Staff_Results '03/08/2013','04/08/2013'