select * from openquery (gsfl2k,'

SELECT	SHINV# AS InvoiceNbr, 
		SHIDAT AS InvoiceDate, 
		SHODAT AS OrderDate, 
		SHPO# AS CustPO#, 
		SHOTYP AS OrderType, 
		SHCUST AS CustNbr, 
		CMNAME AS CustName, 
		SLITEM AS ItemNbr, 
		SLDESC AS ItemDesc, 
		SLBLUS AS ShipQty, 
		SLUM2 AS UnitofMeasure, 
		SLPRIC AS UnitPrice, 
		SLEPRC AS ExtendedPrice

FROM SHLINE 
	Left JOIN SHHEAD ON (SHLINE.SLINV# = SHHEAD.SHINV# 
		AND SHLINE.SLREL# = SHHEAD.SHREL# 
		AND SHLINE.SLORD# = SHHEAD.SHORD# 
		AND SHLINE.SLLOC = SHHEAD.SHLOC
		AND SHLINE.SLCO = SHHEAD.SHCO)
	Left JOIN CUSTMAST ON SHHEAD.SHCUST = CUSTMAST.CMCUST


WHERE SHCUST=''4001041''
	and (year(shidat)=year(current_date - 1 month)
	    and month(shidat)=month(current_date)-1)


	
	')
