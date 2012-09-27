
-- CREATE PROC JT_PM_prod_open_order

/********************************************************
**  Name: James Tuttle									*
**  Date: 10/25/2011									*
**														*							
**														*
**	--------------------------------------------------- *
**	Look for inventory for Company 2 when it is not		*
**  shipped												*								
*********************************************************/


SELECT *
FROM OPENQUERY (GSFL2K,'SELECT 