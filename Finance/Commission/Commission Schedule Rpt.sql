select distinct r.slslmn, oq.smname, oq.smco, r.BasedOn, r.Rate
from dbo.CommissionRate r
left join (select * from openquery(gsfl2k,'select * from salesman')) oq on oq.smno = r.slslmn
where r.sldiv = 1


--update CommissionRate set Rate = .06 where slslmn=71

--select * from openquery(gsfl2k,'select * from salesman')