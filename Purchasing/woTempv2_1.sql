





 SELECT *
 FROM OPENQUERY(GSFL2K,
 'WITH
#tempPO AS
	(	SELECT * 
		FROM poline
		LEFT JOIN vendmast ON vendmast.vmvend = poline.plvend
		LEFT JOIN itemmast ON itemmast.imitem = poline.plitem
		LEFT JOIN pohead ON ( pohead.phco = poline.plco
							AND pohead.phloc = poline.plloc
							AND pohead.phvend = poline.plvend
							AND pohead.phpo# = poline.plpo# )		
		
		WHERE poline.plvend = 24020
			AND poline.pldelt = ''A''
			AND poline.plitem NOT IN( SELECT m1.mnitem FROM manifest m1)
	) 
 
 SELECT *
 
 FROM #tempPO po

 WHERE  po.plitem = ''EN138674''

 ')
 
 
 --SELECT * FROM OPENQUERY(GSFL2K,'select * from manifest where manifest.mnvend = 24020') 
 
