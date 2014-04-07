select CSCUST as 'Customer #',
-- as customer name
CSCHK# as 'Check #',
csco as Company,
csloc as Location,
csord# as [Order],
csrel# as Release,
csinv# as Invoice,
csdate as 'Entry Date',
cspeyr as [Year],
cspecd as [Period],
CSAMT as Amount


from openquery(gsfl2k,'
select * 

from ARCSHISTDC

where cspeyr = 2011
and csco = 2

order by cscust,cschk#,csamt

fetch first 1000 rows only
')

