
-- Example of CASE for a given month


DECLARE @Month1 varchar(5) = '', @Month2 varchar(5) = '', @Month3 varchar(5) = ''

SELECT @Month1 = 
	CASE MONTH(GETDATE()) 
		WHEN 1 THEN	'ibs12'
		when 2 then 'ibs1'
		when 3 then 'ibs2'
		else 'ibs' +  cast(MONTH(GETDATE()) - 3 as varchar(2))
	end,

	@Month2 = 
	CASE MONTH(GETDATE()) 
		WHEN 1 THEN	'ibs11'
		when 2 then 'ibs12'
		when 3 then 'ibs1'
		else 'ibs' +  cast(MONTH(GETDATE()) - 2 as varchar(2))
	end,
	
	@Month3 = 
	CASE MONTH(GETDATE()) 
		WHEN 1 THEN	'ibs10'
		when 2 then 'ibs11'
		when 3 then 'ibs12'
		else 'ibs' +  cast(MONTH(GETDATE()) - 1 as varchar(2))
	end

	
select @Month1, @Month2, @Month3	
