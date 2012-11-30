/* pulled for Will Crites on in person request */

select * from openquery(gsfl2k,'
select 
vendmast.vmvend,
vmname,
vmterm,
pudesc,
vmgl,
vsys$,
vsyc$


from vendmast
left join poterms on vendmast.vmterm = poterms.puterm
left join vendstat on vendmast.vmvend = vendstat.vsvend

and vsloc = 98
and vsco = 2



')
