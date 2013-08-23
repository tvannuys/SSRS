/*********************************************************************************
**																				**
** SR# 13659																	**
** Programmer: James Tuttle	Date: 08/23/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:																		**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_BinQuery 
	@binLoc AS varchar(5)
AS
BEGIN
DECLARE @sql AS varchar(4000) = '

 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT idco
		,idloc
		,iditem
		,idserl
		,idky
		,MONTH(irdate) || ''''/'''' || 
			DAY(irdate) || ''''/'''' || 
			YEAR(irdate) AS dt
		,idbin
		,idqoh
		,idqoo
		,(idqoh - idqoo) AS Avail
		,idcomt
		,iruser
		
	FROM itemrech ir
	LEFT JOIN itemdetl id ON (ir.iritem = id.iditem
						  AND ir.irky = id.idky
						  AND ir.irbin = id.idbin )
	
	WHERE irdate > CURRENT_DATE - 730 DAYS
		AND idbin = ' + '''' + '''' + @binLoc + '''' + '''' + '
		AND irqty > 0
		
	ORDER by idco
			,idloc
	'')'
	
	EXEC (@sql)
END

-- JT_BinQuery 'Z0FRT'