

/*
---------------------------------------------------------------------------------------------------------
Create a report of Back Ordered items that are stocking items.  
Fields:  Buyer   Item #  Description  Vendor#  BO Qty  Sales order #  PO#  PO Due Date   Manifest #
 
Sort would be by buyer/Vendor/item..

---------------------------------------------------------------------------------------------------------
ITEMMAST.IMSI has the flag for master stocking items
 Back ordered lines are in POBOLINE table
---------------------------------------------------------------------------------------------------------
James Tuttle - 08/31/2012

Change:  Omit any FO sales order type or purchase order type

Add 12 month rolling sales Qty and YTD Sales Qty

Add PO Creation Date
---------------------------------------------------------------------------------------------------------
*/

SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT photyp as PO_Type
		  ,phdoi as Created
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
		  ,plddat as due_date
/*---- Get manifest number ------------------------------------------------------------------------------------------*/
		  ,(select max(mnman#) from manifest WHERE mnpo# = pl.plpo#
						and mnpolo = pl.plloc
						and mnitem = pl.plitem
						and mnpoco = pl.plco) as Manifest	
/*---- Rolling 12 month sales qty ------------------------------------------------------------------------------------*/		
		  ,(select sum(slblus) from shline JOIN shhead ON shco = slco  
								and shloc = slloc
								and shord# = slord#
								and shrel# = slrel#
								and shinv# = slinv#
								and shcust = slcust  
								and slitem = pl.plitem     
		 			WHERE shidat >= current_date - 365 days) as  rolling_12m_sales_qty	
/*---- YTD sales qty from ITEMSTAT------------------------------------------------------------------------------------*/  	
		  ,(SELECT SUM(isyqty) from  itemstat where isitem = pl.plitem and isloc != 98) as YTD_sales_qty	
/*---- COUNT on YTD sales orders -------------------------------------------------------------------------------------*/ 
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
	
	
	/* is this the inventory qty or sales qty [SLBLUS] Billable units ship*/
	
