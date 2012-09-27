
----------------------------------------
--
--  For the Display Report
--


-- Create TEMP Table
CREATE TABLE #Displays (
	cmcust varchar(30)
   ,bcblcd varchar(2)
   ,bcdesc varchar(30)
   ,bcvend int
   ,bpprcd int
   ,bpvend int
   ,bpdiv int
   ,bpfmcd varchar(2)
   ,bpcls# int
   ,slord# INT
   ,sleprc FLOAT
   ,sldiv INT
   ,slfmcd varchar(2)
   ,slcls# INT
   ,slprcd INT
   ,slvend INT
  )
				
-- Declare variables One
DECLARE @cmcust1 varchar(30)
	,@bcblcd1 varchar(2)
	,@bcdesc1 varchar(30)
	,@bcvend1 int
	,@bpprcd1 int
	,@bpvend1 int
	,@bpdiv1 int
	,@bpfmcd1 varchar(2)
	,@bpcls#1 int
	,@slord#1 INT
    ,@sleprc1 FLOAT
	,@sldiv1 INT
    ,@slfmcd1 varchar(2)
    ,@slcls#1 INT
    ,@slprcd1 INT
    ,@slvend1 INT
	
-- Declare variables Two
DECLARE @cmcust2 varchar(30)
	,@bcblcd2 varchar(2)
	,@bcdesc2 varchar(30)
	,@bcvend2 int
	,@bpprcd2 int
	,@bpvend2 int
	,@bpdiv2 int
	,@bpfmcd2 varchar(2)
	,@bpcls#2 int
	,@slord#2 INT
    ,@sleprc2 FLOAT
	,@sldiv2 INT
    ,@slfmcd2 varchar(2)
    ,@slcls#2 INT
    ,@slprcd2 INT
    ,@slvend2 INT
	
-- Declare cursor
DECLARE display_cursor CURSOR FOR

-- Get data from AS400
--SELECT *
--FROM OPENQUERY(GSFL2K,
--	'SELECT cbcust
--			,bcblcd
--			,bcdesc
--			,bctype
--			,bcvend
--			,bpprcd
--			,bpvend
--			,bpdiv
--			,bpfmcd
--			,bpcls#
--	FROM custbill cb
--	JOIN blcdmast bcm
--		ON bcm.bcblcd = cb.cbblcd
--	JOIN shline sl
--		ON sl.slcust = cb.cbcust
--	JOIN blcdprod bcp
--		ON bcm.bcblcd = bcp.bpblcd
--	WHERE bcp.bpprcd = sl.slprcd
--	ORDER BY bcblcd
--			,cbcust
--	')	
		SELECT *
	FROM OPENQUERY(GSFL2K,
		'SELECT cbcust
				,bcblcd 
				,bpprcd
				,bpvend
				,bpdiv
				,bpfmcd
				,bpcls#
				,sleprc
				,slord#
				,sldiv
				,slfmcd
				,slcls#
				,slprcd
				,slvend
	FROM custbill cb
	JOIN blcdmast bcm
		ON bcm.bcblcd = cb.cbblcd
	JOIN shline sl
		ON sl.slcust = cb.cbcust
	JOIN blcdprod bcp
		ON bcm.bcblcd = bcp.bpblcd
	WHERE  cbcust = ''4100161''
		AND slord# = 939874
		AND YEAR(slsdat) = 2012
		/*AND sl.slprcd = bcp.bpprcd*/
		/*AND sl.slvend = bcp.bpvend*/
		/*AND sl.slfmcd = bcp.bpfmcd*/
		/*AND sl.sldiv = bcp.bpdiv*/
		AND sl.slcls# = bcp.bpcls#
		
	ORDER BY bcblcd
				,cbcust
		')
-- Open cursor
OPEN display_cursor
-- Get record
FETCH NEXT FROM display_cursor
INTO @cmcust1 
	,@bcblcd1
	,@bcdesc1 
	,@bcvend1 
	,@bpprcd1 
	,@bpvend1 
	,@bpdiv1 
	,@bpfmcd1 
	,@bpcls#1 
	,@slord#1
    ,@sleprc1
	,@sldiv1 
    ,@slfmcd1 
    ,@slcls#1 
    ,@slprcd1 
    ,@slvend1 
	
FETCH NEXT FROM display_cursor
INTO @cmcust2 
	,@bcblcd2
	,@bcdesc2 
	,@bcvend2 
	,@bpprcd2 
	,@bpvend2 
	,@bpdiv2 
	,@bpfmcd2 
	,@bpcls#2 
	,@slord#2
    ,@sleprc2
	,@sldiv2 
    ,@slfmcd2 
    ,@slcls#2 
    ,@slprcd2 
    ,@slvend2 
	
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @cmcust1 = @cmcust2
			,@bcblcd1 = @bcblcd2
			,@bcdesc1 = @bcdesc2 
			,@bcvend1 = @bcvend2 
			,@bpprcd1 = @bpprcd2 
			,@bpvend1 = @bpvend2 
			,@bpdiv1 = @bpdiv2 
			,@bpfmcd1 = @bpfmcd2 
			,@slord#1 = @slord#2 
			,@sleprc1 = @sleprc2
			,@sldiv1 = @sldiv2
		    ,@slfmcd1 = @slfmcd2
			,@slcls#1 = @slcls#2
			,@slprcd1 = @slprcd2
			,@slvend1 = @slvend2
		 
	FETCH NEXT FROM display_cursor INTO
	@cmcust2 
	,@bcblcd2
	,@bcdesc2 
	,@bcvend2 
	,@bpprcd2 
	,@bpvend2 
	,@bpdiv2 
	,@bpfmcd2 
	,@bpcls#2
	,@slord#2
    ,@sleprc2 
	,@sldiv2 
    ,@slfmcd2 
    ,@slcls#2 
    ,@slprcd2 
    ,@slvend2 
	
	/* TEST */
	
	IF @cmcust1 = @cmcust2  
		AND @bpfmcd1 = @bpfmcd2 
		BEGIN
			INSERT #Displays 
			SELECT @cmcust2 
					,@bcblcd2
					,@bcdesc2 
					,@bcvend2 
					,@bpprcd2 
					,@bpvend2 
					,@bpdiv2 
					,@bpfmcd2 
					,@bpcls#2 
					,@slord#2
					,@sleprc2
					,@sldiv2 
					,@slfmcd2 
					,@slcls#2 
					,@slprcd2 
					,@slvend2 
		END
	
	
	END
	
	
CLOSE display_cursor
DEALLOCATE display_cursor

SELECT * FROM #Displays
GO