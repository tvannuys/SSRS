
--CREATE PROC JT_HR_Duplicate_Punch AS

/************************************************************************																		*
* James Tuttle															*
* Date: 9/14/2011														*
* From Eurisko Reports: adminTimeClock									*
* ---------------------------------------------------------------------	*
*																		*
* Look for duplicate punch on the same day by the same employee #		*
*																		*
*************************************************************************/




--=================================================================================
-- Duplicate Punch
--=================================================================================

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