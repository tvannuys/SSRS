/*********************************************************************************
**																				**
** SR# 13712																	**
** Programmer: James Tuttle	Date: 08/26/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:		All samples/display for 001-50 and 002-41 that 					**
**				have QOH > 0													**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_DroppedSamplesJohnB AS
BEGIN
 SELECT idco			AS [Co]
		   ,idloc		AS [Loc]
		   ,iditem		AS [Item]
		   ,iddesc		AS [Description]
		   ,idqoh		AS [QOH]
		   ,idbin		AS [Bin]
		   
 FROM OPENQUERY(GSFL2K,	
	'SELECT idco
		   ,idloc
		   ,iditem
		   ,iddesc
		   ,idqoh
		   ,idbin
		   ,IdFCRG
		   ,imdrop
		   
	FROM itemdetl id
	LEFT JOIN itemmast im ON im.imitem = id.iditem
	
	WHERE id.idloc IN (41,50)
		AND id.idfcrg = ''S''
		AND im.imdrop = ''D''
		
	ORDER BY id.idco
			,id.idloc
	')
END