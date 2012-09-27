
With CTE AS
(
	select  olico as Company,
		oliloc as Location,
		ohotyp as Order_Type,
		olcust as Cust_Number,
		cmname as Cust_Name,
		ohsta3 as City_State,
		cmphon as Phone,
		tktrak# as Tracking,
		olqshp as Qty,
		olwght as wt,
		ROUND(imwght * olqshp,2) as [ttl],
		olord# as [Order],
		olrel# as Release,
		ohviac as Via,
		ohvia as Via_Desc,
		olitem as Item,
		olpric as Price,
		olcost as Cost	
	FROM OPENQUERY (GSFL2K, 'SELECT *
		FROM ooline INNER JOIN oohead ON olco=ohco
			AND olloc=olloc
			AND olord#=ohord#
			AND olrel#=ohrel#
		INNER JOIN custmast ON ohcust = cmcust
		INNER JOIN tracking ON tkord# = ohord#
		INNER JOIN itemmast ON imitem = olitem
			AND tkrel# = ohrel#
			AND ohcust = tkcust
		WHERE olotyp NOT IN(''FO'', ''SA'')
			AND ohvia NOT LIKE ''%FN%''
			AND olinvu = ''T''		
		')
	)
SELECT [Order], Cust_Number,  SUM(ttl) as t
FROM CTE
GROUP BY [Order], Cust_Number
