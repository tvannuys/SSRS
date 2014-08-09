/*
Created By:  Thomas Van Nuys
Date Created: 8/8/2014

SR #24152

*/

--====  Items stocked in branchs, not marked as stocking in 50,60,04

select * from openquery(gsfl2k,'

select imitem,
imdesc as ItemDesc, 
imcolr as ItemColor,
imsi as MasterStockFlag,
ibloc as Location,
IBPRIO as BranchStockFlag

from itembal
join itemmast on imitem = ibitem

where IBPRIO = ''Y''
and ibloc not in (50,60,04)
and ibloc not between 40 and 49
and ibco <> 2

and imdrop <> ''D''
and ibitem not in (select ib2.ibitem
					from itembal ib2
					where ib2.IBPRIO = ''Y''
					and ib2.ibloc in (50,60,04))
')


--====  Items stocked in branchs, not a master stock item

select * from openquery(gsfl2k,'

select imitem,
imdesc as ItemDesc, 
imsi as MasterStockFlag,
ibloc as Location,
IBPRIO as BranchStockFlag

from itembal
join itemmast on imitem = ibitem

where IBPRIO = ''Y''
and ibitem not in (select im2.imitem
					from itemmast im2
					where im2.imsi = ''Y'')


')
