

CREATE PROC JT_qtr_pi_lines
	@StartDate VARCHAR(10)
	,@EndDate VARCHAR(10)
	,@co VARCHAR(3)
	,@Loc VARCHAR(2)

AS

DECLARE @sql VARCHAR(4000)

SET @sql = '
	SELECT *
	FROM OPENQUERY(GSFL2K,''
	SELECT olrico
		,olrilo
		,MONTH(olrdat)|| ''''/'''' || DAY(olrdat) || ''''/'''' || YEAR(olrdat) as Date
		,olritm
		,olrusr
	 FROM oolrfuser hst
	 WHERE hst.olrtyp = ''''I''''
		  AND hst.olrcyrc != ''''Y''''
		  AND hst.olrdat BETWEEN ''''' +  @StartDate  + ''''' AND ''''' + @EndDate + '''''
		  AND hst.olrico = ' + @Co + '
		  AND hst.olrilo ='  + @loc + '
	'')'
EXEC(@sql)
GO