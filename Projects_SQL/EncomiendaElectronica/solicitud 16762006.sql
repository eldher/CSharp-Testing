SELECT * FROM Trusadsolicitante WHERE solicitud ='16762006'

SELECT * FROM Trusadbeneficiario WHERE solicitud ='16762006'

SELECT * FROM Planilla_CadiviEspecial WHERE solicitud ='16762006'

SELECT * from Detalles_Cadivi where Opercadivi = '49180620135100064' 

SELECT * from Enlaces_Cadivi where operacioncierre = '49180620135100064' 

SELECT * FROM tLinksExchangeInstrument Where OperationSource='49021120136400001'

-- SELECT * FROM tLinksExchangeInstrument Where OperationSource='37030420141540002'

SELECT * FROM tMoneySendTransaction WHERE finalOperation='01100420149920001'

--SELECT * FROM tblrusadtransferencia WHERE auxiliarbenef = '17801449'



 EXEC uSpRetornaListaEncomiendasElectronicasESTCE 'CS','','','16762006','',0,'','' 
 

 
 
 
 
 SELECT DISTINCT                   
      ISNULL(t.idProvider,0) as idProvider,       
      ISNULL(s.Solicitud,'') as solicitud,       
      ISNULL(a.NomAgencia,'') AS nomAgencia,       
      ISNULL(s.Operacion,'') AS operacionSol,               
      ISNULL(s.Auxiliar_rep,'') AS cedulaRemitente,       
      ISNULL(c.Nombres,'') + ' ' + ISNULL(C.Apellido1,'') AS nombreRemitente,                
      ISNULL(t.finalOperation,'') AS operacionEnvio,       
      ISNULL(t.paymentkey,'') as clave,       
      ISNULL(t.fileName,'') as archivoEnvio,      
      ISNULL(s.Auxiliar_Est,'') AS cedulaBeneficiario,                    
      ISNULL(trb.Nombre_Benef1,'')+' '+ISNULL(trb.Apellido_Benef1,'') AS beneficiario,       
      ISNULL(t.stateDate,'') AS fechaEnvio,       
      ISNULL(t.paymentDate,'') AS fechaPagado,                                     
      ISNULL(t.amount,0) AS montoEnviado,                               
      CASE                               
       WHEN ISNULL(t.statedate,'') <> '' THEN       
        t.amount                           
       ELSE       
         0                              
      END AS enviado,                             
      CASE                              
       WHEN ISNULL(t.paymentdate,'') <> '' THEN       
        t.amount                              
       ELSE       
        0                               
      END AS pagado,                               
      ISNULL(s.fecha_enviocadivi,'') AS fecha_aprob_cadivi,       
      ISNULL(pm.pai_nombre,'') AS paisRecepcion,    
      ISNULL(c.Correo,'') AS correo,   
      t.stateService,
      s.OPERACIONCIERRE  
      
     SELECT *           
     FROM  planilla_cadivi s                     
     INNER JOIN Detalles_Cadivi dc on (dc.opercadivi = s.operacioncierre)                     
     INNER JOIN enlaces_Cadivi ec on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)            
     INNER JOIN enlaces e1 On ec.Operacion = e1.Operacion            
     INNER JOIN enlaces e2 ON e1.OperacionCierre = e2.Operacion             
     INNER JOIN tLinksExchangeInstrument L ON e2.operacionCierre = L.operationSource            
     INNER JOIN tmoneysendtransaction T ON (L.operationTarget = T.FinalOperation)       
               -- AND (t.providerAcronym = 'JP')                     
     INNER JOIN TRUSADBENEFICIARIO TRB ON (s.SOLICITUD = TRB.SOLICITUD AND s.Auxiliar_Est=TRB.AUXILIARBENEF)                
     INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND s.Auxiliar_Rep = TRS.AUXILIARSOL)            
     INNER JOIN Clientes C ON TRS.auxiliarsol = C.Auxiliar                           
     INNER JOIN MtPaisesmundo PM ON (TRB.Cod_Pais = PM.PAI_ISO3)          
     INNER JOIN MtEstadosmundo EM ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)            
     INNER JOIN AGENCIAS A ON (A.CODAGENCIA = s.CODAGENCIA)                     
     LEFT OUTER JOIN tblrusadtransferencia tt ON tt.solicitud = s.Solicitud and tt.auxiliarbenef = s.Auxiliar_EST                
     LEFT OUTER JOIN MtproviderAgents ba ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais                                                                                               
     WHERE  
       (ISNULL(t.stateService,'') <> 'A')                                                                
       AND (ISNULL(s.OPERACIONCIERRE,'') <> '')       
       --AND s.OPERACIONCIERRE <>''      
       