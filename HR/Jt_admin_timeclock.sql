--CREATE PROC Jt_admin_timeclock AS

-- Testing report from VFP: adminTimeClock Report


--=================================================================================
-- Duplicate Punch
--=================================================================================
WITH CTE_DupPunch AS
(
SELECT * 
FROM OPENQUERY (GSFL2K, 'SELECT ptdate as Date,
								ptco as Co,
								ptloc as Loc,
								ptdept as Dept,ptemp# as Emp#,
								emname as EmpName,
								ptsstm as ClockIn,
								ptsetm as ClockOut
						FROM prtimecd JOIN prempm ON ememp# = ptemp#
						WHERE ptdate >= CURRENT_DATE - 1 DAYS
							AND ptsstm = ptsetm
						ORDER BY ptco, ptloc, ptemp#, ptdate
					')
					)
SELECT * FROM CTE_DupPunch ;
					
					
--=================================================================================
-- Missed Punch
--=================================================================================
WITH CTE_MissPunch AS
(
SELECT * 
FROM OPENQUERY (GSFL2K, 'SELECT ptdate as Date,
								ptco as Co,
								ptloc as Loc,
								ptdept as Dept,ptemp# as Emp#,
								emname as EmpName,
								ptsstm as ClockIn,
								ptsetm as ClockOut
						FROM prtimecd JOIN prempm ON ememp# = ptemp#
						WHERE ptdate = CURRENT_DATE - 1 DAYS
							AND ptsetm = 0 
						OR ptrghr + ptothr > 10
							AND ptdate = CURRENT_DATE - 1 DAYS
						ORDER BY ptco, ptloc, ptemp#, ptdate
					')
					)
SELECT * FROM CTE_MissPunch;
					
					
--=================================================================================
-- Double Punch
--=================================================================================
WITH CTE_DoubPunch AS
(
SELECT * 
FROM OPENQUERY (GSFL2K, 'SELECT ptdate as Date,
								ptco as Co,
								ptloc as Loc,
								ptdept as Dept,ptemp# as Emp#,
								emname as EmpName,
								ptsstm as ClockIn,
								ptsetm as ClockOut
						FROM prtimecd JOIN prempm ON ememp# = ptemp#
						WHERE ptdate >= CURRENT_DATE - 1 DAYS
							AND ptsstm = ptsetm
							AND ptemp# = ptemp#
							AND ptloc = ptloc
							AND ptdept = ptdept
						ORDER BY ptco, ptloc, ptemp#, ptdate
					')
					)
SELECT * FROM CTE_DoubPunch ;
