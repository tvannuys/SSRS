USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_RF_ActivityNonWgtDATASOURCE]    Script Date: 01/15/2014 14:58:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Non Weighted Data for DAILY Report */

ALTER PROC [dbo].[JT_RF_ActivityNonWgtDATASOURCE] AS 

/*---------- Layout last updated: 6/1/12 by James T and Chris C -------------------------------------*/
SELECT p.company
      ,p.location
      ,p.Dept
      ,p.RFUser
      ,p.Metric
      ,p.daily
      ,CONVERT(float, p.Value) as Value
      ,p.rfdate
      ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [M]
      ,DATENAME(MONTH,p.RFDate) AS  [Month]
      ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
      ,u.EMPLOYEENAME
FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser
WHERE RFDate between '10/15/2011' and GETDATE()
      AND Metric not like 'weight%'
      AND Metric not like 'WCC Avg Time%'
ORDER BY DATEPART(wK,p.rfdate)
            ,RFDate
            ,company
            ,location
            ,RFUser

		

GO


