

/*********************************************************************************
**																				**
** SR# 11659																	**
** Programmer: James Tuttle			Date: 06/12/2013							**
** ---------------------------------------------------------------------------- **
** Purpose:		Enter in the RF Gun name as the PROC 							**
**				and date range to see who was logged in 						**
**				using it abd the bin locations.									**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_WhereIsRfGun
	@StartDate AS varchar(10)
	,@EndDate AS varchar(10)
	,@RFgun AS varchar(12)
 AS
BEGIN
SET @RFgun = UPPER(@RFgun)
DECLARE @sql varchar(2000) = '
 SELECT olrco
		,olrloc
		,olrord
		,olritm
		,olrbin
		,olrtim
 
	    ,cast(
		  substring(right(''000000''+cast(olrtim as varchar),6),1,2)
		  + '':'' +
		  substring(right(''000000''+cast(olrtim as varchar),6),3,2)
		 + '':'' +
		 substring(right(''000000''+cast(olrtim as varchar),6),5,2) 
		  as time) AS t
 
		,Dt
		,olrusr
		,olrws
		
 FROM OPENQUERY(GSFL2K,	
	''SELECT olrco
		,olrloc
		,olrord
		,olritm
		,olrbin
		,olrtim
		,MONTH(olrdat) || ''''/'''' || DAY(olrdat) || ''''/'''' || YEAR(olrdat) AS Dt
		,olrusr
		,olrws
		
	FROM oolrfhst
	
	WHERE olrws LIKE ''''%' + @RFgun + '%''''
		AND olrdat >= ' + '''' + '''' + @StartDate + '''' + '''' + '
		AND olrdat <= ' + '''' + '''' + @EndDate + '''' + '''' + '
	
	ORDER BY olrdat
			,olrws
			,olrtim
	'')'
END
EXEC(@sql)
GO

-- JT_WhereIsRfGun '06/07/2013', '06/12/2013','PmcK1_'