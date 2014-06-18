/* set PM contacts back to tradional fax instead of metroFax 
	SR #22363

--=========================================================================================
--   DETAIL RECORDS
--=========================================================================================


--Dataset A
			update CONTCONT set CNCFAX to the left 11 of CNCE_MAIL
				where left 1 of CNCE_MAIL = 1
				and cnce_mailu like ''%METROFAX%''
				and left 7 of CNCE_MAIL in 1253476, 1253581, 1253583, 1253826, 1253922
											1425483, 1425576, 1425645, 1425885
				and CNCFAX = 0 
				
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, left(cnce_mail,11) as newFax
from CONTCONT
where left(cnce_mail,1) = ''1''
and cnce_mailu like ''%METROFAX%''
and left(CNCE_MAIL,7) in (''1253476'', ''1253581'', ''1253583'', ''1253826'', ''1253922'',
											''1425483'', ''1425576'', ''1425645'', ''1425885'')
and CNCFAX = 0 
')


/*
				
--Dataset B

			update CONTCONT set CNCFAX to the substr 2,10 of CNCE_MAIL
				where left 1 of CNCE_MAIL = 1
				and cnce_mailu like ''%METROFAX%''
				and left 4 of CNCE_MAIL in 1253, 1206, 1425
				and left 7 of CNCE_MAIL not in 1253476, 1253581, 1253583, 1253826, 1253922
											1425483, 1425576, 1425645, 1425885
				and CNCFAX = 0 
				
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, substr(cnce_mail,2,10) as newFax
from CONTCONT
where left(cnce_mail,1) = ''1''
and cnce_mailu like ''%METROFAX%''
and left(CNCE_MAIL,4) in (''1253'', ''1206'', ''1425'')
and left(CNCE_MAIL,7) not in (''1253476'', ''1253581'', ''1253583'', ''1253826'', ''1253922'',
											''1425483'', ''1425576'', ''1425645'', ''1425885'')
and CNCFAX = 0 
')


/*

--Dataset C

			update CONTCONT set CNCFAX to the left 11 of CNCE_MAIL
				where left 1 of CNCE_MAIL = 1
				and cnce_mailu like ''%METROFAX%''
				and CNCFAX = 0 
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, left(cnce_mail,11) as newFax
from CONTCONT
where left(cnce_mail,1) = ''1''
and cnce_mailu like ''%METROFAX%''
and CNCFAX = 0 
')


/*
--Dataset D
			update CONTCONT set CNCFAX to 1 + left 10 of CNCE_MAIL
				where left 1 of CNCE_MAIL <> 1
				and cnce_mailu like ''%METROFAX%''
				and left 6 of CNCE_MAIL in 253476, 253581, 253583, 253826, 253922
											425483, 425576, 425645, 425885
				and CNCFAX = 0 
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, concat(''1'',left(cnce_mail,10)) as newFax
from CONTCONT
where left(cnce_mail,1) <> ''1''
and cnce_mailu like ''%METROFAX%''
and left(CNCE_MAIL,6) in (''253476'', ''253581'', ''253583'', ''253826'', ''253922'',
											''425483'', ''425576'', ''425645'', ''425885'')
and CNCFAX = 0 
')


/*
--Dataset E
			update CONTCONT set CNCFAX to left 10 of CNCE_MAIL
				where left 1 of CNCE_MAIL <> 1
				and cnce_mailu like ''%METROFAX%''
				and left 3 of CNCE_MAIL in 253, 206, 425
				and left 6 of CNCE_MAIL not in 253476, 253581, 253583, 253826, 253922
											425483, 425576, 425645, 425885
				and CNCFAX = 0 
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, left(cnce_mail,10) as newFax
from CONTCONT
where left(cnce_mail,1) <> ''1''
and cnce_mailu like ''%METROFAX%''
and left(CNCE_MAIL,3) in (''253'', ''206'', ''425'')
and left(CNCE_MAIL,6) not in (''253476'', ''253581'', ''253583'', ''253826'', ''253922'',
											''425483'', ''425576'', ''425645'', ''425885'')
and CNCFAX = 0 
')


/*
--Dataset F
			update CONTCONT set CNCFAX to 1 + left 10 of CNCE_MAIL
				where left 1 of CNCE_MAIL <> 1
				and cnce_mailu like ''%METROFAX%''
				and CNCFAX = 0 
*/

select * from openquery(gsfl2k,'
select cncfax, cnce_mail, concat(''1'',left(cnce_mail,10)) as newFax
from CONTCONT
where left(cnce_mail,1) <> ''1''
and cnce_mailu like ''%METROFAX%''
and CNCFAX = 0 
')

/*
--=========================================================================================
--   DETAIL RECORDS
--=========================================================================================

--Dataset A

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to left 11 of CCDE_MAIL
		where left 1 of CCDE_MAIL = 1
		and ccde_mail like ''%METROFAX%''
		and left 7 of CCDE_MAIL in 1253476, 1253581, 1253583, 1253826, 1253922
									1425483, 1425576, 1425645, 1425885
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''

--Dataset B

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to substr 2,10 of CCDE_MAIL
		where left 1 of CCDE_MAIL = 1
		and ccde_mail like ''%METROFAX%''
		and left 4 of CCDE_MAIL in 1253, 1206, 1425
		and left 7 of CCDE_MAIL not in 1253476, 1253581, 1253583, 1253826, 1253922
									1425483, 1425576, 1425645, 1425885
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''

--Dataset C

	update CUSTCNDTL set CCDDELMETH  = 'FAX'
		set CCDFAX to left 11 of CCDE_MAIL
		where left 1 of CCDE_MAIL = 1
		and ccde_mail like ''%METROFAX%''
		and CCDFAX = 0 
		and left(ccdcus,1) = ''4''
		and CCDDELMETH = ''EML''

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

-- =====================================================================================
	
253 prefixes that require a 1
	476
	581
	583
	826
	922

425 prefixes that require a 1
	483
	576
	645
	885


*/

select * 
--into TAV_CONTCONT
from openquery(gsfl2k,
'select *

from contcont
where cnce_mailu like ''%METROFAX%''
and CNCFAX = 0 ')


/*

Update 2 - CUSTCNDTL  

*/

select * 
--into TAV_CUSTCNDTL
from openquery(gsfl2k,'
select custcndtl.*

from CUSTCNDTL 
join CUSTCNDTL a on (a.CCDCONTID = CUSTCNDTL.CCDCONTID 
						and a.CCDCUS = CUSTCNDTL.CCDCUS 
						
						and a.ccdcus = custcndtl.ccdcus
						and a.CCDDOC = custcndtl.ccddoc)

where custcndtl.ccde_mail like ''%METROFAX%''
and left(custcndtl.ccdcus,1) = ''4''  
and custcndtl.CCDDELMETH = ''EML'' 

order by ccdcontid
')


select * 
from openquery(gsfl2k,'
select custcndtl.*

from CUSTCNDTL 

where custcndtl.ccde_mail like ''%METROFAX%''
and left(custcndtl.ccdcus,1) = ''4''  
and custcndtl.CCDDELMETH = ''EML'' 
order by ccdcontid
')


