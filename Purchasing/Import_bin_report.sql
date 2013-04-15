
--==================================================================
-- SR# 4768
-- James Tuttle
-- 10/16/2012
--
-- Show bin location report
-- for import skus
-------------------------------------------------------------------
-- SR# 9807 James Tuttlkte 04/15/2013 added IMCLAS = 'IM' 
--==================================================================

ALTER PROC [dbo].[Import_bin_report] AS
BEGIN
	SELECT iditem								AS Item
			,imdesc								AS [Description]
			,imcolr								AS Color
			,idco								AS Wh_Co
			,idloc								AS Wh_Loc
			,idbin								AS Bin_Loc
			,idqoh								AS QOH
			,imfc2a								AS Plt_Recv_Qty
			,CEILING(idqoh / NULLIF(imfc2a,0))	AS Ttl_Plts			-- Divide the QOH by the pallet recv. Qty and round up by 1 whole
			,imdiv								AS Div				--		[Used NULLIF(divisor,0) to prevent divid by 0 error]
			,imfmcd								AS Family
			,imprcd								AS Prd_Code	
			,imclas								AS Class 
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
		WHERE im.imsi = ''Y''
			AND IMCLAS = ''IM''
			AND im.imclas NOT IN (''SA'',''DP'')
			AND id.idqoh > 0
			AND bl.blgrp  != ''XXXXX''
			AND id.idloc IN (41,50,52)

		ORDER BY id.idco
		
		')
END



