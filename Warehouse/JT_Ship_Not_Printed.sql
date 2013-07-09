/*********************************************************************************
**										**
** SR# nnnn									**
** Programmer: James Tuttle						**
** ---------------------------------------------------------------------------- **
** Purpose:									**
**										**
**										**
**										**
**										**
**										**
**********************************************************************************/

ALTER PROC JT_Ship_Not_Printed AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT *

	FROM oohead oh
	Left Join ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#)
						
	WHERE (OHTICP = ''N'' OR OHTICP = '' '')
		AND olINVU = ''T''
		AND ohotyp NOT IN (''IR'',''SI'',''SA'',''DP'',''CL'')
		AND oldirs != ''Y''
	')
END