
--ALTER PROC JT_HR_Double_Punch AS

/************************************************************************																		*
* Thomas Van Nuys														*
* James Tuttle															*
* Date: 9/14/2011														*
* From Eurisko Reports: adminTimeClock									*
* ---------------------------------------------------------------------	*
*																		*
* Look for double punch on the same day by the same employee #			*
*																		*
*************************************************************************/




-- get data from AS400
drop table testTable
SELECT *
INTO testTable 

FROM OPENQUERY (GSFL2K, '
            SELECT tc.ptdate as PunchDate,
           tc.PTSEQ# as SeqNum,
           tc.ptco as Co,
           tc.ptloc as Loc,
           tc.ptdept as Dept,
           tc.ptemp# as Emp#,
        /* emname as EmpName, */
           tc.ptsstm as ClockIn,
           tc.ptsetm as ClockOut  
                 
            FROM prtimecd TC
                                                                                                            
            WHERE tc.ptdate >= CURRENT_DATE - 1 DAYS
                                          
    ORDER BY tc.ptdate, tc.ptemp#, tc.ptseq#, tc.ptco, tc.ptloc
');


                 WITh CTE AS
                 (       
                 SELECT *, 
							COUNT (*) OVER( PARTITION BY emp#, clockin) AS cnt
                 FROM testTable
					)
					
					
					SELECT * 
					FROM CTE 
					WHERE cnt >= 2
						AND emp# = emp#
						AND Clockin=clockout
						AND PunchDate = Punchdate
						
					










--------------------------------------------------------------------------------------
--end
--close timecard_cursor
--deallocate timecard_cursor

--select * from #ExtraPunch
