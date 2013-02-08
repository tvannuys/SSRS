
/*********************************************************
**														**
** SR# 7666												**
** Programmer: James Tuttle		Date: 02/08/2013		**
** ---------------------------------------------------- **
** Purpose:												**
**			Rolls goods, available length, available 	**
**			SF, by serial, with by company, by location,**
**			with bin location, vendor, item, qty sold  	**
**			last 4 months, dollars sold last 4 months	**
**														**
**********************************************************/

CREATE PROC RollGoodsDataSet AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT 
		,
		,
	FROM
	')
END