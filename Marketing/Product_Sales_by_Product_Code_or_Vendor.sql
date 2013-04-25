/*********************************************************************************
**																				**
** SR# 9386																		**
** Programmer: James Tuttle		Date: 04/16/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Commercial Expressions Sales					**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/
-- James Tuttle		Date:04/25/13
-- SR# 9938  this report I need to be able to change the product codes or vendor
-- number. This can be called "Product Sales by Product Code or Vendor #"
----------------------------------------------------------------------------------

ALTER PROC Product_Sales_by_Product_Code_or_Vendor 
	@ProdCode NVARCHAR(100)
	,@Vendor	  smallint 

AS
BEGIN
 SELECT shord#		AS OrderNbr
		,slcls#		AS ItemClass
		,shinv#		AS InvoiceNbr
		,iDt		AS InvoiceDate
		,oDt		AS OrderDate
		,shpo#		AS PONbr
		,shcust		AS CustNbr
		,cmname		AS CustName
		,slprcd		AS ProductCode
		,slitem		AS Item
		,sldesc		AS [Description]
		,slblus		AS BillUnitsShip
		,slum2		AS UM
		,slpric		AS UnitPrice
		,sleprc		AS SubTotal
		,slcost		AS UnitCost
		,slecst		AS ExtCost
		,slencs		AS ExtNetCost
		,slesc1		AS ExtSpecCost1
		,slesc2		AS ExtSpecCost2
		,slesc3		AS ExtSpecCost3
		,slesc4		AS ExtSpecCost4
		,slesc5		AS ExtSpecCost5
		,slloc		AS Loc
		,smno		AS SalesNbr
		,smname		AS SalesName
		,slvend		AS VendNbr
		,vmname		AS VendName
 FROM OPENQUERY(GSFL2K,	
	'SELECT shord#		
		,slcls#
		,shinv#
		,MONTH(shidat) || ''/'' || DAY(shidat) || ''/'' || YEAR(shidat) AS iDt
		,MONTH(shodat) || ''/'' || DAY(shodat) || ''/'' || YEAR(shodat) AS oDt
		,shpo#
		,shcust
		,cmname
		,slprcd
		,slitem
		,sldesc
		,slblus
		,slum2
		,slpric
		,sleprc
		,slcost
		,slecst
		,slencs
		,slesc1
		,slesc2
		,slesc3
		,slesc4
		,slesc5
		,slloc
		,smno
		,smname
		,slvend
		,vmname
		
	FROM shhead sh
	LEFT JOIN shline sl ON (sh.shco = sl.slco
						AND sh.shloc = sl.slloc
						AND sh.shord# = sl.slord#
						AND sh.shrel# = sl.slrel#
						AND sh.shinv# = sl.slinv#)
	LEFT JOIN custmast cm ON cm.cmcust = sh.shcust
	LEFT JOIN salesman sm ON sm.smno = sl.slslmn
	LEFT JOIN vendmast vm ON vm.vmvend = sl.slvend
	
	WHERE ((sl.slprcd = ''+ @ProdCode + '')
	  OR (sl.slvend = '' + @Vendor + ''))
	')
END

-- Product_Sales_by_Product_Code_or_Vendor 

/*----------------------------------------------------------------------------------------------------------
--
MS Access
--
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
		GSFL2K_SHLINE.SLVEND AS Vendor
     
FROM GSFL2K_SALESMAN 
INNER JOIN ((GSFL2K_SHLINE INNER JOIN GSFL2K_SHHEAD ON (GSFL2K_SHLINE.SLCO = GSFL2K_SHHEAD.SHCO) 
	AND (GSFL2K_SHLINE.SLLOC = GSFL2K_SHHEAD.SHLOC) 
	AND (GSFL2K_SHLINE.[SLORD#] = GSFL2K_SHHEAD.[SHORD#])
	 AND (GSFL2K_SHLINE.[SLREL#] = GSFL2K_SHHEAD.[SHREL#]) 
	 AND (GSFL2K_SHLINE.[SLINV#] = GSFL2K_SHHEAD.[SHINV#])) 
INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_SHHEAD.SHCUST = GSFL2K_CUSTMAST.CMCUST) 
ON GSFL2K_SALESMAN.SMNO = GSFL2K_SHLINE.SLSLMN

WHERE (((GSFL2K_SHLINE.SLPRCD)=13660));
----------------------------------------------------------------------------------------------------------*/