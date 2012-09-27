
--CREATE PROC JT_pm_on_hwl_trucks AS

/* -----------------------------------------------------*
** James Tuttle 6/27/2011		Created: 5/28/2009		*
** -----------------------------------------------------*
** 	Report: Query all orders for PMCF On T&A Trucks		*
**  for the prior month. This runs only on the 1st day  *
**  of each month.										*
**------------------------------------------------------*
*/

-- Local variables motnhs
DECLARE @StartMonth DATE
DECLARE @EndMonth	DATE

-- Set the dates on the months -> this runs on the 1st day of the month
-- so a simple dateadd is that is needed
SET @StartMonth = DateAdd(m,-1,getDate())	 -- back 1 month
SET @EndMonth =  DateAdd(d,-1,getDate())	 -- back 1 day

-- Query into As400
select  sliloc as Inv_loc,
		shloc as Order_loc,
		shord# as [Order],
		shcust as Cust_num,
		cmname as Cust_name,
		shsta3 as City_State,
		shodat as Order_date,
		shidat as Invoice_date,
		shinv# as Invoice_num,
		shviac as VIA_code,
		slitem as Item,
		slrout as [route]
from gsfl2k.b107fd6e.gsfl2k.shhead sh JOIN gsfl2k.b107fd6e.gsfl2k.shline sl ON sh.shco = sl.slco
	AND sh.shloc = sl.slloc
	AND sh.shord# = sl.slord#
	AND sh.shrel# = sl.slrel#
JOIN gsfl2k.b107fd6e.gsfl2k.custmast cm ON sl.slcust = cm.cmcust
where shco = 2
	AND shviac = '3'
	and shidat BETWEEN @StartMonth AND @EndMonth
ORDER BY sl.sliloc, sh.shidat, sh.shcust

