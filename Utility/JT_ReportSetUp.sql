
/*********************************************************************************
**																				**
** SR# nnnn																		**
** Programmer: James Tuttle	Date: 04/03/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:		Use Report Server on SQL to quikly search the Gartman			**
**			File 'RPTPRNT' for a report program and/or USER ID.					**
**			This is helpful for when you need to find all reports for USER X	**
**			:: OR :: Find all Prgograms and locations to see what is missing	**
**			for a user.															**
**																				**
**********************************************************************************/

ALTER PROC JT_ReportSetUp 
	 @Program varchar(10) 
	, @USER varchar(10) 
	
AS

DECLARE @sql varchar(2000)
	SET @Program = UPPER(@Program)
	SET @USER = UPPER(@USER) 
	SET @sql = '
		SELECT *
		FROM OPENQUERY(GSFL2K,
		'' SELECT rppgm
				,rpprtfile
				,rpco
				,rploc
				,rpuwcd
				,rpuw
				,rpprtr
				,rpform
		FROM rptprnt rp
		WHERE rppgm LIKE ''''''%'' + @Program + ''%''''''
			AND rpuw LIKE ''''''%'' +  @USER + ''%''''''
		ORDER BY rpco
				,rploc
				,rpuw
		'')'
	
EXEC(@sql)

--	EXEC JT_ReportSetUp 'PO680','MICHELLEM'
	