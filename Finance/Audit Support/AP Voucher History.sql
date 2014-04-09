select APHVOU as 'Voucher#',
APHVEN as 'Vendor#',
APHVNM as 'Vendor Name',

APHINV as 'Invoice #',
APHIDT as 'Invoice Date',
aphedt as 'GL Posting Date',
APHCO as Company,
APHLOC as Location,
APHGL# as 'AP GL#',

APHAMT as 'Invoice Amt',
APHCK# as 'Check #'

from openquery(gsfl2k,'
select *

from aphviv
left join glmast on (aphgl# = glgl# and glco = aphco)

where APHYR = 2011
and APHCO = 2
and APHDLT = 2
 
fetch first 1000 rows only

')