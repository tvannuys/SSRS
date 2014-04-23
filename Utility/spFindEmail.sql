-- spFindEmail 'aqui'

alter proc [dbo].[spFindEmail] 

@AddrPortion varchar(30)

as

declare @sql varchar(max)

set @sql = 'select * from openquery(gsfl2k,''
select cmcust as Acct,
cnccontid as ContactID,
cncfname as ContactFirstName,
cnclname as ContactLastName,
cnce_Mail as ContactEmail,
ccde_mail as ContactDetailEmail,
ccddoc as ContactDocument

from custmast c

left join CONTXREF cm on c.cmcust = cm.ccnxacct
left join contcont ct on ct.cnccontid = cm.ccnxcontid
left join custcndtl cd on cd.ccdcontid = ct.cnccontid

where (upper(ccde_mail) like ''''%' + upper(@AddrPortion) + '%''''
		or upper(cnce_mail) like ''''%' + upper(@AddrPortion) + '%'''')
'')'

exec(@sql)