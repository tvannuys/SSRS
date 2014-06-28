/* and IMHMCD != 0     ONLY HAZMAT ITEMS 


	IRR ITEMS
	and imdiv = 13
	and imfmcd = ''IR''

*/

select * from openquery(gsfl2k,'
select imvend, 
vmname,
imdiv,
dvdesc,
imfmcd, fmdesc, 
imcls# as Class,
ccdesc as ClassDesc,
imprcd, pcdesc, 
imitem, imdesc, imcolr, IMPTRN,
IMXPRODSUB,
IMP1, imp2, imp3, imp4, imp5,
IMHMCD

from itemmast
left join itemxtra on imxitm = imitem
left join vendmast on imvend = vmvend
left join division on imdiv = dvdiv
left join prodcode on imprcd = pcprcd
left join family on imfmcd = fmfmcd
left join clascode cc on cc.ccclas = imcls#

where imdrop != ''D''
and imprcd = 6308

order by imfmcd,imprcd,imdesc
')