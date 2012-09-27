
--CREATE PROC JT_Sales_Order_Direct_Ship_no_PO AS

/************************************************************************																	
*																		*
* James Tuttle															*
* Date: 10/07/2011														*
* From Eurisko Reports: factoryorderalert.prg							*
* ---------------------------------------------------------------------	*
*																		*
* Factory Orders With missing PO's										*
*																		*
*************************************************************************/

SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT ohco as Co,
								ohloc as Loc,
								ohord# as Order,
								ohrel# as Rel,
								ohvia as ship_via
						FROM oohead oh INNER JOIN
						ooline ol ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						LEFT JOIN poboline ON pboco = ohco
							AND pboloc = ohloc 
							AND pboord = ohord#
							AND pborel = ohrel#
					 		AND pboseq = olseq#  
						WHERE oldiv != 13
							AND oldirs = ''Y''
							AND olvend != 40000
							AND olqord != olqshp
							AND ohotyp = ''FO''
							AND ohcm != ''Y''
							AND pbpo# IS NULL
							AND ohodat <= CURRENT_DATE - 2 DAYS		/* Ignore orders 1-2 days old */
						
				')