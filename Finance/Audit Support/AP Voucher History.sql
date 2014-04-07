select APHVOU as 'Voucher#',
APHVEN as 'Vendor#',
APHVNM as 'Vendor Name',
APHDEP as Dept,
APHINV as 'Invoice #',
APHIDT as 'Invoice Date',
APHAMT as 'Invoice Amt',
APHCK# as 'Check #'

from openquery(gsfl2k,'
select *

from aphviv

where APHYR = 2011
and APHCO = 2
and APHDLT = 2
 
fetch first 1000 rows only

')