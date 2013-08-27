alter proc spNewSKU 
@startdate varchar(14),
@enddate varchar(14)

as

declare @sql varchar(2000)

set @startdate = '''''' + @startdate + ''''''
set @enddate = '''''' + @enddate + ''''''

set @sql = 'select * from openquery(gsfl2k,''
select dvdesc,fmdesc,imprcd,pcdesc,imdesc, imcolr
from itemmast
left join itemxtra on imxitm = imitem
left join family on imfmcd = fmfmcd
left join prodcode on imprcd = pcprcd
left join division on imdiv = dvdiv

where IMSDAT >= ' + @startdate + ' and imsdat <= ' + @enddate + '  

order by imprcd,imdesc
'')'

exec(@sql)

/*
spNewSKU '8/21/2013', '8/26/2013'
*/