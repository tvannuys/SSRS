



--CREATE PROC JT_FO_PO_check AS

/********************************************************************
*																	*
*	James Tuttle													*
*	10/24/2011														*
* FROM: VFP - -- fopock.prg											*
* ----------------------------------------------------------------- *
*																	*
* Check open PO Header file for POs that need to be looked at		*
* due to the pprd flag.												*
*********************************************************************/

-- Email with question for the PAs to look
-- at each PO3 on the list
-- "Do any of the these FO need a 'Y' in PPD Flag?"

SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ph.phvend as vendor_no,
								vm.vmname as vendor,
								ph.phco as co,
								ph.phloc as loc,
								ph.phpo# as po,
								ph.photyp as po_type,
								ph.phfrtppd as ppd_flag,
								ph.phalloctn as allo,
								ph.phallocper as aalo_per,
								ph.phequaliz as eq,
								ph.phequalper as eq_per
						FROM pohead as ph JOIN vendmast as vm ON vm.vmvend = ph.phvend
						WHERE ph.photyp = ''FO''
							AND ph.phfrtppd != ''Y''
							AND ph.phalloctn = 0
						ORDER BY ph.phvend, ph.phpo#				
			')
