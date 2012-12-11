select p.seqnum,SenderID,
Manufacturer, 
ManufStyleName,
StyleNum,
imprcd as 'Gartman Product Code'


from EC_832Product P
left join gartman.b107fd6e.gsfl2k.itemmast IM on IM.imitem = P.StyleNum

where P.SeqNum not in (select ProdSeqNum from dbo.EC_832Color C)

--delete  EC_832Product

/*  ======================================================================

		Gartman test queries

    ======================================================================

select * from openquery(gartman,'
select * from itemmast where imitem = ''DE61346200''
')


select * 
from gartman.b107fd6e.gsfl2k.itemmast 
where imitem = 'DE61346200'

*/