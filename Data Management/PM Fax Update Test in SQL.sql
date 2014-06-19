--update TAV_CONTCONT set CNCFAX = 0

/*
				
--Dataset B simple version

*/

--select cncfax, cnce_mail, substring(cnce_mail,2,10) as newFax
update TAV_CONTCONT 
set cncfax = substring(cnce_mail,2,10)

where left(cnce_mail,1) = '1'
and cnce_mailu like '%METROFAX%'
and CNCFAX = 0 
and left(CNCE_MAIL,4) in ('1253', '1206', '1425')
and left(CNCE_MAIL,7) not in ('1253203',
'1253234',
'1253235',
'1253238',
'1253242',
'1253249',
'1253269',
'1253271',
'1253272',
'1253284',
'1253299',
'1253301',
'1253303',
'1253305',
'1253334',
'1253373',
'1253375',
'1253383',
'1253395',
'1253398',
'1253404',
'1253435',
'1253444',
'1253445',
'1253446',
'1253449',
'1253460',
'1253471',
'1253472',
'1253473',
'1253474',
'1253475',
'1253476',
'1253520',
'1253531',
'1253535',
'1253536',
'1253537',
'1253538',
'1253539',
'1253548',
'1253564',
'1253565',
'1253566',
'1253572',
'1253573',
'1253581',
'1253582',
'1253583',
'1253584',
'1253588',
'1253591',
'1253593',
'1253594',
'1253595',
'1253597',
'1253604',
'1253627',
'1253630',
'1253648',
'1253661',
'1253671',
'1253686',
'1253693',
'1253720',
'1253722',
'1253735',
'1253736',
'1253756',
'1253759',
'1253761',
'1253770',
'1253804',
'1253815',
'1253826',
'1253838',
'1253839',
'1253840',
'1253841',
'1253843',
'1253845',
'1253846',
'1253847',
'1253848',
'1253851',
'1253853',
'1253856',
'1253857',
'1253858',
'1253862',
'1253863',
'1253872',
'1253874',
'1253875',
'1253879',
'1253880',
'1253884',
'1253891',
'1253912',
'1253922',
'1253925',
'1253926',
'1253927',
'1253929',
'1253939',
'1253943',
'1253952',
'1253959',
'1253983',
'1253984',
'1253987',
'1425205',
'1425207',
'1425212',
'1425222',
'1425224',
'1425225',
'1425226',
'1425227',
'1425228',
'1425235',
'1425242',
'1425251',
'1425252',
'1425255',
'1425257',
'1425258',
'1425259',
'1425267',
'1425271',
'1425274',
'1425275',
'1425276',
'1425283',
'1425286',
'1425289',
'1425290',
'1425291',
'1425297',
'1425303',
'1425313',
'1425315',
'1425322',
'1425328',
'1425329',
'1425333',
'1425334',
'1425335',
'1425337',
'1425338',
'1425339',
'1425348',
'1425353',
'1425355',
'1425361',
'1425368',
'1425376',
'1425377',
'1425379',
'1425385',
'1425391',
'1425392',
'1425397',
'1425398',
'1425401',
'1425402',
'1425412',
'1425413',
'1425423',
'1425424',
'1425427',
'1425430',
'1425432',
'1425433',
'1425438',
'1425450',
'1425451',
'1425453',
'1425454',
'1425455',
'1425458',
'1425462',
'1425467',
'1425481',
'1425482',
'1425483',
'1425484',
'1425485',
'1425486',
'1425487',
'1425488',
'1425489',
'1425491',
'1425493',
'1425497',
'1425498',
'1425512',
'1425513',
'1425514',
'1425520',
'1425533',
'1425545',
'1425556',
'1425558',
'1425576',
'1425582',
'1425586',
'1425603',
'1425609',
'1425637',
'1425640',
'1425641',
'1425643',
'1425644',
'1425645',
'1425646',
'1425649',
'1425656',
'1425657',
'1425660',
'1425669',
'1425670',
'1425671',
'1425672',
'1425673',
'1425687',
'1425706',
'1425710',
'1425732',
'1425741',
'1425742',
'1425743',
'1425744',
'1425745',
'1425746',
'1425747',
'1425749',
'1425755',
'1425771',
'1425774',
'1425775',
'1425776',
'1425778',
'1425787',
'1425788',
'1425789',
'1425791',
'1425793',
'1425803',
'1425806',
'1425813',
'1425814',
'1425818',
'1425820',
'1425821',
'1425822',
'1425823',
'1425825',
'1425827',
'1425828',
'1425830',
'1425831',
'1425836',
'1425837',
'1425844',
'1425845',
'1425861',
'1425865',
'1425867',
'1425868',
'1425869',
'1425877',
'1425881',
'1425882',
'1425883',
'1425885',
'1425887',
'1425888',
'1425889',
'1425893',
'1425895',
'1425898',
'1425899',
'1425906',
'1425908',
'1425918',
'1425952',
'1425953',
'1425957',
'1425968',
'1425984',
'1425988',
'1425990')


/*
				
--Dataset C

*/

--select cncfax, cnce_mail, left(cnce_mail,11) as newFax
update TAV_CONTCONT
set cncfax = left(cnce_mail,11)

--from TAV_CONTCONT
where left(cnce_mail,1) = '1'
and cnce_mailu like '%METROFAX%'
and CNCFAX = 0
and substring(CNCE_MAIL,11,1) <> '@'
and cnce_mailu <> '150910121@METROFAX.COM'

/*

--Dataset D

*/


--select cncfax, cnce_mail, cast(('1' + left(cnce_mail,10)) as numeric) as NewFax
update TAV_CONTCONT
set cncfax = cast(('1' + left(CNCE_MAIL,10)) as numeric)
--set cncfax = cast(concat('1',left(CNCE_MAIL,10)) as bigint)

--from TAV_CONTCONT
where left(cnce_mail,1) <> '1'
and cnce_mailu like '%METROFAX%'
and CNCFAX = 0 
and left(CNCE_MAIL,6) in ('253203',
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



/*

--Dataset E

*/


update TAV_CONTCONT
set cncfax = left(CNCE_MAIL,10)

--from TAV_CONTCONT

where left(cnce_mail,1) <> '1'
and cnce_mailu like '%METROFAX%'
and CNCFAX = 0 
and left(CNCE_MAIL,3) in ('253', '206', '425')
and left(CNCE_MAIL,6) not in ('253203',
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


/*
	--Dataset F
*/


--select cncfax, cnce_mail, ('1' + left(cnce_mail,10)) as newFax
update TAV_CONTCONT
set cncfax = cast(('1' + left(CNCE_MAIL,10)) as numeric)
--set cncfax = cast(concat('1',left(CNCE_MAIL,10)) as bigint)

--from TAV_CONTCONT
where left(cnce_mail,1) <> '1'
and cnce_mailu like '%METROFAX%'
and CNCFAX = 0 
and CNCE_MAILU not in ('265453504@METROFAX.COM', '209875099@METROFAX.COM')


/* Needs manual fixing after - iSeries SQL */

select ccnxacct, cnccontid, cncfname
from contcont

join contxref on ccnxcontid = cnccontid
where cnce_mailu like '%METROFAX%'
and cncfax = 0
order by ccnxacct,cncfname