
/*=======================================================
=														=
=   Looking at dates and months							=
=														=
=========================================================*/

-- G0 to the end of the last month
select dateadd(s,-1,dateadd(mm,datediff(mm,0,getdate()),0))

-- Go back to the end of the month,2 months ago-> the -1 at 
--     the end takes it 1 month back; -x = month(s) back
select dateadd(s,-1,dateadd(mm,datediff(mm,0,getdate())-1,0))

-- Go to the end of the current month --> the +1 takes to the end starting with current month
--   +x = month end to the positve
select dateadd(s,-1,dateadd(mm,datediff(mm,0,getdate())+1,0))



/* If ran on the first day of the month*/
--Start of Month:
 select DateAdd(m,-1,getDate()) -- back 1 month
--End of Month:
 select DateAdd(d,-1,getDate()) -- back 1 day


