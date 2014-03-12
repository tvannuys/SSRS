-- Query for the datassource on RF Daily Activity
-- 
CREATE PROC NonWgtRfAvtivityKPIchart_WCC_Current

	@Loc AS numeric
AS

SELECT p.company
      ,p.Location
     -- ,p.Dept
      ,p.RFUser
      ,p.Metric
      --,p.daily
      ,CONVERT(float, p.Value) as Value
      ,p.rfdate
    --  ,DATENAME(DW,p.rfdate) as [Day]
      ,DATEPART(M,p.rfdate) as [Month]
    --  ,DATEPART(WK,p.rfdate) as [Week]
      ,DATEPART(YY,p.rfdate) as [Year]
    --,u.EMPLOYEENAME

FROM WarehouseProductivity p WITH (INDEX(NCI_WarehouseProductivity_RFDate_Metric_Daily))
LEFT JOIN WarehouseUsers u on u.OLRUSR = p.RFUser

WHERE RFDate between '01/01/2014' and GETDATE()
      AND Metric not like 'weight%'
      AND Metric not like 'WCC Avg Time%'
	  AND Metric not like 'Hours%'
      AND Metric not like 'Total Activity%'
	  AND Metric not like 'Term Update%'
      AND Metric not like 'XE Item Recv by Plt Tag%'
	  AND Metric not like 'XE Item Ship by Plt Tag%'
      AND Metric not like 'Consol%'
	  AND Metric not like 'XE Rolls Ship by Plt Tag%'
	  AND Metric not like 'POs Recvd by Items%'
      AND Metric not like 'Truck Item by Plt Tag%'
	  AND Metric not like 'XE Rolls Recv by Plt Tag%'
	  AND Metric not like 'Truck Rolls by Plt Tag%'
      AND Metric not like 'POs Recvd by Rolls%'
	  AND Metric not like 'Rolls Moved%'
	  AND Metric not like 'CUTS%'
	  AND Metric not like 'Inv Move Items by Plt Tag%'
      AND Metric not like 'Inv Move Rolls by Non Plt Tag%'
	  AND Metric not like 'XE Rolls Ship Non Plt Tag%'
	  AND Metric not like 'Inv Move Rolls by Plt Tag%'
      AND Metric not like 'XE Items Recvd Non Plt Tag%'
	  AND Metric not like 'XE Rolls Recvd Non Plt Tag%'
      AND Metric not like 'XE Items Ship Non Plt Tag%'
	  AND Metric not like 'Truck Items Non Plt Tagt%'
      AND Metric not like 'Truck Roll Non Plt Tag%'
	  AND Metric not like 'Inv. Counts%'
      AND Metric not like 'inv_move_non_plt_items%'
	   AND Metric not like 'Staged%'

	  AND p.Location =  @loc

ORDER BY DATEPART(wK,p.rfdate)
            ,RFDate
            ,company
            ,location
            ,RFUser

--  NonWgtRfAvtivityKPIchart_WCC_Current 50