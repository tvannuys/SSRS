USE [JAMEST]
GO

/****** Object:  StoredProcedure [dbo].[JT_Test_SVN]    Script Date: 07/30/2012 13:37:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- Test out addition to PROC for the SVN
ALTER PROC [dbo].[JT_Test_SVN] AS
BEGIN
	IF DATEPART(dw,GETDATE()) = 6
		PRINT 'It is Firday!';
	ELSE
		PRINT 'Other day of the week...';
END





GO


