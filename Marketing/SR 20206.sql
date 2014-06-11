	SELECT * FROM OPENQUERY(GSFL2K,'
		     
		SELECT slco as co
				,slloc as loc
				,slord# as order# 
				,slcust as cust#
				,cmname as cust_name
				,shodat as date_created
				,shsdat as date_shipped
				,slitem as item
				,sldesc as description
				,slpric as price
				,slblus as billable_units
				,slum2 as um
				,shquot as quote#
				,sleprc as sub_total
				,shstnm as shipto
				,shsta1 as address1
				,shsta2 as address2
				,shsta3 as city_state
				,left(shsta3,23) as City
				,right(shsta3,2) as State
				,shzip as zip
				,SHPO# as CustomerPO
				,stcmt1 as SideMark

		FROM shline
		LEFT JOIN shhead ON (shhead.shco = shline.slco
								AND shhead.shloc = shline.slloc
								AND shhead.shord# = shline.slord#
								AND shhead.shrel# = shline.slrel#
								AND shhead.shinv# = shline.slinv#
								AND shhead.shcust = shline.slcust)
		LEFT JOIN custmast ON cmcust = slcust
		LEFT JOIN shtext st ON		
 			( shhead.shco = st.stco
				AND shhead.shloc = st.stloc
				AND shhead.shord# = st.stord#
				AND shhead.shrel# = st.strel#
				AND shhead.shcust = st.stcust
				AND stseq# = 0 AND sttseq = 1)
				
/*--------------------------------------------------------------------------------------------------------------------------------------------*/		
		WHERE shhead.shidat >= ''01/01/2012'' 
			
			and slprcd = 6079

		
	')
	 