select * from openquery (gsfl2k,'

SELECT	SLLOC AS Location, 
		SLORD# AS OrderNum, 
		SLCUST AS CustNum, 
		CMNAME AS CustName, 
		SLITEM AS Item#, 
		SLDESC AS ItemDesc, 
		SLQSHP AS ShipQty, 
		SLUM1 AS ShipUM, 
		SLEPRC AS ShipExtendedPrice, 
		SLECST AS ShipExtendedCost, 
		SLINV# AS InvoiceNum, 
		SLDATE AS InvoiceDate, 
		CGBGRP AS BuyingGroup, 
		SLPRCD AS ProdCode, 
		SLESC4 AS FileBackAmount


FROM CUSTMAST 
	INNER JOIN SHLINE ON CUSTMAST.CMCUST = SHLINE.SLCUST
	INNER JOIN CUSTBGRP ON CUSTMAST.CMBILL = CUSTBGRP.CGCUST


WHERE	CGBGRP=''JSCOOP''
		AND SLVEND=1573 
		AND SLCO=1
		and (year(sldate)=year(current_date - 1 month)
			and month(sldate)=month(current_date)-1)
	
	')
