select CSCUST as 'Customer #',
CMNAME as 'customer Name',
CSCHK# as 'Check #',
csco as Company,
csloc as Location,
csord# as [Order],
csrel# as Release,
csinv# as Invoice,
csdate as 'Entry Date',
cspeyr as [Year],
cspecd as [Period],
CSAMT as Amount,
CSARGL as AR_GL#,
CSBKGL as BankGL,
CSOAM1 as OtherAmt_1,
CSOGL1 as OtherGL_1,
CSOAM2 as OtherAmt_2,
CSOGL2 as OtherGL_2,
CSOAM3 as OtherAmt_3,
CSOGL3 as OtherGL_3,
CSOAM4 as OtherAmt_4,
CSOGL4 as OtherGL_4




from openquery(gsfl2k,'
select * 

from ARCSHISTDC
left join custmast on cmcust = cscust

where cspeyr = 2011
and csco = 2

order by cscust,cschk#,csamt

fetch first 1000 rows only
')

