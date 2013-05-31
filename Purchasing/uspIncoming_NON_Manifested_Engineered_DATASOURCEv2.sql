

/*************************************************************************************
**																					**
** SR# 11139																		**
** Programmer: James Tuttle	Date: 05/29/2013										**
** --------------------------------------------------------------------------------	**
** Purpose:		Date Source for Excel Pivot table on Purchase Agent's's Local PC	**
**																					**
**		Used 'WITH #tempXX AS' as temp tables in the DB2 to be able					**
**		to get the QOH itembalance for where the Manifest is going					**
**		since PO# location may differ.												**
**																					**
*************************************************************************************/

-- 184

ALTER PROC uspIncoming_NON_Manifested_Engineered_DATASOURCEv2 AS

 SELECT *
 FROM OPENQUERY(GSFL2K,
 'WITH
#tempPO AS
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
			
			AND poline.plpkg = ''R''
	) 
	
 ,#tempIB AS ( SELECT ibqoh AS QOH
				,ibloc AS Loc
				,ibitem AS Item
			  FROM itembal )
			  
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
		,ib.QOH								AS Loc_QOH
		,po.imdiv							AS Division
		,po.imfmcd							AS Family_Code
 
 FROM #tempPO po
	 ,#tempIB ib
	
WHERE ib.Item = po.plitem
	AND ib.Loc = po.plloc
	AND po.plitem = ''EN194882''
 ')
 
 -- See manifest items ONLY
-- SELECT * FROM OPENQUERY(GSFL2K,'select * from manifest where manifest.mnvend = 24020 ') 
 
