
-- Two TEMP tables in DB2 V2.1--
 SELECT *
 FROM OPENQUERY(GSFL2K,
 'WITH
	#tempIB AS 
	( SELECT ibqoh AS QOH
			,ibloc AS Loc
			,ibitem AS Item
		FROM itembal )
			  
 ,#tempPO AS
	(	SELECT * 
		FROM poline
		LEFT JOIN vendmast ON vendmast.vmvend = poline.plvend
		LEFT JOIN itemmast ON itemmast.imitem = poline.plitem
		LEFT JOIN pohead ON ( pohead.phco = poline.plco
							AND pohead.phloc = poline.plloc
							AND pohead.phvend = poline.plvend
							AND pohead.phpo# = poline.plpo# )
		WHERE poline.plvend = 24020 
			AND poline.pldelt = ''A''
			AND poline.plitem IN( SELECT mnitem FROM manifest)
			) 
		
 ,#tempMN AS
	( SELECT * 
	  FROM manifest
	  WHERE manifest.mnvend = 24020 )
		 
SELECT po.pldelt							AS Code
		,po.plbuyr							AS Buyer
		,po.vmname							AS Vendor
		,po.imprcd							AS Product_Code
		,po.plitem							AS PO_Item
		,po.pldesc							AS Description
		,po.imcolr							AS Color
		,po.plco							AS PO_Co
		,po.plloc							AS PO_Loc
		,po.plpo#							AS PO_Nbr
		,po.plqord							AS PO_Qty
		,po.phref#							AS PO_RefNbr
		,MONTH(po.phdoi) || ''/'' || 
			DAY(po.phdoi) || ''/'' || 
			YEAR(po.phdoi)					AS IssueDate
		,MONTH(po.plpdat) || ''/'' || 
			DAY(po.plpdat) || ''/'' || 
			YEAR(po.plpdat)					AS ProductionDate
		,MONTH(po.plshipdate) || ''/'' || 
			DAY(po.plshipdate) || ''/'' || 
			YEAR(po.plshipdate)				AS ShipDate
		,po.plddatconf
		,MONTH(po.plddat) || ''/'' || 
			DAY(po.plddat) || ''/'' || 
			YEAR(po.plddat)					AS DueDate
	 	,mn.mnloc							AS Man_Loc
	 	,mn.mnman#							AS Man_Nbr
		,ib.QOH								AS Delv_QOH
		,po.imdiv							AS Division
		,imfmcd								AS Family_Code
				  
FROM #tempIB ib
	,#tempPO po
	,#tempMN mn

WHERE ib.item = mn.mnitem
	AND ib.loc = mn.mnloc
	AND 
	AND po.plitem = ''EN138674''

ORDER BY po.plitem
 ') 

