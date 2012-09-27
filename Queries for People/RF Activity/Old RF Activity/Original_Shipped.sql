select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
'Shipped',
lineItemsForShippedColumn
 from openquery(GSFL2K,'

select olrico, 
olrilo,
olrdat,
olrusr,
count(*) as lineItemsForShippedColumn
  from oolrfuser hst
 where hst.olrtyp = ''T''
   and not exists ( 
                   select 1
                     from rfwillchsx wcc 
                    where hst.olrco = wcc.rfoco
                      and hst.olrloc = wcc.rfoloc
                      and hst.olrord = wcc.rfoord#
                      and hst.olrrel = wcc.rforel#
                      and hst.olrusr = wcc.rpuser
                  )
   and hst.olrico = 1 
   and hst.olrilo = 50 
   and hst.olrdat >= ''2011-10-01''
   and hst.olrtim >= 000001 
   and hst.olrdat <= ''2011-10-31'' 
   and hst.olrtim <= 235959 

group by olrico, olrilo,olrdat,olrusr
order by olrusr
')
