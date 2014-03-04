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

ALTER PROC JT_ManningtonSamples90Days AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT plitem	AS Item
			,plpo#	AS PO
			,plqord	AS Qty_Ord
			,'' ''	AS Ref_num
			,'' ''	AS Mann_ID
			,phdoi	AS Issue_date

				FROM pohead ph
	LEFT JOIN poline pl ON ( ph.phco = pl.plco
						AND ph.phloc = pl.plloc
						AND ph.phpo# = pl.plpo# )

	WHERE photyp = ''SA''
		AND plddat = ''12/31/9999''
		AND phdoi > 90 DAYS <------- code for 90 days
	')
END