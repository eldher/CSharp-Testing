USE [Exchange]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uSpControlCambioMotivoDevol]

@cod varchar(30)
AS

/*
Codigo
CodDetalle
codSubDetalle
*/

IF @cod='000'
SELECT * FROM mterroresdevolucion
ELSE
SELECT * FROM mterroresdevolucion 
WHERE (Codigo=@cod) 
	OR (CodDetalle=@cod) 
	OR (codSubDetalle=@cod)
	
--GROUP BY Codigo

--EXEC uSpControlCambioMotivoDevol @cod='000'
