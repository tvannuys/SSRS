 
--ALTER PROC JT_negatives AS

/* -----------------------------------------------------*
** James Tuttle 5/3/2012								*
** -----------------------------------------------------*
** 	  Report is looking for negative inventory from		*
**	the ITEMBAL and ITEMHOLD when the formula results	*
**	are negative:										*
** ((QOH - QtyCmtd) - QtyHld) < 0 						*
**------------------------------------------------------*
*/
-------------------------------------------------------------
		
SELECT idloc 'Location'
	,iditem 'Item'
	,SUM(idqoh) 'QOH'
	--,idqoh
	--,idky
	,SUM(idqoo) 'Qty Cmtd'
	,SUM(idqhld) 'Qty Held'
	--,idqhld
	,((SUM(idqoh) - SUM(idqoo)) - SUM(idqhld)) 'Negative'
FROM OPENQUERY (GSFL2K, '
	SELECT ibloc
		  ,ibitem
		  ,idqoh
		  ,idqoo
		  ,idqhld
		  ,idco
		  ,ibco
		  ,idloc
		  ,iditem
		  ,idinvcat
		  ,idky
	FROM itemdetl id
	JOIN itembal ib
		ON id.iditem = ib.ibitem
			AND id.idco = ib.ibco
			AND id.idloc = ib.ibloc
	--WHERE idinvcat != ''STG''
	/*	AND iditem = ''JODC1674X120''
		AND idloc = 4 */		
')
GROUP BY idloc
		,iditem

HAVING((SUM(idqoh) - SUM(idqoo)) - SUM(idqhld)) < 0.00	
		
ORDER BY idloc ASC
		,iditem ASC




