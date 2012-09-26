-- CREATE PROC JT_all_reverse_po AS

/********************************************************
**	From the VFP Server									*
**	Program Name: allreversepo							*
**	Name: James Tuttle	Date: 09/01/2011				*
**	--------------------------------------------------- *
**	Looks at pohist files for field PLAPCL not = 'C'	*
**	for closed. Any PO in history that has the C in 	*
**  field means it was paid by AP if blank then the PO  *
**  has been shipped but no payment posted to the		*
**  rev. po#											*
**														*
*********************************************************/

SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT phco as comapany,
                                phloc as location,
                                phpo# as po#,
                                phcdat as po_date,
                                plrdat as ship_date,
                                phvend as vendor#,
                                phvnnm as vend_name,
                                plapcl as ap_closed,
                                phcusr as User,
                                sum((plblur - plapqt) * plcost) as cost
                                
        FROM polhist JOIN pohhist ON phco = plco
                                AND phloc = plloc
                                AND phpo# = plpo#
        WHERE phreturn = ''Y''
                                AND plapcl = '' ''
                                AND phcdat > CURRENT_DATE -730 DAYS
                                AND plrdat > CURRENT_DATE -730 DAYS
                                AND plrqty - plapqt < 0
        GROUP BY phco, phloc, phpo#, phcdat, plrdat, phvend, phvnnm, plapcl, 
                                phcusr
        ORDER BY phcusr, phvend, phpo#
        ')

		
			
	