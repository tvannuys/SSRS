USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[GLBalanceExtract]    Script Date: 01/17/2013 14:45:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter proc [dbo].[GLBalanceExtract] as

drop table glBalance

select * 
into GLBalance
from openquery (GSFL2K,'
select gbco,
gbloc,
lcname,
gbgl#,
gldesc,
gbyr,
gbopbl,
gba01,
gba02,
gba03,
gba04,
gba05,
gba06,
gba07,
gba08,
gba09,
gba10,
gba11,
gba12


from GLBAL 
left join location on (glbal.gbco = location.lcco
	and glbal.gbloc = location.lcloc)
left join glmast on (glbal.gbco = glmast.glco
	and glbal.gbgl# = glmast.glgl#)

where gbyr >= 2010
')







GO


