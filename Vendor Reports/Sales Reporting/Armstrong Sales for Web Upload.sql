/* Report for uploading Armstrong Sales to website.  George Rippee 10/03/2013 */
select	'034' AS DistributorNum, 
		'112004' AS BatchNbr,
		SLINV# AS InvoiceNbr, 
		SHBIL# AS DealerNbr, 
		CMNAME AS SoldToName, 
		CMADR2 AS SoldToStreet1, 
		CMADR1 AS SoldToStreet2, 
		Left(CMADR3,23) AS SoldToCity, 
		Right(CMADR3,2) AS SoldToState, 
		CMZIP AS SoldToZip, 
		'' AS ShipToDealerNbr,
		'' AS ShipToName,
		'' AS ShipToStreet1, 
		'' AS ShipToStreet2, 
		'' AS ShipToCity, 
		'' AS ShipToState, 
		'' AS ShipToZip, 
		'034' AS SellingOrganization, 
		SLSEQ# AS InvoiceLineItemNbr, 
		IMSKEY AS ProductItemNbr, 
		SLDESC AS ProductName, 
		IMCOLLECT AS ProductSellingDivision, 
		SLBLUS AS InvoiceLineItemProductQty, 
		SLUM2 AS InvoiceItemProductQtyUOM, 
		SLEPRC AS InvoiceLineItemExtendedAmt, 
		substring(shodat,6,2) + right(shodat,2) + left(shodat,4) AS OrderDate, 
		substring(sldate,6,2) + right(sldate,2) + left(sldate,4) AS ShipDate, 
		substring(sldate,6,2) + right(sldate,2) + left(sldate,4) AS InvoiceDate, 
		RollCutCode,
		DeliveryCode,
		MillContractCode,
		Claim1ProcedureType,
		Claim1ProcedureNbr,
		Claim2ProcedureType, 
		Claim2ProcedureNbr
		
		
FROM OPENQUERY (GSFL2K,'

SELECT 	SHLINE.SLINV#,
		SHHEAD.SHBIL#,
		CUSTMAST.CMNAME,
		CUSTMAST.CMADR2,
		CUSTMAST.CMADR1,
		CMADR3,
		CUSTMAST.CMZIP,
		SHLINE.SLSEQ#,
		ITEMMAST.IMSKEY,
		SHLINE.SLDESC,
		ITEMXTRA.IMCOLLECT,
		SHLINE.SLBLUS,
		SHLINE.SLUM2,
		SHLINE.SLEPRC,
		SHHEAD.SHODAT,
		SHLINE.SLDATE,
	case
		when (imfcrg<>''Y'') then ''''
		when (imfcrg=''Y'' and slcut=''Y'') then ''C''
		else ''R''
	end as RollCutCode,
			
	case
		when (shviac=''1'') then ''W''
		else ''''
	end as DeliveryCode,	
		
	case
		when (shotyp=''FO'' and	slpromocd='''') then ''S''
		when (shotyp=''FO'' and slpromocd<>'''') then ''M''
		else ''''
	end as MillContractCode,
	
	case
		when (shotyp=''FO'') then ''''
		when (shotyp<>''FO'' and slpromocd=''C'') then ''C''
		else ''''
	end as Claim1ProcedureType,
		
	case
		when (shotyp=''FO'') then ''''
		when (shotyp<>''FO'' and slpromocd=''C'') then slpromo#
		else ''''
	end as Claim1ProcedureNbr, 	
		
	case
		when (shotyp=''FO'') then ''''
		when (shotyp<>''FO'' and slpromocd=''S'') then ''S''
		else ''''
	end as 	Claim2ProcedureType, 
		
	case
		when (shotyp=''FO'') then ''''
		when (shotyp<>''FO'' and slpromocd=''S'') then slpromo#
		else ''''
	end as 	Claim2ProcedureNbr
		
		
FROM SHLINE 
LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
LEFT JOIN SHHEAD ON (SHLINE.SLINV# = SHHEAD.SHINV# AND SHLINE.SLCO = SHHEAD.SHCO AND SHLINE.SLLOC = SHHEAD.SHLOC AND SHLINE.SLORD# = SHHEAD.SHORD# AND SHLINE.SLREL# = SHHEAD.SHREL#) 
LEFT JOIN CUSTMAST ON SHHEAD.SHBIL# = CUSTMAST.CMCUST 
LEFT JOIN ITEMXTRA ON SHLINE.SLITEM = ITEMXTRA.IMXITM

WHERE SHHEAD.SHBIL# <> ''4100000''
AND SHLINE.SLEPRC <> 0 
AND SHLINE.SLVEND in (16037,22312,24213)
AND SHLINE.SLCLS# not in (41005,41015,41025,41035,41045,41047,41055,41085,40908,40902,41056,41057) 
AND SHLINE.SLLOC not in (48,47,49)
AND SHLINE.SLDATE Between ''09/01/2013'' And ''09/08/2013''
AND SHLINE.SLDIV <> 13 
AND SHLINE.SLCO = 2 
AND SHHEAD.SHUSER <> ''ARMDATA''
AND SHLINE.SLPROMO# Not Like ''XX%'' 
AND ITEMXTRA.IMXMIT <> ''N'' 
AND SHHEAD.SHOTYP <> ''CL''
')


ORDER BY InvoiceNbr,InvoiceLineItemNbr
