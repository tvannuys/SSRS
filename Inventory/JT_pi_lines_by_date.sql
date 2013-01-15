

ALTER PROC JT_pi_lines_by_date @StartDate varchar(10)
, @EndDate varchar(10)
, @co varchar(3)
, @Loc varchar(2)
AS
	DECLARE @sql varchar(4000)

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
		  AND hst.olrdat BETWEEN ''''' + @StartDate + ''''' AND ''''' + @EndDate + '''''
		  AND hst.olrico = ' + @Co + '
		  AND hst.olrilo =' + @loc + '
	'')'
	EXEC (@sql)
GO

-- JT_pi_lines_by_date '12/01/2012','12/31/2012',1,50