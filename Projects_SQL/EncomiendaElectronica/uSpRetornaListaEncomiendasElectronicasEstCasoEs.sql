--grant all on uSpRetornaListaPaisesPorProveedor to public        
        
        
          
--CORRER ESTO LUEGO          
--GRANT ALL ON uSpRetornaListaEncomiendasElectronicasESTCE TO PUBLIC          
          
ALTER PROC uSpRetornaListaEncomiendasElectronicasEstCasoEs          
/*          
   Creado por Eldher Hernandez 14-05-2014    
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
      ISNULL(s.Auxiliar_Rep,'''') AS cedulaRemitente,           
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
      ISNULL(m.pai_nombre,'''') AS paisRecepcion,        
      ISNULL(c.Correo,'''') AS correo                             
      FROM  planilla_cadivi S                  
       INNER JOIN Detalles_Cadivi B on (B.opercadivi = S.operacioncierre)                        
       INNER JOIN enlaces_Cadivi EC on (EC.operacioncierre = B.opercadivi and EC.operdetalle=B.operacion)                    
       INNER JOIN Enlaces EL ON (EC.Operacion = EL.OperacionCierre)                                                                    
       INNER JOIN TRUSADBENEFICIARIO TRB ON (S.SOLICITUD = TRB.SOLICITUD )                                                              
       INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD )                         
       INNER JOIN tmoneysendtransaction T ON (EL.OperacionCierre = T.FinalOperation)           
               AND (t.providerAcronym = ' +  CHAR(39) + @providerAcronym + CHAR(39) + ')                                                        
       INNER JOIN Clientes C ON (TRS.auxiliarsol = C.Auxiliar)                 
       INNER JOIN AGENCIAS A ON (A.CODAGENCIA = S.CODAGENCIA)                  
       LEFT JOIN  MtPaisesmundo M ON m.pai_iso3 = T.rcvCountry                                 
      WHERE                                     
        ISNULL(S.OPERACIONCIERRE,'''') <> ''''           
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
     SET @sqlText = @sqlText  + ' AND s.Auxiliar_Rep = ' + CHAR(39) + @cedula + CHAR(39)                
     END         
             
     IF(@clave <> '')                    
  BEGIN        
    SET @sqlText = @sqlText  + ' AND t.paymentkey = ' + CHAR(39) + @clave + CHAR(39)             
  END         
          
   IF(@correo <> '')                    
   BEGIN        
    SET @sqlText = @sqlText  + ' AND c.Correo = ' + CHAR(39) + @correo + CHAR(39)         
   END             
                  
     
     
     
                    
 SET @sqlText = @sqlText + ' UNION'    
     
     
     
         
    
  SET @sqlText = @sqlText + ' SELECT DISTINCT                       
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
       INNER JOIN tmoneysendtransaction T ON (EL.OperacionCierre = T.FinalOperation)           
               AND (t.providerAcronym = ' +  CHAR(39) + @providerAcronym + CHAR(39) + ')              
       INNER JOIN Clientes C ON (TRS.auxiliarsol = C.Auxiliar)                 
       INNER JOIN AGENCIAS A ON (A.CODAGENCIA = S.CODAGENCIA)                  
       LEFT JOIN  MtPaisesmundo M ON m.pai_iso3 = T.rcvCountry                                 
      WHERE                                     
        ISNULL(S.OPERACIONCIERRE,'''') <> ''''           
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
     SET @sqlText = @sqlText  + ' AND S.Auxiliar_Sol = ' + CHAR(39) + @cedula + CHAR(39)                
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

--begin tran
-- EXEC uSpRetornaListaEncomiendasElectronicasEstCasoEs 'CS','','','','V6526563',0,'',''  
--rollback tran
 
