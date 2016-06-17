CREATE PROCEDURE [dbo].[SpConsultarStatusGiros]
@solicitud varchar(40)
AS




select Solicitud, CONVERT(datetime,Fecha,121) as Fecha, ISNULL(  MER.SubDetalle + ' // ' + SUBSTRING(TC.Observacion,9,LEN(TC.Observacion)),'')  AS Observacion , Usuario, Tipo,Accion from tStatusContraloria TC
inner join MtErroresDevolucion MER ON (SUBSTRING (TC.Observacion,1,8) = MER.CodSubDetalle)
where solicitud  = @solicitud
and TC.observacion IS NOT NULL
ORDER BY fecha DESC

