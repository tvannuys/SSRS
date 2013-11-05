create table ##TempItemList (imitem char(18),
TempItemDesc char(30),
TempLandedCost float,
TempCustomer char(10),
TempItemUnitPrice float,
TempCutUnitPrice float,
TempFromProdCode int,
TempToProdCode int
)



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
	insert ##TempItemList
	select imitem, imdesc, imcost, @customer, @itemUnitPrice, @cutUnitPrice, @fromPRCD, @toPRCD
	from gsfl2k.b107fd6e.gsfl2k.itemmast
	where imprcd between @fromPRCD and @toPRCD

	fetch next from PRICEXCP_cursor into @customer, @fromPRCD, @toPRCD, @cutUnitPrice, @itemUnitPrice
end

close pricexcp_cursor
deallocate pricexcp_cursor

select TL.TempCustomer,
tl.imitem,
tl.imitem,
tl.TempFromProdCode,
tl.TempToProdCode,
tl.TempCutUnitPrice,
tl.TempItemUnitPrice,
tl.imitem,
tl.TempItemDesc,
tl.TempLandedCost

from ##TempItemList TL




--drop table ##TempItemList
