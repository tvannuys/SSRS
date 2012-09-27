
--CREATE PROC JT_Sales_PO_wrong_location AS

/************************************************************************																		*
*																		*
* James Tuttle															*
* Date: 10/07/2011														*
* From Eurisko Reports: factoryorderalert.prg							*
* ---------------------------------------------------------------------	*
*																		*
* Factory Orders With PO's in Wrong Location							*
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
						JOIN poboline ON pboco = ohco
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
							AND (pbco != pboco OR pbloc != pboloc)
						
				')