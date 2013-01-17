USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[LoadFinancialData2]    Script Date: 01/17/2013 14:41:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE proc [dbo].[LoadFinancialData2] as

drop table FinancialRptData2

/* SINGLE GL to REPORT Level =============    */

select A.GBYR, A.gbco,A.GBGL#,A.GBLOC,B.Level1,B.Level2,B.Level3,
A.GBA01,A.GBA02,a.GBA03,a.GBA04,a.GBA05,A.GBA06,A.GBA07,a.GBA08,a.GBA09,a.GBA10,a.GBA11,a.GBA12

into FinancialRptData2

from GLBalance A
join COAStructure2 B on (A.GBCO = B.GBCO
	and A.GBGL# = B.Beginning_GBGL#)
where B.Beginning_GBGL# <= B.Ending_GBGL#
	
order by 1,2,3

/* Ranges ================================    */

insert FinancialRptData2

select A.gbyr,A.gbco,A.GBGL#,A.GBLOC,B.Level1,B.Level2,B.Level3,
A.GBA01,A.GBA02,a.GBA03,a.GBA04,a.GBA05,A.GBA06,A.GBA07,a.GBA08,a.GBA09,a.GBA10,a.GBA11,a.GBA12

from GLBalance A
join COAStructure2 B on (A.GBCO = B.GBCO
	and A.GBGL# >= B.Beginning_GBGL#
	and A.GBGL# <= B.Ending_GBGL#)

where GBGL# not in (select GBGL# from FinancialRptData2)
	
order by 1,2,3

/* Update Signs ================================    

update FinancialRptData2
set GBA05 = GBA05 * -1,
	GBA04 = GBA04 * -1,
    GBA03 = GBA03 * -1,
    GBA02 = GBA02 * -1,
    GBA01 = GBA01 * -1
where Level1 in ('Product Sales', 'Service Revenue')

 Exceptions ================================    */

Update FinancialRptData2
set Level1 = 'H&W Logistics'
where GBGL# in (850000,850100,
				850200,850500,851000,851500,
				852500,853000,854000,857000,
				860000,861000,862000,891000)
and GBLOC in (20,38)

Update FinancialRptData2
set Level1 = 'GENERAL & ADMINSTRATIVE'
where GBGL# in (850000,850100,
				850200,850500,851000,851500,
				852500,853000,854000,857000,
				860000,861000,862000,891000)
and GBLOC in (47,87,88,89,90,91,93,94)

Update FinancialRptData2
set Level1 = 'SALES & MARKETING'
where GBGL# in (850000,850100,
				850200,850500,851000,851500,
				852500,853000,854000,857000,
				860000,861000,862000,891000)
and GBLOC in (49,86,92,95,96)

Update FinancialRptData2
set Level1 = 'WAREHOUSE'
where GBGL# in (850000,850100,
				850200,850500,851000,851500,
				852500,853000,854000,857000,
				860000,861000,862000,891000)
and GBLOC in (1,2,3,4,5,6,12,13,14,15,16,17,40,50,52,
60,61,62,80,85,97,22,24,35,39,41,42,44,46,48,81,84)


update financialrptdata2
set level2 = 'Other G&A'
where level1 = 'GENERAL & ADMINSTRATIVE'
and level2 like '%Warehouse'

update financialrptdata2
set level2 = 'Other Sales & Marketing'
where level1 = 'SALES & MARKETING'
and level2 like '%Warehouse'








GO


