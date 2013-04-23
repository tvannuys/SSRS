-- SR# 4765
-- James Tuttle		Date:10/16/2012
-- Add five vendors to the list
-- SR# 9807 James Tuttle 04/15/2013 Added IMCLAS = 'IM' 
--------------------------------------------------------------------------------------------------------
-- James Tuttle		Date:04/23/2013
-- SR#10030
-- 1. can review and see if you can have and po's that have been received to delete of report.
-- 2. Also if you can add Div family field in last columns of report.
-- 3. Also  Please add Qty on po.. 
--------------------------------------------------------------------------------------------------------



ALTER PROC spImportStatus AS 
BEGIN 
	select pldelt, Buyer,OQ.VendorName,ProductCode,SKU,[Description],Color,Company,Location,PO,POqty,VendorRefNum,IssueDate,
	case ProductionDate
		when '0001-01-01' then ''
		else ProductionDate
	end as ProductionDate,

	case ShipDate
		when '0001-01-01' then ''
		else ShipDate
	end as ShipDate,

	Confirmed,

	case DueDate
		when '0001-01-01' then ''
		else DueDate
	end as DueDate,

	case when Manifest IS null
		then ''
		else Manifest
	end as Manifest
	
	,Division
	,FamilyCode 
	 
	from openquery(GSFL2K,'

	Select Poline.PLDDAT As DueDate, 
	PHDOI as IssueDate,
	PLSHIPDATE as ShipDate,
	PLRELDATE as ReleaseDate,
	PLPDAT as ProductionDate,
	PLBUYR as Buyer,
	PLDDATCONF as Confirmed,
	PHREF# as VendorRefNum,
	Poline.PLCO as Company,
	Poline.PLLOC As Location, 
	Family.FMFMCD as FamilyCode,
	Family.FMDESC as Family, 
	Itemmast.imprcd as ProductCode,
	ProdCode.pcdesc as ProductCodeDesc,
	Vendmast.VMNAME As VendorName, 
	Poline.PLPO# As PO, 
	Poline.plqord AS POqty,
	Poline.PLITEM As SKU, 
	Poline.PLDESC As Description, 
	Itemmast.IMCOLR As Color, 

	(select max(mnman#) from manifest where mnpo# = poline.plpo#
							and mnpolo = poline.plloc
							and mnitem = poline.plitem
							and mnpoco = poline.plco) as Manifest
	,imdiv AS Division
	,pldelt
	
	FROM Poline

	left join Itemmast on Itemmast.IMITEM = Poline.PLITEM
	Left Join Pohead On (Poline.PLco = Pohead.PHco
		and Poline.PLloc = Pohead.PHloc
		and poline.plvend = pohead.phvend
		and Poline.PLPO# = Pohead.PHPO#) 

	Left Join Vendmast On Poline.PLVEND = Vendmast.VMVEND 
	Left Join Family On Poline.PLFMCD = Family.FMFMCD 
	Left Join ProdCode On Itemmast.imprcd = ProdCode.pcprcd

	Where Pohead.PHDOI > ''12/31/2005''
	  and IMSI = ''Y''
	  AND IMCLAS = ''IM'' 
	  AND Poline.pldelt = ''A''

	Order By Poline.PLDDAT, Vendmast.VMNAME, Poline.PLPO#, Poline.PLITEM 
	') OQ

	Group by Buyer,OQ.VendorName,ProductCode,SKU,[Description],Color,Company,Location,
	PO,POqty,VendorRefNum,IssueDate,ProductionDate,ShipDate,Confirmed,DueDate,manifest,Division,FamilyCode,pldelt

	Order by Buyer,Company,VendorName,ProductCode,SKU,IssueDate
END
