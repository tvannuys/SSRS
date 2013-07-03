USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spReadTempItems]    Script Date: 07/02/2013 16:36:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spReadTempItems] as

create table ##TempItemList (imitem char(18))

exec spGetPriceExceptionItems_PRCD

select * from ##TempItemList

drop table ##TempItemList

GO


