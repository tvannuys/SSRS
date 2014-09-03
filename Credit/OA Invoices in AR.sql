select * from openquery(gsfl2k,'
select o.oicust as Acct,
c.cmname as Customer,
o.oidate as EntryDate,
o.oiinv# as InvoiceNum,
oiord# as OrderNum,
oiamt as GrossAmt,
oinet as NetAmt


from openitem o
join custmast c on oicust = cmcust

where oiinv# like ''OA%''

order by oicust,oiinv#,oitype desc


')