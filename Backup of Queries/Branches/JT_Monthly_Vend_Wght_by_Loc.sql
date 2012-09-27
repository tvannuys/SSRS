
--[JT_Monthly_Vend_Wght_by_Loc] '01/01/2012','01/31/2012'

ALTER PROC [dbo].[JT_Monthly_Vend_Wght_by_Loc]

 @BeginDate varchar(10)  ,
 @EndDate varchar(10) 

AS

SET @BeginDate = 
SET @EndDate = 

Declare @sql as varchar(max)

SET @sql ='
SELECT *
FROM Openquery(GSFL2K,''SELECT sl.slco as Company,
							  sl.slloc as Location,
							  lc.lcname as Location_Name,
							  sl.slvend as vend_Num,
							  vm.vmname as Vend_Name,
							  DEC(ROUND(SUM(sl.slqshp * im.imwght),1),10,0)as Last_Month_Wgt	
						FROM  shline sl
						INNER JOIN itemmast im
							ON sl.slitem = im.imitem
						INNER JOIN vendmast vm
							ON sl.slvend = vm.vmvend
						INNER JOIN location lc
							ON sl.slco = lc.lcco
								AND sl.slloc = lc.lcloc
						WHERE sl.sldate >= ' + '''' + '''' + @BeginDate + '''' + ''''+ '
							AND sl.sldate <=' + '''' + ''''+ @EndDate + '''' + '''' + '
							AND sl.slvend != 40000
						GROUP BY sl.slco,
								 sl.slloc,
								 sl.slvend,
								 lc.lcname,
								 vm.vmname
						ORDER BY sl.slco,
								 sl.slloc,
								 Last_Month_Wgt DESC
						'')
				'		
EXEC(@sql)


GO


