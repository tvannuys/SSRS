
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ememp#
			,emco
			,emloc
			,emdept
			,emname
			,emshft
		
	FROM prempm pre
	LEFT JOIN prshift prs ON (pre.emco = prs.psco
						AND pre.emloc = prs.psloc
						AND pre.emdept = prs.psdept
						AND pre.emshft = prs.psshft)
	
	WHERE emloc = 96
	')
END