

-- SR-4059

SELECT *
FROM OPENQUERY(GSFL2K,
	'SELECT slco
		   ,slloc
		   ,slord#
		   ,slrel#
		   ,shpo#
		   ,slcust
		   ,cmname
		   ,slslmn
		   ,smname
		   ,shquot
		   ,slitem
		   ,slidky
		  ,sleprc
	FROM shhead sh
	JOIN shline sl ON 
		(sh.shco = sl.slco
			AND sh.shloc = sl.slloc
			AND sh.shord# = sl.slord#
			AND sh.shrel# = sl.slrel#
			AND sh.shcust = sl.slcust)
	JOIN custmast cm ON cm.cmcust = sh.shcust
	JOIN salesman sm ON sm.smno = sl.slslmn
	WHERE sh.shidat >= ''08/07/2012''
		AND sh.shord# = 103623
		AND sl.slidky = ''2128078''
/*	GROUP BY  slco
		   ,slloc
		   ,slord#
		   ,slrel#
		   ,shpo#
		   ,slcust
		   ,cmname
		   ,slslmn
		   ,smname
		   ,shquot
		   ,slitem
	HAVING SUM(sl.sleprc) > 9999	*/
	
	
	
	
	
	')
	