


/* -----------------------------------------------------*
** James Tuttle 6/24/2011		Created: 6/25/2009		*
** -----------------------------------------------------*
** 	Report is for Armstrong VCT will QTY < 6			*
**------------------------------------------------------*
*/
-- SR# 10434
-- Need to GROUP BY Item and DyeLot then see if SUM is < 6 
--
--
ALTER PROC [dbo].[JT_small_lot_vct_pm] AS
		SELECT *
		FROM OPENQUERY(GSFL2K,'
		  SELECT ibco
				,ibloc
				,ibitem
				,ibqoh

		FROM itembal ib
		WHERE ib.ibcls# = 41040
			AND ibqoh > 0
			AND ibqoo = 0
			AND ibqoh BETWEEN 1 AND 5
		ORDER BY ibloc
				,ibitem
		')
/* ------
  SELECT idco 
	,idloc 
	,iditem 
	,idserl 
	,iddylt 
	,idbin 
	,SUM(idqoh) AS Qoh

FROM OPENQUERY (GSFL2K, ''
	SELECT idco
		  ,idloc
		  ,iditem
		  ,idserl
		  ,iddylt
		  ,idbin
		  ,idqoh

	FROM itemdetl

	WHERE idcls# = 41040
		AND idqoo = 0 
		AND idqoh > 0
				 		
	'')

GROUP BY idco 
		,idloc 
		,iditem 
		,idserl 
		,iddylt 
		,idbin 
		
HAVING SUM(idqoh) BETWEEN 1 AND 5	
	
ORDER BY idloc
		,iditem
		,idbin
		--------------------------- */


