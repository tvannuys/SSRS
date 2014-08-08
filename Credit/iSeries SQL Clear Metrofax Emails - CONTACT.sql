update CONTCONT

set cnce_mail = ' ',
cnce_mailu = ' '

where cnccontid in (select ccnxcontid 
	from contxref 
	join custmast on ccnxacct = cmcust)

and  cnce_mailu like '%METROFAX%'
