

ALTER PROC [dbo].[JT_HR_Double_Punch] AS

/************************************************************************																		
* Thomas Van Nuys														*
* James Tuttle															*
* Date: 9/14/2011														*
* From Eurisko Reports: adminTimeClock									*
* ---------------------------------------------------------------------	*
*																		*
* Look for double punch on the same day by the same employee #			*
* ---------------------------------------------------------------------	*
*				Modifcation By: James Tuttle							*
*				Date: 02/13/2012										*
*																		*
* Is there any way to add name of employee to this?						*
* Like the other reports?												*
*	-Tonya 	McGrew - HR / Payroll										*
*************************************************************************/


--=================================================================================
-- Double Punch
--=================================================================================
--drop table #ExtraPunch

-- Create Temp Table 
create table #ExtraPunch (
Co int,
Loc int,
Emp#  int,
EmpName varchar(50),
PunchDate  char(10),
ClockIn  int,
ClockOut  int,
NewClockIn  int,
NewClockOut  int)

-- Declare variables for var1 records to compare
declare @PunchDate as char(10)
declare @SeqNum as int
declare @Co as int
declare @Loc as int
declare @Dept as int
declare @Emp# as int
declare @EmpName as varchar(50)
declare @ClockIn as int
declare @ClockOut as int

-- Declare variables for var2 records to compare
declare @PunchDate1 as char(10)
declare @SeqNum1 as int
declare @Co1 as int
declare @Loc1 as int
declare @Dept1 as int
declare @Emp#1 as int
declare @EmpName1 as varchar(50)
declare @ClockIn1 as int
declare @ClockOut1 as int

-- Delcare cursor
declare timecard_cursor cursor for

-- get data from AS400
SELECT * 
FROM OPENQUERY (GSFL2K, '
            SELECT tc.ptdate as PunchDate,
           tc.PTSEQ# as SeqNum,
           tc.ptco as Co,
           tc.ptloc as Loc,
           tc.ptdept as Dept,
           tc.ptemp# as Emp#,
		   em.emname as EmpName,   
           tc.ptsstm as ClockIn,
           tc.ptsetm as ClockOut  
                 
            FROM prtimecd TC
            JOIN prempm em
				ON tc.ptemp# = em.ememp#
                                                                                                            
            WHERE tc.ptdate = CURRENT_DATE
                                          
    ORDER BY tc.ptdate, tc.ptemp#, tc.ptseq#, tc.ptco, tc.ptloc
')
-- Open Cursor
open timecard_cursor
-- get record
fetch next from timecard_cursor
into  @PunchDate,
@SeqNum,
@Co, 
 @Loc, 
 @Dept, 
 @Emp#,
 @EmpName, 
 @ClockIn, 
 @ClockOut 

fetch next from timecard_cursor into 
                        @PunchDate1,
                        @SeqNum1, 
                        @Co1, 
                        @Loc1, 
                        @Dept1, 
                        @Emp#1, 
                        @EmpName1,
                        @ClockIn1, 
                        @ClockOut1 

while @@FETCH_STATUS = 0 
begin

/* moving var2 to var1 */

select @PunchDate = @PunchDate1,
                                    @SeqNum = @SeqNum1,
                                    @Co1 = @Co1,
                                    @Loc = @Loc1, 
                                    @Dept = @Dept1, 
                                    @Emp# = @Emp#1, 
                                    @EmpName = @EmpName1, 
                                    @ClockIn = @ClockIn1, 
                                    @Clockout = @ClockOut1 

/* load var2 */

            fetch next from timecard_cursor into 
                                    @PunchDate1,
                                    @SeqNum1, 
                                    @Co1, 
                                    @Loc1, 
                                    @Dept1, 
                                    @Emp#1,
                                    @EmpName1, 
                                    @ClockIn1, 
                                    @ClockOut1 
            
/* test */

            if @Emp# = @Emp#1 and @PunchDate = @PunchDate1 and @ClockOut = @ClockIn1
                        begin
                                    insert #ExtraPunch
                                    select @Co, @Loc, @Emp#,@EmpName,@PunchDate,@ClockIn,@ClockOut,@ClockIn1,@ClockOut1
                                                
                        end

end
close timecard_cursor
deallocate timecard_cursor

select * from #ExtraPunch

GO


