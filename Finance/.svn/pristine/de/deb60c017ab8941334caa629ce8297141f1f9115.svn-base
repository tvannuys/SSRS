
---------------------------------------------------------------------------
--	General query to DB2 for the records predicated on					 --
---------------------------------------------------------------------------
WITH CTE AS
(
SELECT *
FROM OPENQUERY (GSFL2K,'SELECT DISTINCT plrdat, 
							   plco,
							   plloc,
							   plpo#,
							   plitem,
							   plrcst
						FROM polhist
						WHERE plactn = ''R''
							AND plrdat > CURRENT_DATE - 4 DAYS
							AND ABS(plrqty) > ABS(plapqt)
							AND plapcl = '' ''
						ORDER BY plco, plloc, plpo#, plitem
							')
							)
---------------------------------------------------------------------------
--	CTE to compare items and the cost diff if any and return the results --
---------------------------------------------------------------------------
SELECT  CAST(MONTH(b.plrdat)as varchar)+ '/'+ CAST(DAY(b.plrdat) as varchar)+'/'+ CAST(YEAR(b.plrdat) as varchar) as Rec_Date, 
		b.plco as Co ,
		b.plloc as Loc,
		b.plpo# as PO,
		b.plitem as Item1,
		c.plitem as Item2,
		b.plrcst as Cost1,
		c.plrcst as Cost2
FROM CTE as b
INNER JOIN CTE AS c
ON b.plitem = c.plitem
	AND b.plco = c.plco
	AND b.plloc = c.plloc
	AND b.plpo# = c.plpo#
WHERE b.plrcst != c.plrcst
----------------------------------------------------------------------------
