USE [GartmanReport]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************
**	James Tuttle
**	02/28/2014
**
**		Look at the current month and the prior year same month for
**	shipped RF W\Call lines
**
*****************************************************************************/

-- NonWgtRfAvtivityKPIchart
 
CREATE PROC [dbo].[KPIchart_NonWgtRfAvtivity4] 
	--@Loc AS numeric --= 50 
AS


BEGIN
--====================================================================================================================
--
-- C for Current time period =========================================================================================
--
/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_C'))
		BEGIN
			DROP TABLE #WCC_C
		END;
	WITH CTE_C AS
	(
	SELECT p.company
      ,p.Location
     -- ,p.Dept
   --   ,p.RFUser
  --    ,p.Metric
      --,p.daily
     ------- ,CONVERT(float, p.Value) as Value
	 ,p.Value
      ,p.rfdate
    --  ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
    --  ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
    --,u.EMPLOYEENAME

FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser

WHERE RFDate between '01/01/2014' and '01/31/2014'
    AND Metric not like 'weight%'
   AND Metric not like 'WCC Avg Time%'
   AND Metric not like 'Hours%'
   AND Metric not like 'Total Activity%'
   AND Metric not like 'Term Update%'
   --AND Metric not like 'XE Item Recv by Plt Tag%'
   --AND Metric not like 'XE Item Ship by Plt Tag%'
   --AND Metric not like 'Consol%'
   --AND Metric not like 'XE Rolls Ship by Plt Tag%'
   --AND Metric not like 'POs Recvd by Items%'
   --AND Metric not like 'Truck Item by Plt Tag%'
   --AND Metric not like 'XE Rolls Recv by Plt Tag%'
   --AND Metric not like 'Truck Rolls by Plt Tag%'
   --AND Metric not like 'POs Recvd by Rolls%'
   --AND Metric not like 'Rolls Moved%'
   --AND Metric not like 'CUTS%'
   --AND Metric not like 'Inv Move Items by Plt Tag%'
   --AND Metric not like 'Inv Move Rolls by Non Plt Tag%'
   --AND Metric not like 'XE Rolls Ship Non Plt Tag%'
   --AND Metric not like 'Inv Move Rolls by Plt Tag%'
   --AND Metric not like 'XE Items Recvd Non Plt Tag%'
   --AND Metric not like 'XE Rolls Recvd Non Plt Tag%'
   --AND Metric not like 'XE Items Ship Non Plt Tag%'
   --AND Metric not like 'Truck Items Non Plt Tagt%'
   --AND Metric not like 'Truck Roll Non Plt Tag%'
   --AND Metric not like 'Inv. Counts%'
   --AND Metric not like 'inv_move_non_plt_items%'
   --AND Metric not like 'Staged%'

	  AND p.Location IN (4,44,64)

--ORDER BY DATEPART(wK,p.rfdate)
--            ,RFDate
--            ,company
--            ,location
--            ,RFUser
	)

	SELECT SUM(CONVERT(float,Value)) as C_cnt, NULL as P_cnt
	INTO #WCC_C

	FROM CTE_C
	--GROUP BY Metric

	--SELECT * FROM  #WCC_C
						
--==================================================================================================================
--
-- P for Prior time period =========================================================================================
--
/* DROP a temp table if exists */
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#WCC_P'))
		BEGIN
			DROP TABLE #WCC_P
		END;	

	WITH CTE_P AS
	(
			SELECT p.company
      ,p.Location
     -- ,p.Dept
   --   ,p.RFUser
   --   ,p.Metric
      --,p.daily
     ------- ,CONVERT(float, p.Value) as Value
	 ,p.Value
      ,p.rfdate
    --  ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
    --  ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
    --,u.EMPLOYEENAME

FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser

WHERE RFDate between '01/01/2013' and '01/31/2013'
    AND Metric not like 'weight%'
   AND Metric not like 'WCC Avg Time%'
   AND Metric not like 'Hours%'
   AND Metric not like 'Total Activity%'
   AND Metric not like 'Term Update%'
   --AND Metric not like 'XE Item Recv by Plt Tag%'
   --AND Metric not like 'XE Item Ship by Plt Tag%'
   --AND Metric not like 'Consol%'
   --AND Metric not like 'XE Rolls Ship by Plt Tag%'
   --AND Metric not like 'POs Recvd by Items%'
   --AND Metric not like 'Truck Item by Plt Tag%'
   --AND Metric not like 'XE Rolls Recv by Plt Tag%'
   --AND Metric not like 'Truck Rolls by Plt Tag%'
   --AND Metric not like 'POs Recvd by Rolls%'
   --AND Metric not like 'Rolls Moved%'
   --AND Metric not like 'CUTS%'
   --AND Metric not like 'Inv Move Items by Plt Tag%'
   --AND Metric not like 'Inv Move Rolls by Non Plt Tag%'
   --AND Metric not like 'XE Rolls Ship Non Plt Tag%'
   --AND Metric not like 'Inv Move Rolls by Plt Tag%'
   --AND Metric not like 'XE Items Recvd Non Plt Tag%'
   --AND Metric not like 'XE Rolls Recvd Non Plt Tag%'
   --AND Metric not like 'XE Items Ship Non Plt Tag%'
   --AND Metric not like 'Truck Items Non Plt Tagt%'
   --AND Metric not like 'Truck Roll Non Plt Tag%'
   --AND Metric not like 'Inv. Counts%'
   --AND Metric not like 'inv_move_non_plt_items%'
   --AND Metric not like 'Staged%'

	  AND p.Location IN (4,44,64)

--ORDER BY DATEPART(wK,p.rfdate)
--            ,RFDate
--            ,company
--            ,location
--            ,RFUser
	)

	SELECT SUM(CONVERT(float,Value)) as P_cnt, NULL as C_cnt
	INTO #WCC_P

	FROM CTE_P
	--GROUP BY Metric

	--SELECT * FROM  #WCC_P

--==================================================================================================================
-- UPSERT 
--==================================================================================================================
	MERGE #WCC_C as T1			-- table one with the Current time fram
	USING #WCC_P as T2			-- table two with the Prior time frame feeding table 1 with UPDATE or INSERT
	ON T1.C_cnt = T2.P_cnt 		-- alias the two tables 
	WHEN MATCHED THEN			-- if a match on xxxxx UPDATE fields from table 2 feed
		UPDATE SET T1.C_cnt = T2.P_cnt 
	WHEN NOT MATCHED THEN		-- if xxxxx not present INSERT the fields from table 2 feed
		INSERT ( P_cnt)
		VALUES ( T2.P_cnt);
		
		
	SELECT * FROM #WCC_C

	
END	
	



GO


