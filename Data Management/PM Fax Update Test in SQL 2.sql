--=========================================================================================
--   DETAIL RECORDS
--=========================================================================================

--Dataset A

	update TAV_CUSTCNDTL set TAV_CUSTCNDTL.CCDDELMETH  = 'FAX',
			TAV_CUSTCNDTL.CCDFAX = left(a.CCDE_MAIL,11)
		
		from TAV_CUSTCNDTL a join TAV_CUSTCNDTL on (a.CCDCONTID = TAV_CUSTCNDTL.CCDCONTID 
													and a.CCDCUS = TAV_CUSTCNDTL.CCDCUS 
													and a.CCDDOC = TAV_CUSTCNDTL.CCDDOC)
		
		where left(TAV_CUSTCNDTL.CCDE_MAIL,1) = '1'
		and TAV_CUSTCNDTL.ccde_mail like '%METROFAX%'
		and left(TAV_CUSTCNDTL.CCDE_MAIL,7) in ('1253476', '1253581', '1253583', '1253826', '1253922',
									'1425483', '1425576', '1425645', '1425885')
		and TAV_CUSTCNDTL.CCDFAX = 0 
		and left(TAV_CUSTCNDTL.ccdcus,1) = '4'
		and TAV_CUSTCNDTL.CCDDELMETH = 'EML'

--Dataset B

	update TAV_CUSTCNDTL set tav_custcndtl.CCDDELMETH  = 'FAX',
		tav_custcndtl.CCDFAX = SUBSTRING(a.ccde_mail,2,10) 
		
	from TAV_CUSTCNDTL a join TAV_CUSTCNDTL on (a.CCDCONTID = TAV_CUSTCNDTL.CCDCONTID 
													and a.CCDCUS = TAV_CUSTCNDTL.CCDCUS 
													and a.CCDDOC = TAV_CUSTCNDTL.CCDDOC)
		where left(TAV_CUSTCNDTL.CCDE_MAIL,1) = '1'
		and TAV_CUSTCNDTL.ccde_mail like '%METROFAX%'
		and left(TAV_CUSTCNDTL.CCDE_MAIL,4) in ('1253', '1206', '1425')
		and left(TAV_CUSTCNDTL.CCDE_MAIL,7) not in ('1253476', '1253581', '1253583', '1253826', '1253922',
									'1425483', '1425576', '1425645', '1425885')
		and TAV_CUSTCNDTL.CCDFAX = 0 
		and left(TAV_CUSTCNDTL.ccdcus,1) = '4'
		and TAV_CUSTCNDTL.CCDDELMETH = 'EML'

--Dataset C

	update CUSTCNDTL set CCDDELMETH  = 'FAX',
	CCDFAX = left(a.CCDE_MAIL,11)
	
	from TAV_CUSTCNDTL a join TAV_CUSTCNDTL on (a.CCDCONTID = TAV_CUSTCNDTL.CCDCONTID 
													and a.CCDCUS = TAV_CUSTCNDTL.CCDCUS 
													and a.CCDDOC = TAV_CUSTCNDTL.CCDDOC)

		
		where left(tav_custcndtl.CCDE_MAIL,1) = '1'
		and tav_custcndtl.ccde_mail like '%METROFAX%'
		and tav_custcndtl.CCDFAX = 0 
		and left(tav_custcndtl.ccdcus,1) = '4'
		and tav_custcndtl.CCDDELMETH = 'EML'

--Dataset D

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to 1 + left 10 of CCDE_MAIL
		where left 1 of CCDE_MAIL <> 1
		and ccde_mail like ''%METROFAX%''
		and left 6 of CCDE_MAIL in 253476, 253581, 253583, 253826, 253922
									425483, 425576, 425645, 425885
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''

--Dataset E

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to left 10 of CCDE_MAIL
		where left 1 of CCDE_MAIL <> 1
		and ccde_mail like ''%METROFAX%''
		and left 3 of CCDE_MAIL in 253, 206, 425
		and left 6 of CCDE_MAIL not in 253476, 253581, 253583, 253826, 253922
									425483, 425576, 425645, 425885
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''

--Dataset F

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to 1 + left 10 of CCDE_MAIL
		where left 1 of CCDE_MAIL <> 1
		and ccde_mail like ''%METROFAX%''
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''


--Dataset test

	update TAV_CUSTCNDTL set CCDDELMETH  = 'FAX',
		CCDFAX = cast('1' + left(CCDE_MAIL,10) as numeric)
		
		where ccde_mail like '%METROFAX%'
		and CCDFAX = 0 
		and left(ccdcus,1) = '4'
		and CCDDELMETH = 'EML'
		
select * 
from TAV_CUSTCNDTL
		where ccde_mail like '%METROFAX%'
		and left(ccdcus,1) = '4'
		
