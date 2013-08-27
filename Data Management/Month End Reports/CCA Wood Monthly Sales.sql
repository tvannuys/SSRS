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
			
WHERE 	SHHEAD.SHCUST<>''1008342''
			AND SHLINE.SLDATE Between ''7/1/2013'' And ''7/31/2013'' 
			and (SHLINE.SLPRCD in (34500,22647,34057,34058,13592,13593,13594,13595)
				or SHLINE.SLCLS#=4177
				or SHLINE.SLVEND = 22859
				and slfmcd<>''W2'' )
			and cmkmkc in (''C1'',''FA'',''FE'',''GC'',''ID'',''PR'',''RD'',''ST'',''TR'')

')