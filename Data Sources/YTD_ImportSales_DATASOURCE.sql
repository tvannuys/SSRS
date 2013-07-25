-- SR# 12834
-- Update James Tuttle	Date:07/25/2013

CREATE PROC YTD_ImportSales_DATASOURCE AS
BEGIN
	select *

	from openquery(gsfl2k,'
	select imvend,vmname,imitem,imdesc,imcolr,imfmcd,imsi,IMIITM,
	sldate,
	sum(sleprc)  as YTDSales,
	sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)  as YTDCost

	from itemmast
	join vendmast on imvend=vmvend
	left join shline on slitem=imitem
	where imsi = ''Y''
	and year(sldate) = year(current_date)
		AND ((imfmcd = ''YH'')
		OR (IMCLAS = ''IM''))
	group by imvend,vmname,imitem,imdesc,imcolr,imfmcd,imsi,IMIITM,
	sldate
	')
END

-------------------------------------------------------------------------------------
-- Took these out because IMCLAS = IM replaced the need for this code -------------
--and (
--	(imvend = 22666 and imfmcd in (''L1'',''W1'')) or
--	(imvend in (22674, 22204) and imfmcd in (''L1'',''V4'')) or
--	(imvend = 21861 and imprcd in (34057,34058)) or
--	(imvend = 22859 and imfmcd = ''W1'') or
--	(imvend = 22312 and imfmcd = ''YH'')
--	)
-------------------------------------------------------------------------------------