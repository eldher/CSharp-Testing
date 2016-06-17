  
    
--*****************************************************************************************        
--*****************************************************************************************        
ALTER PROC uSpReturnInformationExchangeInstrumentEstCEImp                        
/* Creado por: Vladimir Yepez 26-12-2012                        
   Este Store Procedure Retorna Informacion correspondiente a una remesa estudiantil,         
   caso especial o importacion que se le permita realizar cambio de instrumento         
   si el giro no ha sido cancelado.                        
*/         
@Operacion varchar(30)              
AS        
SELECT        
isnull(c.Auxiliar,'') as idCliente,        
ltrim(isnull(c.Apellido1,'') + ' ' + isnull(c.Apellido2,'')) + ',' + ltrim(isnull(c.Nombres,'')+ ' ' + isnull(c.SegundoNombre,'')) as Cliente,         
replace(convert(varchar(50),CAST(e.MontoDivisa AS decimal(16,2))), '.', ',') as montoBenef,        
replace(convert(varchar(50),CAST(e.tasa AS decimal(16,2))), '.', ',') as Tasa,         
isnull(trb.auxiliarbenef,'') as Auxiliar_Benef,        
ltrim(isnull(trb.nombre_benef1,'')) + ' ' + ltrim(isnull(trb.nombre_benef2,'')) as nombreBeneficiario,                                  
ltrim(isnull(trb.apellido_benef1,'')) + ' ' + ltrim(isnull(trb.apellido_benef2,'')) as apellidoBeneficiario,                            
isnull(trb.direccion_benef,'') as direccionBeneficiario,                                                                                                           
isnull(trb.ciudad_benef,'') as ciudadBeneficiario,                                                            
isnull(trb.ciudad_benef,'') as provinciaBeneficiario,                                                          
isnull(trb.telefono_benef,'') as telefono1Beneficiario,        
isnull(pm.PAI_NOMBRE,'') AS paisBeneficiario,        
isnull(r.OperacionCierre,'') as OperacionFinal,        
isnull(trb.solicitud,'') as Solicitud,        
Convert(varchar(10),r.Fecha,103) AS Fecha_Sol,        
'TRANSFERENCIA' as instrumentoOriginal,        
'TF' as instrumento,        
'0' as feeAmount,        
'USD' as ReceiveCurrrency,        
'0' as CodDestino,        
pm.pai_iso2 as CodCountry,                  
trb.Cod_Ciudad           
            
FROM autorizaciontransferencia r        
INNER JOIN  Clientes  c ON r.Auxiliar   = c.Auxiliar               
INNER JOIN  Enlaces_Cadivi  e ON r.OperacionCierre  = e.Operacion               
INNER JOIN  Detalles_Cadivi  dc ON e.OperacionCierre  = dc.OperCadivi                
INNER JOIN  Enlaces el ON e.Operacion = el.OperacionCierre          
INNER JOIN  Movimien m ON el.Operacion = m.Operacion              
LEFT OUTER JOIN Planilla_Cadivi   pc ON dc.OperCadivi  = pc.OperacionCierre               
LEFT OUTER JOIN Planilla_Importaciones  pci ON dc.OperCadivi  = pci.OperacionCierre               
LEFT OUTER JOIN Planilla_CadiviEspecial  pce  ON dc.OperCadivi  = pce.OperacionCierre           
LEFT OUTER JOIN  tRusadbeneficiario trb ON (   pc.Solicitud = trb.solicitud         
                                            OR pce.Solicitud = trb.solicitud         
                                            OR pci.Solicitud = trb.solicitud)           
INNER JOIN MtPaisesmundo pm ON trb.Cod_Pais = pm.PAI_ISO3         
WHERE         
 r.OperacionCierre = @Operacion        
 AND r.Estado in ('A','T')       
       
       
--***********************************      
UNION      
--***********************************      
      
       
SELECT       
      
isnull(c.Auxiliar,'') as idCliente,        
ltrim(isnull(c.Apellido1,'') + ' ' + isnull(c.Apellido2,'')) + ',' + ltrim(isnull(c.Nombres,'')+ ' ' + isnull(c.SegundoNombre,'')) as Cliente,         
replace(convert(varchar(50),CAST(ec.MontoDivisa AS decimal(16,2))), '.', ',') as montoBenef,        
replace(convert(varchar(50),CAST(ec.tasa AS decimal(16,2))), '.', ',') as Tasa,         
isnull(trb.auxiliarbenef,'') as Auxiliar_Benef,        
ltrim(isnull(trb.nombre_benef1,'')) + ' ' + ltrim(isnull(trb.nombre_benef2,'')) as nombreBeneficiario,                                  
ltrim(isnull(trb.apellido_benef1,'')) + ' ' + ltrim(isnull(trb.apellido_benef2,'')) as apellidoBeneficiario,                            
isnull(trb.direccion_benef,'') as direccionBeneficiario,                                                                                                           
isnull(trb.ciudad_benef,'') as ciudadBeneficiario,                                                            
isnull(trb.ciudad_benef,'') as provinciaBeneficiario,                                                          
isnull(trb.telefono_benef,'') as telefono1Beneficiario,        
isnull(pm.PAI_NOMBRE,'') AS paisBeneficiario,        
isnull(m.OperacionCierre,'') as OperacionFinal,        
isnull(trb.solicitud,'') as Solicitud,        
Convert(varchar(10),mo.Fecha,103) AS Fecha_Sol,        
'MONEYGRAM' as instrumentoOriginal,        
'MG' as instrumento,        
'0' as feeAmount,        
'USD' as ReceiveCurrrency,        
'0' as CodDestino,        
pm.pai_iso2 as CodCountry,                  
trb.Cod_Ciudad       
      
FROM moneygram m      
      
INNER JOIN movimien mo ON m.OperacionCierre = mo.Operacion      
      
INNER JOIN enlaces e ON m.OperacionCierre = e.OperacionCierre      
      
INNER JOIN enlaces e1 ON e.Operacion = e1.OperacionCierre      
      
INNER JOIN enlaces_cadivi ec ON e1.Operacion = ec.Operacion      
      
INNER JOIN detalles_cadivi dc ON (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)       
      
INNER JOIN planilla_cadivi pc ON (dc.opercadivi = pc.operacioncierre)         
      
INNER JOIN TRUSADBENEFICIARIO TRB ON (PC.SOLICITUD = TRB.SOLICITUD AND PC.Auxiliar_Est=TRB.AUXILIARBENEF)                                                            
            
INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND PC.Auxiliar_Rep = TRS.AUXILIARSOL)                                                            
            
INNER JOIN Clientes C ON TRS.auxiliarsol = C.Auxiliar                                                                                               
            
INNER JOIN MtPaisesmundo PM ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                       
            
INNER JOIN MtEstadosmundo EM ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                             
            
LEFT JOIN tblrusadtransferencia tt ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                      
            
LEFT JOIN MtproviderAgents ba ON ba.returnnumber = trb.Agent  and ba.providerAcronym = 'MG' and ba.iso3Code = TRB.Cod_Pais                  
      
WHERE      
      
m.OperacionCierre = @Operacion      
      
--*********************************************      
UNION      
--*********************************************      
      
SELECT       
      
isnull(c.Auxiliar,'') as idCliente,        
ltrim(isnull(c.Apellido1,'') + ' ' + isnull(c.Apellido2,'')) + ',' + ltrim(isnull(c.Nombres,'')+ ' ' + isnull(c.SegundoNombre,'')) as Cliente,         
replace(convert(varchar(50),CAST(ec.MontoDivisa AS decimal(16,2))), '.', ',') as montoBenef,        
replace(convert(varchar(50),CAST(ec.tasa AS decimal(16,2))), '.', ',') as Tasa,         
isnull(trb.auxiliarbenef,'') as Auxiliar_Benef,        
ltrim(isnull(trb.nombre_benef1,'')) + ' ' + ltrim(isnull(trb.nombre_benef2,'')) as nombreBeneficiario,                                  
ltrim(isnull(trb.apellido_benef1,'')) + ' ' + ltrim(isnull(trb.apellido_benef2,'')) as apellidoBeneficiario,                            
isnull(trb.direccion_benef,'') as direccionBeneficiario,                                                                                                           
isnull(trb.ciudad_benef,'') as ciudadBeneficiario,                                                            
isnull(trb.ciudad_benef,'') as provinciaBeneficiario,                                                          
isnull(trb.telefono_benef,'') as telefono1Beneficiario,        
isnull(pm.PAI_NOMBRE,'') AS paisBeneficiario,        
isnull(m.FinalOperation,'') as OperacionFinal,        
isnull(trb.solicitud,'') as Solicitud,        
Convert(varchar(10),mo.Fecha,103) AS Fecha_Sol,        
mp.providerName as instrumentoOriginal,        
m.ProviderAcronym as instrumento,        
'0' as feeAmount,        
'USD' as ReceiveCurrrency,        
'0' as CodDestino,        
pm.pai_iso2 as CodCountry,                  
trb.Cod_Ciudad       
      
FROM tMoneySendtransaction m      
      
INNER JOIN movimien mo ON m.FinalOperation = mo.Operacion      
      
INNER JOIN mtProvider mp ON m.providerAcronym = mp.providerAcronym      
      
INNER JOIN enlaces e ON m.FinalOperation = e.OperacionCierre      
      
INNER JOIN enlaces e1 ON e.Operacion = e1.OperacionCierre      
      
INNER JOIN enlaces_cadivi ec ON e1.Operacion = ec.Operacion      
      
INNER JOIN detalles_cadivi dc ON (ec.operacioncierre = dc.opercadivi and ec.operdetalle=dc.operacion)       
      
INNER JOIN planilla_cadivi pc ON (dc.opercadivi = pc.operacioncierre)         
      
INNER JOIN TRUSADBENEFICIARIO TRB ON (PC.SOLICITUD = TRB.SOLICITUD AND PC.Auxiliar_Est=TRB.AUXILIARBENEF)                                                            
            
INNER JOIN TRUSADSOLICITANTE TRS ON (TRB.SOLICITUD=TRS.SOLICITUD AND PC.Auxiliar_Rep = TRS.AUXILIARSOL)                                                            
            
INNER JOIN Clientes C ON TRS.auxiliarsol = C.Auxiliar                                                                                               
            
INNER JOIN MtPaisesmundo PM ON (TRB.Cod_Pais = PM.PAI_ISO3)                                                       
            
INNER JOIN MtEstadosmundo EM ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND TRB.Cod_Estado = EM.COD_ESTADO)                                             
            
LEFT JOIN tblrusadtransferencia tt ON tt.solicitud = PC.Solicitud and tt.auxiliarbenef = PC.Auxiliar_EST                                      
            
LEFT JOIN MtproviderAgents ba ON ba.returnnumber = trb.Agent  and ba.providerAcronym = m.providerAcronym and ba.iso3Code = TRB.Cod_Pais                  
      
WHERE      
      
  ISNULL(m.finaloperation,'') <> ''  and ISNULL(m.stateService,'') = ''                          
            
AND  m.idProvider IS NOT NULL      
         
and  m.FinalOperation = @Operacion  
  
  
--*********************************************      
UNION      
--*********************************************      
  
  
  
  
SELECT  
    isnull(c.Auxiliar,'') as idCliente,        
 ltrim(isnull(c.Apellido1,'') + ' ' + isnull(c.Apellido2,'')) + ',' + ltrim(isnull(c.Nombres,'')+ ' ' + isnull(c.SegundoNombre,'')) as Cliente,         
 replace(convert(varchar(50),CAST(a.monto AS decimal(16,2))), '.', ',') as montoBenef,        
 replace(convert(varchar(50),CAST(a.tasadecambio AS decimal(16,2))), '.', ',') as Tasa,         
 isnull(trb.auxiliarbenef,'') as Auxiliar_Benef,        
 ltrim(isnull(trb.nombre_benef1,'')) + ' ' + ltrim(isnull(trb.nombre_benef2,'')) as nombreBeneficiario,                                  
 ltrim(isnull(trb.apellido_benef1,'')) + ' ' + ltrim(isnull(trb.apellido_benef2,'')) as apellidoBeneficiario,                            
 isnull(trb.direccion_benef,'') as direccionBeneficiario,                                                                                                           
 isnull(trb.ciudad_benef,'') as ciudadBeneficiario,                                                            
 isnull(trb.ciudad_benef,'') as provinciaBeneficiario,                                                          
 isnull(trb.telefono_benef,'') as telefono1Beneficiario,        
 isnull(pm.PAI_NOMBRE,'') AS paisBeneficiario,        
 isnull(a.OperacionCierre,'') as OperacionFinal,        
 isnull(trb.solicitud,'') as Solicitud,        
 Convert(varchar(10),m.Fecha,103) AS Fecha_Sol,        
 'MONEYGRAM' as instrumentoOriginal,        
 'MG' as instrumento,    
 '0' as feeAmount,        
 'USD' as ReceiveCurrrency,        
 '0' as CodDestino,        
 pm.pai_iso2 as CodCountry,                  
 trb.Cod_Ciudad       
 FROM  Moneygram a          
 INNER JOIN  Clientes  c ON a.Auxiliar = c.Auxiliar       
 INNER JOIN  Movimien  m ON a.OperacionCierre = m.Operacion      
 INNER JOIN  Detalles_Cadivi dc ON ((CONVERT(varchar(10),m.fecha,103)) = (CONVERT(varchar(10),dc.Fecha_Entrega,103)))         
 INNER JOIN Planilla_Cadivi   pc ON dc.OperCadivi  = pc.OperacionCierre      
 INNER JOIN tRusadsolicitante trs ON  (pc.Solicitud = trs.solicitud AND m.Auxiliar = trs.auxiliarsol)          
 LEFT OUTER JOIN  tRusadbeneficiario trb ON (trs.Solicitud = trb.solicitud AND pc.Auxiliar_Est = trb.auxiliarbenef)      
 INNER JOIN MtPaisesmundo pm ON trb.Cod_Pais = pm.PAI_ISO3        
 WHERE      
       (m.codtransaccion in (66))   
  and a.OperacionCierre = @Operacion  
       
--*****************************************************************************************        
--*****************************************************************************************         

  
--*********************************************      
UNION      
--*********************************************      

       
   
SELECT        
isnull(c.Auxiliar,'') as idCliente,        
ltrim(isnull(c.Apellido1,'') + ' ' + isnull(c.Apellido2,'')) + ',' + ltrim(isnull(c.Nombres,'')+ ' ' + isnull(c.SegundoNombre,'')) as Cliente,         
replace(convert(varchar(50),CAST(e.MontoDivisa AS decimal(16,2))), '.', ',') as montoBenef,        
replace(convert(varchar(50),CAST(e.tasa AS decimal(16,2))), '.', ',') as Tasa,         
isnull(trb.auxiliarbenef,'') as Auxiliar_Benef,        
ltrim(isnull(trb.nombre_benef1,'')) + ' ' + ltrim(isnull(trb.nombre_benef2,'')) as nombreBeneficiario,                                  
ltrim(isnull(trb.apellido_benef1,'')) + ' ' + ltrim(isnull(trb.apellido_benef2,'')) as apellidoBeneficiario,                            
isnull(trb.direccion_benef,'') as direccionBeneficiario,                                                                                                           
isnull(trb.ciudad_benef,'') as ciudadBeneficiario,                                                            
isnull(trb.ciudad_benef,'') as provinciaBeneficiario,                                                          
isnull(trb.telefono_benef,'') as telefono1Beneficiario,        
isnull(pm.PAI_NOMBRE,'') AS paisBeneficiario,        
isnull(r.OperacionCierre,'') as OperacionFinal,        
isnull(trb.solicitud,'') as Solicitud,        
Convert(varchar(10),m.Fecha,103) AS Fecha_Sol,              
'MONEYGRAM' as instrumentoOriginal,        
'MG' as instrumento,        
'0' as feeAmount,        
'USD' as ReceiveCurrrency,        
'0' as CodDestino,        
pm.pai_iso2 as CodCountry,                  
trb.Cod_Ciudad         
FROM moneygram r        
INNER JOIN  Clientes  c ON r.Auxiliar   = c.Auxiliar
INNER JOIN Enlaces en ON en.OperacionCierre = r.Operacion              
INNER JOIN  Enlaces_Cadivi  e ON e.Operacion  = en.Operacion               
INNER JOIN  Detalles_Cadivi  dc ON e.OperacionCierre  = dc.OperCadivi                      
INNER JOIN  Movimien m ON m.Operacion = r.OperacionCierre   
LEFT OUTER JOIN Planilla_Cadivi   pc ON dc.OperCadivi  = pc.OperacionCierre               
LEFT OUTER JOIN Planilla_Importaciones  pci ON dc.OperCadivi  = pci.OperacionCierre               
LEFT OUTER JOIN Planilla_CadiviEspecial  pce  ON dc.OperCadivi  = pce.OperacionCierre           
LEFT OUTER JOIN  tRusadbeneficiario trb ON (   pc.Solicitud = trb.solicitud         
                                            OR pce.Solicitud = trb.solicitud         
                                            OR pci.Solicitud = trb.solicitud)           
INNER JOIN MtPaisesmundo pm ON trb.Cod_Pais = pm.PAI_ISO3         
WHERE         
 r.OperacionCierre = @Operacion  
 AND m.Estado in ('C')  
