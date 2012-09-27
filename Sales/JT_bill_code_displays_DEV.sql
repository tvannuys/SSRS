
-------------------------------------------------------------------------------
-- DROP TEMP TABLES
-------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#prcd') IS NOT NULL
BEGIN
	DROP TABLE dbo.#prcd
END;
IF OBJECT_ID('tempdb..#vend') IS NOT NULL
BEGIN
	DROP TABLE dbo.#vend
END;
IF OBJECT_ID('tempdb..#fmcd') IS NOT NULL
BEGIN
	DROP TABLE dbo.#fmcd
END;
IF OBJECT_ID('tempdb..#div') IS NOT NULL
BEGIN
	DROP TABLE dbo.#div
END;
IF OBJECT_ID('tempdb..#cls#') IS NOT NULL
BEGIN
	DROP TABLE dbo.#cls#
END;
--------------------------------------------------------------------------------


-- Product Code -------------------------------------------------------------
WITH CTE_prcd AS
(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,MONTH(slsdat) || ''-'' || YEAR(slsdat) AS MM_YYYY 
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
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		AND sl.slprcd = bcp.bpprcd
		/*AND sl.slvend = bcp.bpvend*/
		/*AND sl.slfmcd = bcp.bpfmcd*/
		/*AND sl.sldiv = bcp.bpdiv*/
		/*AND sl.slcls# = bcp.bpcls#*/
		
	ORDER BY bcblcd
				,cbcust
		')
)

SELECT *
INTO #prcd
FROM CTE_prcd ;

-- Vendor Code ---------------------------------------------------------
WITH CTE_vend AS
(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,MONTH(slsdat) || ''-'' || YEAR(slsdat) AS MM_YYYY
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
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		/*AND sl.slprcd = bcp.bpprcd*/
		AND sl.slvend = bcp.bpvend
		/*AND sl.slfmcd = bcp.bpfmcd*/
		/*AND sl.sldiv = bcp.bpdiv*/
		/*AND sl.slcls# = bcp.bpcls#*/
		
	ORDER BY bcblcd
				,cbcust
		')
)

SELECT *
INTO #vend
FROM CTE_vend;

-- Famiily Code ---------------------------------------------------------
WITH CTE_fmcd AS
(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,MONTH(slsdat) || ''-'' || YEAR(slsdat) AS MM_YYYY
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
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		/*AND sl.slprcd = bcp.bpprcd*/
		/*AND sl.slvend = bcp.bpvend*/
		AND sl.slfmcd = bcp.bpfmcd
		/*AND sl.sldiv = bcp.bpdiv*/
		/*AND sl.slcls# = bcp.bpcls#*/
		
	ORDER BY bcblcd
				,cbcust
		')
)
SELECT *
INTO #fmcd
FROM CTE_fmcd;

-- Division Code ---------------------------------------------------------
WITH CTE_div AS
(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,MONTH(slsdat) || ''-'' || YEAR(slsdat) AS MM_YYYY
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
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		/*AND sl.slprcd = bcp.bpprcd*/
		/*AND sl.slvend = bcp.bpvend*/
		/*AND sl.slfmcd = bcp.bpfmcd*/
		AND sl.sldiv = bcp.bpdiv
		/*AND sl.slcls# = bcp.bpcls#*/
		
	ORDER BY bcblcd
				,cbcust
		')
)
SELECT *
INTO #div
FROM CTE_div;

-- Class# Code ---------------------------------------------------------
WITH CTE_cls# AS
(
	SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,MONTH(slsdat) || ''-'' || YEAR(slsdat) AS MM_YYYY
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
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		/*AND sl.slprcd = bcp.bpprcd*/
		/*AND sl.slvend = bcp.bpvend*/
		/*AND sl.slfmcd = bcp.bpfmcd*/
		/*AND sl.sldiv = bcp.bpdiv*/
		AND sl.slcls# = bcp.bpcls#
		
	ORDER BY bcblcd
				,cbcust
		')
)
SELECT *
INTO #cls#
FROM CTE_cls#

---------------------------------------------------------------------
-- UNION ALL TEMP TABLES
---------------------------------------------------------------------
SELECT * FROM #prcd
UNION ALL
SELECT * FROM #vend 
UNION ALL
SELECT * FROM #fmcd
UNION ALL
SELECT * FROM #div
UNION ALL
SELECT * FROM #cls#

----------------------------------------------------------------------