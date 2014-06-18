--update TAV_CONTCONT set CNCFAX = 0

/*
				
--Dataset B simple version

*/

--select cncfax, cnce_mail, substring(cnce_mail,2,10) as newFax
update TAV_CONTCONT 
set cncfax = substring(cnce_mail,2,10)

where left(cnce_mail,1) = '1'
and cnce_mailu like '%METROFAX%'
and left(CNCE_MAIL,4) in ('1253', '1206', '1425')
and left(CNCE_MAIL,7) not in ('1253476', '1253581', '1253583', '1253826', '1253922',
											'1425483', '1425576', '1425645', '1425885')
and CNCFAX = 0 


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
and left(CNCE_MAIL,6) in ('253476', '253581', '253583', '253826', '253922',
											'425483', '425576', '425645', '425885')
and CNCFAX = 0 


/*

--Dataset E

*/


update TAV_CONTCONT
set cncfax = left(CNCE_MAIL,10)

--from TAV_CONTCONT

where left(cnce_mail,1) <> '1'
and cnce_mailu like '%METROFAX%'
and left(CNCE_MAIL,3) in ('253', '206', '425')
and left(CNCE_MAIL,6) not in ('253476', '253581', '253583', '253826', '253922',
											'425483', '425576', '425645', '425885')
and CNCFAX = 0 

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