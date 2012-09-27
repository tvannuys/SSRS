
--CREATE PROC JT_Accessory_stock_xe AS

/********************************************************
**  Name: James Tuttle									*
**  Date: 10/26/2011									*
**														*							
**	VFP Program: tansfercheckv2.prg						*
**  As per Jeff N add more vendors and add some other	*
**  user to the report. Also change the name			*
**														*
**	Please add 15659, 21869, 22361, 11882 10094,		*
**  Please Change name to Accessory stock transfer		*
**	report. Please add Mary Norman BryanP Denise along	*
**  with myself to have report.Thanks.		Jeff Nealon *
**														*
**	--------------------------------------------------- *
**	Look for inventory for Company 2 when it is not		*
**  shipped												*								
*********************************************************/

SELECT *
FROM OPENQUERY (GSFL2K,'SELECT imbuyr as buyer,
								month(ohodat) || ''/'' || day(ohodat) || ''/'' || year(ohodat) as date,
								ohotyp as type,
								olloc as ship_to,
								ohprlo as Ship_from,
								olord# as order,
								olrel# as release,
								olitem as item,
								oldesc as description,
								olqord as QTY,
								olqbo as QTY_BO,
								olqshp * imwght as weght_shipped,
								ohuser as created_by
						FROM itemmast as im INNER JOIN ooline as ol 
							ON im.imitem = ol.olitem
						INNER JOIN oohead as oh
							ON ol.olco = oh.ohco
								AND ol.olloc = oh.ohloc
								AND ol.olord# = oh.ohord#
								AND ol.olrel# = oh.ohrel#
						WHERE oh.ohodat = CURRENT_DATE
							AND oh.ohotyp = ''TR''
							AND ol.olloc != oh.ohprlo
							AND im.imvend IN (16106, 2510, 16096, 12384, 13055, 11296,
												15659, 21869, 22361, 11882, 10094)
						ORDER BY im.imbuyr, oh.ohodat, ol.olord#, im.imitem
			')
				