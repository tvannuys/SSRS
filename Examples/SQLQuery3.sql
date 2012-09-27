



DECLARE @StartMonth VARCHAR(10)			-- Start month date
DECLARE @EndMonth	VARCHAR(10)			-- End month date
DECLARE @Query		VARCHAR(1000)		-- Pass query to AS400
DECLARE @ViaCode	VARCHAR(1)			-- Ship Via Code in Gartman 3 our truck



SET @StartMonth = DateAdd(m,-1, CONVERT(datetime, CONVERT(varchar(10),getDate(),101),101))	 -- back 1 month
--SET @EndMonth = DateAdd(d,-1, CONVERT(datetime, CONVERT(varchar(10),getDate(),101),101))
select convert(varchar(10), @EndMonth, 120) 