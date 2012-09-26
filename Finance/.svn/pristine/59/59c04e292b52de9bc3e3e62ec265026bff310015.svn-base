
--CREATE PROC JT_PM_inventory_audit AS


/********************************************************
**  Name: James Tuttle									*
**  Date: 10/25/2011									*
**														*							
**	From the VFP Server									*
**	Program Name: pminventoryreport.prg					*
**														*
**	--------------------------------------------------- *
**	Looks at the Inventory balance for company 2		*
**  Omits class codes, and gcvorp = ' '					*								
*********************************************************/




-- Thomas Revision 10/25/2011

SELECT * FROM
OPENQUERY (GSFL2K, '
	SELECT ibco as co,
		ibloc as loc,
		gcdiv as div,
		gcingl,
		sum(ibdbvl) as SumOfIBDBVL
	FROM  itembal
	JOIN arglcntl ON (arglcntl.gcco = itembal.ibco
						AND arglcntl.gcloc = itembal.ibloc
						and gcvorp = '' '')
	JOIN itemmast ON (itembal.ibitem = itemmast.imitem 
						and itemmast.imdiv = arglcntl.gcdiv)
	JOIN clascode ON itembal.ibcls# = clascode.ccclas
	WHERE itembal.ibco = 2
		AND itembal.ibdbvl != 0  
		AND arglcntl.gcdiv > 0
		AND itembal.ibcls# NOT IN (1220,1240,1250,2040,2041,2042,2070,2071,2210,2211,2215,2230,2240,
			2250,2260,2278,3430,3431,3902,4112,4172,4173,4210,4211,4212,4220,4225,5010,5210,
			6130,6250,7410,7430,8040,9400,10500,10510,11020,11210,11212,11310,12500,12501,12750,
			12770,12910,12922,12930,14001,14002,40520,40540,41005,41015,41025,41035,41045,41047,41055,
			41056,41057,41085,40500,40510,3703,40902,40908)
		AND itembal.ibcls# NOT BETWEEN 3060 and 3070
		AND itembal.ibcls# NOT BETWEEN 3220 and 3230
		AND itembal.ibcls# NOT BETWEEN 13000 and 13997
	            
	GROUP BY ibco,
	ibloc,
	gcdiv,
	gcingl

	ORDER BY ibco,ibloc
	')
