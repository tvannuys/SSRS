


/********************************************************************
*																	*
*	James Tuttle													*
*	9/23/2011														*
* FROM: VFP - Timecard Viewer										*
* ----------------------------------------------------------------- *
*																	*
* Get the clock-in and clock-out from the Gartman PRTIMECD File		*
* This needs to be saved as 'adp.csv' file so the Mobile Time Bank  *
* can export to ADP.												*
*																	*
* File Name: adp.csv												*
*********************************************************************/

ALTER PROC [dbo].[JT_HR_adp_export_v2]

-- days to go back
@DaysBack INT 
 AS
				
-- Set day of week into the variable
SET @DaysBack = @DaysBack * -1

	-- Query PRTIMECD File in Gartman 
	
SELECT *
	FROM OPENQUERY (GSFL2K, 'SELECT ptrun#,
								ptemp#,
								ptcksq,
								month(ptdate) || ''/'' || day(ptdate) || ''/'' || year(ptdate) as ptdate,
								ptseq#,
								ptco,
								ptloc,
								ptdept,
								ptshft,
								pttype,
								ptdi,
								ptoco,
								ptoloc,
								ptoord#,
								ptorel#,
								ptsstm,
								ptsetm,
								ptrghr,
								ptrgor,
								ptlnch,
								ptothr,
								ptotor,
								ptot,
								month(ptdatets) || ''/'' || day(ptdatets) || ''/'' || year(ptdatets) || '' '' ||
									hour(ptdatets) ||'':'' || minute(ptdatets) || '':'' || second(ptdatets) as ptdatets
						FROM prtimecd
						ORDER BY ptemp#, ptdatets
					')
WHERE ptdate = DATEADD(D,@DaysBack,CONVERT(DATE,GETDATE())) 



