--spEMU 'GRTB1211BR'

alter proc spEMU 

@Item as varchar(30)

as

/* =================================================

	First date range - gather total sales 

====================================================*/

declare @sql as varchar(5000)

set @sql = 'select * into #EMU1

from openquery(gsfl2k,''

select  slco,
slloc,
slitem,
year(SHiDAT),
month(SHiDAT),
/* sum(SLBLUS) as QtySold */
sum(SLQSHP) as QtySold 

from shline 
join shhead on (shhead.shco = shline.slco
	and shhead.shloc = shline.slloc
	and shhead.shord# = shline.slord#
	and shhead.shrel# = shline.slrel#
	and shhead.shinv# = shline.slinv#
	and shhead.shcust = shline.slcust)
join itemmast on shline.slitem = itemmast.imitem
join itemxtra on itemmast.imitem = itemxtra.imxitm

where imitem = ' + '''''' + @Item + '''''' + 
' and shidat >= year(current_date - 4 months) || ''''-'''' || month(current_date - 4 months) || ''''-1''''
and shidat < year(current_date - 1 months) || ''''-'''' || month(current_date - 1 months) || ''''-1''''


group by slco,
slloc,
slitem,
year(SHiDAT),
month(SHiDAT)


'')

/* =================================================

	Second date range - gather total sales 

====================================================*/

select * into #EMU2 from openquery(gsfl2k,''

select  slco,
slloc,
slitem,
year(SHiDAT),
month(SHiDAT),
/* sum(SLBLUS) as QtySold */
sum(SLQSHP) as QtySold 


from shline 
join shhead on (shhead.shco = shline.slco
	and shhead.shloc = shline.slloc
	and shhead.shord# = shline.slord#
	and shhead.shrel# = shline.slrel#
	and shhead.shinv# = shline.slinv#
	and shhead.shcust = shline.slcust)
join itemmast on shline.slitem = itemmast.imitem
join itemxtra on itemmast.imitem = itemxtra.imxitm

where imitem = ' + '''''' + @Item + '''''' + 
' and shidat >= year(current_date - 3 months) || ''''-'''' || month(current_date - 3 months) || ''''-1''''
and shidat < year(current_date - 0 months) || ''''-'''' || month(current_date - 0 months) || ''''-1''''


group by slco,
slloc,
slitem,
year(SHiDAT),
month(SHiDAT)

'')

/* =================================================

	Calc average 1, put in temp table

====================================================*/

select slitem,
sum(qtysold)/3 as AvgSold

into #emuAvg1

from #emu1

group by slitem

/* =================================================

	Calc average 2, put in temp table

====================================================*/


select slitem,
sum(qtysold)/3 as AvgSold

into #emuAvg2

from #emu2

group by slitem

/* =================================================

   Final Select

====================================================*/


select (sum(a.AvgSold) + sum(B.AvgSold)) /2 as EMU

from #emuAvg1 a
join #emuAvg2 b on (a.slitem = b.slitem)
	
where ((a.AvgSold + B.AvgSold) /2) / 4 <> 0


'

--select @sql
exec(@sql)