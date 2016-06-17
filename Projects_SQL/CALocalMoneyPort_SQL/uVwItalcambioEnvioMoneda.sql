      
      
        
        
        
        
            
CREATE VIEW uVwItalcambioEnvioMoneda                                                        
/* Creado por Vladimir Yépez 03-01-2013                                                        
   Trae a todas aquellas operaciones que están pendientes por enviarse al proveedor,                                                        
   con toda la información correspondiente del proveedor.                                                             
*/                                                       
AS                                                         
SELECT DISTINCT                                                       
  --Datos del remitente                                                        
  ISNULL(c.Auxiliar,'') AS senderId,                                                        
  ISNULL(c.Nombres,'') AS firstNameRemitter,                                                        
  ISNULL(c.SegundoNombre,'') AS secondNameRemitter,                                                        
  ISNULL(c.Apellido1,'') AS firstLastNameRemitter,                                                        
  ISNULL(c.Apellido2,'') AS secondLastNameRemitter,                                                        
  ISNULL(c.TH_Numero,'') AS phoneRemitter,                                                        
  ISNULL(c.TC_Numero,'') AS phoneRemitter2,                                                       
  ISNULL(c.DH_Sector,'') + ' ' + ISNULL(c.DH_Avenida,'') + ' ' + ISNULL(c.DH_Residencia,'') + ' ' +                                                         
  ISNULL(c.DH_Numero,'') + ' ' + ISNULL(c.DH_Piso,'') + ' ' + ISNULL(c.DH_Municipio,'') AS addressRemitter,                                                        
  ISNULL(c.DH_Ciudad,'') AS cityRemitter,                                                        
  ISNULL(c.DH_Estado,'') AS stateRemitter,                                                        
  ISNULL(c.Correo,'') AS emailRemitter,                                                      
  ISNULL(c.Fecha_Nac,'') AS dateOnBornRemitter,                                                      
  ISNULL(c.Fecha_Carga,'') AS dIssueIDDate,                                                      
  ISNULL(c.Cargo,'') AS sSenderOcupation,                                                      
  ISNULL(c.Antiguedad,'') AS sSourceFund,                                                      
  ISNULL(c.MotivoServicio,'') AS sReasonTxt,                                                      
  ISNULL(c.DH_ZonaPostal,'') AS senderZipCode,                                                        
  ISNULL(c.DH_Pais,'') AS senderCountry,                                                        
  --Datos del beneficiario                                                        
  ISNULL(b.Auxiliar_Benef,'') AS idBeneficiary,                                                          
  ISNULL(b.Nombre1_Benef,'') AS firstNameBeneficiary,                                                        
  ISNULL(b.Nombre2_Benef,'') AS secondNameBeneficiary,                                                        
  ISNULL(b.Apellido1_Benef,'') AS firstLastNameBeneficiary,                                                        
  ISNULL(b.Apellido2_Benef,'') AS secondLastNameBeneficiary,                                                        
  ISNULL(b.Telefono_Benef,'') AS phoneBeneficiary,                                                       
  ISNULL(b.Email_Benef,'') AS emailBeneficiary,                                                       
  SUBSTRING(ISNULL(b.Direccion_Benef,''),1,40) AS addressBeneficiary,                                                     
  ISNULL(b.Cod_Ciudad,'')  AS cityBeneficiary,                                                
  CASE WHEN (i.sBranchStateCode IS NULL OR  i.sBranchStateCode = '') THEN                                                
   ISNULL(b.Cod_Estado,'')                     
    ELSE                                                
   ISNULL(i.sBranchStateCode,'')                                                
  END AS stateBeneficiary,                                           
  '' as senderZipCodeBenef,              
  ISNULL(pm.pai_iso3,'') AS senderCountryBenef,                            
  --Datos de la transaccion             
  ISNULL(t.providerAcronym,'') AS providerAcronym,                     
  ISNULL(pr.ProviderName,'') AS providerName,                   
  ISNULL(t.idProvider,0) AS idProvider,                                                        
  ISNULL(t.codOperation,'') AS operationBoxOffice,                                                        
  ISNULL(t.finalOperation,'') AS operationCashier,                                                        
  ISNULL(m.Fecha,'1900-01-01') AS paymentDateCashier,                                                        
  CONVERT(VARCHAR,GETDATE(),112) AS orderDate,   --LR 20/03/2014 Formato Fecha a yyyymmdd                
  'USD' AS sendCurrency,                                                        
  replace(convert(varchar(50),CAST(cd.amount AS decimal(16,2))), ',', '.') AS amount,                                                         
  ISNULL(i.bankName,'') AS bankName,                                                        
  ISNULL(i.bankAddress,'') AS bankAddress,                                                        
  ISNULL(i.BankCode,'') AS bankCode,                                   
  ISNULL(i.phone,'') AS phoneBank,                                                        
  ISNULL(i.typeAccount,'') AS typeAccount, --PT o DC                                       
  ISNULL(i.sGroupBranchCode,'') AS sGroupBranchCode,                           
  CASE WHEN i.sCurrencyPayCode = 'A' THEN                          
    'D'                          
    ELSE                          
    ISNULL(i.sCurrencyPayCode,'')                          
  END AS sCurrencyPayCode,                                                                             
  ISNULL(i.sBranchCodePay,'') AS sBranchCodePay,                                                      
  ISNULL(pm.pai_iso3,'') AS pai_iso3,                                              
  replace(convert(varchar(50),CAST(t.exchangeRateApplied AS decimal(16,2))), ',', '.') AS exchangeRateApplied,                                               
  replace(convert(varchar(50),CAST(1 AS decimal(16,2))), ',', '.') AS Fixing,                                                      
  CASE WHEN i.pai_iso3 IN ('CAN') THEN                                               
   '2'                                                          
  ELSE                                                          
   ''                                                          
  END AS sTypeAcc,                                                        
  --Datos de la cuenta bancaria si los tiene                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.bankName,'')                                                        
  END AS bankNameAccount,                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.bankCode,'')                                                        
  END AS bankCodeAccount,                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.bankAddress,'')                                                        
  END AS bankAddressAccount,                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   'USD'                                                        
    ELSE                                                        
 (Select Simbolo from divisas where divisa=bad.currencyCode)                                                        
  END AS currencyCode,                    
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   'DOLAR USA'               
    ELSE                                                        
   ISNULL(bad.currency,'')                                                        
  END AS currency,                                                      
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
 ''                          
    ELSE                                                        
   ISNULL(bad.typeAccount,'')                                                        
  END AS bankTypeAccount, --C o A                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.accountNumber,'')                                                        
  END AS accountNumber,                                                         
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                  
   ISNULL(bad.idRegion,'')                                                        
  END AS idRegion,                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.region,'')                                                        
  END AS region,                                                         
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                              
    ELSE                                                        
   ISNULL(bad.aba,'')                                                        
  END AS aba,                                                         
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.swift,'')                                                        
  END AS swift,                                                         
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.iban,'')                                   
  END AS iban,                                                         
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                                                        
    ELSE                                                        
   ISNULL(bad.institutionNumber,0)                                                        
  END AS institutionNumber,                                                        
  CASE WHEN bad.accountNumber IS NULL THEN                                                        
   ''                     
  ELSE                                                        
   ISNULL(bad.officeNumber,'')                                                        
  END AS officeNumber,                                                    
  ISNULL(pm.pai_iso2,'') AS pai_iso2,          
  isnull(i.cityCode,'') AS cityCodeInfP,                                
  isnull(i.sBranchCityCode,'') AS  sBranchCityCode,                              
  isnull(i.sBranchBankCode,'') as  sBranchBankCode,              
  ISNULL(EM.EST_NOMBRE,'') AS  stateNameBeneficiary,            
  -- LR 22/04/2014 --> CPF Benef cuando es Brasil            
  CASE WHEN pm.pai_iso3='BRA' AND t.providerAcronym='JP' AND LEN(b.Auxiliar_Benef)= 12 THEN            
 replace(replace(CONVERT(varchar, convert(money, SUBSTRING(b.Auxiliar_Benef, 2,len(b.Auxiliar_Benef)-3)),1),',','.'),'.00','') +             
    '-' + substring(b.Auxiliar_Benef,len(b.Auxiliar_Benef)-1,len(b.Auxiliar_Benef))                               
  ELSE            
    ISNULL(b.Auxiliar_Benef,'')            
  END AS CPF,          
  ISNULL(b.Email_Benef,'') as emailBeneficiario,          
  ISNULL(m.CodAgencia,0) AS sendIdAgency                                             
  --******                                                       
FROM tMoneysendtransaction t                                                              
INNER JOIN tInformationprovider i ON t.codOperation = i.operation                                                              
INNER JOIN tCostDetails cd ON t.codOperation = cd.operation                                                              
INNER JOIN clientes c ON t.codSender = c.Auxiliar                                                            
INNER JOIN tbeneficiarioSicadII b ON t.codReceiver = b.Auxiliar_Benef AND t.CodSender = b.Auxiliar_Solic                                                          
INNER JOIN mtPaisesMundo pm ON t.rcvCountry = pm.Pai_iso3                                                        
INNER JOIN mtProvider pr ON t.providerAcronym = pr.providerAcronym                                                          
INNER JOIN Movimien m ON t.FinalOperation = m.Operacion                                                          
INNER JOIN Agencias a ON m.CodAgencia = a.CodAgencia               
INNER JOIN MtEstadosmundo EM ON (PM.PAI_ISO2 = EM.PAI_ISO2 AND b.Cod_Estado = EM.COD_ESTADO)       
INNER JOIN tAutSicad2 tas ON t.finalOperation = tas.OperacionFinal                                                        
LEFT OUTER JOIN tBankAccountDetails bad ON b.Auxiliar_Benef = bad.idBeneficiary AND t.rcvCountry = bad.pai_iso3                                                        
WHERE                                                           
   m.Estado = 'C'                                                          
 AND (t.FinalOperation IS NOT NULL AND t.FinalOperation <> '')                                                          
 AND (t.stateService IS NULL OR t.stateService = '')                                                        
 AND (t.idProvider IS NOT NULL AND t.idProvider <> '')      
 AND tas.Status = 'A'                                      
                   
--******************************************                                                          
--******************************************   
  
--select * from uVwItalcambioEnvioMoneda