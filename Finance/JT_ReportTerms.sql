/*************************************************
**												**
** SR# 6397										**
** James Tuttle		Date: 12/20/2012			**
**												**
**     When time allows, could I please get a	**
**	report (01-01-2012 – current date) for ONLY **
**  FO order types, where we have billed		**
** “freight/Handlng” on the back, but only for  **
** those customers where AR terms payments are  **
** offered.										**
**												**
**************************************************/

ALTER PROC JT_ReportTerms AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,
	'SELECT shco AS Co
		, shloc AS Loc
		, MONTH(shidat) || ''/'' || DAY(shidat) || ''/'' || YEAR(shidat) AS Inv_Date
		, shinv# AS Invoice#
		, shcust AS Cust#
		, cmname AS Cust_Name
		, shterm AS Term_Code
		, tmdesc AS Term_Desc
		, shsam4 AS Freight_Handling

	FROM shhead sh
	LEFT JOIN custmast cm ON 
		sh.shcust = cm.cmcust	
	LEFT JOIN arterms art ON
		art.tmterm = sh.shterm
		
	WHERE sh.shidat >= ''01/01/2012''
		AND sh.shidat <= CURRENT_DATE
		AND sh.shotyp = ''FO''
		AND sh.shsam4 != 0
		AND art.tmdsc1 > .0000
	ORDER BY sh.shco
			,sh.shloc
			,sh.shidat
 ')
END
