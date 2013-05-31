

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

ALTER PROC uspIncoming__InventoryAvail_Engineered_DATASOURCEv2 AS

 SELECT *
 FROM OPENQUERY(GSFL2K,
 'WITH
#tempID AS
	(	SELECT * 
		FROM itemdetl
		WHERE idloc IN (04,12,50,60,80)
			AND idvend = 24020
	) 

, #tempBl AS
	(	SELECT * 
		FROM binloc
		WHERE blloc IN (04,12,50,60,80)
	)
			  
SELECT id.idloc						AS Loc
	  ,id.iditem					AS Item
	  ,id.idbin						AS Bin
	  ,SUM(id.idqoh - id.idqoo)		AS Qty_Avail

 FROM #tempID id
	 ,#tempBL bl

 WHERE bl.blbin = id.idbin
	AND bl.blgrp != ''XXXXX''

 GROUP BY id.idloc
		 ,id.iditem
		 ,id.idbin

 HAVING SUM(id.idqoh - id.idqoo) > 0

 ')

 
