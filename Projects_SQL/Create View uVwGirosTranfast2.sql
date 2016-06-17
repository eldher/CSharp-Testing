
CREATE VIEW [dbo].[uVwGirosTransfast2]                   
AS                                                                                                         
SELECT DISTINCT     
                      
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
                
--PM.PAI_ISO3 AS sSenderCountryCode,                     
'VEN' as sSenderCountryCode,   
C.Correo AS sSenderEmail,                     
--convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                     
GETDATE() AS dSenderDOB,  
PM.PAI_ISO3 AS sTypeIDSender,                     
C.Auxiliar AS sNumIDSender,                   
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                     
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                     
C.Cargo AS sSenderOcupation,                    
C.Auxiliar AS sSenderSSN,                     
C.Antiguedad AS sSourceFund,                     
C.MotivoServicio AS sReasonTxn,  
   
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  --pc.Institucion    
   substring(pc.Institucion,1,charindex(' ',pc.Institucion))   
    
  ELSE  
  TRB.nombre_benef1   
    
END AS sReceiverName1,   
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.nombre_benef2, ' ')  
    
END AS sReceiverName2,   
                            
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
substring(pc.Institucion,charindex(' ',pc.Institucion),LEN(pc.Institucion))  
  ELSE  
  TRB.apellido_benef1  
    
END AS sReceiverName3,    
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.apellido_benef2, ' ')  
    
END AS sReceiverName4,                            
                            
            
  
  
--TRB.direccion_benef AS sReceiverAddress,   
substring(TRB.direccion_benef,1,20)+ ' ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.apellido_benef1 AS sReceiverAddress,  
                    
ISNULL(TRB.telefono_benef, 'No posee') AS sReceiverPhone1,                     
'No posee' AS sReceiverPhone2,                     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '10005'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN13'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'U2356'  
END AS sReceiverCityCode,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'NY'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN03'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'ON'  
END AS sReceiverStateCode,                             
trb.Cod_Pais AS sReceiverCountryCode,                     
' ' AS sReceiverZipCode,                     
'No posee' AS sReceiverEmail,                     
CONVERT(DATETIME, '1900-01-01') AS dReceiverDOB,                     
1 AS nCurrencyRemiter,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C'  
END AS sModePayCode,     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'D'  
END AS sCurrencyPayCode,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US030001'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI020006'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01000001'  
END AS sBranchCodePay,                                
replace(convert(varchar(50),CAST(t.amount AS decimal(16,2))), ',', '.') AS dAmountPay,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C0068'  
END AS sBankCode,                                            
T.FinalOperation,                     
t.rcvcountry as receivecountry,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US03'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI02'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01'  
END AS sGroupBranchCode,                         
pc.Solicitud AS Solicitud,                     
isnull(pc.Fecha_Autoriza,'1900-01-01') AS Fecha_Sol,                      
  
t.codReceiver AS Auxiliar_Benef,                     
  
isnull(pc.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                     
isnull(pc.fecha_liberacion,'1900-01-01') as fecha_bcv,                     
isnull(pc.Fecha_Hasta,'1900-01-01') as fecha_devolucion,                     
2 as typeResult,                  
--*******                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(TT.codcuenta,'')                 
  ELSE                  
 ''                  
END AS sAccountNumber,                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 '2'                  
  ELSE                  
 ''                  
END AS sTypeAcc,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(substring(TT.numeroOficina,1,5),'')                 
  ELSE                  
 ''                  
END AS sBranchBankCode,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(TT.numeroInstitucion,0)) ,3)                  
  ELSE                  
 ''                  
END AS aux1,  
'ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.nombre_benef2+' ' +TRB.apellido_benef1+' '+TRB.apellido_benef2+' '+TRB.auxiliarbenef as smessage  
                
                                      
FROM  planilla_cadivi pc  with(nolock)                                                                     
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                                                                      
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                  
INNER JOIN Enlaces E ON (E.Operacion = EC.Operacion)                              
INNER JOIN Enlaces E1 ON ((E1.Operacion = E.OperacionCierre))                       
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E1.OperacionCierre                                   
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget                              
--AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                                                             
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                                                                       
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                                                                         
INNER JOIN Clientes C with(nolock)ON C.Auxiliar =TRS.auxiliarsol                                                                                                      
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                                                
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                                                 
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                                                                                 
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais                                                                                                     
  
    
WHERE  
  
 ((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))         
 and TRB.telefono_benef <> '0'   
 AND TRB.Cod_Pais IN ('CAN','CHN','USA')   
 AND t.ProviderAcronym = 'FT'   
 AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)                                                                                                           
  AND t.finalOperation IN ('01290820147160011','01290820147160010')  
      
    
 
  
UNION                                                                                                            
--************************                                           
   
SELECT DISTINCT                                     
  
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
'VEN' as sSenderCountryCode,                     
--PM.PAI_ISO3 AS sSenderCountryCode,                     
C.Correo AS sSenderEmail,                     
--convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                     
GETDATE() AS dSenderDOB,  
PM.PAI_ISO3 AS sTypeIDSender,                     
C.Auxiliar AS sNumIDSender,                   
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                     
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                     
C.Cargo AS sSenderOcupation,                    
C.Auxiliar AS sSenderSSN,                     
C.Antiguedad AS sSourceFund,                     
C.MotivoServicio AS sReasonTxn,                     
/*TRB.nombre_benef1 AS sReceiverName1,                     
ISNULL(TRB.nombre_benef2, ' ') AS sReceiverName2,                     
TRB.apellido_benef1 AS sReceiverName3,                     
ISNULL(TRB.apellido_benef2, ' ') AS sReceiverName4,                   */  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  --pc.Institucion    
   substring(pc.Institucion,1,charindex(' ',pc.Institucion))   
    
  ELSE  
  TRB.nombre_benef1   
    
END AS sReceiverName1,   
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.nombre_benef2, ' ')  
    
END AS sReceiverName2,   
                            
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
     substring(pc.Institucion,charindex(' ',pc.Institucion),LEN(pc.Institucion))  
  ELSE  
  TRB.apellido_benef1  
    
END AS sReceiverName3,    
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.apellido_benef2, ' ')  
    
END AS sReceiverName4,                 
  
--TRB.direccion_benef AS sReceiverAddress,   
substring(TRB.direccion_benef,1,20)+ ' ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.apellido_benef1 AS sReceiverAddress,                    
ISNULL(TRB.telefono_benef, 'No posee') AS sReceiverPhone1,                     
'No posee' AS sReceiverPhone2,                     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '10005'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN13'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'U2356'  
END AS sReceiverCityCode,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'NY'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN03'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'ON'  
END AS sReceiverStateCode,                             
trb.Cod_Pais AS sReceiverCountryCode,                     
' ' AS sReceiverZipCode,                     
'No posee' AS sReceiverEmail,                     
CONVERT(DATETIME, '1900-01-01') AS dReceiverDOB,                     
1 AS nCurrencyRemiter,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C'  
END AS sModePayCode,     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'D'  
END AS sCurrencyPayCode,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US030001'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI020006'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01000001'  
END AS sBranchCodePay,                                
replace(convert(varchar(50),CAST(t.amount AS decimal(16,2))), ',', '.') AS dAmountPay,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C0068'  
END AS sBankCode,                                            
T.FinalOperation,                     
t.rcvcountry as receivecountry,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US03'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI02'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01'  
END AS sGroupBranchCode,                       
pc.Solicitud AS Solicitud,                     
isnull(pc.Fecha_Autoriza,'1900-01-01') AS Fecha_Sol,                      
--pc.Auxiliar_Est AS Auxiliar_Benef,                     
t.codReceiver AS Auxiliar_Benef,  
isnull(pc.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                     
isnull(pc.fecha_liberacion,'1900-01-01') as fecha_bcv,                     
isnull(pc.Fecha_Hasta,'1900-01-01') as fecha_devolucion,                     
2 as typeResult,                  
--*******                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(TT.codcuenta,'')                 
  ELSE                  
 ''                  
END AS sAccountNumber,                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 '2'                  
  ELSE                  
 ''                  
END AS sTypeAcc,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(substring(TT.numeroOficina,1,5),'')                 
  ELSE                  
 ''                  
END AS sBranchBankCode,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(TT.numeroInstitucion,0)) ,3)                  
  ELSE                  
 ''                  
END AS aux1,  
'ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.nombre_benef2+' ' +TRB.apellido_benef1+' '+TRB.apellido_benef2+' '+TRB.auxiliarbenef as smessage                                  
                                                                                         
FROM  planilla_cadivi pc   with(nolock)                                                                    
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pc.operacioncierre=dc.opercadivi)                                                                             
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                                              
INNER JOIN enlaces e with(nolock)On   e.Operacion=ec.Operacion                         
INNER JOIN Enlaces E1 with(nolock) ON (E1.Operacion = E.OperacionCierre)                                       
INNER JOIN tmoneysendtransaction T with(nolock)ON ( T.FinalOperation=E1.OperacionCIERRE )                         
--AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL    )                                                                                     
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                                                                    
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                                                                                                                                 
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar =TRS.auxiliarsol                                               
INNER JOIN MtPaisesmundo PM with(nolock)ON (PM.PAI_ISO3 = TRB.Cod_Pais)                                                                                                         
INNER JOIN MtEstadosmundo EM with(nolock)ON (EM.PAI_ISO2 = PM.PAI_ISO2  AND EM.COD_ESTADO= TRB.Cod_Estado)                                                                                            
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                         
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais   
  
WHERE  
  
 ((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))         
 and TRB.telefono_benef <> '0'  
 AND TRB.Cod_Pais IN ('CAN','CHN','USA')   
 AND t.ProviderAcronym = 'FT'      
 AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)                                                                                                           
 AND t.finalOperation IN ('01290820147160011','01290820147160010')   
      
--************************                                                                                                           
UNION                                                                                                            
--************************               
    
            
SELECT DISTINCT   
  
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
  
'VEN' as sSenderCountryCode,  
--PM.PAI_ISO3 AS sSenderCountryCode,                     
C.Correo AS sSenderEmail,                     
--convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                     
GETDATE() AS dSenderDOB,  
PM.PAI_ISO3 AS sTypeIDSender,                     
C.Auxiliar AS sNumIDSender,                   
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                     
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                     
C.Cargo AS sSenderOcupation,                    
C.Auxiliar AS sSenderSSN,                     
C.Antiguedad AS sSourceFund,                     
C.MotivoServicio AS sReasonTxn,                     
/*TRB.nombre_benef1 AS sReceiverName1,                     
ISNULL(TRB.nombre_benef2, ' ') AS sReceiverName2,                     
TRB.apellido_benef1 AS sReceiverName3,                     
ISNULL(TRB.apellido_benef2, ' ') AS sReceiverName4, */  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  --pc.Institucion    
   substring(pc.Institucion,1,charindex(' ',pc.Institucion))   
    
  ELSE  
  TRB.nombre_benef1   
    
END AS sReceiverName1,   
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.nombre_benef2, ' ')  
    
END AS sReceiverName2,   
                            
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
     substring(pc.Institucion,charindex(' ',pc.Institucion),LEN(pc.Institucion))  
  ELSE  
  TRB.apellido_benef1  
    
END AS sReceiverName3,    
  
CASE WHEN dc.Concepto IN ('MT') THEN --PREGUNTAR EL CASO EN EL QUE SE PAGUE AL SEGURO  
  ''  
  ELSE  
  ISNULL(TRB.apellido_benef2, ' ')  
    
END AS sReceiverName4,                     
  
--TRB.direccion_benef AS sReceiverAddress,   
substring(TRB.direccion_benef,1,20)+ ' ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.apellido_benef1 AS sReceiverAddress,                    
ISNULL(TRB.telefono_benef, 'No posee') AS sReceiverPhone1,                     
'No posee' AS sReceiverPhone2,                     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '10005'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN13'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'U2356'  
END AS sReceiverCityCode,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'NY'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CHN03'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'ON'  
END AS sReceiverStateCode,                             
trb.Cod_Pais AS sReceiverCountryCode,                     
' ' AS sReceiverZipCode,                     
'No posee' AS sReceiverEmail,                     
CONVERT(DATETIME, '1900-01-01') AS dReceiverDOB,                     
1 AS nCurrencyRemiter,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  '2'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C'  
END AS sModePayCode,     
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'D'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'D'  
END AS sCurrencyPayCode,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US030001'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI020006'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01000001'  
END AS sBranchCodePay,                                
replace(convert(varchar(50),CAST(t.amount AS decimal(16,2))), ',', '.') AS dAmountPay,   
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  ''  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'C0068'  
END AS sBankCode,                                            
T.FinalOperation,                     
t.rcvcountry as receivecountry,  
CASE WHEN TRB.Cod_Pais IN ('USA') THEN  
  'US03'  
  WHEN TRB.Cod_Pais IN ('CHN') THEN  
  'CI02'  
  WHEN TRB.Cod_Pais IN ('CAN') THEN  
  'XA01'  
END AS sGroupBranchCode,                         
pc.Solicitud AS Solicitud,                     
isnull(pc.Fecha_Autoriza,'1900-01-01') AS Fecha_Sol,                      
--pc.Auxiliar_Est AS Auxiliar_Benef,                     
t.codReceiver as Auxiliar_Benef,  
isnull(pc.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                     
isnull(pc.fecha_liberacion,'1900-01-01') as fecha_bcv,                     
isnull(pc.Fecha_Hasta,'1900-01-01') as fecha_devolucion,                     
2 as typeResult,                  
--*******                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(TT.codcuenta,'')                 
  ELSE                  
 ''                  
END AS sAccountNumber,                  
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 '2'                  
  ELSE                  
 ''                  
END AS sTypeAcc,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 ISNULL(substring(TT.numeroOficina,1,5),'')                 
  ELSE                  
 ''                  
END AS sBranchBankCode,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                  
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(TT.numeroInstitucion,0)) ,3)                  
  ELSE                  
 ''                  
END AS aux1,  
'ON BEHALF : '+ TRB.nombre_benef1 +' ' +TRB.nombre_benef2+' ' +TRB.apellido_benef1+' '+TRB.apellido_benef2+' '+TRB.auxiliarbenef as smessage     
                                         
FROM  planilla_cadivi pc  with(nolock)                                                                             
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                                                                             
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                
INNER JOIN Enlaces E ON (E.OperacionCierre = EC.Operacion)             
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E.OperacionCierre             
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget                          
--AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                                                           
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PC.SOLICITUD  AND TRB.AUXILIARBENEF=PC.Auxiliar_Est)                                                                                                      
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PC.Auxiliar_Rep)                                                                   
INNER JOIN Clientes C with(nolock)ON C.Auxiliar =TRS.auxiliarsol                                                                                              
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                                 
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                                                     
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                                                                                                    
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais           
  
WHERE  
  
 ((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))         
 and TRB.telefono_benef <> '0'  
 AND TRB.Cod_Pais IN ('CAN','CHN','USA')   
 AND t.ProviderAcronym = 'FT'       
 AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)      

AND t.finalOperation IN ('01290820147160011','01290820147160010')
				  
				  