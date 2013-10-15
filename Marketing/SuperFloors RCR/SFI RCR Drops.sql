select h.ITEM,oq.imdesc,oq.imcolr,oq.IDRDAT

from CustomerPriceHistory h

join openquery(gsfl2k,'select itemdrop.*, imdesc,imcolr
					from itemdrop 
					left join itemmast on imitem=idritm
					
					where idrdat >= ''8/27/2013'' ') OQ on OQ.idritm=ITEM 

where h.CustID = '1006826'

/*

select idrdat,
LEFT(idrdat,4) + SUBSTRING(idrdat,6,2) + right(idrdat,2)

from openquery(gsfl2k,'select idrdat,
month(idrdat) as DateMonth,
day(idrdat) as DateDay,
year(idrdat) as DateYear

from itemdrop 
where idrdat >= ''08/27/2013'' ')

*/