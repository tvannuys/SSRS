/*  Will Crites  

Credits with reason codes

*/

select * from openquery (gsfl2k,'

select      ''Credit Memo'' as SourceApp,
			shcust as Acct,
            cmname as Customer,
            shidat as CreditDate,
            shinv# as Invoice,
            shcred as CreditCode,
            crrdes as CreditCodeDesc,
            shtotl * -1 as AdjustmentAmt,
            '' '' as Comment
            
            
from shhead sh
      left join custmast cm on cm.cmcust = sh.shcust
      left join crreason cr on cr.crreas = sh.shcred
      
      
where shidat >= ''07/01/2014'' 
      and shcm = ''Y''
      and shotyp not in (''RA'',''RI'',''CL'',''FC'')
      and shco = 1
      and shcred in (''BE'',''CC'',''CD'',''CF'',''FN'',
		''FR'',''FS'',''GI'',''IT'',''ME'',''MM'',''PE'',
		''OB'',''OE'',''PA'',''PA'',''PD'',''PE'',''PN'',
		''PU'',''RB'',''WE'',''RS'',''SA'',''SD'',''SE'',
		''FR'',''ST'',''TX'',''VD'',''WE'',''WW'')

order by shidat asc     
      ')    
