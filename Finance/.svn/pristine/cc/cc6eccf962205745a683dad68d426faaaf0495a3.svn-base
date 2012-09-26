
--CREATE PROC JT_orders_without_inventory AS

-- orderswithoutinventory.prg


SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ohotyp as order_type,
								ohco as co,
								ohloc as loc,
								ohord# as order,
								ohrel# as release,
								olitem as item,
								oldesc as description,
								olbyp as bypass,
								ohuser as user
						FROM oohead INNER JOIN ooline 
							ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						JOIN itemmast ON olitem = imitem
						WHERE olbyp = ''N''
							AND ohotyp NOT IN(''CL'', ''FC'')
							AND imsi != ''O''
						ORDER BY ohco, ohloc
						
				')
						