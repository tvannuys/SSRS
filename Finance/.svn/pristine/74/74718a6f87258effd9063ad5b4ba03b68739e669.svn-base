--CREATE PROC JT_ak_hi_upcharge_order_alert AS

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


SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT olco,
								olloc,
								oliloc,
								olord#,
								olrel#,
								olcust,
								olinvu
						FROM ooline
						WHERE olcust NOT LIKE ''IRR%''
							AND olinvu = ''T''
							AND olloc != oliloc
							AND olloc IN (80, 85)
')
