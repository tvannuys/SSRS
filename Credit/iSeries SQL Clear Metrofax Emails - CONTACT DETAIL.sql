update custcndtl

set ccde_mail  = ' '

where (CCDE_MAIL like '%METROFAX%' or CCDE_MAIL like '%metrofax%')
and CCDCUS = '4100761'