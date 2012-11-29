USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spMrktDiscInv2]    Script Date: 11/27/2012 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER proc [dbo].[spMrktDiscInv2]

@SearchTerm varchar(20) = '%'

as

declare @sql as varchar(5000)

set @SearchTerm = upper(@SearchTerm)

set @sql = '

select * 
from openquery(GSFL2K,''

SELECT ITEMMAST.IMITEM AS Item, 
ITEMMAST.IMDESC AS ItemDescription, 
ITEMMAST.IMCOLR AS Color, 
itemxtra.imsearch as SearchWords,
division.DVDESC AS Division, 
itemmast.imfmcd as FamilyCode,
Family.fmdesc AS Family, 
VENDMAST.VMNAME AS Vendor, 
ITEMMAST.IMSI AS MasterStockItem, 
ITEMMAST.IMDROP AS DropFlag,
itemmast.imum1 as InventoryUOM,
itemmast.imum2 as SalesUOM,
itemmast.immd as IMMD,
itemmast.immd2 as IMMD2,
itemmast.imfact as IMFACT,
itemmast.imrpt2 as ReportCode2,
(select sum(olbluo) from oolbo where itemmast.imitem = olitem) as BackOrderQty,
(select sum(plqord) from poline join pohead on (phco = plco and phloc = plloc and phpo# = plpo# and phrel# = plrel# and phvend = plvend) where itemmast.imitem = plitem and pldelt <> ''''C'''' and PHRETURN <> ''''Y'''') as POQty,
(select sum(SLBLUS) from SHLINE where slitem = itemmast.imitem and sldate between current_date - 30 days and current_date) as SalesQty30Days,

/*                                                    */
/* SUB SELECT FOR ON HAND                             */
/*                                                    */

			(select 

			case 
				when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then (sum(IbQOH)*itemmast.IMFACT)
				when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then ((sum(IbQOH)*itemmast.IMFACT)/itemmast.IMFAC2)
				else 0
			end as SalesUOMOnHand

			from itemmast i
			join itembal on ITEMBal.IBITEM = i.IMITEM

			where i.imitem = itemmast.imitem
			and ibqoh+ibqal+ibqoo <> 0
			
			) as SalesUOMOnHandResult,

/*                                                    */
/* END SUB SELECT FOR ON HAND                         */
/*                                                    */

/*                                                    */
/* SUB SELECT FOR AVAILABLE                           */
/*                                                    */

			(select 

			case 
				when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then (sum(ibqoh-ibqal-ibqoo)*itemmast.IMFACT)
				when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then ((sum(ibqoh-ibqal-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2)
				else 0
			end as SalesUOMAvail

			from itemmast i
			join itembal on ITEMBal.IBITEM = i.IMITEM

			where i.imitem = itemmast.imitem
			and ibqoh+ibqal+ibqoo <> 0
			
			) as SalesUOMAvailResult

/*                                                    */
/* END SUB SELECT FOR ON HAND                         */
/*                                                    */


FROM ITEMMAST
join VENDMAST ON VENDMAST.VMVEND = ITEMMAST.IMVEND
LEFT JOIN ITEMxtra ON ITEMxtra.IMXITM = ITEMMAST.IMITEM
LEFT JOIN family ON Family.fmfmcd = ITEMMAST.IMFMCD
LEFT JOIN division ON division.DVDIV = ITEMMAST.IMDIV


where itemmast.imrpt2 = ''''213''''
and (ITEMMAST.IMDESC like ''''%' + @SearchTerm + '%'''' or itemxtra.imsearch like ''''%' + @SearchTerm + '%'''' or ITEMMAST.IMCOLR like ''''%' + @SearchTerm + '%'''')
and itemmast.imitem in (
''''GR0406B'''',
''''GR0440B'''',
''''GR0494B'''',
''''LO90022'''',
''''LO890153'''',
''''LO80072'''',
''''QC7640GPS142CYB'''',
''''QC7620ICL142CMS'''',
''''QC7620ICL142BAM'''',
''''QC7620ICL142RKO'''',
''''GR81001B'''',
''''GR82001B'''',
''''GR83002B'''',
''''GR83004B'''',
''''GR83005B'''',
''''QC76600CL142GMA'''',
''''QC76600CL142HOM'''',
''''QC76600CL142SIM'''',
''''QC7660PCC142CMS'''',
''''QC7660PCC142BAM'''',
''''GR100631B'''',
''''GR10SG0494B'''',
''''GR100163B'''',
''''GR100272B'''',
''''GR1080969B'''',
''''GR73552'''',
''''GR73553'''',
''''GR73554'''',
''''GR73557'''',
''''LOH18023'''',
''''LOH890096'''',
''''LOH9826'''',
''''BBAMWA956HDF'''',
''''BBCABI95BSHDF'''',
''''BBCAEL95BWHDF'''',
''''BBCAEL95COHDF'''',
''''BBCAEL95FQHDF'''',
''''BBCAEL95RSHDF'''',
''''BBCAHI85NAHDF'''',
''''BBCAHI95CAHDF'''',
''''BBCAMP95CSHDF'''',
''''BBCAMP95DWHDF'''',
''''BBCAMP95MFHDF'''',
''''BBCAMP95SMHDF'''',
''''BBCAOK95AFHDF2'''',
''''BBCAOK95BEHDF'''',
''''BBCAOK95BUHDF'''',
''''BBCAOK95NAHDF'''',
''''BBCOBI955ABHDF2'''')

order by itemmast.imitem

'')
'

--select @sql
exec (@sql)






GO


