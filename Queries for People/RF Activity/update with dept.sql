insert WarehouseProductivity (Company,Location,RFDate,Dept,RFUser,Metric,Value)
select 
	case H.[Company Code]
		when 'zyb' then 2
		else 1
	end,
	SUBSTRING(convert(varchar(10),H.Department),1,2),
	H.[Pay Date],
	RIGHT(H.Department,2),
	(select MAX(U.OLRUSR) from WarehouseUsers U where U.EMEMP# = CONVERT(decimal,H.Badge)), --<
	'Hours',
	H.[Hours]
from WarehouseHours H
where h.[Pay Date] between '10/15/2011' and getdate()
and H.[Earnings Code] in ('OVERTIME','REGULAR')

--SELECT * FROM WareHouseHours
--SELECT * FROM WarehouseProductivity WHERE RFUser IS NULL AND Location = 50

-- DELETE WareHouseHours
-- DELETE WarehouseProductivity WHERE RFUser IS NULL

--SELECT * FROM WareHouseHours Where Hours IS NULL

--SELECT datepart(m,RFDate),datepart(d,RFDate)
--FROM WarehouseProductivity
--GROUP BY datepart(m,RFDate),datepart(d,RFDate)
--ORDER BY datepart(m,RFDate),datepart(d,RFDate)
