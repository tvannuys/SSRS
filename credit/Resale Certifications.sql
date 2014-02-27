select 
Acct,
Customer,
Class,
StateDesc as [State],
StateTaxable as Taxable,
ExemptionCert as [Certificate],
ExemptionCertExpirationDate as Expiration,
LastSaleDate as 'Last Sale',
SalesDollars13Months1 as '13 Month Sales'

from openquery(gsfl2k,'
select CTBCUS as Acct,
cmname as Customer,
CEXCLASS as Class,
TXDESC as StateDesc,
CTBSTT as StateTaxable,
CTBSTE as ExemptionCert,
CTBSTEXDT as ExemptionCertExpirationDate,

CMLSAL as LastSaleDate,
IFNULL(CHS$13,0) as SalesDollars13Months1

from custtxbl
join custmast on cmcust = ctbcus
join custextn on ctbcus = cexcust
join taxmast on (ctbstc = TXSTCD and TXCNCD = 0 and TXCICD = 0)
left join custhist on (chcust = ctbcus and chyear = year(current_date))

where SUBSTR(ctbcus, 1, 1) between ''0'' and ''9''
and (CTBSTEXDT < (current_date + 45 days)) 

order by cexcust

')