

-- SR 4158
-- Full pallet quantity orders

SELECT *
FROM OPENQUERY (GSFL2K,
'SELECT shcust cust#
		,cmname customer
		,shord# order#
		,shrel# rel#
		,slitem item
		,slqshp qty_shp
		,imfc2a plt_rec_qty
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
WHERE shidat >= ''08/01/2012''
	AND sl.slqshp = im.imfc2a
	AND fm.FMFMCD not in (''L2'',''YI'')
	AND im.IMSI = ''Y''
	AND (sl.slvend IN (''22666'',''22887'',''22674'',''22204'',''22859'',''23306'',''22312'',''16006'')
		OR (sl.slvend = ''21861'' AND im.imprcd IN (''34057'',''34058'')))

	/*AND shord# = 154008*/
')