USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[NonStkRecdSAF]    Script Date: 09/25/2013 07:28:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[NonStkRecdSAF] as


select *
from openquery (GSFL2K, '
	SELECT	GSFL2K.OOHEAD.OHCO AS Company, 
			GSFL2K.OOHEAD.OHLOC AS Location, 
			GSFL2K.OOHEAD.OHORD# AS OrderNum, 
			GSFL2K.OOHEAD.OHREL# AS Release, 
			GSFL2K.OOHEAD.OHCUST AS CustNum, 
			GSFL2K.CUSTMAST.CMNAME AS CustName, 
			GSFL2K.OOHEAD.OHODAT AS OrderDate, 
			GSFL2K.OOHEAD.OHBRDT AS BackorderRecDate, 
			GSFL2K.OOLINE.OLITEM AS ItemNbr, 
			GSFL2K.ITEMMAST.IMSI AS StockingItem, 
			GSFL2K.OOLINE.OLBLUS AS QtyToShip, 
			GSFL2K.OOLINE.OLEPRC AS ExtendedPrice
			
			from gsfl2k.oohead
				inner join gsfl2k.ooline on gsfl2k.oohead.ohco=gsfl2k.ooline.olco
					and gsfl2k.oohead.ohloc=gsfl2k.ooline.olloc
					and gsfl2k.oohead.ohord#=gsfl2k.ooline.olord#
					and gsfl2k.oohead.ohrel#=gsfl2k.ooline.olrel#
				inner join gsfl2k.custmast on gsfl2k.oohead.ohcust=gsfl2k.custmast.cmcust
				inner join gsfl2k.itemmast on gsfl2k.ooline.olitem=gsfl2k.itemmast.imitem
				
			WHERE	 GSFL2K.OOHEAD.OHCO=3
					 AND GSFL2K.OOHEAD.OHBRDT=CURDATE()-14 DAYS
					 AND GSFL2K.ITEMMAST.IMSI=(''N'')
					 AND GSFL2K.OOHEAD.OHOTYP NOT IN (''FO'',''TR'',''SA'',''DP'',''SO'')
					 AND GSFL2K.OOHEAD.OHBRUS NOT IN ('''') 
					 AND GSFL2K.OOLINE.OLINVU NOT IN (''T'')
			
			')	



GO


