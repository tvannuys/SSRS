USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spStoreSundriesSales]    Script Date: 01/07/2013 16:45:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Division 6 thru 9 Sales Report
	Requested by Greg Szalay Oct-2011
*/

create proc [dbo].[spStoreSundriesSales] as

select *
from openquery (GSFL2K,'
select d.dvdiv as Division,
slco as Company,
slloc as Location,
lcrnam as LocationName,
year(shidat) as TranYear,
month(shidat) as TranMonth,
sum(SLEPRC) AS SalesTotal, 
sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) AS CostTotal

from shline 

join shhead on (shhead.shco = shline.slco
	and shhead.shloc = shline.slloc
	and shhead.shord# = shline.slord#
	and shhead.shrel# = shline.slrel#
	and shhead.shinv# = shline.slinv#
	and shhead.shcust = shline.slcust)
left join itemmast I on I.IMITEM = SHLINE.SLITEM
left join division D on I.imdiv = D.dvdiv
LEFT join location L on (L.lcco = slco and L.lcloc = slloc)

where year(SHiDAT) in (year(CURDATE()),year(CURDATE()) - 1)
and D.DVDIV in (6,7,8,9)

group by d.dvdiv,
slco,
slloc,
lcrnam,
year(shidat),
month(shidat)

')


GO


