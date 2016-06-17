USE [Exchange]
GO

/****** Object:  Table [dbo].[tPosicion]    Script Date: 05/13/2014 16:14:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tPosicionSII](
	[Operacion] [varchar](30) NOT NULL,
	[CodTipo] [int] NOT NULL,
	[Divisa] [varchar](6) NOT NULL,
	[MontoDivisa] [money] NOT NULL,
	[TasaCambio] [real] NOT NULL,
	[MontoBs] [money] NOT NULL,
	[TasaRef] [real] NOT NULL,
	[FixingRef] [real] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CodUsuario] [varchar](20) NOT NULL,
	[CodUsuarioRec] [varchar](20) NULL,
	[CodAgencia] [int] NOT NULL,
	[CodTransaccion] [int] NOT NULL,
	[Estado] [varchar](1) NOT NULL,
	[Cantidad] [varchar](6) NULL,
PRIMARY KEY CLUSTERED 
(
	[Operacion] ASC,
	[CodTipo] ASC,
	[Divisa] ASC
)
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


