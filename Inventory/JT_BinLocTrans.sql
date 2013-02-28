/*********************************************************************************
**																				**
** SR# nnnn																		**
** Programmer: James Tuttle	Date: 02/25/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:			Have Colleen put in a date range comapny and bin location	**
**					then query the transactions that happenedwithin the PARMS	**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_BinLocTrans @StartDate varchar(10)
, @EndDate varchar(10)
, @Loc varchar(2)
, @Bin varchar(5)
AS

	DECLARE @sql varchar(4000)
	SET @sql = '

SELECT *
FROM OPENQUERY(GSFL2K,''
	SELECT irdate
			,iritem
			,irdesc
			,irco
			,irloc
			,irky
			,irserl
			,irdylt
			,irbin
			,irqty
			,irooco
			,iroolo
			,irord#
			,irrel#
			,irsrc
			,iruser
	FROM itemrech ir
	WHERE ir.irdate BETWEEN ''''' + @StartDate + ''''' AND ''''' + @EndDate + '''''
		AND ir.irloc = ' + @Loc + '
		AND ir.irbin = ''''' + @Bin + '''''
	'')
'
	EXEC (@sql)
GO
-- JT_BinLocTrans '2/22/2013','2/22/2013',41,'99F2A'

			