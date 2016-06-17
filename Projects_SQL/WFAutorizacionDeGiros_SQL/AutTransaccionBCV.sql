ALTER PROCEDURE [dbo].[AutTransaccionBCV]      
--  
-- @eldher 27.08.2014    
     
@opcion varchar(30),    
@status varchar(30),    
@finalOperation varchar(40) = NULL,  
@codOperation varchar(40) = NULL,  
@amountOld money = NULL,  
@amountNew money = NULL     
      
AS      
      
DECLARE @status_buscar varchar(20)      


---------------
--------------- C A R G A R
---------------
    
IF (@opcion ='CARGAR')    
    
BEGIN      
 SELECT @status_buscar =       
       
 CASE @status      
  WHEN 'APROBADAS' THEN 'A'      
  WHEN 'PENDIENTES' THEN ''      
  WHEN 'DENEGADAS' THEN 'R'      
  WHEN 'DEVUELTAS' THEN 'C'       
 END      
     
 SELECT 
	tas2.OperacionFinal,
	tas2.Status,
	tas2.FechaCreacion,
	tas2.FechaModificacion, 
	t.*,
	c.Nombres +' '+ c.Apellido1 as NameSender,  
	Nombre1_Benef +' '+ Apellido1_Benef as NameReceiver      
     
 FROM TautSicad2 tas2      
 INNER JOIN tMoneySendtransaction t ON tas2.OperacionFinal = t.FinalOperation      
 INNER JOIN Clientes c on c.Auxiliar=t.CodSender    
 INNER JOIN tBeneficiarioSicadII ts2 on ts2.Auxiliar_Benef = t.codReceiver     
	WHERE tas2.Status = @status_buscar
	ORDER by t.TimeStamp DESC   
END    


---------------
--------------- C A R G A R C O N T R A T O  S
---------------

IF (@opcion = 'CARGARCONTRATOS')
BEGIN
   IF (@status = 'PENDIENTES')
	select * from  vwContratosEmitidos    
   
   IF (@status = 'APROBADOS')
	exec uSpContratosPendientes 'V'
   
   IF (@status = 'DENEGADOS')
	exec uSpContratosPendientes 'V'
END

  
---------------
--------------- C O N S U L T A
---------------
    
IF (@opcion = 'CONSULTA')    
BEGIN    
 SELECT tas2.OperacionFinal,tas2.Status,tas2.FechaCreacion,tas2.FechaModificacion, t.*     
 FROM TautSicad2 tas2      
 LEFT OUTER JOIN tMoneySendtransaction t ON tas2.OperacionFinal = t.FinalOperation      
 WHERE t.FinalOperation = @finalOperation    
END    
    
    
IF (@opcion = 'PRUEBA')    
BEGIN    
 SELECT tas2.OperacionFinal,tas2.Status,tas2.FechaCreacion,tas2.FechaModificacion, t.*,    
 c.Nombres +' '+ c.Apellido1 as NameSender,  Nombre1_Benef +' '+ Apellido1_Benef as NameReceiver      
     
 FROM TautSicad2 tas2      
 INNER JOIN tMoneySendtransaction t ON tas2.OperacionFinal = t.FinalOperation      
 INNER JOIN Clientes c on c.Auxiliar=t.CodSender    
 INNER JOIN tBeneficiarioSicadII ts2 on ts2.Auxiliar_Benef = t.codReceiver    
     
 WHERE t.FinalOperation = @finalOperation    
END    
    
    

---------------
--------------- D I V I D I R
---------------
    
IF (@opcion = 'DIVIDIR')   
--EXEC AutTransaccionBCV 'DIVIDIR','','010407201410760023',010407201410750080,199.26,100  
  
BEGIN    
 DECLARE @idUpdate integer   
 DECLARE @cont integer  
 DECLARE @updfinaloperation varchar(50)   
 DECLARE @newIdProvider integer  
 DECLARE @providerAcronym varchar(10)  
 DECLARE @updtcod varchar(40)  
   
 SELECT @cont = COUNT(*) FROM tmoneysendtransaction where codOperation = @codOperation   
   
 -- inserta copia del giro en tmoney  
 INSERT INTO tMoneySendtransaction  
 (providerAcronym,codOperation,finalOperation,codProductType,codSender,codReceiver,amount,feeamount,  
 exchangeRateApplied,sendCountry,sendCurrency,sendAgent,rcvCountry,rcvCurrency,rcvAgent,timeStamp,codDestination,  
 stateService,stateDate,paymentDate,expirationDate,fileName,paymentKey,smsDate,emailDate,iossDate,createUser,createDate,  
 createAplication,createMachine,idProvider)   
  
 SELECT   
 providerAcronym,codOperation,finalOperation,codProductType,codSender,codReceiver,amount,feeamount,exchangeRateApplied,  
 sendCountry,sendCurrency,sendAgent,rcvCountry,rcvCurrency,rcvAgent,timeStamp,codDestination,stateService,stateDate,  
 paymentDate,expirationDate,fileName,paymentKey,smsDate,emailDate,iossDate,createUser,createDate,createAplication,  
 createMachine,idProvider  
 FROM tMoneySendtransaction  
 WHERE finalOperation = @finalOperation  
 --*  
  
 -- selecciona el finaloperation del primer giro enviado  
 SELECT TOP 1 @updfinalOperation= finalOperation from tmoneysendtransaction where codOperation = @codOperation order by id ASC 
  
 -- selecciona el id del ultimo giro, resultado del duplicado  
 SELECT TOP 1 @idUpdate= id from tmoneysendtransaction where codOperation = @codOperation order by id desc  
    
 -- actualiza el idprovider  
 SELECT @providerAcronym = providerAcronym from tmoneysendtransaction where codOperation = @codOperation   
   
 -- Aumenta el idProvider y lo actualiza en mtProvider
 SELECT @newIdProvider = idProvider + 1 from mtProvider where providerAcronym = @providerAcronym  
 UPDATE mtProvider set idProvider = @newIdProvider where providerAcronym = @providerAcronym  
   
 -- actualiza el finaloperation y monto del nuevo giro  
 UPDATE tmoneysendtransaction SET finaloperation = @updfinalOperation + CONVERT(varchar,@cont), amount = @amountNew,  
 idProvider = @newIdProvider WHERE id = @idUpdate  
   
 -- actualiza el monto del giro inicial  
 UPDATE tmoneysendtransaction SET amount= @amountOld WHERE finalOperation = @finalOperation   
 ---  
 SELECT @updtcod = @updfinalOperation + CONVERT(varchar,@cont)   
 --PRINT @updtcod  
   
 -- inserta en tautsicad2  
 INSERT INTO tautsicad2 (OperacionFinal,Status,FechaCreacion,FechaModificacion) VALUES( @updfinalOperation + CONVERT(varchar,@cont) , '',GETDATE(),GETDATE())  
  
 -- para ver los giros en orden   
 --SELECT * from TmoneySendtransaction where codOperation = @codOperation order by id asc  
END    
--**** END of 'DIVIDIR'  



---------------
--------------- H I S T O R I C O
---------------
  
  
IF (@opcion = 'HISTORICO')  
--EXEC AutTransaccionBCV 'HISTORICO','','','010407201410750080',0,0  
  
BEGIN   
  
 SELECT tas2.OperacionFinal,t.codOperation ,t.Amount ,tas2.FechaModificacion,    
 c.Nombres +' '+ c.Apellido1 as NameSender,  Nombre1_Benef +' '+ Apellido1_Benef as NameReceiver    
  
 --SELECT tas2.OperacionFinal,tas2.Status,tas2.FechaCreacion,tas2.FechaModificacion,t.Paymentkey, t.*,    
 --c.Nombres +' '+ c.Apellido1 as NameSender,  Nombre1_Benef +' '+ Apellido1_Benef as NameReceiver      
     
 FROM TautSicad2 tas2      
 INNER JOIN tMoneySendtransaction t ON tas2.OperacionFinal = t.FinalOperation      
 INNER JOIN Clientes c on c.Auxiliar=t.CodSender    
 INNER JOIN tBeneficiarioSicadII ts2 on ts2.Auxiliar_Benef = t.codReceiver     
    WHERE t.codOperation = @codOperation  
END  
--**** END of 'HISTORICO'  
  
   
--EXEC AutTransaccionBCV 'CONSULTA','010205201407120054'     
  
--EXEC AutTransaccionBCV 'CARGAR','PENDIENTES'  
  
--EXEC AutTransaccionBCV 'DIVIDIR','','011007201409870001','011007201409860012',100,100   
  
--EXEC AutTransaccionBCV 'HISTORICO','','','010105201407800009',0,0   




---------------
--------------- C O N T R A T O S 
---------------
  
IF (@opcion = 'CONTRATOS')   -- consultar giros
	
	IF (@status = 'PENDIENTES') 
	BEGIN
		SELECT	   
		c.Nro_Contrato as Contrato,
		tcv.Tipo as Tipo,
		c.Auxiliar as Cedula, 
		cl.Nombres +' '+ cl.Apellido1 +' '+ cl.Apellido2 as Nombre,
		tcv.Monto as Monto,
		tcv.Tasa as Tasa, 
		tcv.Divisa as Divisa,
		tcv.MontoBs as MontoBS,
		tcv.Motivo as Motivo,
		tcv.Instrumento as Instrumento, 
		tcv.Operacion as OperacionCaja, 
		tcv.OperacionAutorizBCV as AutorizacionBCV,
		CASE tcv.Status
		WHEN 'A' THEN 'APROBADO POR CONTROL DE CAMBIO' 
		WHEN 'C' THEN 'CONTRATO ASIGNADO'	
		WHEN 'E' THEN 'ENVIADO A BCV'   
		WHEN 'E' THEN 'ENVIADO A BCV'
		WHEN 'N' THEN 'NEGADO POR CONTROL DE CAMBIO'
		END as Status
				

		FROM contratos c 
		INNER JOIN tcompraventadivisa tcv on  tcv.OperacionContrato = c.Nro_Contrato
		INNER JOIN Clientes cl on cl.Auxiliar = c.Auxiliar
		WHERE tcv.OperacionAutorizBCV IS NULL	
		AND tcv.Status ='A'						-- aprobadas por contraloria
		AND SUBSTRING(tcv.Tipo,1,1) = 'C'		-- solo venta
		
	END	
	
	
	
	IF (@status = 'APROBADOS') 
	BEGIN
		SELECT	   
		c.Nro_Contrato as Contrato,
		tcv.Tipo as Tipo,
		c.Auxiliar as Cedula, 
		cl.Nombres +' '+ cl.Apellido1 +' '+ cl.Apellido2 as Nombre,
		tcv.Monto as Monto,
		tcv.Tasa as Tasa, 
		tcv.Divisa as Divisa,
		tcv.MontoBs as MontoBS,
		tcv.Motivo as Motivo,
		tcv.Instrumento as Instrumento, 
		tcv.Operacion as OperacionCaja, 
		tcv.OperacionAutorizBCV as AutorizacionBCV,
		CASE tcv.Status
		WHEN 'A' THEN 'APROBADO POR CONTROL DE CAMBIO' 
		WHEN 'C' THEN 'CONTRATO ASIGNADO'	
		WHEN 'E' THEN 'ENVIADO A BCV'   
		WHEN 'E' THEN 'ENVIADO A BCV'
		WHEN 'N' THEN 'NEGADO POR CONTROL DE CAMBIO'
		END as Status

		FROM contratos c 
		INNER JOIN tcompraventadivisa tcv on  tcv.OperacionContrato = c.Nro_Contrato
		INNER JOIN Clientes cl on cl.Auxiliar = c.Auxiliar
		WHERE tcv.OperacionAutorizBCV IS NOT NULL AND   tcv.OperacionAutorizBCV <>'DENEGADO'
		AND tcv.Status ='A'
		AND SUBSTRING(tcv.Tipo,1,1) = 'C'
		
	END	
	
	IF (@status = 'DENEGADOS') 
	BEGIN
		SELECT	   
		c.Nro_Contrato as Contrato,
		tcv.Tipo as Tipo,
		c.Auxiliar as Cedula, 
		cl.Nombres +' '+ cl.Apellido1 +' '+ cl.Apellido2 as Nombre,
		tcv.Monto as Monto,
		tcv.Tasa as Tasa, 
		tcv.Divisa as Divisa,
		tcv.MontoBs as MontoBS,
		tcv.Motivo as Motivo,
		tcv.Instrumento as Instrumento, 
		tcv.Operacion as OperacionCaja, 
		tcv.OperacionAutorizBCV as AutorizacionBCV,
		CASE tcv.Status
		WHEN 'A' THEN 'APROBADO POR CONTROL DE CAMBIO' 
		WHEN 'C' THEN 'CONTRATO ASIGNADO'	
		WHEN 'E' THEN 'ENVIADO A BCV'   
		WHEN 'E' THEN 'ENVIADO A BCV'
		WHEN 'N' THEN 'NEGADO POR CONTROL DE CAMBIO'
		END as Status

		FROM contratos c 
		INNER JOIN tcompraventadivisa tcv on  tcv.OperacionContrato = c.Nro_Contrato
		INNER JOIN Clientes cl on cl.Auxiliar = c.Auxiliar
		WHERE tcv.OperacionAutorizBCV = 'DENEGADO'
		AND tcv.Status ='A'
		AND SUBSTRING(tcv.Tipo,1,1) = 'C'
		
	END	
	
---------------	E N D   C O N T R A T O S
---------------




---------------
--------------- CAMBIOMONTOCONTRATO
---------------
    
IF (@opcion = 'CAMBIOMONTOCONTRATO')
-- Requiere Nro de Contrato y Monto Nuevo en original y Monto Nuevo en Nevo

   




--EXEC AutTransaccionBCV 'DIVIDIR','','010407201410760023',010407201410750080,199.26,100  
  
BEGIN    
 DECLARE @idUpdate integer   
 DECLARE @cont integer  
 DECLARE @updfinaloperation varchar(50)   
 DECLARE @newIdProvider integer  
 DECLARE @providerAcronym varchar(10)  
 DECLARE @updtcod varchar(40)  
   
 SELECT @cont = COUNT(*) FROM tmoneysendtransaction where codOperation = @codOperation   
   
 -- inserta copia del giro en tmoney  
 INSERT INTO tMoneySendtransaction  
 (providerAcronym,codOperation,finalOperation,codProductType,codSender,codReceiver,amount,feeamount,  
 exchangeRateApplied,sendCountry,sendCurrency,sendAgent,rcvCountry,rcvCurrency,rcvAgent,timeStamp,codDestination,  
 stateService,stateDate,paymentDate,expirationDate,fileName,paymentKey,smsDate,emailDate,iossDate,createUser,createDate,  
 createAplication,createMachine,idProvider)   
  
 SELECT   
 providerAcronym,codOperation,finalOperation,codProductType,codSender,codReceiver,amount,feeamount,exchangeRateApplied,  
 sendCountry,sendCurrency,sendAgent,rcvCountry,rcvCurrency,rcvAgent,timeStamp,codDestination,stateService,stateDate,  
 paymentDate,expirationDate,fileName,paymentKey,smsDate,emailDate,iossDate,createUser,createDate,createAplication,  
 createMachine,idProvider  
 FROM tMoneySendtransaction  
 WHERE finalOperation = @finalOperation  
 --*  
  
 -- selecciona el finaloperation del primer giro enviado  
 SELECT TOP 1 @updfinalOperation= finalOperation from tmoneysendtransaction where codOperation = @codOperation order by id ASC 
  
 -- selecciona el id del ultimo giro, resultado del duplicado  
 SELECT TOP 1 @idUpdate= id from tmoneysendtransaction where codOperation = @codOperation order by id desc  
    
 -- actualiza el idprovider  
 SELECT @providerAcronym = providerAcronym from tmoneysendtransaction where codOperation = @codOperation   
   
 -- Aumenta el idProvider y lo actualiza en mtProvider
 SELECT @newIdProvider = idProvider + 1 from mtProvider where providerAcronym = @providerAcronym  
 UPDATE mtProvider set idProvider = @newIdProvider where providerAcronym = @providerAcronym  
   
 -- actualiza el finaloperation y monto del nuevo giro  
 UPDATE tmoneysendtransaction SET finaloperation = @updfinalOperation + CONVERT(varchar,@cont), amount = @amountNew,  
 idProvider = @newIdProvider WHERE id = @idUpdate  
   
 -- actualiza el monto del giro inicial  
 UPDATE tmoneysendtransaction SET amount= @amountOld WHERE finalOperation = @finalOperation   
 ---  
 SELECT @updtcod = @updfinalOperation + CONVERT(varchar,@cont)   
 --PRINT @updtcod  
   
 -- inserta en tautsicad2  
 INSERT INTO tautsicad2 (OperacionFinal,Status,FechaCreacion,FechaModificacion) VALUES( @updfinalOperation + CONVERT(varchar,@cont) , '',GETDATE(),GETDATE())  
  
 -- para ver los giros en orden   
 --SELECT * from TmoneySendtransaction where codOperation = @codOperation order by id asc  
END    
--**** END of 'DIVIDIR'  




