select d.Division,d.DivisionDesc, d.FamilyCode,d.FamilyCodeDesc
from customersalesdetail d
where d.InvoiceDate > '12/31/2010'
and d.Company = 1
group by d.Division,d.DivisionDesc, d.FamilyCode,d.FamilyCodeDesc