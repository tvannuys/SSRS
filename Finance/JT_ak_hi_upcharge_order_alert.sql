USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_ak_hi_upcharge_order_alert]    Script Date: 12/18/2013 07:31:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[JT_ak_hi_upcharge_order_alert] AS

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
--	George Rippee III	Date: 12/18/2013
--	Added batch number from ooinuse file
-----------------------------------------------------------


SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT olco
								,olloc
								,oliloc
								,olord#
								,olrel#
								,olcust
								, CASE WHEN olinvu = ''T'' THEN ''Shipped'' ELSE olinvu END AS Status
								,iubat#
						FROM ooline
							left join ooinuse on (olco=iuco and olloc=iuloc and olord#=iuord# and olrel#=iurel# and iupgm = ''OE105'')
						WHERE olcust NOT LIKE ''IRR%''
							AND olinvu = ''T''
							AND olloc != oliloc
							AND olloc IN (80, 85, 81, 53, 54)
						order by olco asc,olloc asc,olord# asc,olrel# asc
')


GO


