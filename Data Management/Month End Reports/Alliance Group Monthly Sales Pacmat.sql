select * from openquery (gsfl2k,'

SELECT 	SHHEAD.SHINV# AS InvoiceNbr, 
		SHHEAD.SHIDAT AS InvoiceDate, 
		SHHEAD.SHODAT AS OrderDate, 
		SHHEAD.SHPO# AS CustPO#, 
		SHHEAD.SHOTYP AS OrderType, 
		SHHEAD.SHCUST AS CustNbr, 
		CUSTMAST.CMNAME AS CustName, 
		SHLINE.SLITEM AS ItemNbr, 
		SHLINE.SLDESC AS ItemDesc, 
		SHLINE.SLBLUS AS ShipQty, 
		SHLINE.SLUM2 AS UnitOfMeasure, 
		SHLINE.SLPRIC AS UnitPrice, 
		SHLINE.SLEPRC AS ExtendedPrice, 
		SHLINE.SLESC5 AS AccruedRebate, 
		mkcdmast.mcdesc as MktgCodeDesc,
		SHLINE.SLVEND as VendNum, 
		VENDMAST.VMNAME as VendName
		
FROM 	SHLINE 
			INNER JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
				AND SHLINE.SLLOC = SHHEAD.SHLOC AND SHLINE.SLORD#=SHHEAD.SHORD# 
				AND SHLINE.SLREL#=SHHEAD.SHREL# AND SHLINE.SLINV#=SHHEAD.SHINV#) 
			INNER JOIN CUSTMKTG ON CUSTMKTG.CMKCUS=SHLINE.SLCUST
			INNER JOIN VENDMAST ON SHLINE.SLVEND = VENDMAST.VMVEND
			INNER JOIN CUSTMAST ON CUSTMAST.CMCUST=SHLINE.SLCUST
			inner join mkcdmast on mkcdmast.mcmkcd=custmktg.cmkmkc
			
WHERE 	shline.slvend in (22666,22674,22204,22887,22859,17000,22728,22906,21861,16088,16006)
		AND (year(shline.sldate)=year(current_date - 1 month) and month(shline.sldate)=month(current_date)-1)
		and cmkmkc in (''CO'',''CP'')
		and shco=2
		and shotyp not in (''SA'',''DP'',''SR'')

')