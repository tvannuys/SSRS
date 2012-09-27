


SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc IN (4, 44, 64)
								AND rfodate = CURRENT_DATE - 1 days
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							ORDER BY RFOTIME
									,RFOORD#		
					')