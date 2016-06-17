
  /*                   
CREATE BY: Dennis Useche                   
DATE: 15/05/2011                   
DESCRIPTION: This View show all operation its ready to send to TRANSFAST                   
                  
*/                   
ALTER VIEW [dbo].[uVwGirosTransfast]                   
AS                   
                 
--VY 29-06-2011                   
--Con la nueva tabla tMoneySendTransaction                   
SELECT DISTINCT                   
t.idProvider as Id,                   
CAST(T.idProvider AS VARCHAR(50)) + CAST(B.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,                 
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
convert(DATETIME, isnull(b.fecha_devolucion,'1900-01-01'),103) AS dExpirationIDDate,                   
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
replace(convert(varchar(50),CAST(B.Monto_Benef AS decimal(16,2))), ',', '.') AS dAmountPay,                                  
AT.sBankCode AS sBankCode,                   
T.FinalOperation,                   
t.rcvcountry as receivecountry,                   
AT.sGroupBranchCode,                   
B.Solicitud AS Solicitud,                   
isnull(B.fecha_aprob_cadivi,'1900-01-01') AS Fecha_Sol,                   
B.Auxiliar_Benef AS Auxiliar_Benef,                   
isnull(b.fecha_aprob_cadivi,'1900-01-01') as fecha_aprob_cadivi,                   
isnull(b.fecha_bcv,'1900-01-01') as fecha_bcv,                   
isnull(b.fecha_devolucion,'1900-01-01') as fecha_devolucion,                   
2 as typeResult,                
--*******                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
  ISNULL(TRT.codcuenta,'')               
  ELSE                
  ''                
END AS sAccountNumber,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
  '2'                
  ELSE                
  ''                
END AS sTypeAcc,              
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 ISNULL(substring(TRT.numeroOficina,1,5),'')               
  ELSE                
 ''                
END AS sBranchBankCode,        
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(TRT.numeroInstitucion,0)) ,3)                
  ELSE                
 ''                
END AS aux1              
--*********                 
                
FROM   REMESAS_FAMILIARESBENEF B                   
INNER JOIN   TmoneySendTransaction T                            
on (t.providerAcronym = 'FT' AND B.operacionfinal = T.FinalOperation 
and (ISNULL(T.FinalOperation,'')<>''       
AND T.StateService IS NULL OR T.StateService = ''          
AND ISNULL(T.idProvider,'') <> ''  ) and b.Estado='C' )   
            
INNER JOIN   TRUSADBENEFICIARIO TRB    ON (B.SOLICITUD = TRB.SOLICITUD AND B.AUXILIAR_BENEF=TRB.AUXILIARBENEF)                   
INNER JOIN   TRUSADSOLICITANTE TRS    ON (TRB.SOLICITUD=TRS.SOLICITUD AND B.AUXILIAR_SOL = TRS.AUXILIARSOL)                   
INNER JOIN   dbo.remesas_familiaressol RFS   ON (RFS.OPERACION = B.OPERACIONSOL)                   
INNER JOIN   Clientes C                      ON TRS.auxiliarsol = C.Auxiliar and C.Fecha_Nac <> ''               
INNER JOIN   mtagentsTransfast AT            ON      (AT.sBranchCityCode = '10005' and AT.sBranchStateCode = 'NY' and AT.sModePayCode = '2' and AT.agente = 16899 and TRB.Cod_Pais = 'USA')               
                                                  OR (AT.sBranchCountryCode = 'CHN' and AT.sBranchStateCode = 'CHN03' and AT.sModePayCode = '2' and AT.agente = 35 and TRB.Cod_Pais = 'CHN')              
                                                  OR (AT.sBranchCountryCode = 'CAN' and AT.sModePayCode = 'C' and TRB.Cod_Pais = 'CAN')              
INNER JOIN   MtPaisesmundo PM                ON (TRB.Cod_Pais = PM.PAI_ISO3 )                   
INNER JOIN   MtEstadosmundo EM               ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                 
LEFT OUTER JOIN tblrusadtransferencia TRT    ON (TRB.auxiliarbenef = TRT.auxiliarbenef AND TRB.solicitud = TRT.solicitud AND AT.agente = TRT.numeroInstitucion)                 
WHERE                              
 ((TRB.Cod_Pais IN ('CAN') AND TRT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0'   
 AND B.Auxiliar_Sol NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=B.Auxiliar_Sol)                                                                                                         
      
-- and B.auxiliar_sol not in ('V1197977',    
--'V3611972',    
--'V3611972',    
--'V6056068',    
--'V6305139',    
--'V1155280',    
--'V2954368',    
--'V1155280',    
--'V1413261',    
--'V2954368',    
--'V3635867',    
--'V3027309',    
--'V3027309',    
--'V14840492',    
--'V5884324',    
--'V1892162',    
--'V3822911',    
--'V1892162',    
--'V1892162',    
--'V5247407',    
--'V3832094',    
--'V3832094',    
--'V3082822',    
--'V3082822',    
--'V4058788',    
--'V4058788',    
--'V4058788',    
--'V8003340',    
--'V3405261',    
--'V3405261',    
--'V3405261',    
--'V2932901',    
--'V2932901',    
--'V5440850',    
--'V5440850',    
--'V5440850',    
--'V3896988',    
--'V5288864',    
--'V12607375',    
--'V17032699',    
--'V4088206',    
--'V4088206',    
--'V4088206',    
--'V4451397',    
--'V4451397',    
--'V8177797',    
--'V11568366',    
--'V3564647',    
--'V1272220',    
--'V3178987',    
--'V2159044',    
--'V3713819',    
--'V10547717',    
--'V3713819',    
--'V2669921',    
--'V2669921',    
--'V2669921')              
                
--**********************************************************                
UNION                   
--**********************************************************                
                
SELECT DISTINCT                   
t.idProvider as Id,                   
CAST(T.idProvider AS VARCHAR(50)) + CAST(B.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,                
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
--PMc.PAI_ISO3 AS sSenderCountryCode,                   
C.Correo AS sSenderEmail,                   
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PMc.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(b.fecha_devolucion,'1900-01-01'),103) AS dExpirationIDDate,                   
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
replace(convert(varchar(50),CAST(B.Monto_Benef AS decimal(16,2))), ',', '.') AS dAmountPay,                                         
AT.sBankCode AS sBankCode,                   
T.FinalOperation,                   
t.rcvcountry as receivecountry,                   
AT.sGroupBranchCode,                   
B.Solicitud AS Solicitud,                   
isnull(B.fecha_aprob_cadivi,'1900-01-01') AS Fecha_Sol,                    
B.Auxiliar_Benef AS Auxiliar_Benef,                   
isnull(b.fecha_aprob_cadivi,'1900-01-01') as fecha_aprob_cadivi,                   
isnull(b.fecha_bcv,'1900-01-01') as fecha_bcv,                   
isnull(b.fecha_devolucion,'1900-01-01') as fecha_devolucion,                   
2 as typeResult,                
--*******                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 ISNULL(TRT.codcuenta,'')               
  ELSE                
 ''                
END AS sAccountNumber,                
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 '2'                
  ELSE                
 ''                
END AS sTypeAcc,              
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 ISNULL(substring(TRT.numeroOficina,1,5),'')               
  ELSE                
 ''                
END AS sBranchBankCode,              
CASE WHEN TRB.Cod_Pais IN ('CAN') THEN                
 RIGHT(REPLICATE('0',3) + convert(varchar(3),ISNULL(TRT.numeroInstitucion,0)) ,3)                
  ELSE                
 ''                
END AS aux1              
--*********                  
     
FROM   REMESAS_FAMILIARESBENEF B                    
INNER JOIN   tLinksExchangeInstrument L      ON B.OperacionFinal = L.OperationSource                   
INNER JOIN   TmoneySendTransaction T         ON t.finalOperation = L.operationTarget and t.providerAcronym = 'FT'                   
INNER JOIN   TRUSADBENEFICIARIO TRB          ON (B.SOLICITUD = TRB.SOLICITUD AND B.AUXILIAR_BENEF=TRB.AUXILIARBENEF)                   
INNER JOIN   TRUSADSOLICITANTE TRS           ON (TRB.SOLICITUD=TRS.SOLICITUD AND B.AUXILIAR_SOL = TRS.AUXILIARSOL)                   
INNER JOIN   dbo.remesas_familiaressol RFS   ON (RFS.OPERACION = B.OPERACIONSOL)                   
INNER JOIN   Clientes C                      ON TRS.auxiliarsol = C.Auxiliar  and C.Fecha_Nac <> ''                  
INNER JOIN   mtagentsTransfast AT            ON      (AT.sBranchCountryCode = '10005' and AT.sBranchStateCode = 'NY' and AT.sModePayCode = '2' and AT.agente = 16899 and TRB.Cod_Pais = 'USA')               
                                                  OR (AT.sBranchCountryCode = 'CHN' and AT.sBranchStateCode = 'CHN03' and AT.sModePayCode = '2' and AT.agente = 35 and TRB.Cod_Pais = 'CHN')              
                                                  OR (AT.sBranchCountryCode = 'CAN' and AT.sModePayCode = 'C' and TRB.Cod_Pais = 'CAN')              
INNER JOIN   dbo.MtPaisesmundo PMc           ON (c.DH_Pais = PMc.PAI_NOMBRE)                   
INNER JOIN   MtPaisesmundo PM                ON (TRB.Cod_Pais = PM.PAI_ISO3 )                   
INNER JOIN   MtEstadosmundo EM               ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                 
LEFT OUTER JOIN tblrusadtransferencia TRT    ON (TRB.auxiliarbenef = TRT.auxiliarbenef AND TRB.solicitud = TRT.solicitud AND AT.agente = TRT.numeroInstitucion)              
WHERE                   
  L.modifiedInstrument ='FT'                   
 AND ISNULL(T.FinalOperation,'')<>''                   
 AND ( T.StateService IS NULL OR T.StateService = '')                  
 AND ISNULL(T.idProvider,'') <> ''                  
 AND ((TRB.Cod_Pais IN ('CAN') AND TRT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))      
 and TRB.telefono_benef <> '0'     
-- and B.auxiliar_sol not in ('V1197977',    
--'V3611972',    
--'V3611972',    
--'V6056068',    
--'V6305139',    
--'V1155280',    
--'V2954368',    
--'V1155280',    
--'V1413261',    
--'V2954368',    
--'V3635867',    
--'V3027309',    
--'V3027309',    
--'V14840492',    
--'V5884324',    
--'V1892162',    
--'V3822911',    
--'V1892162',    
--'V1892162',      
--'V5247407',    
--'V3832094',    
--'V3832094',    
--'V3082822',    
--'V3082822',    
--'V4058788',    
--'V4058788',    
--'V4058788',    
--'V8003340',    
--'V3405261',    
--'V3405261',    
--'V3405261',    
--'V2932901',    
--'V2932901',    
--'V5440850',    
--'V5440850',    
--'V5440850',    
--'V3896988',    
--'V5288864',    
--'V12607375',    
--'V17032699',    
--'V4088206',    
--'V4088206',    
--'V4088206',    
--'V4451397',    
--'V4451397',    
--'V8177797',    
--'V11568366',    
--'V3564647',    
--'V1272220',    
--'V3178987',    
--'V2159044',    
--'V3713819',    
--'V10547717',    
--'V3713819',    
--'V2669921',    
--'V2669921',    
--'V2669921')     

AND B.Auxiliar_Sol NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=B.Auxiliar_Sol)                                                                                                         
  
    

--**********************************************
UNION
--**********************************************  
                                                       
                                                                                                    
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
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pc.Auxiliar_Est AS Auxiliar_Benef,                   
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
END AS aux1        
              
                                    
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
  
WHERE

	((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0' 
 AND TRB.Cod_Pais IN ('CAN','CHN','USA') 
 AND t.ProviderAcronym = 'FT' 
 AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)                                                                                                         
  
    
  
                                        
--**********************************************
UNION
--**********************************************  

                                       
SELECT DISTINCT  

t.idProvider as Id,                   
CAST(T.idProvider AS VARCHAR(50)) + CAST(pce.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,                
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
'VEN' AS sSenderCountryCode, 
C.Correo AS sSenderEmail,                   
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pce.Fecha_Riscatto,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pce.Solicitud AS Solicitud,                   
isnull(pce.Fecha_Italcadivi,'1900-01-01') AS Fecha_Sol,                    
pce.Auxiliar_Benef AS Auxiliar_Benef,                   
isnull(pce.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                   
isnull(pce.fecha_liberacion,'1900-01-01') as fecha_bcv,                   
isnull(pce.Fecha_Riscatto,'1900-01-01') as fecha_devolucion,                   
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
END AS aux1                                                                                   
                                                    
                                              
FROM  planilla_cadiviespecial pce  with(nolock)                                                                       
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pce.operacioncierre=dc.opercadivi )                                                                                         
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                                                               
INNER JOIN Enlaces e with(nolock)ON  e.Operacion=ec.Operacion -- OR  el.OperacionCierre=ec.Operacion                                                       
INNER JOIN Enlaces E1 with(nolock)ON  e1.Operacion=e.OperacionCIERRE                               
INNER JOIN tmoneysendtransaction T with(nolock) ON  T.FinalOperation=E1.OperacionCIERRE                             
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                                                             
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PCe.SOLICITUD AND TRB.AUXILIARBENEF=pce.Auxiliar_Benef)                                                                                                                      
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=pce.Auxiliar_Sol)                                                          
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar   =TRS.auxiliarsol                                                                                                                                                        
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                                                           
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                                                               
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = pce.Solicitud and tt.auxiliarbenef = pce.Auxiliar_Sol                                                                                                     
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais

WHERE

	((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0' 
 AND TRB.Cod_Pais IN ('CAN','CHN','USA') 
 AND t.ProviderAcronym = 'FT' 
 AND pce.Auxiliar_Sol NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pce.Auxiliar_Sol)                                                                                                        
                           
                                                                  
--**********************                                                                                                      
UNION                                                                                               
--**********************                                            
                                                   
SELECT DISTINCT                                                                             
                                                   
t.idProvider as Id,                   
CAST(T.idProvider AS VARCHAR(50)) + CAST(pce.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,                
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
--PM.PAI_ISO3 AS sSenderCountryCode,                   
C.Correo AS sSenderEmail,                   
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pce.Fecha_Riscatto,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pce.Solicitud AS Solicitud,                   
isnull(pce.Fecha_Italcadivi,'1900-01-01') AS Fecha_Sol,                    
pce.Auxiliar_Benef AS Auxiliar_Benef,                   
isnull(pce.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                   
isnull(pce.fecha_liberacion,'1900-01-01') as fecha_bcv,                   
isnull(pce.Fecha_Riscatto,'1900-01-01') as fecha_devolucion,                   
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
END AS aux1                                    
                                        
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

WHERE

	((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0'
 AND TRB.Cod_Pais IN ('CAN','CHN','USA') 
 AND t.ProviderAcronym = 'FT'     
 AND pce.Auxiliar_Sol NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pce.Auxiliar_Sol)                                                                                                        
  
                                                   
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
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pc.Auxiliar_Est AS Auxiliar_Benef,                   
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
END AS aux1                                
                                                                                       
FROM  planilla_cadivi pc   with(nolock)                                                                  
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pc.operacioncierre=dc.opercadivi)                                                                           
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                                                            
INNER JOIN enlaces e with(nolock)On   e.Operacion=ec.Operacion                       
INNER JOIN Enlaces E1 with(nolock) ON (E1.Operacion = E.OperacionCierre)                                     
INNER JOIN tmoneysendtransaction T with(nolock)ON ( T.FinalOperation=E1.OperacionCIERRE )                       
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL    )                                                                                   
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
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pc.Fecha_Hasta,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pc.Auxiliar_Est AS Auxiliar_Benef,                   
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
END AS aux1   
                                       
FROM  planilla_cadivi pc  with(nolock)                                                                           
INNER JOIN Detalles_Cadivi dc with(nolock)on (dc.opercadivi = pc.operacioncierre)                                                                           
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                                              
INNER JOIN Enlaces E ON (E.OperacionCierre = EC.Operacion)           
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

WHERE

	((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0'
 AND TRB.Cod_Pais IN ('CAN','CHN','USA') 
 AND t.ProviderAcronym = 'FT'     
 AND pc.Auxiliar_Rep NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pc.Auxiliar_Rep)    

--************************                                                                                                         
UNION                                                                                                          
--************************  

  
SELECT DISTINCT  
  
t.idProvider as Id,                   
CAST(T.idProvider AS VARCHAR(50)) + CAST(pce.Solicitud AS VARCHAR(50)) as sPrePrintedNumber,                
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
'VEN' AS sSenderCountryCode,
C.Correo AS sSenderEmail,                   
convert(DATETIME,isnull(C.Fecha_Nac,'1900-01-01'),103) AS dSenderDOB,                   
PM.PAI_ISO3 AS sTypeIDSender,                   
C.Auxiliar AS sNumIDSender,                 
isnull(C.Fecha_Carga,'1900-01-01') AS dIssueIDDate,                   
convert(DATETIME, isnull(pce.Fecha_Riscatto,'1900-01-01'),103) AS dExpirationIDDate,                   
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
pce.Solicitud AS Solicitud,                   
isnull(pce.Fecha_Italcadivi,'1900-01-01') AS Fecha_Sol,                    
pce.Auxiliar_Benef AS Auxiliar_Benef,                   
isnull(pce.Fecha_enviocadivi,'1900-01-01') as fecha_aprob_cadivi,                   
isnull(pce.fecha_liberacion,'1900-01-01') as fecha_bcv,                   
isnull(pce.Fecha_Riscatto,'1900-01-01') as fecha_devolucion,                   
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
END AS aux1  
  
FROM  planilla_cadiviespecial pce with(nolock)                                                                      
INNER JOIN Detalles_Cadivi dc with(nolock)on ( pce.operacioncierre=dc.opercadivi)                                                                                             
INNER JOIN enlaces_Cadivi ec with(nolock)on (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)                          
INNER JOIN Enlaces E ON ((EC.Operacion = E.Operacion) /*OR (EC.Operacion = E.OperacionCierre)*/)                                
INNER JOIN tLinksExchangeInstrument L with(nolock)ON  L.operationSource = E.OperacionCierre                                                                                         
INNER JOIN tmoneysendtransaction T with(nolock)ON  T.FinalOperation=L.operationTarget                          
AND (ISNULL(t.finaloperation,'') <> ''  and ISNULL(t.stateService,'') = '' AND  t.idProvider IS NOT NULL )                                                                                              
INNER JOIN TRUSADBENEFICIARIO TRB with(nolock)ON ( TRB.SOLICITUD=PCe.SOLICITUD  AND TRB.AUXILIARBENEF=PCe.Auxiliar_Benef)                                                                                                                                     
INNER JOIN TRUSADSOLICITANTE TRS with(nolock)ON (TRS.SOLICITUD=TRB.SOLICITUD AND  TRS.AUXILIARSOL=PCe.Auxiliar_Sol)                                                                                                                                   
INNER JOIN Clientes C with(nolock)ON  C.Auxiliar  =TRS.auxiliarsol                                                                              
INNER JOIN MtPaisesmundo PM with(nolock)ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                                                                                                 
INNER JOIN MtEstadosmundo EM with(nolock)ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                                                                                                      
LEFT OUTER JOIN tblrusadtransferencia tt with(nolock)ON tt.solicitud = PCe.Solicitud and tt.auxiliarbenef = PCe.Auxiliar_Sol                                                                                                  
LEFT OUTER JOIN MtproviderAgents ba with(nolock)ON ba.returnnumber = trb.Agent  and ba.providerAcronym = t.providerAcronym and ba.iso3Code = TRB.Cod_Pais   

WHERE

	((TRB.Cod_Pais IN ('CAN') AND TT.codcuenta IS NOT NULL) OR (TRB.Cod_Pais NOT IN ('CAN')))       
 and TRB.telefono_benef <> '0' 
 AND TRB.Cod_Pais IN ('CAN','CHN','USA') 
 AND t.ProviderAcronym = 'FT'    
 AND pce.Auxiliar_Sol NOT IN (select t1.auxiliar_sol from tClientesBloqueados t1 where t1.estado='B' and t1.auxiliar_sol=pce.Auxiliar_Sol )    
  
--***************************************************************************************************************
--*************************************************************************************************************** 
  
  