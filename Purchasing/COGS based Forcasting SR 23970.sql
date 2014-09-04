USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spCOGSForecast]    Script Date: 09/03/2014 13:08:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* 


SR 23970

Created:  8/4/2014 - Thomas

where SLSDAT >= CURDATE() - 90 days

sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as SOCOGS,

-- want COGS for last 3 complete months
 
*/
ALTER proc [dbo].[spCOGSForecast] 

@StartDate as varchar(15), 
@EndDate as varchar(15) 

as

declare @sql as varchar(max)

set @sql = 'select OQ.*,

case 
	when (OQ.IMMD = ''M'' and OQ.IMMD2 = '' '') then (BOQty*OQ.IMFACT*imcost)
	when (OQ.IMMD = ''M'' and OQ.IMMD2 = ''D'') then (((BOQty*imcost)*OQ.IMFACT)/OQ.IMFAC2)
	else 0
end as BOValue

from openquery(gsfl2k,''
select i1.imvend,
i1.imfmcd,
i1.imitem,
i1.imdesc,
i1.imcolr,
i1.IMMD,
i1.IMMD2,
i1.imfact,
i1.imfac2,
i1.imcost,
sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as SOCOGS,

ifnull((select sum(PBOQTY)
		from poboline 
		join itemmast i3 on i3.imitem = pbitem
		where PBITEM = i1.imitem),0) as BOQty,
		
ifnull((select sum(sleprc)
		from shline sl 
		where sl.slitem = i1.imitem
		and year(SLDATE) = year(current_date)),0) as YTDSales

from shline
LEFT JOIN ITEMMAST i1 ON SHLINE.SLITEM = i1.IMITEM 
		
where SLDATE >= ''''' + @StartDate + '''''
 and SLDATE <= ''''' + @EndDate + '''''
 and i1.IMCLAS in (''''IM'''',''''NL'''')
 and i1.IMFCRG <> ''''S''''
 and i1.imsi = ''''Y''''
 and i1.imfmcd not in (''''L2'''',''''W2'''')
 and i1.imdrop <> ''''D''''

group by i1.imvend,
i1.imfmcd,
i1.imitem,
i1.imdesc,
i1.imcolr,
i1.IMMD,
i1.IMMD2,
i1.imfact,
i1.imfac2,
i1.imcost

'') OQ;


'

--select (@sql)
exec(@sql)


GO


