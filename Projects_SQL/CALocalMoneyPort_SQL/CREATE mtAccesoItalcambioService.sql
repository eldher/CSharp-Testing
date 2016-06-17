USE [Exchange]
GO

/****** Object:  Table [dbo].[mtAccesoItalcambioService]    Script Date: 06/12/2014 15:40:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[mtAccesoItalcambioService](
	[id] [int] NOT NULL,
	[sendProviderAcronym] [varchar](5) NOT NULL,
	[sendLogin] [varchar](50) NOT NULL,
	[sendPassword] [varchar](50) NOT NULL,
	[receiptIdCompany] [varchar](5) NULL,
	[Pai_Iso3] [varchar](5) NOT NULL,
	[status] [varchar](5) NOT NULL,
	[description] [varchar](300) NULL,
	[receiptNameCompany] [varchar](100) NULL,
	[requestType] [varchar](20) NULL,
	[currencyPayment] [varchar](5) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


