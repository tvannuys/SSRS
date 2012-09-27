
--ALTER PROC [dbo].[JT_HR_adp_export_searchdate]  @SearchDate as DATE		
	--= '2011-12-02'
-- [dbo].[JT_HR_adp_export_searchdate] '2011-12-02'
--AS
DECLARE @SearchDate date
DECLARE @sql as varchar(max)

SET @SearchDate = getdate()-1							--convert(varchar, getdate()-4, 101)
--SELECT @sql

SET @sql = '	
SELECT *
	FROM OPENQUERY (GSFL2K, ''SELECT ptrun#,
								ptemp#,
								ptcksq,
								month(ptdate) || ''''/'''' || day(ptdate) || ''''/'''' || year(ptdate) as ptdate,
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
								month(ptdatets) || ''''/'''' || day(ptdatets) || ''''/'''' || year(ptdatets) || '''' '''' || hour(ptdatets) ||'''':'''' || minute(ptdatets) || '''':'''' || second(ptdatets) as ptdatets
						FROM prtimecd
						WHERE '''@SearchDate''' = ptdate
						ORDER BY ptemp#, ptdatets'')
					'
--SELECT @sql

EXEC (@sql) 
 GO
 
 
 
 

--select * FROM OPENQUERY(GSFL2K,'select ptdate from prtimecd WHERE ptdate = ''2011-12-02''')

--SELECT convert(varchar, getdate(), 101) -- mm/dd/yyyy 

--SELECT replace(convert(varchar, getdate()-3, 111), '/', '-') -- yyyy-mm-dd

