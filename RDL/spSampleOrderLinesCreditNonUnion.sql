USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spSampleOrderLinesCreditNonUnion]    Script Date: 09/12/2012 15:55:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER proc [dbo].[spSampleOrderLinesCreditNonUnion]

  @DaysBack as varchar(3) = '1'

AS

declare @sql as varchar(3000) 

set @sql = '


		select * 
		into #spSampleCredit
		from openquery(gsfl2k,''

		SELECT SHHEAD.SHINV# AS InvoiceNbr, 
		SHHEAD.SHIDAT AS InvoiceDate, 
		SHHEAD.SHCM AS CreditMemo, 
		SHHEAD.SHPO# AS CustPO, 
		shhead.SHOTYP as OrderType,
		CUSTMAST.CMCUST as CustNum,
		CUSTMAST.CMNAME AS CustName, 
		SHTOTL AS Total

		FROM SHHEAD 
		LEFT JOIN CUSTMAST ON SHHEAD.SHBIL# = CUSTMAST.CMCUST 

		WHERE SHHEAD.SHIDAT = current_date - ' + @DaysBack +
		
		' days and SHOTYP in (''''SA'''',''''DP'''',''''SR'''')
		
		'') 
		
insert #spSampleCredit

select * from openquery(gsfl2k,''

		SELECT h.SHINV# AS InvoiceNbr, 
		h.SHIDAT AS InvoiceDate, 
		h.SHCM AS CreditMemo, 
		h.SHPO# AS CustPO, 
		h.SHOTYP as OrderType,
		C.CMCUST as CustNum,
		C.CMNAME AS CustName, 
		h.SHTOTL AS Total
		
from shhead h
left join shline l on (l.SLCO = h.SHCO 
					AND l.SLLOC = h.SHLOC 
					AND l.SLORD# = h.SHORD# 
					AND l.SLREL# = h.SHREL# 
					AND l.SLINV# = h.SHINV#) 
left join itemmast i on l.slitem = i.imitem
LEFT JOIN CUSTMAST c ON h.SHBIL# = c.CMCUST 

where h.shotyp = ''''FO''''
and i.imfcrg = ''''S''''
and h.SHIDAT = current_date - ' + @DaysBack + ' days'')




select * from #spSampleCredit

'

--select(@sql)
exec(@sql) 







GO


