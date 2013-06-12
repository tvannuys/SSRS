/*  C1 Purchases of Private Label wood
	wrong item number
	
	Greg Szalay
	
	SR 4020
	
 */

select *
from openquery(GSFL2K,'
 
SELECT 
OOHEAD.OHCO,
OOHEAD.OHLOC,
OOHEAD.OHORD#,
OOHEAD.OHREL#,
OOline.olitem,
CUSTMAST.CMCUST AS CustNbr, 
CUSTMAST.CMNAME AS CustName, 
CUSTMKTG.CMKMKC as MarketingCode

FROM CUSTMAST
left join OOHEAD on oohead.ohcust = custmast.cmcust 
left JOIN OOLINE ON (OOLINE.OLCO = OOHEAD.OHCO 
	AND OOLINE.OLLOC = OOHEAD.OHLOC
	AND OOLINE.OLORD# = OOHEAD.OHORD# 
	AND OOLINE.OLREL# = OOHEAD.OHREL#) 
left JOIN CUSTMKTG ON CUSTMKTG.CMKCUS = CUSTMAST.CMCUST 

WHERE CUSTMAST.CMCO=1 
/* and shidat >= current_date - 1 day  */
and CUSTMKTG.CMKMKC = ''C1''
and olitem in (
''BBCAAC95NAHSHDF'',   
''BBCAAC95WHHSHDF'',   
''BBCAAC95NAHDF'',     
''BBCAAC95WHHDF'',     
''BBCABI955BAHSHDF2'', 
''BBCABI955VIHSHDF2'', 
''BBCAPC115ESHDF'',    
''BBCAMP95SMHDF'',     
''BBCAMP95NAHDF'',     
''BBCAOK95BIHDF'',     
''BBCAHI95ANHDF'',    
''BBCA95RIHSHDF2'',    
''BBCAEL95BWHDF'',     
''BBCAEL95FQHDF'',     
''BBCAOK95BUHDF'',     
''BBCAOK95NAHDF'',     
''BBCAHI85NAHDF'',     
''BBCAOK95HBHDF2'',    
''PA18815'',           
''PA18813'',           
''PA18812'',           
''PA18816'',           
''WBSWWPDLHON'',       
''WBSWWPDLMAC'',       
''WBSWHSWPDLMAC'',     
''LOSWBEPCB601C'',     
''LOSWBEPNR601C'',     
''LOSWBEPTG601C'',     
''LOSWBEPHSCP601C''   
)


')