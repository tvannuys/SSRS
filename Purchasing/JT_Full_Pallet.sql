

----------------------------------------------------------------------------------------------
-- SR 4158
-- Full pallet quantity orders since these vendors are sold by the pallet only - Jeff N
--============================================================================================
-- James Tuttle	10/12/12
-- Per Jeff take out the customers - View the ITEM
--============================================================================================
-- James Tuttle
-- 11/6/12
--
--ADDED: company to query so the report can
-- use company as a PARM to split companys
-----------------------------------------------------------------------------------------------
ALTER PROC [dbo].[JT_Full_Pallet] AS
BEGIN
	SELECT  slco		AS [Co]
			,slitem		AS [Item]
			,imdesc		AS [Description]
			,imcolr		AS [Color]
			,cmname		AS [Customer Name]
			
			,UPPER(RTRIM(reverse(substring(reverse(cmadr3),3,len(cmadr3)))))	AS [City]
			,UPPER(REVERSE(left(reverse(cmadr3),2))) 						AS [State]
			
			,smno		AS [Rep#]
			,smname		AS [Rep. Name]
			
			,COALESCE(CASE WHEN MONTH(sldate) = 1 THEN COUNT(slqshp) END,0) AS [Jan]
			,COALESCE(CASE WHEN MONTH(sldate) = 2 THEN COUNT(slqshp) END,0) AS [Feb]
			,COALESCE(CASE WHEN MONTH(sldate) = 3 THEN COUNT(slqshp) END,0) AS [Mar]
			,COALESCE(CASE WHEN MONTH(sldate) = 4 THEN COUNT(slqshp) END,0) AS [Apr]
			,COALESCE(CASE WHEN MONTH(sldate) = 5 THEN COUNT(slqshp) END,0) AS [May]
			,COALESCE(CASE WHEN MONTH(sldate) = 6 THEN COUNT(slqshp) END,0) AS [Jun]
			,COALESCE(CASE WHEN MONTH(sldate) = 7 THEN COUNT(slqshp) END,0) AS [Jul]
			,COALESCE(CASE WHEN MONTH(sldate) = 8 THEN COUNT(slqshp) END,0) AS [Aug]
			,COALESCE(CASE WHEN MONTH(sldate) = 9 THEN COUNT(slqshp) END,0) AS [Sep]
			,COALESCE(CASE WHEN MONTH(sldate) = 10 THEN COUNT(slqshp) END,0) AS [Oct]
			,COALESCE(CASE WHEN MONTH(sldate) = 11 THEN COUNT(slqshp) END,0) AS [Nov]
			,COALESCE(CASE WHEN MONTH(sldate) = 12 THEN COUNT(slqshp) END,0) AS [Dec]	
			
	FROM OPENQUERY (GSFL2K,
	'SELECT  *
	FROM shline sl
		LEFT JOIN shhead sh ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shinv# = sl.slinv#
								AND sh.shcust = sl.slcust)
		LEFT JOIN itemmast im ON sl.slitem = im.imitem
		LEFT JOIN family fm ON sl.slfmcd = fm.fmfmcd
		LEFT JOIN custmast cm ON sl.slcust = cm.cmcust
		LEFT JOIN salesman sm ON sm.smno = sl.slslmn
		
	WHERE shidat >= ''01/01/2012''
		AND sl.slqshp = im.imfc2a
		AND fm.FMFMCD not in (''L2'',''YI'')
		AND im.IMSI = ''Y''
		AND (sl.slvend IN (''22666'',''22887'',''22674'',''22204'',''22859'',''23306'',''22312'',''16006'')
			OR (sl.slvend = ''21861'' AND im.imprcd IN (''34057'',''34058'')))

		/* AND shcust = ''1001341''
			AND slitem = ''LOLG1039''	*/

	')
		GROUP BY slco
				,shcust
				,cmname
				,slitem
				,sldate
				,imdesc
				,imcolr	
				,cmadr3
				
		ORDER BY slco
				,slitem
			--  ,shcust
			--	,sldate		
END

GO


