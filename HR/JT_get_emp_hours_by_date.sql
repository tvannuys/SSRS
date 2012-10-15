

-- SR-4112
 ALTER PROC JT_get_emp_hours_by_date 

	 @StartDate as varchar(10)	= '01/01/2012'
	,@EndDate as  varchar(10)	= '01/01/2012'
	,@EmpNum as VARCHAR(4)		= '0'
	
AS
DECLARE @sql VARCHAR(3000)
SET @sql = '
	SELECT *		
	FROM OPENQUERY (GSFL2K, ''SELECT ptrun#,
									ptemp#,
									ptcksq,
									ptdate,
									ptseq#,
									ptco,
									ptloc,
									ptdept,
									ptshft,
									pttype,
									ptdi,
									ptoco,
									ptoloc,
									ptoord#,
									ptorel#,
									ptsstm,
									ptsetm,
									ptrghr,
									ptrgor,
									ptlnch,
									ptothr,
									ptotor,
									ptot,
									ptdatets
							FROM prtimecd
							WHERE ptdate >= ' + '''' + '''' + @StartDate + '''' + '''' + '
								 AND  ptdate <=  ' + '''' + '''' + @EndDate + '''' + '''' + '
								AND ptemp# = ' + '''' + '''' + @EmpNum + '''' + '''' + '
							ORDER BY ptemp#, ptdatets
						'')'

EXEC(@sql)
GO

-- JT_get_emp_hours_by_date '10/15/2012','10/15/2012', 7013