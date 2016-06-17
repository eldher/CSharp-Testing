select	DISTINCT

t.idProvider as Id,
CAST(T.idProvider AS VARCHAR(50)) + CAST(pc.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,   
T.FinalOperation  as sClavePay,   
C.Nombres AS sSenderName1, 
' ' AS sSenderName2,
C.Apellido1 AS sSenderName3,  
ISNULL(C.Apellido2, ' ') AS sSenderName4,                 
C.DH_Sector + ' ' +                 
C.DH_Avenida + ' ' +                 
C.DH_Residencia + ' ' +                 
C.DH_Numero + ' ' +                 
C.DH_Piso + ' ' +                 
C.DH_Municipio + ' ' AS sSenderAddress,                 
ISNULL(C.TH_Numero, 'No posee') AS sSenderPhone1,                 
ISNULL(C.TC_Numero, 'No posee') AS sSenderPhone2,                 
C.DH_Ciudad AS sSenderCity,                 
'VEN' AS sSenderCountryCode,                 
C.Correo AS sSenderEmail,                
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,
'VEN' AS sTypeIDSender,                 
C.Auxiliar AS sNumIDSender,  
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                 

--convert(DATETIME, isnull(b.fecha_devolucion,'1900-01-01'),103) AS dExpirationIDDate,                 
GETDATE() + 7 AS dExpirationIDDate, 

C.Cargo AS sSenderOcupation,                 
C.Auxiliar AS sSenderSSN,                 
C.Antiguedad AS sSourceFund,                 
C.MotivoServicio AS sReasonTxn,    
TRB.nombre_benef1 AS sReceiverName1,                 
ISNULL(TRB.nombre_benef2, ' ') AS sReceiverName2,                 
TRB.apellido_benef1 AS sReceiverName3,                 
ISNULL(TRB.apellido_benef2, ' ') AS sReceiverName4,                 
TRB.direccion_benef AS sReceiverAddress,                 
ISNULL(TRB.telefono_benef, 'No posee') AS sReceiverPhone1,                 
'No posee' AS sReceiverPhone2, 


AT.sBranchCityCode AS sReceiverCityCode,                 
AT.sBranchStateCode AS sReceiverStateCode,                 


trb.Cod_Pais AS sReceiverCountryCode,                 
' ' AS sReceiverZipCode,                 
'No posee' AS sReceiverEmail,                 
CONVERT(DATETIME, '1900-01-01') AS dReceiverDOB,                 
1 AS nCurrencyRemiter,   
              
AT.sModePayCode AS sModePayCode,                 
AT.sCurrencyPayCode AS sCurrencyPayCode,                 
AT.sBranchCodePay AS sBranchCodePay,     
    
--replace(convert(varchar(50),CAST(B.Monto_Benef AS decimal(16,2))), ',', '.') AS dAmountPay,                     
replace(convert(varchar(50),CAST(EC.MontoDivisa AS decimal(16,2))), ',', '.') AS dAmountPay,                     

               

T.FinalOperation,                 
t.rcvcountry as receivecountry,                 
AT.sBankCode AS sBankCode,                 
AT.sGroupBranchCode,                 
pc.Solicitud AS Solicitud,                 
isnull(pc.Fecha_Taq,'1900-01-01') AS Fecha_Sol,                  
PC.Auxiliar_Est AS Auxiliar_Benef,                 
isnull(dc.Fecha_Autorizado,'1900-01-01') as fecha_aprob_cadivi,                 
isnull(pc.fecha_liberacion,'1900-01-01') as fecha_bcv,   
              
--isnull(b.fecha_devolucion,'1900-01-01') as fecha_devolucion,    
GETDATE() + 7		 as fecha_devolucion, 
             
2 as typeResult, 
             
--*******              
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN              
 ISNULL(tt.codcuenta,'')             
  ELSE              
 ''              
END AS sAccountNumber,              
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN              
 '2'              
  ELSE              
 ''              
END AS sTypeAcc,            
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN              
 ISNULL(substring(tt.numeroOficina,1,5),'')             
  ELSE              
 ''              
END AS sBranchBankCode,            
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN              
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(tt.numeroInstitucion,0)) ,3)              
  ELSE              
 ''              
END AS aux1            
					  


FROM  planilla_cadivi pc  with(nolock)                           
                                          
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                            
                                           
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)       
                                    
--INNER JOIN Enlaces E ON (E.Operacion = EC.Operacion)                  
        
INNER JOIN Enlaces E1 ON ((E1.Operacioncierre = EC.Operacion/*E.OperacionCierre*/))             
        
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E1.OperacionCierre      
                                  
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget                
                
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                    
                                            
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                            
                                            
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                             
                                            
INNER JOIN Clientes C with(nolock)ON C.Auxiliar =TRS.auxiliarsol                                                          
                                            
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                       
                                   
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                             
                                            
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                                      
                                            
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais   and TRB.Cod_Ciudad = ba.cityCode  

INNER JOIN   mtagentsTransfast AT            ON      (AT.sBranchCountryCode = '10005' and AT.sBranchStateCode = 'NY' and AT.sModePayCode = '2' and AT.agente = 16899 and TRB.Cod_Pais = 'USA')                   
                                                  OR (AT.sBranchCountryCode = 'CHN' and AT.sBranchStateCode = 'CHN03' and AT.sModePayCode = '2' and AT.agente = 35 and TRB.Cod_Pais = 'CHN')                  
              OR (AT.sBranchCountryCode = 'CAN' and AT.sModePayCode = 'C' and TRB.Cod_Pais = 'CAN') 
 /*  */
where 

/* B.instrumento = 'FT'                       
AND ISNULL(T.FinalOperation,'')<>''                       
AND ( T.StateService IS NULL OR T.StateService = '')                      
AND ISNULL(T.idProvider,'') <> ''                     
AND*/--comentado por ayharik 16012014 para optimizacion de la vista , se agrego esas condiciones en el 1er join 

((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))           
AND TRB.telefono_benef <> '0'  
AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)            
AND T.finalOperation= '700290820147160004'
--pc.OperacionCierre= '701220420144900001'  









--select operationSource,* from tLinksExchangeInstrument te where  te.operationTarget = '700290820147160004' 

--select Operacion,* from Enlaces where OperacionCierre = '701010820141540002' 


--select * from Enlaces_Cadivi where Operacioncierre = '700290820147160004'

  

--select * from Enlaces_Cadivi where OperacionCierre = '70112082014440002'

--select * from Planilla_Cadivi where Auxiliar_Rep='V9669070'
--select * from Detalles_Cadivi where OperCadivi='701220420144900001'
--select * from Enlaces_Cadivi where OperacionCierre='701220420144900001'
--select * from Enlaces where OperacionCierre='701010820141540002'


--select * from tLinksExchangeInstrument

--select * from Enlaces where Operacion='701010820141540002'

--select * from Movimien where Auxiliar='V9669070'

--   70112082014440002

--select * from Enlaces_Cadivi


--select * from MtPaisesmundo where	PAI_NOMBRE='UNITED STATES'
--select * from MtCiudadesmundo where PAI_ISO2='US' and NOMBRE_CIUDAD like '%camp%'	--CMP

--select * from MtProviderAgents where  providerAcronym='FT' and cityCode='CMP'
