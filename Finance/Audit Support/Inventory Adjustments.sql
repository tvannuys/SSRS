/*

  and irsrc in ( ''A'',''B'',''I'',''M'',''C'')  
  and iritem not like ''XX%'' 

*/

select irvend as 'Vendor #',
iritem as 'Item #', 
irco as Company,
irloc as Location,
irdesc as [Description],
irdate as [Date Entered],
irserl as 'Serial #',
irbin as 'Bin Location', 
irqty as 'Quantity', 
SalesQty,  
ircost as 'Unit Cost',
irsrc as Source, 
iruser as [User], 
iredat as [Entry Date],
irreason as [Adj Reason Code],
iardes as [Adj Reason Desc] 


from openquery(gsfl2k,' 
select irvend,
iritem, 
irco,
irloc,
irky,
irdesc, 
year(irdate) as DateEnteredYear, 
irdate, 
irserl,irbin, 
irqty, 
case  
	when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = '' '') then (irqty*itemmast.IMFACT)  
	when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = ''D'') then ((irqty*itemmast.IMFACT)/itemmast.IMFAC2)  
	else 0  
end as SalesQty,  
ircost,
irsrc, 
iruser, 
iredat,
iretim, 
irreason,
iardes 

 from ITEMRCHY 
 left join iareason on irreason=iareas 
 left join itemmast on iritem=imitem 

where year(irdate) = 2011
 and irco = 2
 
 order by irserl,irdate 
 
 ')