
--==================================================================
-- SR# 4768
-- James Tuttle
-- 10/16/2012
--
-- Show bin location report
-- for import skus
--==================================================================

-- CREATE Import_bin_report AS
BEGIN
	SELECT iditem						AS Item
			,imdesc						AS [Description]
			,imcolr						AS Color
			,idco						AS Wh_Co
			,idloc						AS Wh_Loc
			,idbin						AS Bin_Loc
			,idqoh						AS QOH
			,imfc2a						AS Plt_Recv_Qty
			,CEILING(idqoh / imfc2a)	AS Ttl_Plts
			,imdiv						AS Div
			,imfmcd						AS Family
			,imprcd						AS Prd_Code	
			,imclas						AS Class 
	FROM OPENQUERY(GSFL2K,
		'SELECT iditem
				,imdesc
				,imcolr
				,idco
				,idloc
				,idbin
				,idqoh
				,imfc2a
				,imdiv
				,imfmcd			
				,imprcd
				,imclas
		FROM itemdetl id
		JOIN itemmast im ON id.iditem = im.imitem
		LEFT JOIN binloc bl ON (id.idbin = bl.blbin
									AND id.idco = bl.blco
									AND id.idloc = bl.blloc)
		WHERE im.imfmcd NOT IN (''L2'',''YI'',''W2'',''VV'',''T1'',''YK'',''Y4'')
			AND im.imsi = ''Y''
			AND (im.imvend IN (''22666'',''22887'',''22674'',''22204''
								,''22859'',''23306'',''22312'',''16006'',''22179'',''24077'')
				OR (im.imvend IN(''21861'',''17000'',''10131'',''16006'') 
					AND imprcd IN (''34057'',''4906'',''4906'',''6392'',''32608'')))
			AND im.imclas NOT IN (''SA'',''DP'')
			AND id.idqoh > 0
			AND bl.blgrp  != ''XXXXX''
			AND id.idloc IN (41,50,52)

		ORDER BY id.idco
		
		')
END


