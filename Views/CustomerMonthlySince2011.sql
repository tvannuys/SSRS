alter VIEW [dbo].[CustomerMonthlySince2011]
AS

select * from openquery(gsfl2k,'
select *
from gscust.CUSTOMERDETAILSBYMONTH2YEARS
')