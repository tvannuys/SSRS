
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT irloc
		,iritem
		,irqty
		,ircost
		,SUM(irqty * ircost) AS TotalCost
		,irbin
		,iruser
		,irreason
		
	FROM itemrech ir
	
	WHERE irdate >= ''09/23/2013''
		AND irdate <= ''09/27/2013''
		AND irbin = ''SHW50''
		AND irreason = ''PI''
	GROUP BY irbin
		,iruser
		,irreason
		,irloc
		,iritem
		,ircost
		,irqty
		
	ORDER BY iritem
	')
END