
--CREATE PROC JT_po_over_10000 as

/********************************************************************
*																	*
*	James Tuttle													*
*	11/4/2011														*
* FROM: VFP - posover$10k.prg										*
* ----------------------------------------------------------------- *
*																	*
* 		POs over $10,00												*
*********************************************************************/
-- 


SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT month(phdoi) || ''/'' || day(phdoi) || ''/'' || year(phdoi) as date,
							phco as co,
							phpo# as po#,
							vmname as vender,
							DEC(SUM(plbluo * plcost + plffac),11,3) as ttl_cost,
							phutp as user
					FROM pohead INNER JOIN poline
						ON (phco = plco
						AND phloc = plloc
						AND phpo# = plpo#
						AND phrel# = plrel#)
					INNER JOIN vendmast ON vmvend = plvend
					GROUP BY phdoi, phco, phpo#, vmname, phutp
					HAVING phdoi = CURRENT_DATE - 1 DAYS
						AND DEC(SUM(plbluo * plcost + plffac),11,3) > 10000
					ORDER BY phco, phutp



					')


					