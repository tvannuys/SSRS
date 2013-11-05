
ALTER PROC JT_orders_without_inventory AS

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
								
						FROM oohead oh INNER JOIN ooline ol
							ON (oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#)
						JOIN itemmast im ON ol.olitem = im.imitem
						
						WHERE ol.olbyp = ''N''
							AND ol.olinvu = ''T''  
							AND oh.ohotyp NOT IN(''CL'', ''FC'')
							AND im.imsi != ''O''
							AND oh.ohcred NOT IN (''MP'',''AP'')
							
						ORDER BY ohco, ohloc
						
				')
						