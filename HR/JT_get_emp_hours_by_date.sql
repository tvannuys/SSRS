

-- SR-4112
CREATE PROC JT_get_emp_hours_by_date 
	 @StartDate date
	,@EndDate date
	,@EmpNum int
AS
DECLARE @sql VARCHAR(4000)
SET @sql = '
	SELECT *		
	FROM OPENQUERY (GSFL2K, ''SELECT ptrun#,
									ptemp#,
									ptcksq,
									month(ptdate) || ''/'' || day(ptdate) || ''/'' || year(ptdate) as ptdate,
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
									month(ptdatets) || ''/'' || day(ptdatets) || ''/'' || year(ptdatets) || '' '' ||
										hour(ptdatets) ||'':'' || minute(ptdatets) || '':'' || second(ptdatets) as ptdatets
							FROM prtimecd
							WHERE ptdate BETWEEN ''''' +  @StartDate  + ''''' AND  ''''' +   @EndDate  + '''''
								AND ptemp# = ' + @EmpNum + '
							ORDER BY ptemp#, ptdatets
						'')'

EXEC(@sql)
GO