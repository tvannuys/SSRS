



/********************************************************
**  Name: James Tuttle									*
**  Date: 10/31/2011									*
**														*							
**	From the VFP Server									*
**	Program Name: criticalitemrepor50.prg				*
**														*
**	--------------------------------------------------- *
**														*								
*********************************************************/



SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT imbuyr as buyer,
							ibvend as vendor,
							vmname as vendor_name,
							ibitem as item,
							imdesc as description,
							ibloc as loc,
							(ibqoh - ibqoo + ibqbo + ibqoov) as available 
						/*	ROUND( month1+month2+month3) - ROUND(month1+month2+month3)/2  --2 dec. places  as short,        */
						/*  ROUND(ibqoh-ibqoo-ibqbo+ibqoov) - ROUND(month1+month2+month3) /3 2 dec. places as months_on_hand   */
						FROM itemmast RIGHT JOIN itembal ON imitem =  ibitem
							RIGHT JOIN vendmast ON ibvend = vmvend
							RIGHT JOIN itemxtra ON imxitm = ibitem 							

			
								
							
							
							
							
							
						')