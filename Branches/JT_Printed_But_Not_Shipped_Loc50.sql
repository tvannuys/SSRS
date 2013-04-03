USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_Printed_But_Not_Shipped_Loc50]    Script Date: 04/03/2013 07:40:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JT_Printed_But_Not_Shipped_Loc50]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


ALTER PROC [dbo].[JT_Printed_But_Not_Shipped_Loc50] AS

/*------------------------------------------------------*
** James Tuttle											*	
** Date: 11/3/2011										*
**														*
** report for loc50 on orders printed and not all		*
** lines are shipped									*
**														*
** ADDED: Ship VIA Code 6								*
**------------------------------------------------------*/



/* Query to look at orders printed but not shipped for Will Call */

SELECT DISTINCT *
	FROM OPENQUERY (GSFL2K, ''SELECT cmname AS CustName
									,ohprco AS CO
									,ohprlo AS Loc
									,ohord# AS Order
									,ohrel# AS Release
									,ohdtp AS Date_Printed
									,ohviac AS Via_Code
									,ohvia AS Via_Description
								,olinvu AS Status
							FROM oohead oh JOIN ooline ol ON (oh.ohco = ol.olco
								AND oh.ohloc = ol.olloc
								AND oh.ohord# = ol.olord#
								AND oh.ohrel# = ol.olrel#)
								Join custmast cm ON cm.cmcust = oh.ohcust
							WHERE ohdtp = CURRENT_DATE
								AND ohviac IN (''''1'''', ''''6'''')
								AND ohticp = ''''Y''''
								AND ohprlo = 50
								AND ohotyp NOT IN (''''SA'''', ''''DP'''')
								AND (olinvu = '''' '''' OR olinvu = ''''S'''' OR olinvu = ''''X'''' OR olinvu = ''''M'''') 
								/*AND ohprtr IN (''''KSL1'''',''''KSL2'''')  */
					'')
ORDER BY [Status] DESC


' 
END
GO


