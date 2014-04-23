/*********************************************************************************
**																				**
** SR# 16949																	**
** Programmer: James Tuttle	Date: 03/21/2014									**
** ---------------------------------------------------------------------------- **
** Purpose:		We could possibly make this very simple.  Report for items in	**
**			Exclusion bin.   If exlusion bin equal zero the items should not 	**
**			 on the report.														**
**			Jeff N																**
**																				**
**																				**
**********************************************************************************/

--ALTER PROC  uspExclusionBin AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT idco		AS Co
			,idloc		AS Loc
			,idbin		AS Bin
			,blgrp		AS Section
			,iditem		AS Item
			,idserl		AS Serl
			,idqoh		AS QOH
			,idqoo		AS Committed


	
	FROM binloc bl
	INNER JOIN itemdetl id ON (id.idbin = bl.blbin
							AND id.idco = bl.blco
							AND id.idloc = bl.blloc)

	WHERE blndbn = ''N''
		AND idqoh > 0
		AND idqoo < 1


	ORDER BY idco
			,blloc
			,iditem
			,blbin
	')
END
