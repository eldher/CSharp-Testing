 
            
ALTER VIEW [dbo].[UVWGirostMoneySendTransaction]                                                                  
                                      
AS                                                                  
                      
  /*Se agregó                    
  CodTipoTransaccion Identifica con un codigo el tipo de transaccion                    
  6  = remesas familiares                    
  7  = casos especiales / pension                    
  10 = estudiantes                    
  Esto debido a que en RAH los tipos de de transaccion estan codificados de esta manera               
  --ayharik 30/01 se agregaron los with (nolock) y se acomodaron las condiciones en el orden logico                     
   */                                        
SELECT DISTINCT                                          
   t.idProvider as Id,                                            
   convert(varchar,getdate(),103) as transmitionDate,                                         
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,                                          
   REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                                         
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName,                                          
   TRS.AuxiliarSol AS SenderId,                                           
   TRS.direccion_Sol AS SenderAddress,                                             
   ISNULL(c.TC_Numero,'') as SenderPhone,                                         
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                         
   ISNULL(C.DH_Estado,'') AS SenderState,                                         
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                                        
   ISNULL(C.DH_Pais,'') AS SenderCountry,                                           
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                         
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                          
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','')  AS ReceiveName,                                        
   TRB.AuxiliarBenef AS ReceiveId,                                           
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,                                          
   CASE                                           
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                          
      ELSE trb.ciudad_benef                                        
   END AS ReceiveCity,                                           
   EM.EST_NOMBRE AS ReceiveState,                                          
   trb.cod_pais as ReceiveCountry,                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                         
   ' ' as ReceivePhone2,                                                 
   CASE   WHEN trb.depositoenCuenta = 'S' THEN 'B'       ELSE 'O'     END AS PaymentType,                                         
   B.Monto_Benef  AS amount,                                          
   1 as ExchangeRate,                                         
   t.feeAmount,                                           
   'D' AS CurrencyPaymentType,                                         
   CASE                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                         
       ELSE ''                                         
   END AS BankName,                                         
   CASE                                              
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                           
       ELSE 0                                          
   END AS BankCode,                                         
 ISNULL(ba.AgentName,' ') as  AgentName,                                         
   CASE                  
      WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                          
      ELSE ''                                         
   END AS AccountType,                                           
   CASE                                             
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                         
       ELSE  ''                                           
   END AS  AccountNumber,                            
   T.FinalOperation,                                            
   trb.Solicitud,                                           
   rfs.Fecha_Sol,                                         
   t.paymentKey AS Clave_IOSS,                                         
   b.fecha_aprob_cadivi,                                         
   b.fecha_bcv,                                        
   b.fecha_devolucion,                      
   CASE                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba                                         
       ELSE ''                                       
   END ABBA,                                          
   CASE                                         
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                           
       ELSE ''                                           
   END AS IBAN,                                          
   CASE                                           
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                           
       ELSE   ''                                          
   END SWIFT,                                            
   t.providerAcronym,                                        
   trb.agent as returnNumber,                             
   B.Operacion as operation,                    
   '6' AS CodTipoTransaccion                                         
FROM REMESAS_FAMILIARESBENEF B with(nolock)                                          
INNER JOIN   tmoneysendtransaction T with(nolock)ON  T.FinalOperation=B.operacionfinal and t.providerAcronym=b.Instrumento                    
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )               
AND ((datediff(dd,t.timeStamp,GETDATE()))<=45 AND (datediff(dd,t.timeStamp,GETDATE()))>=0 )                                       
INNER JOIN  TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=B.SOLICITUD AND TRB.AUXILIARBENEF=B.AUXILIAR_BENEF)                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=B.AUXILIAR_SOL)                             
INNER JOIN  dbo.remesas_familiaressol RFS with(nolock)ON (RFS.OPERACION = B.OPERACIONSOL)                                                                   
INNER JOIN  Clientes C with(nolock)ON  C.Auxiliar =TRS.auxiliarsol                            
INNER JOIN  MtPaisesmundo PM with(nolock)ON (PM.PAI_ISO3=TRB.Cod_Pais)                                         
INNER JOIN MtEstadosmundo EM  with(nolock)ON (EM.PAI_ISO2=PM.PAI_ISO2  AND  EM.COD_ESTADO=TRB.Cod_Estado)                                        
LEFT JOIN  tblrusadtransferencia tt with(nolock)ON tt.solicitud = b.Solicitud and tt.auxiliarbenef = b.Auxiliar_Benef                                            
LEFT JOIN MtproviderAgents ba  with(nolock)ON ba.returnnumber = trb.Agent and ba.providerAcronym = t.providerAcronym  and ba.iso3Code = b.Cod_Pais                                         
--WHERE  ISNULL(t.finaloperation,'') <> '' and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL                                          
--AND ((datediff(dd,timeStamp,GETDATE()))<=45 AND (datediff(dd,timeStamp,GETDATE()))>=0 )                              
----and t.providerAcronym = 'CS'                                    
            
                                        
UNION                                                                  
                                          
SELECT DISTINCT   t.idProvider as Id, convert(varchar,getdate(),103) as transmitionDate,REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,                                                                  
   REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName,                                                                  
   TRS.AuxiliarSol AS SenderId,TRS.direccion_Sol AS SenderAddress, ISNULL(c.TC_Numero,'') as SenderPhone, ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
   ISNULL(C.DH_Estado,'') AS SenderState,ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,ISNULL(C.DH_Pais,'') AS SenderCountry,                                                                       
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName, REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','')  AS ReceiveName,                                                                  
   TRB.AuxiliarBenef as ReceiveId, REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,                                         
   CASE  WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')  ELSE trb.ciudad_benef  END AS ReceiveCity,                                         
   EM.EST_NOMBRE AS ReceiveState, trb.cod_pais as ReceiveCountry, TRB.TELEFONO_BENEF as ReceivePhone1, ' ' as ReceivePhone2,                                                                  
  CASE  WHEN trb.depositoenCuenta = 'S' THEN 'B' ELSE 'O'  END AS PaymentType,                                                                  
  B.Monto_Benef  AS amount, 1 as ExchangeRate,t.feeAmount, 'D' CurrencyPaymentType,                                                
   CASE WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')  ELSE '' END AS BankName,                                                           
   CASE WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ') ELSE 0 END AS BankCode,                                                        
  ISNULL(ba.AgentName,' ') as  AgentName,                                                                  
  CASE  WHEN trb.depositoenCuenta = 'S' THEN 'CC' ELSE '' END AS AccountType,                                                                  
  CASE WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ') ELSE  ''  END AS  AccountNumber,                                                                    
  T.FinalOperation, trb.Solicitud,rfs.Fecha_Sol, t.paymentKey AS Clave_IOSS, b.fecha_aprob_cadivi,                                                                    
b.fecha_bcv, b.fecha_devolucion,                                                                  
  CASE  WHEN trb.depositoenCuenta = 'S' THEN tt.abba  ELSE '' END ABBA,                                                                      
  CASE  WHEN trb.depositoenCuenta = 'S' THEN tt.iban  ELSE '' END AS IBAN,                                                              
  CASE  WHEN trb.depositoenCuenta = 'S' THEN tt.swift  ELSE   '' END SWIFT,                                                         
  t.providerAcronym, trb.agent as returnNumber,                            
  B.Operacion as operation,                    
  '6' AS CodTipoTransaccion                                       
FROM REMESAS_FAMILIARESBENEF B  with(nolock)                                        
INNER JOIN   tLinksExchangeInstrument L with(nolock) ON  L.OperationSource =B.OperacionFinal                                         
INNER JOIN   tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget               
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                            
INNER JOIN   TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=B.SOLICITUD   AND TRB.AUXILIARBENEF=B.AUXILIAR_BENEF)                                                       
INNER JOIN  TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND TRS.AUXILIARSOL=B.AUXILIAR_SOL)                                          
INNER JOIN   dbo.remesas_familiaressol RFS  with(nolock)ON (RFS.OPERACION = B.OPERACIONSOL)                                        
INNER JOIN Clientes C  with(nolock)ON  C.Auxiliar  =TRS.auxiliarsol                                        
INNER JOIN   MtPaisesmundo PM ON (PM.PAI_ISO3=TRB.Cod_Pais)                                         
INNER JOIN  MtEstadosmundo EM ON (EM.PAI_ISO2=PM.PAI_ISO2 AND EM.COD_ESTADO=TRB.Cod_Estado)                                        
LEFT OUTER JOIN   tblrusadtransferencia tt with(nolock)ON tt.solicitud = b.Solicitud and tt.auxiliarbenef = b.Auxiliar_Benef                                         
LEFT OUTER JOIN   MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = l.modifiedInstrument and ba.iso3Code = b.Cod_Pais                                         
--WHERE ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL                                        
                                   
--************************                                                
                                        
UNION                                                
                                          
--*******************CAMBIO DE INSTRUMENTO*****                                         
 SELECT DISTINCT   t.idProvider as Id,convert(varchar,getdate(),103) as transmitionDate,    
                                          
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,  REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                                         
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName, TRS.AuxiliarSol AS SenderId,                                                                   
                                          
   TRS.direccion_Sol AS SenderAddress,                                                              
                                          
   ISNULL(c.TC_Numero,'') as SenderPhone,                                                              
                                          
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
                                          
   ISNULL(C.DH_Estado,'') AS SenderState,                                                                       
                                          
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                                                                         
                                          
   ISNULL(C.DH_Pais,'') AS SenderCountry,                          
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                                                  
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
                                
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','') AS ReceiveName,                                                                  
                                          
   TRB.AuxiliarBenef as ReceiveId,                                                                   
                                          
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,      
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                   
                                     
  ELSE trb.ciudad_benef                                                                   
                                          
   END AS ReceiveCity,                                                         
                                          
   EM.EST_NOMBRE AS ReceiveState,                                                                   
       
   trb.cod_pais as ReceiveCountry,                                                       
                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                                                  
                                          
   ' ' as ReceivePhone2,                                                                  
               
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'B'                                                                  
                                          
      ELSE 'O'                                                                   
                                          
   END AS PaymentType,                                                                  
                                          
   EC.MontoDivisa AS amount,                                      
                                          
   1 as ExchangeRate,                                                         
                                          
   t.feeAmount,                                                                 
                  
   'D' CurrencyPaymentType,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                
                                          
       ELSE ''                                                           
                                          
   END AS BankName,                                                           
                 
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                                                  
                                          
       ELSE 0                                                           
                                          
   END AS BankCode,                                                       
                                          
   ISNULL(ba.AgentName,' ') as  AgentName,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                                          
                                          
      ELSE ''                                                                   
                                          
   END AS AccountType,                                                                  
                                          
 CASE                                        
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                                                  
                                          
       ELSE  ''                                                      
                                          
   END AS  AccountNumber,                                                                    
                                          
   T.FinalOperation,                                                                                      
                                          
   trb.Solicitud,                      
                                          
   pc.Fecha_Ger as Fecha_Sol,                                                                                                   
                                          
   t.paymentKey AS Clave_IOSS,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_aprob_cadivi,                                                                    
                                     
   dc.Fecha_Aprobado as fecha_bcv,                                                                    
                                          
   dc.Fecha_Aprobado+30  as fecha_devolucion,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba                                        
                                          
       ELSE ''                                                          
                                          
   END ABBA,                                                                      
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                                     
                                          
ELSE ''                                                          
                                          
   END AS IBAN,                                                              
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                                          
                                          
       ELSE   ''                                                          
                   
   END SWIFT,                                        
                                          
   t.providerAcronym,                                                          
                                          
   trb.agent as returnNumber,                            
   ''  as operation,                                                        
   '10' AS  CodTipoTransaccion       
                                 
FROM  planilla_cadivi pc  with(nolock)                         
                                        
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                          
                                         
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)     
                                  
INNER JOIN Enlaces E ON (E.Operacion = EC.Operacion)                
      
INNER JOIN Enlaces E1 ON ((E1.Operacion = E.OperacionCierre))           
      
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E1.OperacionCierre    
                                
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget              
              
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                  
                                          
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                          
                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                           
                                          
INNER JOIN Clientes C with(nolock)ON C.Auxiliar =TRS.auxiliarsol                                                        
                                          
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                     
                                 
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                           
                                          
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                                    
                                          
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais                                                                                                     
  
       
    
                                        
--WHERE ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL                                                 
                                       
                                              
                                          
--************************                                                
                                          
UNION                                                
                                          
--************************                                               
                                          
                                            
                                          
SELECT DISTINCT                                                                   
                                          
   t.idProvider as Id,                                                                  
                                          
   convert(varchar,getdate(),103) as transmitionDate,                                                                   
                                          
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,                                                                  
                                          
   REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                                                                  
                                          
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName,                                 
                                          
   TRS.AuxiliarSol AS SenderId,                                                                   
                                          
   TRS.direccion_Sol AS SenderAddress,                                                              
                                          
   ISNULL(c.TC_Numero,'') as SenderPhone,                                                              
                                          
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
                                          
   ISNULL(C.DH_Estado,'') AS SenderState,                                                                       
                                          
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                         
                                          
   ISNULL(C.DH_Pais,'') AS SenderCountry,                                              
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                                                  
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
                                    
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','') AS ReceiveName,                                                                  
                                          
   TRB.AuxiliarBenef as ReceiveId,                                                                   
                                          
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,                                                                  
                      
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                 
                                          
      ELSE trb.ciudad_benef                                                                   
                                          
   END AS ReceiveCity,                                                         
                                          
   EM.EST_NOMBRE AS ReceiveState,                                                                   
                                
   trb.cod_pais as ReceiveCountry,                                                                  
                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                                                  
                                          
   ' ' as ReceivePhone2,                                                                  
                                 
   CASE                                                                  
                                       
      WHEN trb.depositoenCuenta = 'S' THEN 'B'                                                                  
                                          
      ELSE 'O'                                                                   
                                          
   END AS PaymentType,                                                                  
                                          
   EC.MontoDivisa AS amount,                                                                
                                          
   1 as ExchangeRate,                                                         
                                          
   t.feeAmount,                                                                 
                                          
   'D' CurrencyPaymentType,                                                                  
                                          
   CASE                      
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                  
                                          
       ELSE ''                                                           
                                          
   END AS BankName,                                                           
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                                                  
                                          
       ELSE 0                                                           
                                          
   END AS BankCode,                                                        
                                       
   ISNULL(ba.AgentName,' ') as  AgentName,                                                             
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                                                  
                                          
      ELSE ''                                                          
                  
   END AS AccountType,                                                  
                                          
      CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                                                  
                                          
       ELSE  ''                                                          
                                          
   END AS  AccountNumber,                                                                    
                       
   T.FinalOperation,                                                                                      
                                          
   trb.Solicitud,                                                                                       
                                          
   pce.Fecha_Ger as Fecha_Sol,                                      
                                          
   t.paymentKey AS Clave_IOSS,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_aprob_cadivi,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_bcv,                                                                    
                                          
   dc.Fecha_Aprobado+30  as fecha_devolucion,                                                                  
                
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba         
                                          
       ELSE ''                                                          
                                          
   END ABBA,                                                                      
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                                          
                                          
       ELSE ''                                                          
                                          
   END AS IBAN,                                                              
                                     
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                  
                                          
       ELSE   ''                                                          
                                          
   END SWIFT,                                                                 
                                          
   t.providerAcronym,                                                          
                                          
   trb.agent as returnNumber,                            
   '' as operation,                    
   '7' AS CodTipoTransaccion                                                        
                                          
FROM  planilla_cadiviespecial pce  with(nolock)                                    
                   
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pce.operacioncierre=dc.opercadivi )                                                    
                                          
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                
                                          
INNER JOIN Enlaces e with(nolock)ON  e.Operacion=ec.Operacion -- OR  el.OperacionCierre=ec.Operacion                                        
            
inner join Enlaces E1 with(nolock)ON  e1.Operacion=e.OperacionCIERRE            
              
INNER JOIN tmoneysendtransaction T with(nolock) ON  T.FinalOperation=E1.OperacionCIERRE               
              
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                        
                                          
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PCe.SOLICITUD AND TRB.AUXILIARBENEF=pce.Auxiliar_Benef)                                                                               
                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=pce.Auxiliar_Sol)                     
                                          
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar   =TRS.auxiliarsol                                                                                                                           
                                          
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                     
                                          
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                           
                                          
                                    
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = pce.Solicitud and tt.auxiliarbenef = pce.Auxiliar_Sol                                                                    
                                          
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais            
         
                                          
--WHERE ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL                                                
                                          
                                             
                                          
--**********************                                              
                                          
UNION                                          
                                          
--**********************                                  
                                          
                                              
                                          
 SELECT DISTINCT                                                                   
                                          
   t.idProvider as Id,                                                                  
                                          
   convert(varchar,getdate(),103) as transmitionDate,                                                                   
                                          
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,                                                                  
                                          
   REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                                                                  
                                          
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName,                                                                  
                                          
   TRS.AuxiliarSol AS SenderId,                                           
                                          
   TRS.direccion_Sol AS SenderAddress,                                                              
                                          
   ISNULL(c.TC_Numero,'') as SenderPhone,                                    
                                          
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
                                          
   ISNULL(C.DH_Estado,'') AS SenderState,                           
                                          
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                                                                         
                                          
   ISNULL(C.DH_Pais,'') AS SenderCountry,                                                                       
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                                                  
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
                     
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','') AS ReceiveName,                                                         
                                          
   TRB.AuxiliarBenef as ReceiveId,                                                                   
                                          
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                   
                                          
      ELSE trb.ciudad_benef                                                                   
                                          
   END AS ReceiveCity,                                                         
                                          
   EM.EST_NOMBRE AS ReceiveState,                                                                   
                                          
   trb.cod_pais as ReceiveCountry,                                                                  
                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                                                  
                                          
   ' ' as ReceivePhone2,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'B'                                                                  
                                 
      ELSE 'O'                                                                   
                                          
   END AS PaymentType,                                                                  
                                          
   EC.MontoDivisa AS amount,                                                                
                                          
   1 as ExchangeRate,                                                         
                              
   t.feeAmount,                         
                                          
   'D' CurrencyPaymentType,                                                                  
  
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                  
                                          
       ELSE ''                                                           
                                          
   END AS BankName,                                                           
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                                     
                                          
       ELSE 0                                                         
                                          
   END AS BankCode,                                                        
                                          
   ISNULL(ba.AgentName,' ') as  AgentName,                                                                  
                                          
   CASE                                                                  
                                          
 WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                                                  
                                          
      ELSE ''                                                                   
                                          
   END AS AccountType,                                                                  
                                          
      CASE                       
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                                                  
                                          
       ELSE  ''                                                          
                                          
   END AS  AccountNumber,                                                                    
                                          
   T.FinalOperation,                                                                                      
                                          
   trb.Solicitud,                                                           
                                          
   pce.Fecha_Ger as Fecha_Sol,               
                                          
   t.paymentKey AS Clave_IOSS,                                                                    
                             
   dc.Fecha_Aprobado as fecha_aprob_cadivi,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_bcv,                                                                    
                                          
   dc.Fecha_Aprobado+30  as fecha_devolucion,                                                                  
                                          
   CASE                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba                                                           
                                          
       ELSE ''                                                          
                                          
   END ABBA,                                                                      
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                                          
                                          
       ELSE ''                                                          
                                          
   END AS IBAN,                                                        
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                               
                                          
       ELSE   ''                                                          
                                          
   END SWIFT,                                                                 
                                          
   t.providerAcronym,                                                          
                                          
   trb.agent as returnNumber,                           
   '' as operation ,                    
   '7' AS CodTipoTransaccion                           
                              
FROM  planilla_cadiviespecial pce with(nolock)                                      
                                          
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pce.operacioncierre=dc.opercadivi)                                                    
                                          
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)              
            
INNER JOIN Enlaces E ON (E.Operacion = EC.Operacion)                
      
INNER JOIN Enlaces E1 ON ((E1.Operacion = E.OperacionCierre))           
      
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E1.OperacionCierre                                             
                                          
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget               
              
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                   
                                          
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PCe.SOLICITUD  AND TRB.AUXILIARBENEF=PCe.Auxiliar_Benef)                                                                                          
                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PCe.Auxiliar_Sol)                                                                                          
                                          
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar  =TRS.auxiliarsol                                  
                                          
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                     
                                          
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                           
                                          
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PCe.Solicitud and tt.auxiliarbenef = PCe.Auxiliar_Sol                                                                     
                                          
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais                                                                                                     
  
    
      
        
          
                                        
--WHERE  ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = ''   AND  t.idProvider IS NOT NULL                       
--************************                                                
                                          
UNION                                                
                                          
--************************                               
 SELECT DISTINCT                         
                       
   t.idProvider as Id,                      
                       
   convert(varchar,getdate(),103) as transmitionDate,                           
                                       
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,  REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                       
                                           
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName, TRS.AuxiliarSol AS SenderId,                                                                   
                                          
   TRS.direccion_Sol AS SenderAddress,                                  
                                          
   ISNULL(c.TC_Numero,'') as SenderPhone,                                                              
                                          
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
                                          
   ISNULL(C.DH_Estado,'') AS SenderState,                                                           
                                          
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                                                                         
                                          
   ISNULL(C.DH_Pais,'') AS SenderCountry,                                                                       
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                                                  
                      
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
                                          
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','') AS ReceiveName,                                                                  
                                          
   TRB.AuxiliarBenef as ReceiveId,                                                                   
                                          
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                   
                                          
      ELSE trb.ciudad_benef                                                                   
                                          
   END AS ReceiveCity,                                                         
                                          
   EM.EST_NOMBRE AS ReceiveState,                                                                   
                                          
   trb.cod_pais as ReceiveCountry,                                                       
                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                                                  
                                          
   ' ' as ReceivePhone2,                                                   
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'B'                                                                  
                                          
      ELSE 'O'                                                                   
                                          
   END AS PaymentType,                              
                                          
   EC.MontoDivisa AS amount,     
                                 1 as ExchangeRate,                                                         
                                          
   t.feeAmount,                                                                 
                                          
   'D' CurrencyPaymentType,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                
                                          
       ELSE ''                                                           
                                          
   END AS BankName,                                                           
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                                                  
                                      
       ELSE 0                                           
                                          
   END AS BankCode,                                                       
                                          
   ISNULL(ba.AgentName,' ') as  AgentName,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                                          
                                          
      ELSE ''                                                                   
                                          
   END AS AccountType,                                                                  
                                          
      CASE                                        
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                                                  
                                          
       ELSE  ''                                                          
                                          
   END AS  AccountNumber,                                                                    
                                          
   T.FinalOperation,                                                          
                                          
   trb.Solicitud,                                                                                       
                                          
   pc.Fecha_Ger as Fecha_Sol,                                                                                            
                                          
   t.paymentKey AS Clave_IOSS,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_aprob_cadivi,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_bcv,                                                                    
                                          
   dc.Fecha_Aprobado+30  as fecha_devolucion,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba                                                           
                                          
       ELSE ''                                                          
                                          
   END ABBA,                                                                    
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                                     
                                          
       ELSE ''                                                          
                                          
   END AS IBAN,                                                              
                                 
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                                          
                                          
       ELSE   ''                  
                                          
   END SWIFT,                                        
                                          
   t.providerAcronym,                                                          
                                          
   trb.agent as returnNumber,                            
   '' as operation ,                    
   '10' AS CodTipoTransaccion                                                       
                       
FROM  planilla_cadivi pc   with(nolock)                        
                                        
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pc.operacioncierre=dc.opercadivi)                          
                                         
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                     
                                  
INNER JOIN enlaces e with(nolock)On   e.Operacion=ec.Operacion            
            
INNER JOIN Enlaces E1 with(nolock) ON (E1.Operacion = E.OperacionCierre)                           
----Comentado por Anya 16/12/2013                                 
----INNER JOIN tLinksExchangeInstrument L ON e.operacionCierre = L.operationSource                                                                
----INNER JOIN tmoneysendtransaction T ON L.operationTarget = T.FinalOperation                      
----Agregado Anya 16/12/2013  Liste solo estudiantes sin cmbio de proveedor                  
INNER JOIN tmoneysendtransaction T with(nolock)ON ( T.FinalOperation=E1.OperacionCIERRE ) -- or  T.finaloperation=e.operacioncierre)              
               
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL    )                                                               
                              
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                          
                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                                                                                          
                                          
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar =TRS.auxiliarsol                                                                                                                            
                                          
INNER JOIN MtPaisesmundo PM with(nolock)ON (PM.PAI_ISO3 = TRB.Cod_Pais)                                                                                     
                                 
INNER JOIN MtEstadosmundo EM with(nolock)ON (EM.PAI_ISO2 = PM.PAI_ISO2  AND EM.COD_ESTADO= TRB.Cod_Estado)                                                              
                                          
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                             
                                          
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais                                                                                                     
  
     
     
        
          
                                          
--WHERE   ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL 



--///////////////////////////////***********************  UNION 03-06-2014

UNION

 SELECT DISTINCT   t.idProvider as Id,convert(varchar,getdate(),103) as transmitionDate,    
                                          
   REPLACE(ISNULL(c.Apellido1,''),',','')   AS SenderLastName,  REPLACE(ISNULL(c.Apellido2,''),',','') AS SenderSecondLastName,                                         
   REPLACE(ISNULL(c.Nombres,'')+' '+ ISNULL(c.SegundoNombre,''),',','')  AS SenderName, TRS.AuxiliarSol AS SenderId,                                                                   
                                          
   TRS.direccion_Sol AS SenderAddress,                                                              
                                          
   ISNULL(c.TC_Numero,'') as SenderPhone,                                                              
                                          
   ISNULL(c.DH_Ciudad,'') as SenderCity,                                                        
                                          
   ISNULL(C.DH_Estado,'') AS SenderState,                                                                       
                                          
   ISNULL(C.DH_ZonaPostal,'') AS SenderZipCode,                                                                         
                                          
   ISNULL(C.DH_Pais,'') AS SenderCountry,                          
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef1,''),',','')  AS ReceiveLastName,                                                                  
                                          
   REPLACE(ISNULL(TRB.Apellido_Benef2,''),',','') AS ReceiveSecondLastName,                                                                  
                                
   REPLACE(ISNULL(TRB.Nombre_Benef1,'')+' '+ ISNULL(TRB.nombre_Benef2,''),',','') AS ReceiveName,                                                                  
                                          
   TRB.AuxiliarBenef as ReceiveId,                                                                   
                                          
   REPLACE(TRB.Direccion_Benef,',','') AS ReceiveAddress,      
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                                   
                                     
  ELSE trb.ciudad_benef                                                                   
                                          
   END AS ReceiveCity,                                                         
                                          
   EM.EST_NOMBRE AS ReceiveState,                                                                   
       
   trb.cod_pais as ReceiveCountry,                                                       
                                          
   TRB.TELEFONO_BENEF as ReceivePhone1,                                                                  
                                          
   ' ' as ReceivePhone2,                                                                  
               
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'B'                                                                  
                                          
      ELSE 'O'                                                                   
                                          
   END AS PaymentType,                                                                  
                                          
   EC.MontoDivisa AS amount,                                      
                                          
   1 as ExchangeRate,                                                         
                                          
   t.feeAmount,                                                                 
                  
   'D' CurrencyPaymentType,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.AgentName,' ')                                                
                                          
       ELSE ''                                                           
                                          
   END AS BankName,                                                           
                 
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(ba.returnNumber,' ')                                                                  
                                          
       ELSE 0                                                           
                                          
   END AS BankCode,                                                       
                                          
   ISNULL(ba.AgentName,' ') as  AgentName,                                                                  
                                          
   CASE                                                                  
                                          
      WHEN trb.depositoenCuenta = 'S' THEN 'CC'                                                          
                                          
      ELSE ''                                                                   
                                          
   END AS AccountType,                                                                  
                                          
 CASE                                        
                                          
       WHEN trb.depositoenCuenta = 'S' THEN ISNULL(tt.codcuenta, ' ')                                                                  
                                          
       ELSE  ''                                                      
                                          
   END AS  AccountNumber,                                                                    
                                          
   T.FinalOperation,                                                                                      
                                          
   trb.Solicitud,                      
                                          
   pc.Fecha_Ger as Fecha_Sol,                                                                                                   
                                          
   t.paymentKey AS Clave_IOSS,                                                                    
                                          
   dc.Fecha_Aprobado as fecha_aprob_cadivi,                                                                    
                                     
   dc.Fecha_Aprobado as fecha_bcv,                                                                    
                                          
   dc.Fecha_Aprobado+30  as fecha_devolucion,                                                                  
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.abba                                        
                                          
       ELSE ''                                                          
                                          
   END ABBA,                                                                      
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.iban                                                     
                                          
ELSE ''                                                          
                                          
   END AS IBAN,                                                              
                                          
   CASE                                                           
                                          
       WHEN trb.depositoenCuenta = 'S' THEN tt.swift                                                          
                                          
       ELSE   ''                                                          
                   
   END SWIFT,                                        
                                          
   t.providerAcronym,                                                          
                                          
   trb.agent as returnNumber,                            
   ''  as operation,                                                        
   '10' AS  CodTipoTransaccion      
                                 
FROM  planilla_cadivi pc  with(nolock)                         
                                        
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                          
                                         
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)     
                                  
INNER JOIN Enlaces E ON (E.OperacionCierre = EC.Operacion)
                                                  
--LEFT OUTER JOIN Enlaces E ON (E.Operacion = EC.Operacion)                
      
--LEFT OUTER JOIN Enlaces E1 ON ((E.Operacion = E.OperacionCierre))           
      
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E.OperacionCierre 
                                
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget              
              
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                  
                                          
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                          
                                          
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                           
                                          
INNER JOIN Clientes C with(nolock)ON C.Auxiliar =TRS.auxiliarsol                                                        
                                          
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                     
                                 
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                           
                                          
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                                    
                                          
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais  



