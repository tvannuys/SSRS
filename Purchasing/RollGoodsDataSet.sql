
/*********************************************************
**														**
** SR# 7666												**
** Programmer: James Tuttle		Date: 02/08/2013		**
** ---------------------------------------------------- **
** Purpose:												**
**			Rolls goods, available length, available 	**
**			SF, by serial, with by company, by location,**
**			with bin location, vendor, item, qty sold  	**
**			last 4 months, dollars sold last 4 months	**
**														**
** Name: RollGoodsDataSet								**
**														**
**********************************************************/

--========================================================
--					D A T A S E T						--
--========================================================
 
SELECT idco					AS Co
		,idloc				AS Loc
		,iditem				AS Item
		,imdesc				AS [Description]
		,idserl				AS Serail#
		,iddylt				AS DyeLot
		,idky				AS Tag#
		,idbin				AS Bin
		,(idqoh - idqoo)	AS Feet_Avbl
		,idvend				AS Vender#
		,vmname				AS Vendor_Name
		,Feet_Sold_Last_4_Months
		,Total_$_Last_4_Months
				
FROM OPENQUERY(GSFL2K,'
	SELECT idco
			,idloc
			,iditem
			,imdesc
			,idserl
			,iddylt
			,idky
			,idbin
			,idqoh
			,idqoo
			,idvend
			,vmname
/*------------------ Get the last four months qty (feet) sold ------------------------------------------------------ */
/*-------------------------------------------------------------------------------------------------------------------*/
			,(SELECT SUM(slqshp) FROM shline sl2 WHERE sl2.sldate >= CURRENT_DATE -120 DAYS
													AND sl2.slitem = id.iditem) AS Feet_Sold_Last_4_Months
/*------------------ Get the last four months dollars sold --------------------------------------------------------- */
/*-------------------------------------------------------------------------------------------------------------------*/
			,(SELECT SUM(sleprc) FROM shline sl2 WHERE sl2.sldate >= CURRENT_DATE -120 DAYS
													AND sl2.slitem = id.iditem) AS Total_$_Last_4_Months
					
	FROM ITEMDETL id
	LEFT JOIN ITEMMAST im ON im.imitem = id.iditem
	LEFT JOIN VENDMAST vm ON vm.vmvend = id.idvend
	LEFT JOIN SHLINE sl ON sl.slitem = id.iditem
	LEFT JOIN BINLOC bl ON bl.blbin = id.idbin
	
	WHERE sl.sldate >=  ''02/01/2013''
		AND id.idfcrg = ''Y''
		AND id.idqoh > 0.0
		AND bl.blgrp != ''XXXXX''
	')
GROUP BY idco
		,idLoc
		,iditem
		,imdesc
		,idserl
		,iddylt
		,idky
		,idbin
		,idvend
		,vmname
		,idqoh
		,idqoo
		,Feet_Sold_Last_4_Months
		,Total_$_Last_4_Months
			
HAVING (idqoh - idqoo) <= 30.00
	AND (idqoh - idqoo) > 0.00
-----------------------------------------------------------

-- 	