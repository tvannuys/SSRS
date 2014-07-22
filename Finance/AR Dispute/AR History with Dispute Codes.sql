select * 
into #ARDisputeHist
from openquery(gsfl2k,'
select ''AR Adj'' as SourceApp,
cscust as Acct,
cmname as Customer,
csdate as CreditDate,
CSINV# as Invoice,
cscrcd as CreditCode,
ACDESC as CreditCodeDesc,
csoam1+csoam2+csoam3 as AdjustmentAmt,
cscomt as Comment

from ARCSHIST
left join ARCRCODE on cscrcd = ACCODE
left join custmast on cscust = cmcust

where csdate >= ''7/1/2014''
and cscrcd in (''BE'',''CC'',  ''CD'',  ''CF'',  ''FN'',  ''FR'',  ''FS'',  ''GI'',  ''ME'',  ''MM'',  ''OB'',  ''OE'',
''PA'',  ''PE'',  ''PN'',  ''PU'',  ''RS'',  ''SA'',  ''SD'',  ''ST'',  ''TX'',  ''VD'',  ''WE'')

and CSCO = 1

order by cscrcd


')

--======================================
update #ARDisputeHist
set creditcode = 'WE', 
	creditcodedesc = 'WAREHOUSE ERROR'
where creditcode = 'RD'

--=======================================

select * from #ARDisputeHist