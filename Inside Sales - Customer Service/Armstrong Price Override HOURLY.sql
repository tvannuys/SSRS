USE [GartmanReport]
GO
/****** Object:  StoredProcedure [dbo].[ArmstrongPriceOverride]    Script Date: 03/04/2013 10:17:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ===================================================

	Purpose:  Armstrong Product Price overrides - open orders
	
	Created By:  George
	Date Created:  6/14/2011
	
	Last Update Date: 06/16/2011
	Last Updated By: Thomas Van Nuys
	
	Change Log:
	
	06/16/2011 - added criteria to only get the previous days orders
	11/26/2012 - comment out declaration of @DayofWeek and @QueryDate, case statement and related where criteria -George 
	12/04/2012 - add criteria to exclude lines that Kim Earle has already modified. Also, change passthrough SQL to exclude machine serial nbr.
			Saved original version in MyProjects folder.
	12/10/2012 - changed join to oochange to exclude the sequence number(comment out)
	03/04/2013 - changed where clause to exclude order type "SO" per Kim Earle request --GR
=====================================================*/
		
ALTER proc [dbo].[ArmstrongPriceOverrideHOURLY] as 
----------------------------------
DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2
--DECLARE @Query AS VARCHAR(600)		-- Pass query to AS400
----------------------------------
-- Get LastTime timestamp
SELECT @LastRan = dbo.JT_JobLog_v2.LastRan
FROM dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'ArmstrongPriceOverrideHOURLY';

----------------------------------

select * from openquery(TSGSFL2K,'

	select  OLCO AS Company, 
	OLLOC AS Location, 
	OLORD# AS OrderNum, 
	OLREL# AS Release, 
	OHODAT AS OrderDate, 
	OHOTYP AS OrderType, 
	OLCUST AS CustNbr, 
	CMNAME AS CustName, 
	OLITEM AS ItemNum, 
	OLDESC AS ItemDesc, 
	OLQORD AS OrdQty, 
	OLQSHP AS ShipQty, 
	OLQBO AS BackorderQty, 
	OLPRIC AS UnitPrice,  
	ohtime,
	ohodat,
	
	case 
		when olpric = 0 then 0
		else (OLPRIC-(OLCOST-OLSCS4))/OLPRIC 
	end as GMPerc,

	OLPOR AS PriceOverride, 
	OLPCRS AS PriceChangeReason, 
	OLCOST AS UnitCost, 
	OLSCS4 AS UnitFileback, 
	OLC4OR AS FilebackOverride, 
	OLQT# AS QuoteNbr, 
	OLVEND as VendNum, 
	OLPROMO# as ProcedureNum,
	IMP1 AS ItemMastP1, 
	IMLD1 AS ItemMastP1Rbt, 
	IMP2 AS ItemMastP2, 
	IMLD2 AS ItemMastP2Rbt, 
	IMP3 AS ItemMastP3, 
	IMLD3 AS ItemMastP3Rbt, 
	IMP4 AS ItemMastP4, 
	IMLD4 AS ItemMastP4Rbt, 
	IMP5 AS ItemMastP5, 
	IMLD5 AS ItemMastP5Rbt, 
	OLPRCD as ProdCode,
	ogtime 
	
	from OOLINE LINE
	INNER JOIN OOHEAD HEAD ON (OLCO = OHCO 
		AND OLLOC = OHLOC
		AND OLORD# = OHORD#
		AND OLREL# = OHREL#)
	INNER JOIN oochange OOCHANGE ON (OGCO = OHCO 
		AND OGLOC = OHLOC
		AND OGORD# = OHORD#
		AND OGREL# = OHREL#)
	INNER JOIN CUSTMAST ON OLCUST = CMCUST
	INNER JOIN ITEMMAST ON OLITEM = IMITEM 
	INNER JOIN ITEMXTRA ON OLITEM = IMXITM

	WHERE OHOTYP not in (''DP'',''RA'',''SO'')
		AND OLVEND in (16037,22312)
		AND IMFCRG <> ''S''
		and OLPOR = ''Y''
		AND ogtype = ''PR''
		AND ohord# = 397647
			
		and not exists (select * from oochange
			where line.olco = ogco
					AND line.OLLOC = OGLOC
					AND line.OLORD# = OGORD#
					AND line.OLREL# = OGREL#
					AND oguser = ''KIME'' 
					)
														
	order by CustName
	')
----------------------------------
WHERE CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  CASE len(ohtime) 
				WHEN 5 THEN '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + 
					substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ohtime),4,2)
				ELSE substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ohtime),5,2) 
END < @LastRan
----------------------------------
OR
----------------------------------
	 CONVERT(VARCHAR(10), ogtime, 126) + ' ' +
		  CASE len(ogtime) 
				WHEN 5 THEN '0' + substring(CONVERT(VARCHAR(7), ogtime),1,1) + ':' + 
					substring(CONVERT(VARCHAR(7), ogtime),2,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ogtime),4,2)
				ELSE substring(CONVERT(VARCHAR(7), ogtime),1,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ogtime),3,2) + ':' + 
					substring(CONVERT(VARCHAR(7), ogtime),5,2) 
END < @LastRan

------------------------------------

-- Update the table with current time for LastTime
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) + ' ' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'ArmstrongPriceOverrideHOURLY'

----------------------------------
--EXEC(@Query)


/* ---- TEST DATA ---------------------------------------------------------------|

SELECT * FROM JT_JobLog_v2

UPDATE dbo.JT_JobLog_v2
SET  dbo.JT_JobLog_v2.LastRan = '2013-12-24 07:00:00'
WHERE JobName = 'ArmstrongPriceOverrideHOURLY'

DELETE FROM JT_JobLog_v2
WHERE JobName = 'ArmstrongPriceOverrideHOURLY'

INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('ArmstrongPriceOverrideHOURLY', '2011-07-13 11:00:00')

--------------------------------------------------------------------------------- */


