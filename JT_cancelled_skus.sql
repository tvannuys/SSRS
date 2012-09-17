

ALTER PROC [dbo].[JT_cancelled_skus] AS

/************************************************************************																		*
*																		*
* James Tuttle															*
* Date: 10/25/2011														*
* From Eurisko Reports: cancelledskus.prg								*
* ---------------------------------------------------------------------	*
*																		*
* Canceled skus	on orders and what is tied to POs						*
*																		*
*************************************************************************/
--------------------------------------------------------------------------
-- James Tuttle		09/17/2012
-- Add: pldelt != ''C''
-- Due to some POs getting closed in a way that does not 
-- clear the POLINE of the record.
--------------------------------------------------------------------------


SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT imbuyr as buyer,
								month(olcdte) || ''/'' || day(olcdte) || ''/'' || year(olcdte) as cancel_date,
								imsi as master_stock,
								olco as co,
								olloc as loc,
								olord# as order,
								olitem as sku,
								oldesc as description,
								vmname as vendor_name,
								olqord as qty_cancel,
								olqord * olcost as cancel_cost,
								olqord * imwght as cancel_wgt,
								olreas as reason,
								olcusr as who_cancel,
								sum(plqord) as ttl_po 
							FROM vendmast  RIGHT JOIN oclhist ON vmvend = olvend
							LEFT JOIN itemmast  ON olitem = imitem
							LEFT JOIN poline ON olitem = plitem
						WHERE olcdte = CURRENT_DATE - 1 DAYS
							AND olreas != ''TRANSFER''
							AND olvend != 40000
							AND pldelt != ''C''
						GROUP BY imbuyr,
								olcdte,
								imsi,
								olco,
								olloc,
								olord#,
								olitem,
								oldesc,
								vmname,
								olqord,
								olqord * olcost,
								olqord * imwght,
								olreas,
								olcusr
						ORDER BY imbuyr, imsi, olord#
				')
				
				



