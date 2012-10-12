

/********************************************
*											*
* Programmer: James Tuttle					*
* Date: 08/09/2012							*
*											*
* Purpose: Create a report in SQL that		*
* mirrors the manual report that marketing  *
* built in Excel							*
*											*
* Others Invovled: Thomas V and Holiday		*
*-------------------------------------------*
* PGR: James Tuttle		DATE:08/09/2012		*
* Added Search by George per Holiday to		*
*  seperate the co1 & 2 searches on the		*
*  As400: HPRO -co1 and KPRO for co2		*
*********************************************/

------------  Mary H other SAMPLE REPORT ----------------------------------------------------------------

/*
James Tuttle
08/13/2012
SR-3860
===========================================================================================================

Mary Harchuck needs a report of all stocking samples, displays as well as her separate list, 
with qty available.  IMFCRG="S" AND IMSI="Y" AND IMCOLIMIT=2 or  IMSEARCH="PMPRO" AND IMCOLIMIT=2
-George 
===========================================================================================================
*/
/*
--- Removed columns per Mary H
imcolimit as Company
		  ,imsamp as Parent_Sku
===========================================================================================================
*/
/*
James Tuttle
10/09/2012
SR# - 4702
--
ADD Fields: Vendor Number and Buyer Number

===========================================================================================================
*/

ALTER PROC [dbo].[JT_stocking_products_samples_PM] AS
BEGIN
	SELECT *
	FROM OPENQUERY(GSFL2K,
		  'SELECT imitem as Sample_Sku
		  ,imdesc as Product_Description
		  ,CASE
			WHEN imdrop = ''D'' THEN ''Drop''
			ELSE '' ''
		   END as Drops
		   ,imvend AS Vendor#
		   ,imbuyr AS Buyer#
	/*------- Contiguous US locations ----------------------------------------------------------------------------------*/				
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc NOT IN(84,81) AND itembal.ibitem = im.imitem) AS Stock_QOH
		  ,(SELECT (COALESCE(SUM(itembal.ibqoh),0) - COALESCE(SUM(itembal.ibqoo),0)) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc NOT IN(84,81) AND itembal.ibitem = im.imitem AND itembal.ibqoh > 0) AS Stock_AVBL
		  ,(SELECT COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc NOT IN(84,81) AND ooline.olitem = im.imitem) AS BO	
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc NOT IN(84,81) AND poline.plitem = im.imitem) AS PO	
	/*------- Anchorage locations --------------------------------------------------------------------------------------*/				
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 81 AND itembal.ibitem = im.imitem) AS AK_Stock_QOH
		  ,(SELECT (COALESCE(SUM(itembal.ibqoh),0) - COALESCE(SUM(itembal.ibqoo),0)) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 81 AND itembal.ibitem = im.imitem) AS AK_Stock_AVBL
		  , (SELECT	COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc = 81 AND ooline.olitem = im.imitem) AS AK_BO	
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc = 81 AND poline.plitem = im.imitem) AS AK_PO		
	/*------- Hawaii location -----------------------------------------------------------------------------------------*/
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2
				AND itembal.ibloc = 84 AND itembal.ibitem = im.imitem) AS HI_Stock_QOH
		  ,(SELECT (COALESCE(SUM(itembal.ibqoh),0) - COALESCE(SUM(itembal.ibqoo),0)) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 84 AND itembal.ibitem = im.imitem) AS HI_Stock_AVBL
		  , (SELECT	COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc = 84 AND ooline.olitem = im.imitem) AS Hi_BO
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc = 84 AND poline.plitem = im.imitem) AS HI_PO	
	/*------- End of locations -----------------------------------------------------------------------------------------*/						
		  ,''        '' as Comments
		  FROM itemxtra ix
		   JOIN itemmast im
				ON im.imitem = ix.imxitm
		  WHERE (ix.imsearch LIKE ''%PMPRO%''
					AND ix.imcolimit IN (0,2))
			OR (ix.imcolimit IN (0,2)
			AND im.imfcrg = ''S''
			AND im.imsi=''Y'')
		  ORDER BY ix.imcolimit
				,im.imitem
		  ')
END


GO


