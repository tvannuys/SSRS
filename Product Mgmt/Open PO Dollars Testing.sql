/*
Created By:  Thomas Van Nuys
Date Created: 

SR #

*/
/*
select i4.*,i4.SalesUOMOnHand*i4.imrcst as OnHandValue
FROM OPENQUERY(GSFL2K, 'select imitem,imprcd, dvdiv,
						dvdesc,
						pcdesc,
						imrcst,
						
						case 
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = '' '') then sum(((IbQOH-ibqoo)*itemmast.IMFACT))
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = ''D'') then sum((((IbQOH-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2))
							else sum(0)
						end as SalesUOMOnHand
						
						FROM itembal
						JOIN itemmast ON ibitem = imitem
						left join division on imdiv = dvdiv
						left join prodcode on imprcd = pcprcd
						
						WHERE ibco = 2
						AND  ibqoh - ibqoo > 0	
						group by imitem,imprcd,dvdiv,dvdesc,pcdesc,imrcst,immd,immd2
						
					') i4
*/

select * from openquery(gsfl2k,'select imitem,imprcd, dvdiv,
						dvdesc,
						pcdesc,
						plpo#,
						plcost,
						PLBLUO,
						PLBLUR,
						sum((PLBLUO-PLBLUR)*plcost) as OnPOValue
						
						from poline
						join itemmast on plitem = imitem
						left join division on imdiv = dvdiv
						left join prodcode on imprcd = pcprcd
						where plco = 2
						and PLDELT <> ''C''
						and imitem = ''JODC454X120''
						
						
						group by imitem,imprcd,dvdiv,dvdesc,pcdesc,plpo#,plcost,PLBLUO,PLBLUR

						
						')
						

/*

case 
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = '' '') then sum(((IbQOH-ibqoo)*itemmast.IMFACT))
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = ''D'') then sum((((IbQOH-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2))
							else sum(0)
						end as SalesUOMOnHand
						
*/