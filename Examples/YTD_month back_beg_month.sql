


select * from openquery(gsfl2k,'
	select shord#
			,shsdat
			,current_date as cur_date
			,(CURRENT_date - (DAY(CURRENT_date + 1 MONTHS) - 1) DAYS) /*back to first of the month */
			,current_date - (dayofyear(current_date) - 1) days /* beggining of year	*/


	FROM shhead
	where shsdat >= DATE((DAY(CURRENT_DATE - 1 MONTH) -1)) 
	')
