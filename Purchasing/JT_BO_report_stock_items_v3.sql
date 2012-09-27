
/*
---------------------------------------------------------------------------------------------------------
Create a report of Back Ordered items that are stocking items.  
Fields:  Buyer   Item #  Description  Vendor#  BO Qty  Sales order #  PO#  PO Due Date   Manifest #
 
Sort would be by buyer/Vendor/item..

---------------------------------------------------------------------------------------------------------
ITEMMAST.IMSI has the flag for master stocking items
 Back ordered lines are in POBOLINE table
---------------------------------------------------------------------------------------------------------
James Tuttle - 08/31/2012

Change:  Omit any FO sales order type or purchase order type

Add 12 month rolling sales Qty and YTD Sales Qty

Add PO Creation Date

Add count on sales order per YTD column and rolling 12 month
---------------------------------------------------------------------------------------------------------
*/
-- James	09/12/2012
-- Talked with Jeff and went over v3
-- He wants the YTD fields removed and keep the rolling 12 months.
-- Also he arange how he would like the fields to layed out now.
--
alter PROC JT_BO_Report_Stock_Items_v3 AS 
BEGIN
SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT photyp as PO_Type
		  ,MONTH(phdoi)|| ''/'' || DAY(phdoi) || ''/'' || YEAR(phdoi) as Created_on
		  ,plbuyr as buyer
		  ,pbitem as item
		  ,pldesc as description
		  ,plvend as vendor
		  ,pboqty as qty
		  ,pboco as Order_Co
		  ,pboloc as Order_loc
		  ,pboord as order
		  ,pbco as PO_co
		  ,pbloc as PO_loc
		  ,pbpo# as po
		  ,MONTH(plddat)|| ''/'' || DAY(plddat) || ''/'' || YEAR(plddat) as due_date
/*---- Get manifest number ------------------------------------------------------------------------------------------*/
		  ,(select COALESCE(max(mnman#),''None'') from manifest WHERE mnpo# = pl.plpo#
						and mnpolo = pl.plloc
						and mnitem = pl.plitem
						and mnpoco = pl.plco) as Manifest	
/*---- YTD sales qty  -----------------------------------------------------------------------------------------------*/  	
		 , (select COALESCE(sum(slblus),0) from shline sl1 JOIN shhead sh1 ON (sh1.shco = sl1.slco  
								and sh1.shloc = sl1.slloc
								and sh1.shord# = sl1.slord#
								and sh1.shrel# = sl1.slrel#
								and sh1.shinv# = sl1.slinv#
								and sh1.shcust = sl1.slcust)  
					WHERE sl1.slitem = pl.plitem     
		 						and sh1.shidat >= current_date - (dayofyear(current_date) - 1) days /* beggining of year	*/) as YTD_sales_qty
/*---- Bill Sales UM  -----------------------------------------------------------------------------------------------*/
		 ,(Select slum2 from shline sl2 
					WHERE sl2.slitem = pl.plitem
					fetch first 1 rows only) as YTD_sales_UM
/*---- COUNT on YTD sales orders -------------------------------------------------------------------------------------*/ 
		 , (select COUNT(slitem) from shline sl3 JOIN shhead sh3 ON (sh3.shco = sl3.slco  
								and sh3.shloc = sl3.slloc
								and sh3.shord# = sl3.slord#
								and sh3.shrel# = sl3.slrel#
								and sh3.shinv# = sl3.slinv#
								and sh3.shcust = sl3.slcust)  
					WHERE sl3.slitem = pl.plitem     
		 						and sh3.shidat >= current_date - (dayofyear(current_date) - 1) days /* beggining of year	*/) as YTD_Order_Count
/*---- Rolling 12 month sales qty ------------------------------------------------------------------------------------*/		
		  ,(select COALESCE(sum(slblus),0) from shline sl4 JOIN shhead sh4 ON (sh4.shco = sl4.slco  
								and sh4.shloc = sl4.slloc
								and sh4.shord# = sl4.slord#
								and sh4.shrel# = sl4.slrel#
								and sh4.shinv# = sl4.slinv#
								and sh4.shcust = sl4.slcust)  
					WHERE sl4.slitem = pl.plitem     
		 						and sh4.shidat >= current_date - 365 days /* rolling year */) as  rolling_12m_sales_qty
/*---- Bill Sales UM  -----------------------------------------------------------------------------------------------*/
		 ,(Select MAX(slum2) from shline sl5
					WHERE sl5.slitem = pl.plitem ) as rolling_12m_sales_UM	
/*---- COUNT on rolling 12 month sales orders ------------------------------------------------------------------------*/ 
		  ,(select COUNT(slitem) from shline sl6 JOIN shhead sh6 ON (sh6.shco = sl6.slco  
						and sh6.shloc = sl6.slloc
						and sh6.shord# = sl6.slord#
						and sh6.shrel# = sl6.slrel#
						and sh6.shinv# = sl6.slinv#
						and sh6.shcust = sl6.slcust)
			WHERE sl6.slitem = pl.plitem     
						and sh6.shidat >= current_date - 365 days /* rolling year */) as  rolling_12m_order_count	
			
	FROM poboline bo
	JOIN poline pl
		ON (bo.pbco = plco
			AND bo.pbloc = pl.plloc
			AND bo.pbpo# = pl.plpo#
			AND bo.pbitem = pl.plitem)
	JOIN itemmast im ON pl.plitem = im.imitem
	JOIN pohead ph ON (pl.plco = ph.phco
		AND pl.plloc = ph.phloc
		AND pl.plpo# = ph.phpo#)
	WHERE im.imsi = ''Y''
		AND pl.pldirs != ''Y''
	ORDER BY plbuyr
			,plvend
			,manifest
			,pbpo#
	')
END	


