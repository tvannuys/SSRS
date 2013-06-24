

/*********************************************************************************
**																				**
** SR# 11474																	**
** Programmer: James Tuttle	Date: 06/10/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:	Can you run a query to show how many open lines I have on PO for	**
**	3 Vendor numbers?															**
**																				**
**                16037    Armstrong Residential								**
**                22312    Armstrong Wood										**
**                24213    Armstrong Commercial									**
**																				**
**	Vendor (multiple) as a PARM													**
**  return as a summary and user can expand by clicking the + symbol to view	**
**  the vendor's POs and the PO's lines											**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC  uspVendorPoLines
	@CSV varchar(100)
	
 AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT plco
		,plloc
		,plpo#
		,plvend
		,vmname
		,plitem
		,pldesc
		,plqord
		,plum1
		
	FROM poline pl
	LEFT JOIN vendmast vm ON pl.plvend = vm.vmvend
	
	WHERE pl.pldelt = ''A''
	
	ORDER BY pl.plco
			,pl.plloc
			,pl.plvend
			,pl.plpo#
			,pl.plitem
	')
	WHERE plvend IN (SELECT * FROM dbo.udfCSVToList(@CSV))
	
END

-- uspVendorPoLines '24213'