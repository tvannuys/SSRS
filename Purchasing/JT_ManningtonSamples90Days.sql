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
	'SELECT plco	AS Co
			,plloc	AS Loc
			,plitem	AS Item
			,plpo#	AS PO
			,plqord	AS Qty_Ord
			,phref#	AS Ref_num
			,plaltitm	AS Mann_ID
			,MONTH(phdoi) || ''/'' || DAY(phdoi) || ''/'' ||
				YEAR(phdoi)	AS Issue_date
			/* ,pldelt */

				FROM pohead ph
	LEFT JOIN poline pl ON ( ph.phco = pl.plco
						AND ph.phloc = pl.plloc
						AND ph.phpo# = pl.plpo# )

	WHERE photyp = ''SA''
		AND plddat = ''12/31/9999''
		AND phdoi < CURRENT_DATE - 90 DAYS
		AND plvend = ''10131''
		AND pldelt != ''C''

	ORDER BY phdoi 
	')
END