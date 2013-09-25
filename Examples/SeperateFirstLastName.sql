
-- Seprate the firt and last name since employee name is one field in the PREMPM File in Gartman
--
SELECT SUBSTRING(emname,1, CHARINDEX(' ',emname)-1) AS [First]
	 ,LTRIM(SUBSTRING(emname,CHARINDEX(' ', emname)+1, LEN(emname))) AS [Last]