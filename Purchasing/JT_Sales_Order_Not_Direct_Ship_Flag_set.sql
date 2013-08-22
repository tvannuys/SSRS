

ALTER PROC JT_Sales_Order_Not_Direct_Ship_Flag_set AS

/************************************************************************																		*
*																		*
* James Tuttle															*
* Date: 10/07/2011														*
* From Eurisko Reports: factoryorderalert.prg							*
* ---------------------------------------------------------------------	*
*																		*
* Non-Factory Orders WITH Direct Ship Flag Set							*
*																		*
*************************************************************************/


SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT DISTINCT ohco as Co,
								ohloc as Loc,
								ohord# as Order,
								ohrel# as Rel
								
						FROM oohead oh INNER JOIN
						ooline ol ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
							
						WHERE oldiv != 13
							AND oldirs = ''Y''
							AND olvend != 40000
							AND ohotyp NOT IN (''FO'', ''SD'')
							AND ohcm != ''Y''

				')

