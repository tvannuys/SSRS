/* Hard Coded customer pricing 

SR 15513

PECPRC Cut Unit price 
PEPRIC Item Unit price 


*/


/* Item Ranges */

select * from openquery(gsfl2k,'
select pecust as Customer,
pefitm as FromItem,
petitm as ToItem,
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice 

from PRICEXCP
where  pepric <> 0
and peedat > current_date
and pefitm <> '' ''
and pefitm <> petitm
and (pecust like ''1%'' or pecust like ''40%'')
')

/* Single Items */

select * from openquery(gsfl2k,'
select pecust as Customer,
pefitm as FromItem,
petitm as ToItem,
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice,
imitem,
imdesc,
imrcst

from PRICEXCP
join itemmast on imitem = pefitm


where  pepric <> 0
and peedat > current_date
and pefitm <> '' ''
and pefitm = petitm
and (pecust like ''1%'' or pecust like ''40%'')
')


/* Single Product Codes */

select * from openquery(gsfl2k,'
select pecust as Customer,
pefitm as FromItem,
petitm as ToItem,
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice,
imitem,
imdesc,
imrcst

from PRICEXCP
join itemmast on imprcd = pefprc


where  pepric <> 0
and peedat > current_date
and pefprc <> 0
and pefprc = petprc
and (pecust like ''1%'' or pecust like ''40%'')

order by pefprc, imitem

')


/* Range of Product Codes 

select * from openquery(gsfl2k,'
select pecust as Customer,
pefitm as FromItem,
petitm as ToItem,
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice 

from PRICEXCP


where  pepric <> 0
and peedat > current_date
and pefprc <> 0
and pefprc <> petprc
and (pecust like ''1%'' or pecust like ''40%'')
')

*/