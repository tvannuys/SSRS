


-- CREATE PROC JT_Sales_Order_Direct_Ship_Flag_not_set AS

/************************************************************************																		*
*																		*
* James Tuttle															*
* Date: 10/06/2011														*
* From Eurisko Reports: factoryorderalert.prg							*
* ---------------------------------------------------------------------	*
*																		*
* Sales Order Direct Ship Flag not set									*
*																		*
*************************************************************************/



SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT  ohco as Co,
								ohloc as Loc,
								ohord# as Order,
								olrel# as Rel,
								ohvia as Ship_via
						FROM oohead oh INNER JOIN
						ooline ol ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						WHERE oldiv != 13
							AND oldirs != ''Y''
							AND olidky IS NULL
							AND olvend != 40000
							AND ohotyp = ''FO''
							AND ohcm != ''Y''
						')
						