select * from openquery (gsfl2k,'

SELECT 	SHLINE.SLLOC AS Location, 
		SHLINE.SLORD# AS OrderNum, 
		SHLINE.SLCUST AS CustNum, 
		CUSTMAST.CMNAME AS CustName, 
		SHLINE.SLITEM AS ItemNum, 
		SHLINE.SLDESC AS ItemDesc, 
		SHLINE.SLQSHP AS ShipQty, 
		SHLINE.SLUM1 AS ShipUM, 
		SHLINE.SLEPRC AS ExtendedPrice, 
		SHLINE.SLECST AS ExtendedCost, 
		SHLINE.SLINV# AS InvoiceNum, 
		SHLINE.SLDATE AS InvoiceDate, 
		SHLINE.SLPRCD AS ProdCode, 
		SHLINE.SLESC4 AS FileBackAmt, 
		SHLINE.SLGRP


FROM SHLINE 
	INNER JOIN CUSTMAST ON SHLINE.SLCUST = CUSTMAST.CMCUST


WHERE (year(shline.sldate)=year(current_date - 1 month) and month(shline.sldate)=month(current_date)-1)
		AND SHLINE.SLPRCD Between 52033 And 52052 
		AND SHLINE.SLVEND = 1573 
		AND SHLINE.SLCO = 1
')