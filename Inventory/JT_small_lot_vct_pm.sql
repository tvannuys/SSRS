


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
ALTER PROC JT_small_lot_vct_pm AS

  SELECT idco		AS Co
	,idloc			AS Loc
	,iditem 
	,idserl 
	,iddylt 
	,idbin 
	,SUM(idqoh) AS Qoh
	,idqoo

FROM OPENQUERY (GSFL2K, '
	SELECT idco
		  ,idloc
		  ,iditem
		  ,idserl
		  ,iddylt
		  ,idbin
		  ,idqoh
		  ,idqoo

	FROM itemdetl

	WHERE idcls# = 41040
		
		AND idqoh > 0
		AND iditem = ''AR51811''
				 		
	')

GROUP BY idco 
		,idloc 
		,iditem 
		,idserl 
		,iddylt 
		,idbin 
		,idqoo
		
HAVING SUM(idqoh) BETWEEN 1 AND 5	
	
ORDER BY idloc
		,iditem
		,idbin
	
	/*********************************************************************************		
SELECT *
		FROM OPENQUERY(GSFL2K,'
		  SELECT ibloc
				,ibitem
				,ibqoh
				,ibqoo
				,ibcls#
		FROM itembal ib
		WHERE ib.ibcls# = 41040
			AND ibqoh > 0
			
			AND ibqoh BETWEEN 1 AND 5
			AND ibitem = ''AR51811''
		ORDER BY ibloc
				,ibitem
		') *********************************************************************************/