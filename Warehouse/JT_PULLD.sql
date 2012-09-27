
--ALTER PROC [dbo].[JT_PULLD] AS
BEGIN

/****************************************************************************
*																			*
* Programmer: James Tuttle		Date: 1/4/2012		Req By: Colleen B		*
* -------------------------------------------------------------------------	*
* Purpose: Report to show any ITEMDETL Item in the PULLD bin location		*
*																			*
*****************************************************************************/

	SELECT *
	FROM OPENQUERY (GSFL2K, 'SELECT idco
									, idloc
									, iditem
									, idbin
									, idqoh
							FROM itemdetl
							WHERE idbin = ''PULLD''
								AND idqoh != 0.00
							')
END						

GO


