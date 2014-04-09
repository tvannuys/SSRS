select 

ACHVEND as 'Vendor#',
ACHVNM as 'Vendor Name',
ACHCHECKDT as 'Check date',

ACHCHECK# as 'Check #',
ACH$DS as 'Discount Amt',
ACHCKAMT as 'Net Chk Amt'



from openquery(gsfl2k,'
select * 

from APCHECKHSD

where year(ACHCHECKDT) = 2011
and ACHCHECK# in (select APHCK# from aphviv where APHYR = 2011 and APHCO = 2)

fetch first 1000 rows only
')

