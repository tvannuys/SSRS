/* 

SR 22172

Vendor Profile report

Table references from vendor maintenance screen:

APDXVENDRT
APVVCL    
APVNVO    
VENDMANT  
VENDDIST  

VENDBANK 
VMCLMAST 
VENDMAST 
VENDNAMEX
VENDNAME 
VENDXTRA 
VENDMAST 
VM010FM  

*/


select * from openquery(gsfl2k,'
select vmvend,
vmname,
vmdisc,
vmtrms,
vmterm as TermsCode,
vmbuyr as BuyerCode,
poterms.pudesc as PaymentTerms,
byname,
vcmcomment


from vendmast
left join poterms on PUTERM = vmterm
left join BUYER on BYBUYR = vmbuyr
left join VENDCOMT on VCMVEND = vmvend

where vmvend = ''15559''
')