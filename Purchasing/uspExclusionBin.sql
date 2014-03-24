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
	'SELECT idco
			,idloc
			,idbin
			,blgrp
			,iditem
			,idserl
			,idqoh
			,idqoo
			,blzone AS Zone
			,blgrp AS section

	
	FROM binloc bl
	INNER JOIN itemdetl id ON (id.idbin = bl.blbin
							AND id.idco = bl.blco
							AND id.idloc = bl.blloc)

	WHERE blndbn = ''N''
		AND idqoh > 0
		AND blbin != ''SHIPD''
		AND idqoo < 1


	ORDER BY idco
			,blloc
			,blzone
			,iditem
			,blbin
	')
END
