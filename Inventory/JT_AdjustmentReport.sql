/*********************************************************************************
**																				**
** SR# 10634																	**
** Programmer: James Tuttle	Date:05/08/2013										**
** ---------------------------------------------------------------------------- **
** Purpose:		A report for Colleen that accepts these parameters:				**
**					- Company													**
**					- Location													**
**					- Date range												**
**					- Adjustment code											**
**																				**
**********************************************************************************/

ALTER PROC JT_AdjustmentReport 
	@co varchar(3)					-- Company
	,@loc varchar(2)				-- Location
	,@startDate varchar(10)			-- Start Date
	,@endDate varchar(10)			-- End Date
	,@adjustCode varchar(2)			-- Adjustment Code

AS
BEGIN
DECLARE @sql varchar(4000) = '
 SELECT irco					AS Co
		,irloc					AS Loc
		,aDate					AS [Date]
		,irreason				AS Code
		,irqty					AS Qty
		,ircost					AS Cost
		,CAST((irqty * ircost)
			AS DECIMAL(18,5))	AS TotalCost
			
 FROM OPENQUERY(GSFL2K,	
	''SELECT irco
		,irloc
		,MONTH(irdate) || ''''/'''' || DAY(irdate) || ''''/'''' || YEAR(irdate) AS aDate
		,irreason
		,irqty
		,ircost
		
	FROM itemrech ir
	
	WHERE ir.irco =  ' + '''' + '''' + @co + '''' + '''' + '
		AND ir.irloc = ' + '''' + '''' + @loc + '''' + '''' + '
		AND ir.irdate BETWEEN ' + '''' + '''' + @startDate + '''' + '''' + ' AND ' + '''' + '''' + @endDate + '''' + '''' + '
		AND ir.irreason = ' + '''' + '''' + @adjustCode + '''' + '''' + '
	'')'
END
EXEC(@sql)

-- JT_AdjustmentReport 1,50,'05/01/2013','05/08/2013','02'