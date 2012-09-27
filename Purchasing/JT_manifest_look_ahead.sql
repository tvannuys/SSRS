
--CREATE PROC JT_manifest_look_ahead AS

/* -----------------------------------------------------*
** James Tuttle 6/24/2011		Created: 6/25/2009		*
** -----------------------------------------------------*
** 														*
**------------------------------------------------------*
*/

-- DISTINCT

select  *
FROM OPENQUERY (GSFL2K, 'SELECT olseq# AS Seq#,
		olloc AS OrderLoc,
		irloc as ManiLoc,
		mtman# AS Manifest#,
		mtddate AS Delv_Date, 
		pbpo# as PO#,
		mtstatus AS Status, 
		ohcust AS Cust_Num,
		cmname AS Cust_Name,
		cmadr3 AS City_State,
		cmzip AS Zip,
		pboqty * imwght AS Weight,
		ohotyp AS Order_Type,
		ohord# AS Order#,
		ohsdat AS Ship_Date,
		pboloc AS Delv_Loc,
		ohviac AS Via_Code,
		ohvia AS Via_Desc,
		olitem AS Item,
		pboqty AS BO_Qty
	FROM ooline 
	JOIN oohead ON (olco = ohco
					AND olloc = ohloc
					AND olord# = ohord#
					AND olrel# = ohrel#)
	JOIN poboline ON (poboline.pbitem = ooline.olitem
							and poboline.pboco = ooline.olco
							and poboline.pboloc = ooline.olloc
							and poboline.pboord = ooline.olord#)
	left JOIN itemmast ON itemmast.imitem = ooline.olitem
	left JOIN custmast on oohead.ohcust = custmast.cmcust
	left JOIN manidetl ON (ooline.olseq# = manidetl.irseq#
							AND ooline.olco = manidetl.irooco
							AND ooline.olloc = manidetl.iroolo
							AND ooline.olord# = manidetl.irord#)
	left join mantrack on mantrack.mtman# = manidetl.irman#
   	WHERE ohotyp != ''FO''
   		AND irloc IN(52, 50, 41)
   		AND olord# = 803015
   		ORDER BY irloc, mtddate, mtman#, pboloc
	 ')
 
 
 
