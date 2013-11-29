/* Query the Active Directory AD and get the members of a Group 

Change the value of @GroupName as necessary

*/

declare @GroupName varchar(50)
declare @sql varchar(max)

set @GroupName = 'All T&A'
set @GroupName = 'orderscancelled'

set @sql = 'SELECT *
FROM OPENQUERY(ADSI,''<LDAP://DC=tasupply,DC=com>;
(&(objectCategory=user)(memberOf=CN=' + @GroupName + ',CN=Users,DC=tasupply,DC=com));
cn,name;subtree'')'

exec(@sql)





/* Query the Active Directory AD and get the members of a Group 

Version with no variables

*/

SELECT
*
FROM OPENQUERY(ADSI,'<LDAP://DC=tasupply,DC=com>;
(&(objectCategory=user)(memberOf=CN=Management-s,CN=Users,DC=tasupply,DC=com));
cn,name;subtree')


/* Get a list of Groups */


select  *
from  openquery(ADSI, '
select  samaccountname,mail,sn,name, cn, objectCategory,distinguishedName 
from    ''LDAP://dc=tasupply,dc=com''
where   objectCategory=''group''
      
')


