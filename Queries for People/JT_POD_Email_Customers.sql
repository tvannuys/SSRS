


SELECT ccdcus as Cust_Num
	, cmname as Cust_Name
	, ccde_mail as Email
FROM OPENQUERY (GSFL2K,
	'SELECT *
	FROM custcndtl cd
	INNER JOIN custmast cm ON cd.ccdcus = cm.cmcust
	WHERE cd.ccddoc = ''SHP''
		AND cd.ccdfax = 0
	')
ORDER BY ccdcus