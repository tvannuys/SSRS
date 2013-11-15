USE [GartmanReport]
GO

/****** Object:  Table [dbo].[WarehouseProductivity]    Script Date: 10/18/2013 14:31:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
-- Add Hours column -----------------------------------------------------------
CREATE TABLE [dbo].[WarehouseProductivityV2](
	[Company] [numeric](3, 0) NULL,
	[Location] [numeric](2, 0) NULL,
	[RFDate] [datetime] NULL,
	[Dept] [float] NULL,
	[RFUser] [varchar](10) NULL,
	[Metric] [varchar](50) NULL,
	[Daily] [varchar](50) NULL,
	[Value] [varchar](50) NULL,
	[Hours] [float] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


