select distinct r.slslmn, oq.smname, r.BasedOn, r.Rate
from dbo.CommissionRate r
left join (select * from openquery(gsfl2k,'select * from salesman')) oq on oq.smno = r.slslmn
where r.slslmn = 71 


--update CommissionRate set Rate = .06 where slslmn=71