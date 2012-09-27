


--CREATE PROC JT_FO_without_freight_cost AS

/************************************************************************																
*																		*
* James Tuttle															*
* Date: 10/07/2011														*
* From Eurisko Reports: factoryorderalert.prg							*
* ---------------------------------------------------------------------	*
*																		*
* Orders with missing freight cost										*
*																		*
*************************************************************************/

SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT ohco as Co,
								ohloc as Loc,
								ohord# as Order,
								ohrel# as Rel
						FROM oohead oh INNER JOIN
						ooline ol ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						WHERE olitem = ''FREIGHT''
							AND olpric > 0
							AND olcost = 0
							AND olinvu = ''T''
							AND ohotyp = ''FO''
								
					')