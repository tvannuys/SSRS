USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spCOGSForecast]    Script Date: 08/06/2014 09:38:41 ******/
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

set @sql = 'select *
from openquery(gsfl2k,''
select i1.imitem,
i1.imdesc,
i1.imcolr,
sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as SOCOGS,
ifnull((select sum(PBOQTY*i2.IMCOST)
		from poboline 
		join itemmast i2 on i2.imitem = pbitem
		where PBITEM = i1.imitem),0) as BOValue

from shline
LEFT JOIN ITEMMAST i1 ON SHLINE.SLITEM = i1.IMITEM 
		
where SLDATE >= ''''' + @StartDate + '''''
 and SLDATE <= ''''' + @EndDate + '''''
 and i1.IMCLAS in (''''IM'''',''''NL'''')
 and i1.IMFCRG <> ''''S''''
 and i1.imsi = ''''Y''''
 and i1.imfmcd not in (''''L2'''',''''W2'''')
 and i1.imdrop <> ''''D''''

group by i1.imitem,
i1.imdesc,
i1.imcolr

'')'

exec(@sql)



GO


