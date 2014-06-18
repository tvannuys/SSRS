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



/*
				
--Dataset B

*/

--select cncfax, cnce_mail, substring(cnce_mail,2,10) as newFax
update TAV_CONTCONT 
set TAV_CONTCONT.cncfax = substring(a.cnce_mail,2,10)

from TAV_CONTCONT a join TAV_CONTCONT on a.cnccontid = TAV_CONTCONT.cnccontid

where left(TAV_CONTCONT.cnce_mail,1) = '1'
and TAV_CONTCONT.cnce_mailu like '%METROFAX%'
and left(TAV_CONTCONT.CNCE_MAIL,4) in ('1253', '1206', '1425')
and left(TAV_CONTCONT.CNCE_MAIL,7) not in ('1253476', '1253581', '1253583', '1253826', '1253922',
											'1425483', '1425576', '1425645', '1425885')
and TAV_CONTCONT.CNCFAX = 0 

/*
				
--Dataset C

*/

--select cncfax, cnce_mail, left(cnce_mail,11) as newFax
update TAV_CONTCONT
set TAV_CONTCONT.cncfax = left(a.cnce_mail,11)
from TAV_CONTCONT a join TAV_CONTCONT on TAV_CONTCONT.CNCCONTID = a.CNCCONTID
--from TAV_CONTCONT
where left(TAV_CONTCONT.cnce_mail,1) = '1'
and TAV_CONTCONT.cnce_mailu like '%METROFAX%'
and TAV_CONTCONT.CNCFAX = 0
and substring(TAV_CONTCONT.CNCE_MAIL,11,1) <> '@'
and TAV_CONTCONT.cnce_mailu <> '150910121@METROFAX.COM'

/*

--Dataset D

*/


--select cncfax, cnce_mail, cast(('1' + left(cnce_mail,10)) as numeric) as NewFax
update TAV_CONTCONT
set TAV_CONTCONT.cncfax = cast(('1' + left(TAV_CONTCONT.CNCE_MAIL,10)) as numeric)
from TAV_CONTCONT a join TAV_CONTCONT on TAV_CONTCONT.CNCCONTID = a.CNCCONTID
--from TAV_CONTCONT
where left(TAV_CONTCONT.cnce_mail,1) <> '1'
and TAV_CONTCONT.cnce_mailu like '%METROFAX%'
and left(TAV_CONTCONT.CNCE_MAIL,6) in ('253476', '253581', '253583', '253826', '253922',
											'425483', '425576', '425645', '425885')
and TAV_CONTCONT.CNCFAX = 0 


/*

--Dataset E

*/


update TAV_CONTCONT
set TAV_CONTCONT.cncfax = left(TAV_CONTCONT.CNCE_MAIL,10)
from TAV_CONTCONT a join TAV_CONTCONT on TAV_CONTCONT.CNCCONTID = a.CNCCONTID
--from TAV_CONTCONT

where left(TAV_CONTCONT.cnce_mail,1) <> '1'
and TAV_CONTCONT.cnce_mailu like '%METROFAX%'
and left(TAV_CONTCONT.CNCE_MAIL,3) in ('253', '206', '425')
and left(TAV_CONTCONT.CNCE_MAIL,6) not in ('253476', '253581', '253583', '253826', '253922',
											'425483', '425576', '425645', '425885')
and TAV_CONTCONT.CNCFAX = 0 

/*
	--Dataset F
*/


--select cncfax, cnce_mail, ('1' + left(cnce_mail,10)) as newFax
update TAV_CONTCONT
set TAV_CONTCONT.cncfax = cast(('1' + left(TAV_CONTCONT.CNCE_MAIL,10)) as numeric)
from TAV_CONTCONT a join TAV_CONTCONT on TAV_CONTCONT.CNCCONTID = a.CNCCONTID
--from TAV_CONTCONT
where left(TAV_CONTCONT.cnce_mail,1) <> '1'
and TAV_CONTCONT.cnce_mailu like '%METROFAX%'
and TAV_CONTCONT.CNCFAX = 0 
and TAV_CONTCONT.CNCE_MAILU not in ('265453504@METROFAX.COM', '209875099@METROFAX.COM')
