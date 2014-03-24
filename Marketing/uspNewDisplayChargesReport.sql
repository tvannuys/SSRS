/*********************************************************************************
**																				**
** SR# 17979																	**
** Programmer: James Tuttle		Date: 03/21/2014								**
** ---------------------------------------------------------------------------- **
** Purpose:		We are interested in getting a report created that would show   **
**		us prices charged for displays so we can see where we may				**
**		need to bump up prices to be closer to the cost that we pay for them so **
**		we aren’t losing money.  This is what we would need.					**				
**																				**
**		Dori A																	**
**																				**
**																				**
**																				**
**********************************************************************************/

CREATE PROC uspNewDisplayChargesReport  AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT *
		,
		,
	FROM Table
	')
END