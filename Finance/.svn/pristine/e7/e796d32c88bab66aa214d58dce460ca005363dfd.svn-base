

--DROP TABLE #ClaimComments
--DROP TABLE #ClaimCommentsSummary
--DROP TABLE #LineDetails
--GO


--ALTER PROC JT_new_claims_v2 AS

/* -----------------------------------------------------*
** James Tuttle 6/24/2011		Created: 6/25/2009		*
** FROM: VFP Finance Reports							*
** -----------------------------------------------------*
** 	Report is for new claims writen the prior day		*
**														*
**------------------------------------------------------*
*/

-- Drop table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[JAMEST].[dbo].[#ClaimComments]') AND TYPE in (N'U'))
DROP TABLE [dbo].[#ClaimComments]
--GO

-- Get OrderHeader with Comments
SELECT Customer,
CustName,
otseq#,
[DATE],
Company,
Location,
[Order],
Release,
Comment1,
Comment2

into #ClaimComments


-- AS400 Query
FROM OPENQUERY (GSFL2K, 'SELECT ohcust as Customer,
										cmname as CustName,
										otseq#,
										ohodat as Date,
										ohco as Company,
										ohloc as Location,
										ohord# as Order,
										ohrel# as Release,
										otcmt1 as Comment1,
										otcmt2 as Comment2
							FROM oohead JOIN ootext ON ohco = otco
											AND ohloc = otloc
											AND ohord# = otord#
											AND ohrel# = otrel#
											AND ohrel# = otrel#
								JOIN custmast ON ohcust = cmcust
							WHERE ohotyp = ''CL''
								AND ohodat = (CURRENT_DATE - 1 DAYS)
						')

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[JAMEST].[dbo].[#ClaimCommentSummary]') AND TYPE in (N'U'))
DROP TABLE [dbo].[#ClaimCommentSummary]
--GO
--=======================================================================================================
--
--	 Text catenate
--
--=======================================================================================================
--
SELECT Customer,
CustName,
otseq#,
[DATE],
Company,
Location,
[Order],
Release,
SUBSTRING(
      (SELECT ', ' + Comment1 + ', ' + Comment2
      FROM #ClaimComments e2
    WHERE e2.[order] = e1.[order]
FOR XML PATH ('')),2,999) AS Comment
 
INTO #ClaimCommentSummary 

FROM #ClaimComments e1

GROUP BY Customer,
CustName,
otseq#,
[DATE],
Company,
Location,
[Order],
Release
--=======================================================================================================
--=======================================================================================================





-- ===============================================================================================
--
--  GET LINE DETAILS 
--
-- ===============================================================================================
-- Temp #LineDetails

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[JAMEST].[dbo].[#LineDetails]') AND TYPE in (N'U'))
DROP TABLE [dbo].[#LineDetails]


SELECT Company,
		Location,
		[Order],
		Release,
		Item,
		[Description],
		olseq#,
		Quantity,
		Amount,
		Vendor
		
INTO #LineDetails

-- AS400 Query
FROM OPENQUERY (GSFL2K, 'SELECT olco as Company,
								olloc as Location,
								olord# as Order,
								olrel# as Release,
								olitem as Item,
								oldesc as Description,
								olseq#,
								olqord as Quantity,
								oleprc as Amount,
								vmname as Vendor
						FROM ooline JOIN vendmast ON olvend = vmvend
						WHERE olvend != 40000
							AND olqord > 0
						')
--SELECT * FROM #LineDetails
-- ======================================================================================================
--=======================================================================================================


-- Join Line Details with OrderHeader with Comments 
SELECT CCS.Customer, CCS.CustName, LD.Vendor, LD.Item, LD.[Description], LD.Quantity, LD.Amount, CCS.[Date], LD.Company, LD.Location, LD.[Order], CCS.Comment 
FROM #ClaimCommentSummary AS CCS JOIN #LineDetails AS LD ON CCS.company = LD.Company
								AND	CCS.Location = LD.Location
								AND CCS.[Order] = LD.[Order]
								AND CCS.Release = LD.Release
								



-- 	AS400 Concant.
--  >> LTRIM(RTRIM(otcmt1)) || '' '' || LTRIM(RTRIM(otcmt2))