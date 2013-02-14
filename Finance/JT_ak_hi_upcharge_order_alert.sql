ALTER PROC JT_ak_hi_upcharge_order_alert AS

/********************************************************
**	From the VFP Server									*
**	Program Name: ak-hi-upcgarge order alert			*
**	Name: James Tuttle	Date: 08/31/2011				*
**	--------------------------------------------------- *
**	Looks for Alaska (loc80) and Hawaii (loc85)			*
**	Shipped orders when the order loc and Inventory		*
**	are not equal to eachother.							*
**														*
*********************************************************/
--
-- SR# 6406
-- James Tuttle		Date: 12/21/2012
--
-- Added SAF and Pacmat locations for AK and HI
-----------------------------------------------------------


SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT olco
								,olloc
								,oliloc
								,olord#
								,olrel#
								,olcust
								, CASE WHEN olinvu = ''T'' THEN ''Shipped'' ELSE olinvu END AS Status
						FROM ooline
						WHERE olcust NOT LIKE ''IRR%''
							AND olinvu = ''T''
							AND olloc != oliloc
							AND olloc IN (80, 85, 81, 53, 54)
')
