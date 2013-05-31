
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

ALTER PROC uspIncoming_Manifested_Engineered_DATASOURCEv2 AS
BEGIN
-- Two TEMP tables in DB2 V2--
 SELECT *
 FROM OPENQUERY(GSFL2K,
 'WITH
	#tempIB AS ( SELECT ibqoh AS QOH
				,ibloc AS Loc
				,ibitem AS Item
			  FROM itembal )
 ,#tempMN AS
	(	SELECT * 
		FROM manifest 
		LEFT JOIN vendmast ON vendmast.vmvend = manifest.mnvend
		LEFT JOIN itemmast ON itemmast.imitem = manifest.mnitem
		WHERE manifest.mnvend = 24020
		 ) 
		 
SELECT   mn.vmname							AS Vendor
		,mn.imprcd							AS Product_Code
		,mn.mnitem							AS PO_Item
		,mn.imdesc							AS Description
		,mn.imcolr							AS Color
		,mn.mnloc							AS PO_Loc
		,mn.mnpo#							AS PO_Nbr
		,mn.mnqshp							AS Man_Qty
		,mn.mnloc							AS Man_Loc
		,mn.mnman#							AS Man_Nbr
		,SUM(ib.QOH)						AS Delv_QOH
		,mn.imdiv							AS Division
		,mn.imfmcd							AS Family_Code
				  
FROM #tempIB ib
	,#tempMN mn

WHERE ib.Item = mn.mnitem
	AND ib.Loc = mn.mnloc
	AND mn.mnitem = ''EN194882''
	
GROUP BY mn.vmname
		,mn.imprcd							
		,mn.mnitem							
		,mn.imdesc							
		,mn.imcolr							
		,mn.mnloc							
		,mn.mnpo#						
		,mn.mnqshp							
		,mn.mnloc							
		,mn.mnman#												
		,mn.imdiv							
		,mn.imfmcd							

 ') 
END
