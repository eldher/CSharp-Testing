
select 
      ISNULL(t.idProvider,0) as idProvider,         
      ISNULL(PCE.Solicitud,'') as solicitud,         
      ISNULL(a.NomAgencia,'') AS nomAgencia,         
      ISNULL(PCE.Operacion,'') AS operacionSol,                 
      ISNULL(PCE.Auxiliar_Sol,'') AS cedulaRemitente,         
      ISNULL(c.Nombres,'') + ' ' + ISNULL(C.Apellido1,'') AS nombreRemitente,                  
      ISNULL(t.finalOperation,'') AS operacionEnvio,         
      ISNULL(t.paymentkey,'') as clave,         
      ISNULL(t.fileName,'') as archivoEnvio,        
      ISNULL(PCE.Auxiliar_Benef,'') AS cedulaBeneficiario,                      
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
      ISNULL(PCE.fecha_enviocadivi,'') AS fecha_aprob_cadivi,         
      ISNULL(MPais.pai_nombre,'') AS paisRecepcion,      
      ISNULL(c.Correo,'') AS correo      
      
      
from tMoneySendTransaction t
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
       ISNULL(t.stateService,'') <> 'A'                                         
       AND ISNULL(PCE.OPERACIONCIERRE,'') <> ''         
       AND PCE.OPERACIONCIERRE <> '' --***  
       
       
       
AND t.finalOperation = '01150720147120001'





