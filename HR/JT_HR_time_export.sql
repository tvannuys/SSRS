
--ALTER PROC JT_HR_adp_export AS

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


-- day of week
DECLARE @DOW INT				
-- Set day of week into the variable
SET @DOW = DATEPART(DW,GETDATE()) 



-- If Monday go back 3 days for Friday's time and date
IF  @DOW = 2
BEGIN
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
						WHERE ptdate BETWEEN (CURRENT_DATE - 3 DAYS) AND  (CURRENT_DATE - 1 DAYS)
						ORDER BY ptemp#, ptdatets
					')
END

ELSE
-- Tue - Fri go back one day

	--Query PRTIMECD File in Gartman
	
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
						WHERE ptdate = (CURRENT_DATE - 1 DAYS)
						ORDER BY ptemp#, ptdatets
					')
