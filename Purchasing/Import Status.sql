-- Thomas V

select Buyer,OQ.VendorName,ProductCode,SKU,[Description],Color,Company,Location,PO,VendorRefNum,IssueDate,
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
Poline.PLITEM As SKU, 
Poline.PLDESC As Description, 
Itemmast.IMCOLR As Color, 

(select max(mnman#) from manifest where mnpo# = poline.plpo#
						and mnpolo = poline.plloc
						and mnitem = poline.plitem
						and mnpoco = poline.plco) as Manifest

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
and FMFMCD not in (''L2'',''YI'')
and IMSI = ''Y''
and (poline.plvend in (''22666'',''22887'',''22674'',''22204'',''22859'',''23306'',''22312'',''16006'')
	or (poline.plvend = ''21861'' and imprcd in (''34057'',''34058'')))

Order By Poline.PLDDAT, Vendmast.VMNAME, Poline.PLPO#, Poline.PLITEM 
') OQ

Group by Buyer,OQ.VendorName,ProductCode,SKU,[Description],Color,Company,Location,
PO,VendorRefNum,IssueDate,ProductionDate,ShipDate,Confirmed,DueDate,manifest

Order by Buyer,Company,VendorName,ProductCode,SKU,IssueDate