
/* -------------------------------------------------<
--> Query CUSTMAST for customer by route			<
--> Split the City and State into seperate feilds	<
-->-------------------------------------------------*/

SELECT cmloc,
		cmcust,
		cmname,
	UPPER(RTRIM(reverse(substring(reverse(cmadr3),3,len(cmadr3))))) City,
	UPPER(REVERSE(left(reverse(cmadr3),2))) [State],
	cmdrt1
FROM OPENQUERY(GSFL2K, 'SELECT *
						FROM custmast
						WHERE cmdrt1 IN (''271'', ''293'', ''297'', ''298'')
						')
						
ORDER BY cmdrt1, [City]
