
-- Variables for the three month by Field Names for the Gartman File
DECLARE @Month1 varchar(5), @Month2 varchar(5), @Month3 varchar(5)

-- SELECT CASE depending on the MONTH() 
SELECT 
	CASE MONTH(GETDATE()) WHEN 1 THEN				-- Current month is January (1)
		SET @Month1 = 'ibs12'
		SET @Month2 = 'ibs11'
		SET @Month3 = 'ibs10'
	CASE MONTH(GETDATE()) WHEN 2 THEN				-- Current month is Februay (2)
		SET @Month1 = 'ibs1'
		SET @Month2 = 'ibs12'
		SET @Month3 = 'ibs11'		
	CASE MONTH(GETDATE()) WHEN 3 THEN				-- Current month is March (3)
		SET @Month1 = 'ibs2'
		SET @Month2 = 'ibs1'
		SET @Month3 = 'ibs12'
	ELSE											-- Any other month (4-12)
		SET @Month1 = 'ibs' + MONTH(GETDATE()-3)
		SET @Month2 = 'ibs' + MONTH(GETDATE()-2)
		SET @Month3 = 'ibs' + MONTH(GETDATE()-1)
	END
	
--> QUERY		
SELECT *
FROM OPENQUERY( GSFL2K,' SELECT im.imbuyr as buyer_ID,
							ib.ibvend as vendor_ID,
							vm.vmname as vendor_name,
							ib.ibitem as item_number,
							im.imdesc as item_description,
							ib.ibloc as loc
						FROM itembal as ib RIGHT JOIN itemmast as im
							ON ib.ibitem = im.imitem
						RIGHT JOIN itemxtra as ix 
							ON ix.imxitm = ib.ibitem
						RIGHT JOIN vendmast as vm
							ON ib.ibvend = vm.vmvend
						WHERE ix.imfitm = ''B''
							AND ib.ibloc = 50
							AND ib.ibvend != 2510
						GROUP BY ib.ibloc, ib.ibitem, im.imbuyr,vm.vmname,ib.ibvend,im.imdesc
						ORDER BY im.imbuyr, vm.vmname, ib.ibitem, ib.ibloc
									
				')
	
/*	----------------------------------------------------------------------------------------------------------------
	
	Use datata!itembalCIR In 0 Shared
	Select itembalCIR
	Go Bottom
	Use datata!vendmastCIR In 0 Shared
	Use datata!itemmastCIR In 0 Shared
	Use datata!itemxtraCIR In 0 Shared


****Create months to import based on today's date
	Store Month(Date()) To m.curmonth
	If m.curmonth=1
		Store "ibs12" To m.month1
		Store "ibs11" To m.month2
		Store "ibs10" To m.month3
	Else
		If m.curmonth=2
			Store "ibs1" To m.month1
			Store "ibs12" To m.month2
			Store "ibs11" To m.month3
		ELSE
			If m.curmonth=3
				Store "ibs2" To m.month1
				Store "ibs1" To m.month2
				Store "ibs12" To m.month3
			ELSE
				Store "ibs"+Alltrim(Str(Month(Date())-3)) To m.month1
				Store "ibs"+Alltrim(Str(Month(Date())-2)) To m.month2
				Store "ibs"+Alltrim(Str(Month(Date())-1)) To m.month3
			Endif
		Endif
	Endif




	Select imbuyr As buyerID, ibvend As vendorID, vmname As vendorname, ibitem As itemnumber,;
			imdesc As itemdescription, ibloc As location, ;
			ibqoh-ibqoo+ibqbo+ibqoov As available,;
			ROUND((&month1+&month2+&month3)/3,2) As avgmonthlyamt, ;
			(ibqoh-ibqoo+ibqbo+ibqoov) - Round((&month1+&month2+&month3)/3,2) As Short;
			,Round((ibqoh-ibqoo+ibqbo+ibqoov) / ((&month1+&month2+&month3)/3),2) As monthsonhand ;
		FROM itemmastCIR Right Join(itemxtraCIR Right Join (vendmastCIR Right Join itembalCIR On vmvend=ibvend) On imxitm=ibitem) On imitem=ibitem;
		WHERE imfitm="B" AND ibloc=50 AND ibvend <> 2510;
		GROUP By ibloc, ibitem;
		HAVING (ibqoh-ibqoo-ibqbo+ibqoov)- (Round((&month1+&month2+&month3)/3,2))<0;
		ORDER By imbuyr, vmname, ibitem, ibloc;
		INTO Cursor criticalitems
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/