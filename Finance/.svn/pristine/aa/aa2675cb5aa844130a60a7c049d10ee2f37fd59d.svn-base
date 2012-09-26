
CREATE PROC new_claims AS

/* -----------------------------------------------------*
** James Tuttle 6/24/2011		Created: 6/25/2009		*
** -----------------------------------------------------*
** 	Report is for Mannington VCT will QTY < 6			*
**------------------------------------------------------*
*/

-- Drop table
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[JAMEST].[dbo].[#ClaimComments]') AND TYPE in (N'U'))
DROP TABLE [dbo].[#ClaimComments]
GO

SELECT Customer,
CustName,
Vendor,
Item,
[Description],
olseq#,
otseq#,
Quantity,
Price,
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
										vmname as Vendor,
										olitem as Item,
										oldesc as Description,
										olseq#,
										otseq#,
										olqord as Quantity,
										oleprc as Price,
										ohodat as Date,
										ohco as Company,
										ohloc as Location,
										ohord# as Order,
										ohrel# as Release,
										otcmt1 as Comment1,
										otcmt2 as Comment2
							FROM oohead JOIN ooline ON ohco = olco
														AND	ohloc = olloc
														AND	ohord# = olord#
														AND	ohrel# = olrel#
														AND ohrel# = olrel#
								JOIN ootext ON ohco = otco
											AND ohloc = otloc
											AND ohord# = otord#
											AND ohrel# = otrel#
											AND ohrel# = otrel#
								JOIN custmast ON ohcust = cmcust
								JOIN vendmast ON olvend = vmvend
							WHERE ohotyp = ''CL''
								AND ohodat = (CURRENT_DATE - 3 DAYS)
								AND olvend != 40000	
						')

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[JAMEST].[dbo].[#ClaimCommentSummary]') AND TYPE in (N'U'))
DROP TABLE [dbo].[#ClaimCommentSummary]
GO

-- Text conversion

SELECT Customer,
CustName,
Vendor,
Item,
[Description],
olseq#,
otseq#,
Quantity,
Price,
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
 
  --  FOR XML PATH(''))
  --, 2, 999) AS Comments


INTO #ClaimCommentSummary

FROM #ClaimComments e1

GROUP BY Customer,
CustName,
Vendor,
Item,
[Description],
olseq#,
otseq#,
Quantity,
Price,
[DATE],
Company,
Location,
[Order],
Release



SELECT * FROM #ClaimCommentSummary


-- 	AS400 Concant.
--  >> LTRIM(RTRIM(otcmt1)) || '' '' || LTRIM(RTRIM(otcmt2))