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
			/* INNER JOIN [customer marketing codes cca group] ON SHHEAD.SHCUST = [customer marketing codes cca group].[Cust Nbr])  */
			INNER JOIN CUSTMKTG ON CUSTMKTG.CMKCUS=SHLINE.SLCUST
			INNER JOIN VENDMAST ON SHLINE.SLVEND = VENDMAST.VMVEND
			INNER JOIN CUSTMAST ON CUSTMAST.CMCUST=SHLINE.SLCUST
			inner join mkcdmast on mkcdmast.mcmkcd=custmktg.cmkmkc
			
WHERE 	shline.sldiv between 6 and 9
		and shline.slvend not in (1573,2490,10131,10202)
		and shline.sldate between ''07/01/2013'' and ''07/31/2013''
		and cmkmkc in (''C1'',''FA'',''FE'',''GC'',''ID'',''PR'',''RD'',''ST'',''TR'')

')