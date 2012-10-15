

-- SR 4158
-- Full pallet quantity orders
--============================================================================================
-- James Tuttle	10/12/12
-- Per Jeff take out the customers - View the ITEM
--============================================================================================

--INSERT INTO [JAMEST].[dbo].[FullPallet]
SELECT  slitem 
		,COALESCE(CASE WHEN MONTH(sldate) = 1 THEN COUNT(slqshp) END,0) as Jan
		,COALESCE(CASE WHEN MONTH(sldate) = 2 THEN COUNT(slqshp) END,0) as Feb
		,COALESCE(CASE WHEN MONTH(sldate) = 3 THEN COUNT(slqshp) END,0) as Mar
		,COALESCE(CASE WHEN MONTH(sldate) = 4 THEN COUNT(slqshp) END,0) as Apr
		,COALESCE(CASE WHEN MONTH(sldate) = 5 THEN COUNT(slqshp) END,0) as May
		,COALESCE(CASE WHEN MONTH(sldate) = 6 THEN COUNT(slqshp) END,0) as Jun
		,COALESCE(CASE WHEN MONTH(sldate) = 7 THEN COUNT(slqshp) END,0) as July
		,COALESCE(CASE WHEN MONTH(sldate) = 8 THEN COUNT(slqshp) END,0) as Aug
		,COALESCE(CASE WHEN MONTH(sldate) = 9 THEN COUNT(slqshp) END,0) as Sep
		,COALESCE(CASE WHEN MONTH(sldate) = 10 THEN COUNT(slqshp) END,0) as Oct
		,COALESCE(CASE WHEN MONTH(sldate) = 11 THEN COUNT(slqshp) END,0) as Nov
		,COALESCE(CASE WHEN MONTH(sldate) = 12 THEN COUNT(slqshp) END,0) as [Dec]	
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
WHERE shidat >= ''01/01/2012''
	AND sl.slqshp = im.imfc2a
	AND fm.FMFMCD not in (''L2'',''YI'')
	AND im.IMSI = ''Y''
	AND (sl.slvend IN (''22666'',''22887'',''22674'',''22204'',''22859'',''23306'',''22312'',''16006'')
		OR (sl.slvend = ''21861'' AND im.imprcd IN (''34057'',''34058'')))

	/* AND shcust = ''1001341''
		AND slitem = ''LOLG1039''	*/

')
	GROUP BY shcust
			,cmname
			,slitem
			,sldate
	ORDER BY shcust
			,slitem
			,sldate
			
			--CREATE TABLE FullPallet 
			--(
			--	shcust varchar(10)
			--	,cmname varchar(25)
			--	,slitem varchar(18)
			--	,Jan int
			--	,Feb int
			--	,Mar int
			--	,Apr int
			--	,May int
			--	,Jun int
			--	,July int
			--	,Aug int
			--	,Sep int
			--	,Oct int
			--	,Nov int
			--	,[Dec] int
			--)
			
			
			
			--SELECT * FROM FullPallet
			--DELETE FullPallet