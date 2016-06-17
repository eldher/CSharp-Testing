--CORRER ESTO LUEGO
--GRANT ALL ON uSpRetornaListaEncomiendasElectronicasESTCE TO PUBLIC

ALTER PROC uSpRetornaListaEncomiendasElectronicasESTCE
/*
   Creado por Vladimir Yépez 17-07-2013
   Consulta aquellas operaciones que son de encomiendas electronicas
   para los distintos proveedores con Cambios de Proveedor, Estudiantes Casos Especiales.
*/
  @providerAcronym VARCHAR(5),
  @fechaDesde VARCHAR(10),
  @fechaHasta VARCHAR(10),
  @solicitud VARCHAR(20),
  @cedula VARCHAR(30),
  @codigoAgencia INT,
  @clave VARCHAR(60),
  @correo VARCHAR(60)
AS

DECLARE @sqlText VARCHAR(8000)

SET @sqlText = ' SELECT DISTINCT
ISNULL(t.idProvider,0) as idProvider,
ISNULL(s.Solicitud,'''') as solicitud,
ISNULL(a.NomAgencia,'''') AS nomAgencia,
ISNULL(s.Operacion,'''') AS operacionSol,
ISNULL(s.Auxiliar_Sol,'''') AS cedulaRemitente,
ISNULL(c.Nombres,'''') + '' '' + ISNULL(C.Apellido1,'''') AS nombreRemitente,
ISNULL(t.finalOperation,'''') AS operacionEnvio,
ISNULL(t.paymentkey,'''') as clave,
ISNULL(t.fileName,'''') as archivoEnvio,
ISNULL(s.Auxiliar_Benef,'''') AS cedulaBeneficiario,
ISNULL(trb.Nombre_Benef1,'''')+'' ''+ISNULL(trb.Apellido_Benef1,'''') AS beneficiario,
ISNULL(t.stateDate,'''') AS fechaEnvio,
ISNULL(t.paymentDate,'''') AS fechaPagado,
ISNULL(t.amount,0) AS montoEnviado,
CASE
WHEN ISNULL(t.statedate,'''') <> '''' THEN
t.amount
ELSE
 0
END AS enviado,
CASE
WHEN ISNULL(t.paymentdate,'''') <> '''' THEN
t.amount
ELSE
0
END AS pagado,
ISNULL(s.fecha_enviocadivi,'''') AS fecha_aprob_cadivi,
ISNULL(m.pai_nombre,'''') AS paisRecepcion,
ISNULL(c.Correo,'''') AS correo
FROM  planilla_cadiviespecial S
INNER JOIN Detalles_Cadivi B on (B.opercadivi = S.operacioncierre)
INNER JOIN enlaces_Cadivi EC on (EC.operacioncierre = B.opercadivi and EC.operdetalle=B.operacion)
INNER JOIN Enlaces EL ON (EC.Operacion = EL.OperacionCierre)
INNER JOIN TRUSADBENEFICIARIO TRB ON (S.SOLICITUD = TRB.SOLICITUD AND S.Auxiliar_Benef =TRB.AUXILIARBENEF)
INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND  S.Auxiliar_Sol = TRS.AUXILIARSOL)
INNER JOIN tLinksExchangeInstrument Tl ON (EC.OPERACION= Tl.OPERATIONSOURCE OR EC.Operacion = TL.operationTarget OR EC.OperacionCierre= Tl.OPERATIONSOURCE OR EC.OperacionCierre= Tl.OPERATIONTARGET )
INNER JOIN tmoneysendtransaction T ON (TL.operationTarget = T.FinalOperation)
	AND (t.providerAcronym = ' +  CHAR(39) + @providerAcronym + CHAR(39) + ')
INNER JOIN Clientes C ON (TRS.auxiliarsol = C.Auxiliar)
INNER JOIN AGENCIAS A ON (A.CODAGENCIA = S.CODAGENCIA)
LEFT JOIN  MtPaisesmundo M ON m.pai_iso3 = T.rcvCountry
WHERE
ISNULL(t.stateService,'''') <> ''A''
AND ISNULL(S.OPERACIONCIERRE,'''') <> ''''
AND S.OPERACIONCIERRE <> '''''
IF (@solicitud <> '')
BEGIN
SET @sqlText = @sqlText  + 'AND s.solicitud = ' + CHAR(39) + @solicitud + CHAR(39)
END

IF (@fechaDesde <> '' AND @fechaHasta <> '')
BEGIN
SET @sqlText = @sqlText  + ' AND datediff(dd,convert(datetime,s.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaDesde + CHAR(39) + ',103))<=0
                   AND datediff(dd,convert(datetime,s.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaHasta + CHAR(39) + ',103))>=0'
     END

     IF (@codigoAgencia > 0)
     BEGIN
        SET @sqlText = @sqlText  + ' AND s.CodAgencia = ' + CONVERT(VARCHAR(25),@codigoAgencia)
     END

     IF(@cedula <> '')
     BEGIN
     SET @sqlText = @sqlText  + ' AND s.Auxiliar_Sol = ' + CHAR(39) + @cedula + CHAR(39)
     END

     IF(@clave <> '')
  BEGIN
    SET @sqlText = @sqlText  + ' AND t.paymentkey = ' + CHAR(39) + @clave + CHAR(39)
  END

   IF(@correo <> '')
   BEGIN
    SET @sqlText = @sqlText  + ' AND c.Correo = ' + CHAR(39) + @correo + CHAR(39)
   END

SET @sqlText = @sqlText + '
UNION

		SELECT DISTINCT
		ISNULL(t.idProvider,0) as idProvider,
		ISNULL(s.Solicitud,'''') as solicitud,
		ISNULL(a.NomAgencia,'''') AS nomAgencia,
		ISNULL(s.Operacion,'''') AS operacionSol,
		ISNULL(s.Auxiliar_rep,'''') AS cedulaRemitente,
		ISNULL(c.Nombres,'''') + '' '' + ISNULL(C.Apellido1,'''') AS nombreRemitente,
		ISNULL(t.finalOperation,'''') AS operacionEnvio,
		ISNULL(t.paymentkey,'''') as clave,
		ISNULL(t.fileName,'''') as archivoEnvio,
		ISNULL(s.Auxiliar_Est,'''') AS cedulaBeneficiario,
		ISNULL(trb.Nombre_Benef1,'''')+'' ''+ISNULL(trb.Apellido_Benef1,'''') AS beneficiario,
		ISNULL(t.stateDate,'''') AS fechaEnvio,
		ISNULL(t.paymentDate,'''') AS fechaPagado,
		ISNULL(t.amount,0) AS montoEnviado,
		CASE
		WHEN ISNULL(t.statedate,'''') <> '''' THEN
		t.amount
		ELSE
		0
		END AS enviado,
		CASE
		WHEN ISNULL(t.paymentdate,'''') <> '''' THEN
		t.amount
		ELSE
		0
		END AS pagado,
		ISNULL(s.fecha_enviocadivi,'''') AS fecha_aprob_cadivi,
		ISNULL(pm.pai_nombre,'''') AS paisRecepcion,
		ISNULL(c.Correo,'''') AS correo
		FROM  planilla_cadivi s
		INNER JOIN Detalles_Cadivi dc on (dc.opercadivi = s.operacioncierre)
		INNER JOIN enlaces_Cadivi ec on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)
		INNER JOIN enlaces e1 On ec.Operacion = e1.Operacion OR ec.Operacion = e1.OperacionCierre
		INNER JOIN enlaces e2 ON e1.OperacionCierre = e2.Operacion OR e1.OperacionCierre = e2.OperacionCierre
		INNER JOIN tLinksExchangeInstrument L ON e2.operacionCierre = L.operationSource
		INNER JOIN tmoneysendtransaction T ON (L.operationTarget = T.FinalOperation)
		AND (t.providerAcronym = ' +  CHAR(39) + @providerAcronym + CHAR(39) + ')
		INNER JOIN TRUSADBENEFICIARIO TRB ON (s.SOLICITUD = TRB.SOLICITUD AND s.Auxiliar_Est=TRB.AUXILIARBENEF)
		INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND s.Auxiliar_Rep = TRS.AUXILIARSOL)
		INNER JOIN Clientes C ON TRS.auxiliarsol = C.Auxiliar
		INNER JOIN MtPaisesmundo PM ON (TRB.Cod_Pais = PM.PAI_ISO3)
		INNER JOIN MtEstadosmundo EM ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)
		INNER JOIN AGENCIAS A ON (A.CODAGENCIA = s.CODAGENCIA)
		LEFT OUTER JOIN tblrusadtransferencia tt ON tt.solicitud = s.Solicitud and tt.auxiliarbenef = s.Auxiliar_EST
		LEFT OUTER JOIN MtproviderAgents ba ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais
		WHERE
		ISNULL(t.stateService,'''') <> ''A''
		AND ISNULL(s.OPERACIONCIERRE,'''') <> ''''
		AND s.OPERACIONCIERRE <> '''''
  IF (@solicitud <> '')
  BEGIN
   SET @sqlText = @sqlText  + 'AND s.solicitud = ' + CHAR(39) + @solicitud + CHAR(39)
  END

  IF (@fechaDesde <> '' AND @fechaHasta <> '')
  BEGIN
   SET @sqlText = @sqlText  + ' AND datediff(dd,convert(datetime,s.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaDesde + CHAR(39) + ',103))<=0
                       AND datediff(dd,convert(datetime,s.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaHasta + CHAR(39) + ',103))>=0'
  END

  IF (@codigoAgencia > 0)
  BEGIN
   SET @sqlText = @sqlText  + ' AND s.CodAgencia = ' + CONVERT(VARCHAR(25),@codigoAgencia)
  END

  IF(@cedula <> '')
  BEGIN
   SET @sqlText = @sqlText  + ' AND s.Auxiliar_Sol = ' + CHAR(39) + @cedula + CHAR(39)
  END

  IF(@clave <> '')
  BEGIN
  SET @sqlText = @sqlText  + ' AND t.paymentkey = ' + CHAR(39) + @clave + CHAR(39)
  END

  IF(@correo <> '')
  BEGIN
 SET @sqlText = @sqlText  + ' AND c.Correo = ' + CHAR(39) + @correo + CHAR(39)
  END



 --------------   *********************************
 -------------     FIX MONEYGRAM		16/07/2014
 --------------   **********************************


   SET @sqlText = @sqlText + '
      UNION
SELECT DISTINCT
		ISNULL(t.idProvider,0) as idProvider,
		ISNULL(PCE.Solicitud,'''') as solicitud,
		ISNULL(a.NomAgencia,'''') AS nomAgencia,
		ISNULL(PCE.Operacion,'''') AS operacionSol,
		ISNULL(PCE.Auxiliar_Sol,'''') AS cedulaRemitente,
		ISNULL(c.Nombres,'''') + '' '' + ISNULL(C.Apellido1,'''') AS nombreRemitente,
		ISNULL(t.finalOperation,'''') AS operacionEnvio,
		ISNULL(t.paymentkey,'''') as clave,
		ISNULL(t.fileName,'''') as archivoEnvio,
		ISNULL(PCE.Auxiliar_Benef,'''') AS cedulaBeneficiario,
		ISNULL(trb.Nombre_Benef1,'''')+'' ''+ISNULL(trb.Apellido_Benef1,'''') AS beneficiario,
		ISNULL(t.stateDate,'''') AS fechaEnvio,
		ISNULL(t.paymentDate,'''') AS fechaPagado,
		ISNULL(t.amount,0) AS montoEnviado,
		CASE
		WHEN ISNULL(t.statedate,'''') <> '''' THEN
		t.amount
		ELSE
		 0
		END AS enviado,
		CASE
		WHEN ISNULL(t.paymentdate,'''') <> '''' THEN
		t.amount
		ELSE
		0
		END AS pagado,
		ISNULL(PCE.fecha_enviocadivi,'''') AS fecha_aprob_cadivi,
		ISNULL(MPais.pai_nombre,'''') AS paisRecepcion,
		ISNULL(c.Correo,'''') AS correo
		
		FROM tMoneySendTransaction t
		inner join tLinksExchangeInstrument TL on t.finalOperation = TL.operationTarget
		inner join moneygram m on m.OperacionCierre = TL.operationSource
		inner join Enlaces EN ON EN.OperacionCierre = m.Operacion
		inner join Enlaces_Cadivi EC ON EC.Operacion = EN.Operacion
		INNER JOIN Detalles_Cadivi DC ON EC.OperacionCierre  = dc.OperCadivi
		inner join Planilla_CadiviEspecial PCE ON PCE.OperacionCierre = DC.OperCadivi
		INNER JOIN TRUSADBENEFICIARIO TRB ON (PCE.SOLICITUD = TRB.SOLICITUD AND PCE.Auxiliar_Benef =TRB.AUXILIARBENEF)
		INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND  PCE.Auxiliar_Sol = TRS.AUXILIARSOL)
		INNER JOIN Clientes C ON (TRS.auxiliarsol = C.Auxiliar)
		INNER JOIN AGENCIAS A ON (A.CODAGENCIA = PCE.CODAGENCIA)
		LEFT JOIN  MtPaisesmundo MPais ON MPais.pai_iso3 = T.rcvCountry

		WHERE
		ISNULL(t.stateService,'''') <> ''A''
		AND ISNULL(PCE.OPERACIONCIERRE,'''') <> ''''
		AND PCE.OPERACIONCIERRE <> '''''


  IF (@solicitud <> '')
  BEGIN
  SET @sqlText = @sqlText  + 'AND PCE.solicitud = ' + CHAR(39) + @solicitud + CHAR(39)
  END

  IF (@fechaDesde <> '' AND @fechaHasta <> '')
  BEGIN
  SET @sqlText = @sqlText  + ' AND datediff(dd,convert(datetime,PCE.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaDesde + CHAR(39) + ',103))<=0
                   AND datediff(dd,convert(datetime,PCE.Fecha_enviocadivi,103),convert(datetime,' + CHAR(39) + @fechaHasta + CHAR(39) + ',103))>=0'
     END

     IF (@codigoAgencia > 0)
     BEGIN
        SET @sqlText = @sqlText  + ' AND PCE.CodAgencia = ' + CONVERT(VARCHAR(25),@codigoAgencia)
     END

     IF(@cedula <> '')
     BEGIN
     SET @sqlText = @sqlText  + ' AND PCE.Auxiliar_Sol = ' + CHAR(39) + @cedula + CHAR(39)
     END

     IF(@clave <> '')
  BEGIN
    SET @sqlText = @sqlText  + ' AND t.paymentkey = ' + CHAR(39) + @clave + CHAR(39)
  END

   IF(@correo <> '')
   BEGIN
    SET @sqlText = @sqlText  + ' AND c.Correo = ' + CHAR(39) + @correo + CHAR(39)
   END




--PRINT  @sqlText
EXEC (@sqlText)

--********************************************************************************************************
--********************************************************************************************************
--EXEC uSpRetornaListaEncomiendasElectronicasESTCE 'CS','','','17986242','',0,'',''