--WITH CTE_fmcd AS
--(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,slsdat
				,bcdesc	
			/*	,bctype	*/
			/*	,bcvend */
				,bpdiv
				,bpfmcd
				,bpcls#
				,bpprcd
				,bpvend
				,sleprc
				,slord#
				,slrel#
				,slseq#
				,slitem
				,sldesc
				,slfmcd
				,sldiv
				,slcls#
				,slprcd
				,slvend
				,slcust
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
			AND  (bcp.bpdiv = sl.sldiv
					OR bcp.bpfmcd = sl.slfmcd)
	WHERE sl.slsdat >= ''07/01/2012''
		AND sl.slloc = 50
	ORDER BY bcblcd
			,cbcust
		')
--)
--SELECT cte1.cbcust
--			,cte1.bcblcd
--			,cte1.bcdesc	
--			,cte1.bpdiv
--			,cte1.bpfmcd
--			,cte1.bpcls#
--			,cte1.bpprcd
--			,cte1.bpvend
--			,cte1.sleprc
--			,cte1.slord#
--			,cte1.slrel#
--			,cte1.slseq#
--			,cte1.slitem
--			,cte1.sldesc
--FROM CTE_fmcd AS cte1
--JOIN CTE_fmcd AS cte2
--	ON cte1.slfmcd = cte2.bpfmcd
--		AND cte1.slord# = cte2.slord#
--		AND cte1.slrel# = cte2.slrel#
--		AND cte1.slitem = cte2.slitem

		--AND cte1.cbcust = cte2.cbcust
		--AND cte1.slseq# = cte2.slseq#
		--AND cte1.sldesc = cte2.sldesc
