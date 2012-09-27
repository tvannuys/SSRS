
/* ---------------------------------------------------------*
**  James Tuttle 5/12/2011									*
** ---------------------------------------------------------*
** 	Report is 
**
**
**												*
**----------------------------------------------------------*
*/

SELECT *
FROM ri_order

INSERT INTO ri_order (company,	
	location,
	[date],
	[order],
	release,
	[user])


SELECT ohco 'Company',
	ohloc 'Location',
	ohsdat 'Date',
	ohord# 'Order',
	ohrel# 'Release',
	ohuser 'User'
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead
WHERE ohotyp IN(''RI'', ''IR'')	
')

 	
	
	
	
	
	
--SELECT * 
--FROM ri_orders