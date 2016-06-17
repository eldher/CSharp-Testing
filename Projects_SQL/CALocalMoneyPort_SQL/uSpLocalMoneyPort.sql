          
CREATE PROCEDURE [dbo].[uSpLocalMoneyPort]          
          
@sendProAcro varchar(3)=NULL,          
@receiveProAcro varchar(3)=NULL,          
@requestType varchar(10)=NULL,          
@finalOperation varchar(30)=NULL  
AS          
BEGIN        
        
DECLARE @sendLogin varchar(30)          
DECLARE @sendPassword varchar(30)       
DECLARE @currencyPayment varchar(3)        
    
    
    
           
IF (@requestType='CREDENTIAL')          
 BEGIN          
 SELECT         
 @sendLogin = mtais.sendLogin,        
 @sendPassword=mtais.sendPassword,      
 @currencyPayment =mtais.currencyPayment                                   
   FROM mtAccesoItalcambioService mtais          
   WHERE           
   sendProviderAcronym=@sendProAcro           
   AND receiptIdCompany=@receiveProAcro        
   AND mtais.status <> 'D'         
         
 SELECT       
 ISNULL(@sendLogin,'DENIED') as sendLogin,       
 ISNULL(@sendPassword,'DENIED') as sendPassword,        
 ISNULL(@currencyPayment,'DENIED') as currencyPayment      
 END         
--END (@requestType='CREDENTIAL')          
          
      
          
          
IF (@requestType='SEND')          
 BEGIN          
  SELECT                  
 operationCashier as operationfinal,                
 senderId as IdSender,                
 firstNameRemitter as FirstNameSender,                
 secondNameRemitter as SecondNameSender,                
 firstLastNameRemitter as LastNameSender,                
 secondLastNameRemitter as SecondLastNamerSender,                
 IdBeneficiary as IdBeneficiary,                
 firstNameBeneficiary as FirstNameBeneficiary,                
 secondNameBeneficiary as SecondNameBeneficiary,                
 firstLastNameBeneficiary as LastNameBeneficiary,                
 secondLastNameBeneficiary as SecondLastNameBeneficiary,                
 addressBeneficiary as AddressBeneficiary,                
 CityBeneficiary as CityBeneficiary,                
 Amount as Amount,                
 senderCountryBenef as Country,                
 PhoneBeneficiary as PhoneBeneficiary,                
 --KeySender, lo genera la aplicacion                
 --IdCompany, lo genera la aplicacion                
 --SendDate, lo genera la aplicacion                
 IdProvider as IdProvider,                
 senderCountryBenef as pai_iso3,                
 typeAccount as paymenttype,                
 bankName as bankName,                
 bankAddress,                
 bankCode,                
 phoneBank as phone,                
 sGroupBranchCode,                
 sCurrencyPayCode,                
 sBranchCodePay,                
 currencyCode,                
 currency,                
 banktypeAccount as typeAccount,                
 accountNumber,                
 idRegion,                
 aba,                
 swift,                
 iban,                
 bankCodeAccount as idAgency,                
 bankAddressAccount as agency,                
 institutionNumber,                
 officeNumber,                
 Fixing,                
 exchangeRateApplied,ProviderAcronym,senderCountryBenef,        
 emailBeneficiary,        
 sendIdAgency           
  FROM uvwGirostMoneySendTransaction WHERE operationCashier=@finalOperation          
END        
--END (@requestType='SEND')         
        
        
        
        
IF (@requestType='GETKEY')        
 BEGIN        
 SELECT ISNULL(CONVERT(varchar,providerAcronym),'')as providerAcronym ,ISNULL(CONVERT(varchar,idProvider),'') as idProvider         
 FROM tMoneySendTransaction WHERE finalOperation=@finaloperation        
 END        
--END (@requestType='GETKEY')        
          
END     
    
    
-- Se trae todos los giros Aprobados por el BCV     
IF (@requestType='SENDALL')          
 BEGIN          
  SELECT                  
 operationCashier as operationfinal,                
 senderId as IdSender,                
 firstNameRemitter as FirstNameSender,                
 secondNameRemitter as SecondNameSender,                
 firstLastNameRemitter as LastNameSender,                
 secondLastNameRemitter as SecondLastNamerSender,                
 IdBeneficiary as IdBeneficiary,                
 firstNameBeneficiary as FirstNameBeneficiary,                
 secondNameBeneficiary as SecondNameBeneficiary,       
 firstLastNameBeneficiary as LastNameBeneficiary,                
 secondLastNameBeneficiary as SecondLastNameBeneficiary,                
 addressBeneficiary as AddressBeneficiary,                
 CityBeneficiary as CityBeneficiary,                
 Amount as Amount,                
 senderCountryBenef as Country,                
 PhoneBeneficiary as PhoneBeneficiary,                
 --KeySender, lo genera la aplicacion                
 --IdCompany, lo genera la aplicacion                
 --SendDate, lo genera la aplicacion                
 IdProvider as IdProvider,                
 senderCountryBenef as pai_iso3,                
 typeAccount as paymenttype,                
 bankName as bankName,                
 bankAddress,                
 bankCode,                
 phoneBank as phone,                
 sGroupBranchCode,                
 sCurrencyPayCode,                
 sBranchCodePay,                
 currencyCode,                
 currency,                
 banktypeAccount as typeAccount,                
 accountNumber,                
 idRegion,                
 aba,                
 swift,                
 iban,                
 bankCodeAccount as idAgency,                
 bankAddressAccount as agency,                
 institutionNumber,                
 officeNumber,                
 Fixing,                
 exchangeRateApplied,ProviderAcronym,senderCountryBenef,        
 emailBeneficiary,        
 sendIdAgency           
  FROM uVwItalcambioEnvioMoneda-- WHERE operationCashier=@finalOperation          
END        
--END (@requestType='SEND')         
        
       
--EOF   
  
  
--IF   
  
--           ([ProviderAcronym]  
--           ,[PaymentKey]  
--           ,[Response]  
--           ,[IdCliente])  
       
          
-- uSpLocalMoneyPort ID,OI,'CREDENTIAL'          
-- uSpLocalMoneyPort FT,MT          
-- uSpLocalMoneyPort FT,OI          
-- uSpLocalMoneyPort ID,OI,'GETKEY','013004201407590002','SEND' 