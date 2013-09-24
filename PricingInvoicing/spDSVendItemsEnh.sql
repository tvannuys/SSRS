use [gartmanreport]
go
/****** Object:  StoredProcedure [dbo].[spDSVendItemsEnh]    Script Date: 09/24/2013 15:14:58 ******/
set ansi_nulls on
go

set quoted_identifier on
go

create proc [dbo].[spDSVendItemsEnh]

@Vendor varchar(6)

as

declare @sql varchar (2000)



set @sql = 

'select * from openquery (gsfl2k,''

select	imitem as ItemNum,
		imdesc as ItemDesc,
		imcolr as Color,
		imskey as AltItemNum,
		imiitm as InventoryItemNum,
		imptrn as Pattern,
		imstyle as Style,
		imsurf as Surface,
		imbacking as Backing,
		imsdat as SetupDate,
		imdrop as DropCode,
		idrdrd as DropDate,
		imsi as StockingItem,
		imdiv as Division,
		dvdesc as DivisionDesc,
		imfmcd as Family,
		fmdesc as FamilyDesc,
		imcls# as Class,
		ccdesc as ClassDesc,
		imprcd as ProdCode,
		pcdesc as ProdCodeDesc,
		imxprodsub as SubProductCode,
		imhmcd as HazMatCode,
		imvend as VendNum,
		vmname as VendName,
		imbuyr as BuyerNum,
		byname as BuyerName,
		impgcd as PriceGroup,
		imumd4 as RebateCode,
		imrpt1 as Report1,
		imrpt2 as Report2,
		imordm as OrderMult,
		imordq as MinOrderQty,
		imcqty as PkgQty,
		impumc as PkgUM,
		imbrk as BreakPkgYN,
		imblcd as BillingCode,
		imwwwview as IMShowOnWWW,
		pcwwwview as PCShowOnWWW,
		imcolimit as CoLimit,
		imwght as Weight,
		imcost as LandedCost,
		imrcst as InvoiceCost,
		imum1 as InventoryUM,
		imfact as PriceToInvFactor,
		imum2 as PriceUM,
		imp1 as Price1,
		imp2 as Price2,
		imp3 as Price3,
		imp4 as Price4,
		imp5 as Price5,
		imcp1 as CutPrice1,
		imcp2 as CutPrice2,
		imcp3 as CutPrice3,
		imcp4 as CutPrice4,
		imcp5 as CutPrice5
	
		
	from itemmast im
		left join prodcode pc on pc.pcprcd = im.imprcd
		left join clascode cc on cc.ccclas = im.imcls#
		left join itemxtra ix on ix.imxitm = im.imitem
		left join family fm on fm.fmfmcd = im.imfmcd
		left join vendmast vm on vm.vmvend = im.imvend
		left join division di on di.dvdiv = im.imdiv
		left join itemdrop id on id.idritm = im.imitem
		left join buyer byr on byr.bybuyr = im.imbuyr
		
	
	where imvend = ' + @Vendor + '
		and imfcrg <> ''''S''''
		and imdrop <> ''''D''''
	'')'
	
	exec(@sql)
	
	go