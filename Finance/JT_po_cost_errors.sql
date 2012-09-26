

-- CREATE PORC JT_po_cost_errors as 

/*==========================================================*
** James Tuttle		Date: 11/14/2011						*
**															*
** FROM VFP: received po item with different costs.prg		*
**															*
**  Purpose: Costs differences in PO receivings ion items	*
**==========================================================*/ 

-- Run 4am and 4pm <-----

--IF OBJECT_ID ('dbo.#PO') IS NOT NULL
--BEGIN
--	DROP TABLE dbo.#PO 
--END

-- DROP TABLE #PO


-- Create Temp Table
CREATE TABLE #PO (
	[date] date,
	co int,
	loc int,
	po int,
	item varchar(max),
	item2 varchar(max),
	cost money,
	cost2 money
)
-- Declare variables
DECLARE @Date date, 
	@co int, 
	@loc int, 
	@po int,
	@item varchar(max), 
	@cost money

-- Comerasion variables
DECLARE @Date2 date, 
	@co2 int, 
	@loc2 int, 
	@po2 int,
	@item2 varchar(max), 
	@cost2 money
	
-- Delcare cursor
declare po_cursor cursor for

	SELECT * 
	FROM OPENQUERY(GSFL2K, 'SELECT month(plrdat) || ''/'' || day(plrdat) || ''/'' || year(plrdat) as date,
								plco as co,
								plloc as loc,
								plpo# as po,
								plitem as item,
								plrcst as cost
							FROM polhist
							WHERE /* ---> plrdat > CURRENT_DATE - 5 DAYS
								AND <-----*/ plactn = ''R''
								AND plrqty > plapqt
								AND plapcl = ''''
								/*AND plpo# = 129839 */
								
						')
-- Open Cursor
open po_cursor
-- get record
fetch next from po_cursor
into  @date,
 @co, 
 @loc, 
 @po,
 @item, 
 @cost

--fetch next from po_cursor into 
--                         @date,
--						 @co, 
--						 @loc, 
--						 @po,
--						 @item, 
--						 @cost 

while @@FETCH_STATUS = 0 
begin

/* moving var2 to var1 */

select @date = @date2,
        @co = @co2,
        @loc = @loc2, 
        @po = @po2,
        @item = @item2, 
        @cost = @cost2
   
/* load var2 */

            fetch next from po_cursor into 
                                   @date2,
                                    @co2, 
                                    @loc2, 
                                    @po2,
                                    @item2, 
                                    @cost2
/* test */

            if @item = @item2 AND @cost != @cost2
                        begin
                                    insert #PO 
                                    select @date, @co, @Loc, @po, @item, @item2, @cost, @cost2 
                                                
                        end
                        
                 --SELECT Co int, Loc int, Emp#  int, PunchDate  char(10), ClockIn  int, ClockOut  int, NewClockIn  int, NewClockOu, COUNT OVER()
                 --FROM Punch 
                 --GROUP BY 

end
close po_cursor
deallocate po_cursor

select * from #PO