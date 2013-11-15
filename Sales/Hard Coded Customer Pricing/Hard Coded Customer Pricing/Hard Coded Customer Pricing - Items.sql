/* Hard Coded customer pricing 

SR 15513

PECPRC Cut Unit price 
PEPRIC Item Unit price 

11/14/2013
------------------------------------
PECST4 = Manufacturer Rebate - Item
PECCS4 = Manufacturer Rebate - Cut

Buying Group Rebate
CUSTLICG - by customer, first matching product criteria
LICST5 - buying group rebate amount - LISTY5 inidcates % (of cost), P (percent of sell) or $ (dollars per selling unit)


drop table #TempItemList
*/

create table #TempItemList (imitem char(18),
TempItemDesc char(30),
TempLandedCost float,
TempCustomerID char(10),
TempCustomer char(25),
TempState char(2),
TempSalesPerson char(30),
TempItemUnitPrice float,
TempCutUnitPrice float,
TempFromProdCode int,
TempToProdCode int,
TempMnfRebateItem float,
TempMnfRebateCut float
)


/* Single Items */

insert #TempItemList
select FromItem, imdesc, imcost, customerid, Customer, [state], SalesPerson, ItemUnitPrice, CutUnitPrice, FromProdCode,ToProdCode,
	MnfRebateItem, MnfRebateCut
from openquery(gsfl2k,'
select pecust as CustomerID,
cmname as Customer,
right(cmadr3,2) as State,
smname as SalesPerson,
pefitm as FromItem,
petitm as ToItem,
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice,
imitem,
imdesc,
imcost,
PECST4 as MnfRebateItem,
PECST5 as MnfRebateCut

from PRICEXCP
join itemmast on imitem = pefitm
join custmast on cmcust = pecust
left join salesman on smno=cmslmn

where  pepric <> 0
and peedat > current_date
and pefitm <> '' ''
and pefitm = petitm
and (pecust like ''1%'' or pecust like ''40%'')
')



/* Single Product Codes */

insert #TempItemList
select FromItem, imdesc, imcost, customerid, Customer, [state], SalesPerson, ItemUnitPrice, CutUnitPrice, FromProdCode,ToProdCode,
	MnfRebateItem, MnfRebateCut
from openquery(gsfl2k,'
select pecust as CustomerID,
cmname as Customer,
right(cmadr3,2) as State,
smname as SalesPerson,

imitem as FromItem,
imitem as ToItem,

/*
pefitm as FromItem,
petitm as ToItem,
*/
pefprc as FromProdCode,
petprc as ToProdCode,
PECPRC CutUnitPrice, 
PEPRIC ItemUnitPrice,
imitem,
imdesc,
imcost,
PECST4 as MnfRebateItem,
PECST5 as MnfRebateCut


from PRICEXCP
join itemmast on imprcd = pefprc
join custmast on cmcust = pecust
left join salesman on smno=cmslmn

where  pepric <> 0
and peedat > current_date
and pefprc <> 0
and pefprc = petprc
and (pecust like ''1%'' or pecust like ''40%'')

')

/* Range of Product Codes */

declare @fromPRCD int, 
@toPRCD int,
@cutUnitPrice float,
@itemUnitPrice float,
@customer char(10),
@MnfRebateItem float,
@MnfRebateCut float

declare PRICEXCP_cursor cursor for
	select * from openquery(gsfl2k,'
			select pecust as Customer,
			pefprc as FromProdCode,
			petprc as ToProdCode,
			PECPRC CutUnitPrice, 
			PEPRIC ItemUnitPrice,
			PECST4 as MnfRebateItem,
			PECST5 as MnfRebateCut
			
			from PRICEXCP

			where  pepric <> 0
			and peedat > current_date
			and pefprc <> 0
			and pefprc <> petprc
			and (pecust like ''1%'' or pecust like ''40%'')
			')
	
open PRICEXCP_cursor

fetch next from PRICEXCP_cursor
into @customer, @fromPRCD, @toPRCD, @cutUnitPrice, @itemUnitPrice,@MnfRebateItem,@MnfRebateCut

while @@FETCH_STATUS = 0
begin
	insert #TempItemList
	select item.imitem, 
		item.imdesc, 
		item.imcost, 
		@customer, 
		cust.cmname,
		right(cust.cmadr3,2),
		sales.smname,
		@itemUnitPrice, 
		@cutUnitPrice, 
		@fromPRCD, 
		@toPRCD,
		@MnfRebateItem,
		@MnfRebateCut
		
		
	from gsfl2k.b107fd6e.gsfl2k.itemmast item
	join gsfl2k.b107fd6e.gsfl2k.custmast cust on @customer = cust.cmcust
	left join gsfl2k.b107fd6e.gsfl2k.salesman sales on sales.smno=cust.cmslmn
			
	where imprcd between @fromPRCD and @toPRCD

	fetch next from PRICEXCP_cursor into @customer, @fromPRCD, @toPRCD, @cutUnitPrice, @itemUnitPrice,@MnfRebateItem,@MnfRebateCut
end

close pricexcp_cursor
deallocate pricexcp_cursor




/* Final select */

select TempCustomerID as Acct,
TempCustomer as Customer,
#TempItemList.TempState as [State],
#TempItemList.TempSalesPerson as SalesPerson,
#TempItemList.imitem as Item,
TempItemDesc as ItemDesc,
#TempItemList.TempItemUnitPrice as ItemPrice,
TempCutUnitPrice as CutPrice,
TempLandedCost as Cost,
TempMnfRebateItem as MnfRebateItem,
TempMnfRebateCut as MnfRebateCut,
isnull((select SUM(sleprc) from gsfl2k.b107fd6e.gsfl2k.shline where slitem = #TempItemList.imitem and sldate >= DATEADD(M,-12,GETDATE())),0) as TwelveMonthSales,
(select vmname from gsfl2k.b107fd6e.gsfl2k.VENDMAST v join gsfl2k.b107fd6e.gsfl2k.itemmast i on i.imvend = v.vmvend where #TempItemList.imitem = i.IMITEM) as Vendor 

from #TempItemList

where (TempItemUnitPrice-TempLandedCost+TempMnfRebateItem)/TempItemUnitPrice < .15



/* Item Ranges - shouldn't exist

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

*/