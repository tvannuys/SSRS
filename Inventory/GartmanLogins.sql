/*****************************************************************************************************
**																									**
** SR# 17060																							**
** Programmer: Thomas Van Nuys		Date: 01/07/2014												**
** ------------------------------------------------------------------------------------------------ **
** Purpose:		See the User name, Email, and ID Number												**
**																									**
**																									**
**		--- 01/04/2014 James Tutle - Was just a report query, turned into a PROC					**
**																									**
**																									**
******************************************************************************************************/

ALTER PROC GartmanLogins AS
BEGIN
select *
from openquery(GSFL2K,'
select u.usid
		,x.usxid
		,x.usxeml
		,p.emdept
		,p.emname
		,x.usxemp#
from userxtra x
left join prempm p on x.usxemp# = p.ememp#
left join userfile u on u.usid = x.usxid

order by usxid
')
END