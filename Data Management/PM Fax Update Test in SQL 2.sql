--=========================================================================================
--   DETAIL RECORDS
--=========================================================================================
/*
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

*/

/*  Load SQL Tables

drop table TAV_CUSTCNDTL

select *
into TAV_CUSTCNDTL
from openquery(gsfl2k,'
select * 
from CUSTCNDTL
')

*/

--Dataset test

-- Local prefixes that need a 1

	update TAV_CUSTCNDTL set CCDDELMETH  = 'FAX',
		CCDFAX = cast('1' + left(CCDE_MAIL,10) as numeric)
--set CCDFAX = cast(concat('1',left(CCDE_MAIL,10)) as bigint)

		
		where ccde_mail like '%METROFAX%'
		and CCDFAX = 0 
		and left(ccdcus,1) = '4'
		and CCDDELMETH = 'EML'
		--and CCDCONTID in (42262,42266,42267,42272)
		and left(CCDE_MAIL,6) in (
'253203',
'253234',
'253235',
'253238',
'253242',
'253249',
'253269',
'253271',
'253272',
'253284',
'253299',
'253301',
'253303',
'253305',
'253334',
'253373',
'253375',
'253383',
'253395',
'253398',
'253404',
'253435',
'253444',
'253445',
'253446',
'253449',
'253460',
'253471',
'253472',
'253473',
'253474',
'253475',
'253476',
'253520',
'253531',
'253535',
'253536',
'253537',
'253538',
'253539',
'253548',
'253564',
'253565',
'253566',
'253572',
'253573',
'253581',
'253582',
'253583',
'253584',
'253588',
'253591',
'253593',
'253594',
'253595',
'253597',
'253604',
'253627',
'253630',
'253648',
'253661',
'253671',
'253686',
'253693',
'253720',
'253722',
'253735',
'253736',
'253756',
'253759',
'253761',
'253770',
'253804',
'253815',
'253826',
'253838',
'253839',
'253840',
'253841',
'253843',
'253845',
'253846',
'253847',
'253848',
'253851',
'253853',
'253856',
'253857',
'253858',
'253862',
'253863',
'253872',
'253874',
'253875',
'253879',
'253880',
'253884',
'253891',
'253912',
'253922',
'253925',
'253926',
'253927',
'253929',
'253939',
'253943',
'253952',
'253959',
'253983',
'253984',
'253987',
'425205',
'425207',
'425212',
'425222',
'425224',
'425225',
'425226',
'425227',
'425228',
'425235',
'425242',
'425251',
'425252',
'425255',
'425257',
'425258',
'425259',
'425267',
'425271',
'425274',
'425275',
'425276',
'425283',
'425286',
'425289',
'425290',
'425291',
'425297',
'425303',
'425313',
'425315',
'425322',
'425328',
'425329',
'425333',
'425334',
'425335',
'425337',
'425338',
'425339',
'425348',
'425353',
'425355',
'425361',
'425368',
'425376',
'425377',
'425379',
'425385',
'425391',
'425392',
'425397',
'425398',
'425401',
'425402',
'425412',
'425413',
'425423',
'425424',
'425427',
'425430',
'425432',
'425433',
'425438',
'425450',
'425451',
'425453',
'425454',
'425455',
'425458',
'425462',
'425467',
'425481',
'425482',
'425483',
'425484',
'425485',
'425486',
'425487',
'425488',
'425489',
'425491',
'425493',
'425497',
'425498',
'425512',
'425513',
'425514',
'425520',
'425533',
'425545',
'425556',
'425558',
'425576',
'425582',
'425586',
'425603',
'425609',
'425637',
'425640',
'425641',
'425643',
'425644',
'425645',
'425646',
'425649',
'425656',
'425657',
'425660',
'425669',
'425670',
'425671',
'425672',
'425673',
'425687',
'425706',
'425710',
'425732',
'425741',
'425742',
'425743',
'425744',
'425745',
'425746',
'425747',
'425749',
'425755',
'425771',
'425774',
'425775',
'425776',
'425778',
'425787',
'425788',
'425789',
'425791',
'425793',
'425803',
'425806',
'425813',
'425814',
'425818',
'425820',
'425821',
'425822',
'425823',
'425825',
'425827',
'425828',
'425830',
'425831',
'425836',
'425837',
'425844',
'425845',
'425861',
'425865',
'425867',
'425868',
'425869',
'425877',
'425881',
'425882',
'425883',
'425885',
'425887',
'425888',
'425889',
'425893',
'425895',
'425898',
'425899',
'425906',
'425908',
'425918',
'425952',
'425953',
'425957',
'425968',
'425984',
'425988',
'425990')

-- Local prefixes that don't need a 1

update TAV_CUSTCNDTL set CCDDELMETH  = 'FAX',
		CCDFAX = left(CCDE_MAIL,10) 
		
		where ccde_mail like '%METROFAX%'
		and CCDFAX = 0 
		and left(ccdcus,1) = '4'
		and CCDDELMETH = 'EML'
		and LEFT(CCDE_MAIL,3) in ('253','206','425')


-- All Others

update TAV_CUSTCNDTL set CCDDELMETH  = 'FAX',
		CCDFAX = cast('1' + left(CCDE_MAIL,10) as numeric)
--set CCDFAX = cast(concat('1',left(CCDE_MAIL,10)) as bigint)
		
		
		where ccde_mail like '%METROFAX%'
		and CCDFAX = 0 
		and left(ccdcus,1) = '4'
		and CCDDELMETH = 'EML'