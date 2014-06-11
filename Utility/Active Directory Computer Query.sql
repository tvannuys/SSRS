--test

select  cn as ComputerName,
operatingSystem,
CAST((cast(pwdLastSet as BIGINT) / 864000000000.0 - 109207) AS DATETIME) as PwdLastSet


from  openquery(ADSI, '
select  cn, 
operatingSystem,
pwdLastSet

from    ''LDAP://tasupply.com''
where   objectCategory = ''Computer''
')

where operatingSystem like '%XP%'

