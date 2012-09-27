
SELECT * FROM
	(SELECT DISTINCT iritem, DENSE_RANK() OVER(ORDER BY iritem ASC) as Item_Rank
	FROM OPENQUERY(GSFL2K,'SELECT *
							FROM itemrech
							WHERE irdate > CURRENT_DATE - 14 DAYS
							')) As Qry
WHERE Item_Rank < 26