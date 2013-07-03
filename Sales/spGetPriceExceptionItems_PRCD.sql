USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spGetPriceExceptionItems_PRCD]    Script Date: 07/02/2013 16:35:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* find PRICEXCP PECUST records that start with alpha

SELECT * FROM TestTable WHERE TestNames NOT LIKE '[A-z]%'

*/




CREATE proc [dbo].[spGetPriceExceptionItems_PRCD] as

set nocount on

declare @fromPRCD int, @toPRCD int

declare PRICEXCP_cursor cursor for
	select * from openquery(gsfl2k,'select pefprc, petprc from pricexcp where pecust = ''ARSPOTLT'' and pefprc <> 0')
	
open PRICEXCP_cursor

fetch next from PRICEXCP_cursor
into @fromPRCD, @toPRCD

while @@FETCH_STATUS = 0
begin
	insert ##TempItemList
	select imitem 
	from gsfl2k.b107fd6e.gsfl2k.itemmast
	where imprcd between @fromPRCD and @toPRCD

	fetch next from PRICEXCP_cursor into @fromPRCD, @toPRCD
end

close pricexcp_cursor
deallocate pricexcp_cursor





GO


