 
--ALTER PROC JT_COD_Shippers AS

/* 
	James Tuttle	12/14/2011
	COD orders  not in Via Codes (1 or 3)


*/


SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ohco as Co,
								ohloc as Loc,
								ohord# as Order,
								ohrel# as Rel,
								ohviac as ViaCode,
								ohvia as Shipper,
								ohterm as terms,
								ohcod as COD
						FROM oohead oh
						WHERE oh.ohco = 1
							AND oh.ohloc = 50
							AND oh.ohdate = CURRENT_DATE
							AND oh.ohterm = ''2''
								/* oh.ohcod = ''Y''	*/
							AND oh.ohviac NOT IN (1,3,2)
							
								
					')			
								
								
								
								
								
								
								
								
								
								
								
					