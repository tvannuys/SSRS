
--ALTER PROC JT_branch_inv_ck AS 

/********************************************************************
*																	*
* From: Eurisko -- branchinvck.prg									*
* James Tuttle														*
* 09/28/2011														*
* ----------------------------------------------------------------- *
*																	*
* Get location values on Thursdays at 9am for Daniel B				*
*																	*
*********************************************************************/


SELECT *
FROM OPENQUERY (GSFL2K,'SELECT isco,
								isloc,
								isvalu
						FROM itemstat
						WHERE isloc != 98
							AND isvalu > 0
				ORDER BY isco, isloc
						')
		