/* Hard Coded customer pricing 

SR 15513

PECPRC Cut Unit price 
PEPRIC Item Unit price 

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
TempToProdCode int
)


/* Single Items */

insert #TempItemList
select FromItem, imdesc, imcost, customerid, Customer, [state], SalesPerson, ItemUnitPrice, CutUnitPrice, FromProdCode,ToProdCode
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
imcost

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
select FromItem, imdesc, imcost, customerid, Customer, [state], SalesPerson, ItemUnitPrice, CutUnitPrice, FromProdCode,ToProdCode
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
imcost

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
@customer char(10)

declare PRICEXCP_cursor cursor for
	select * from openquery(gsfl2k,'
			select pecust as Customer,
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
	
open PRICEXCP_cursor

fetch next from PRICEXCP_cursor
into @customer, @fromPRCD, @toPRCD, @cutUnitPrice, @itemUnitPrice

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
		@toPRCD
		
	from gsfl2k.b107fd6e.gsfl2k.itemmast item
	join gsfl2k.b107fd6e.gsfl2k.custmast cust on @customer = cust.cmcust
	left join gsfl2k.b107fd6e.gsfl2k.salesman sales on sales.smno=cust.cmslmn
			
	where imprcd between @fromPRCD and @toPRCD

	fetch next from PRICEXCP_cursor into @customer, @fromPRCD, @toPRCD, @cutUnitPrice, @itemUnitPrice
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
(select SUM(sleprc) from gsfl2k.b107fd6e.gsfl2k.shline where slitem = #TempItemList.imitem and sldate >= DATEADD(M,-12,GETDATE())) as TwelveMonthSales

from #TempItemList


where (TempItemUnitPrice-TempLandedCost)/TempItemUnitPrice < .15



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