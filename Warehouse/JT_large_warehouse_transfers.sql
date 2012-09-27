
--CREATE PROC JT_large_warehouse_transfers AS


/****************************************************************
*																*
*	James Tuttle												*
*	11/4/2011													*
*																*
*   From VFP: -- largewarehousetransfers.prg					*
*	Get order that are over 8,000 lbs							*
*																*
*****************************************************************/


SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT oliloc as inv_loc,
								olloc as loc_to,
								month(olsdat) || ''/'' || day(olsdat) || ''/'' || year(olsdat) as ship_date,
								ohvia as shipping,
								olcust as cust_no,
								ohord# as order,
								ohrel# as rel,
								DEC(ROUND(SUM(imwght * olqord),0),11,0) as weight
						FROM oohead INNER JOIN ooline 
							ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						LEFT JOIN itemmast ON olitem = imitem
						WHERE olqshp > 0
							AND ohotyp NOT IN (''SA'', ''DP'')
						GROUP BY oliloc, olloc, olsdat, ohvia, olcust, ohord#, ohrel#
						HAVING SUM(imwght * olqord) > 8000
						ORDER BY olsdat

		')

