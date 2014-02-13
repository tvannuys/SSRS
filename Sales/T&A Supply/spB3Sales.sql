alter proc spB3Sales as

select * 
into #TempB3Sales
from openquery (gsfl2k,'

select      pecust as CustNum,
            cmname as Custname,
            peref# as B3RefCode,
            left(cmadr3,23) as CustCity,
            right(cmadr3,2) as CustState,
            slitem as ItemNum,
            sldesc as ItemDesc,
            sleprc as SalesDollars
            
from pricexcp pe
      left join custmast cm on cm.cmcust=pe.pecust
      left join shline sl on sl.slcust=pe.pecust


where (year(sldate)=year(current_date - 1 month) and month(sldate)=month(current_date - 1 month))
      and peref# = ''B3EAST''
      and slitem in (''GAGVGM81012'',''LOH8289'',''LOLG1039'',''GAGVCR10008P'',''MATL160'',''CHCW879V'',''GRTB1216B'',''MATL120'')
      
      
');


insert #TempB3Sales
select CustNum,
CustName,
B3RefCode,
CustCity,
CustState, 
'GAGVGM81012' as ItemNum,
'GRAND MESA PLUS 12.3MM 19.42SF' as ItemDesc,
0 as SalesDollars

from openquery (gsfl2k,'

select      pecust as CustNum,
            cmname as CustName,
            left(cmadr3,23) as CustCity,
            right(cmadr3,2) as CustState,
            cmslmn as RepNum,
            smname as RepName,
            cuclxclass as CustType,
            ccldesc as TypeDesc,
            peref# as B3RefCode
            
from pricexcp pe
      left join custmast cm on cm.cmcust = pe.pecust
      left join salesman sm on sm.smno = cm.cmslmn
      left join cucl2xref cucl on cucl.cuclxcust = pe.pecust
      left join cuclmast ccl on ccl.cclclass = cucl.cuclxclass
      
where peref# = ''B3EAST''
      


');

select * from #TempB3Sales
