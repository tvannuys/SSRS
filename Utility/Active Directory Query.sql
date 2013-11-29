select  mail,
displayname,
samAccountName,
distinguishedname,
pwdLastSet,
userAccountControl as PasswordNeverExpires


from  openquery(ADSI, '
select  givenName,
				sn,
				sAMAccountName,
				displayName,
				mail,
				telephoneNumber,
				mobile,
				physicalDeliveryOfficeName,
				department,
				division,
				pwdLastSet,
				userAccountControl,
				profilePath,
				distinguishedname



from    ''LDAP://dc=tasupply,dc=com''
where   objectCategory = ''Person''
        and
        objectClass = ''user''
')

where displayname like '%nora%'
or displayname like '%mary%'
or displayname like '%judi%'
or displayname like '%thomas%'
or displayname like '%owen%'


