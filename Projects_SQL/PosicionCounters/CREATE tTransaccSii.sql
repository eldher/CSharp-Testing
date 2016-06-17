USE [Exchange]
GO

/****** Object:  Table [dbo].[Transacc]    Script Date: 05/13/2014 16:28:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tTransaccSII](
	[CodTransaccion] [int] NOT NULL,
	[NomTransaccion] [varchar](40) NOT NULL,
 CONSTRAINT [PK_tTransaccSII] PRIMARY KEY NONCLUSTERED 
(
	[CodTransaccion] ASC
)
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


