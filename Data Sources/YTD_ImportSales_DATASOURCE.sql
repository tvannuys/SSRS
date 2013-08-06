-- SR# 12834
-- Update James Tuttle	Date:07/25/2013

ALTER PROC YTD_ImportSales_DATASOURCE AS
BEGIN
	SELECT *
		,((YTDSales - YTDCost) / YTDSales) [GM%]

	FROM OPENQUERY(gsfl2k,'
	SELECT imvend
		,vmname
		,imitem
		,imdesc
		,imcolr
		,imfmcd
		,imsi
		,IMIITM
		,imprcd
		,sldate
		,sum(sleprc)  AS YTDSales
		,sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)  AS YTDCost

	FROM itemmast
	JOIN vendmast ON imvend = vmvend
	LEFT JOIN shline ON slitem = imitem
	
	WHERE imsi = ''Y''
		AND year(sldate) = year(current_date)
		AND ((imfmcd = ''YH'')
			OR (IMCLAS = ''IM'')
			OR (imprcd = 6392))
		AND imfmcd NOT IN(''L2'', ''W2'', ''LC'', ''A6'', ''LS'', ''KS'', ''VV'')
		
		
	GROUP BY imvend
				,vmname
				,imitem
				,imdesc
				,imcolr
				,imfmcd
				,imsi
				,IMIITM
				,imprcd
				,sldate

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