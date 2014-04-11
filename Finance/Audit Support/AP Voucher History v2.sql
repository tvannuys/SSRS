select APHVOU as 'Voucher#',
APHVEN as 'Vendor#',
APHVNM as 'Vendor Name',

APHINV as 'Invoice #',
APHIDT as 'Invoice Date',
aphedt as 'GL Posting Date',
APHCO as Company,
APHLOC as Location,
--APHGL# as 'AP GL#',

APHAMT as 'Invoice Amt',
APHCK# as 'Check #',

aphlgl as GL,
aphlamt as Amt

--oq.*

from openquery(gsfl2k,'
select h.*, d.*

from aphistd d
join aphviv h on h.APHEKEY = d.APHLKEY

where h.APHYR = 2011
and APHCO = 2

') oq