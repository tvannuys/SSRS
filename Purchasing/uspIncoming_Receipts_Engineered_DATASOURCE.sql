USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[uspIncoming_Receipts_Engineered]    Script Date: 5/24/2013 8:34:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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



ALTER PROC [dbo].[uspIncoming_Receipts_Engineered_DATASOURCE] AS 
BEGIN 
	select pldelt
		,Buyer
		,OQ.VendorName
		,ProductCode
		,SKU
		,[Description]
		,Color
		,Company
		,Location
		,PO
		,POqty
		,QOH
		,VendorRefNum
		,IssueDate
	,case ProductionDate
		when '0001-01-01' then ''
		else ProductionDate
	end as ProductionDate

	,case ShipDate
		when '0001-01-01' then ''
		else ShipDate
	end as ShipDate

	,Confirmed

	,case DueDate
		when '0001-01-01' then ''
		else DueDate
	end as DueDate

	,Manloc

	,case when Manifest IS null
		then ' '
		else Manifest
	end as Manifest
	
	,Division
	,FamilyCode 
	 
	from openquery(GSFL2K,'

	Select MONTH(Poline.PLDDAT) || ''/'' || DAY(Poline.PLDDAT) || ''/'' || YEAR(Poline.PLDDAT) As DueDate
				,MONTH(PHDOI) || ''/'' || DAY(PHDOI) || ''/'' || YEAR(PHDOI) as IssueDate
				,MONTH(PLSHIPDATE) || ''/'' || DAY(PLSHIPDATE) || ''/'' || YEAR(PLSHIPDATE) as ShipDate
				,MONTH(PLRELDATE) || ''/'' || DAY(PLRELDATE) || ''/'' || YEAR(PLRELDATE) as ReleaseDate
				,MONTH(PLPDAT) || ''/'' || DAY(PLPDAT) || ''/'' || YEAR(PLPDAT) as ProductionDate
				,PLBUYR as Buyer
				,PLDDATCONF as Confirmed
				,PHREF# as VendorRefNum
				,Poline.PLCO as Company
				,Poline.PLLOC As Location 
				,Family.FMFMCD as FamilyCode
				,Family.FMDESC as Family
				,Itemmast.imprcd as ProductCode
				,ProdCode.pcdesc as ProductCodeDesc
				,Vendmast.VMNAME As VendorName 
				,Poline.PLPO# As PO
				,Poline.plqord AS POqty
				,Poline.PLITEM As SKU 
				,Poline.PLDESC As Description
				,Itemmast.IMCOLR As Color

	,(select max(mnman#) from manifest where mnpo# = poline.plpo#
							and mnpolo = poline.plloc
							and mnitem = poline.plitem
							and mnpoco = poline.plco) as Manifest

	,(select max(mnloc) from manifest where mnpo# = poline.plpo#
							and mnpolo = poline.plloc
							and mnitem = poline.plitem
							and mnpoco = poline.plco) as ManLoc

	 ,(select ibqoh from itembal where ibloc in (4,12,50,52,60,80)
							and ibitem = manifest.mnitem
							and ibco = manifest.mnco
							and ibloc = manifest.mnloc) as QOH 
	
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
	Left Join Manifest On Poline.PLITEM = Manifest.MNITEM
	Left Join Itembal On Itembal.ibitem = manifest.mnitem				

	Where Pohead.PHDOI > ''12/31/2005''
	  and IMSI = ''Y''
	/*  AND IMCLAS = ''IM'' */
	  AND Poline.pldelt = ''A''
	  AND Poline.plvend = 24020
 
 AND POLINE.PLITEM = ''EN3221825''

	Order By Poline.PLDDAT
			,Vendmast.VMNAME
			,Poline.PLPO#
			,Poline.PLITEM 
	') OQ

	Group by Buyer
			,OQ.VendorName
			,ProductCode
			,SKU
			,[Description]
			,Color
			,Company
			,Location
			,PO
			,POqty
			,VendorRefNum
			,IssueDate
			,ProductionDate
			,ShipDate
			,Confirmed
			,DueDate
			,manifest
			,Division
			,FamilyCode
			,pldelt
			,Manloc
			,QOH

	Order by Buyer
			,Company
			,VendorName
			,ProductCode
			,SKU
			,IssueDate
END

GO


