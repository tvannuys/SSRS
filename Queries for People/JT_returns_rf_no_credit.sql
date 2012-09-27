
--CREATE PROC JT_returns_rf_no_credit AS
/************************************
* 									*
*  James Tuttle		Date:9/7/11		* 
*  -------------------------------- *
*  Test for returns that have been	*
*  scanned through the RF Gun but	* 
*  not updated in the terminal yet	*
*									*
*************************************/

SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ohco as Company,
							ohloc as Location,
							ohord# as Order#
						FROM oohead JOIN ooline ON ohco = olco
							AND ohloc = olloc
							AND ohord# = olord#
							AND ohrel# = olrel#
						WHERE olinvu = ''U''
							AND ohcm = ''R''
				')
				
						