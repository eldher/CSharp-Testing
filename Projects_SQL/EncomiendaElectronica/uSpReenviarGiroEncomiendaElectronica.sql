--grant all on uSpRetornaListaPaisesPorProveedor to public    
  
    
    
--CORRER ESTO LUEGO     
--GRANT ALL ON uSpReenviarGiroEncomiendaElectronica TO PUBLIC     
    
--***************************************************************************************     
--***************************************************************************************     
ALTER PROC uSpReenviarGiroEncomiendaElectronica     
/* Creado por Vladimir Yépez 01-03-2013     
Este Store procedure contempla la posibilidad de reenviar un giro     
que ya fue procesado, el cual anulara el anterior y generara uno     
nuevo.     
*/     
    
@providerAcronym varchar(5),     
@finalOperation varchar(30),     
@user varchar(20),     
--@amount money,     
--@amountModified money     
@amountSTR VARCHAR(30),     
@amountModifiedSTR VARCHAR(30)    
    
AS     
DECLARE @sqltext varchar(5000)    
DECLARE @finalAmount money     
DECLARE @amount money     
DECLARE @amountModified money    
    
SET @amount = CONVERT(MONEY,@amountSTR)    
SET @amountModified = CONVERT(MONEY,@amountModifiedSTR)    
    
--Asignamos el Monto_Benef final     
IF (@amountModified > 0)     
	BEGIN     
	SET @finalAmount = @amountModified     
	--Si el monto fue modificado debemos actualizar la tabla remesas_familiaresbenef (Remesas Familiares)     
	UPDATE remesas_familiaresbenef SET Monto_Benef = @finalAmount WHERE OperacionFinal = @finalOperation     
	--Modificamos en enlaces_cadivi si (Estudiante, Casos Especiales o Importaciones)     
	UPDATE enlaces_cadivi SET MontoDivisa = @finalAmount where Operacion = @finalOperation     
	END     
ELSE     
	BEGIN     
	SET @finalAmount = @amount     
END     
--*******************************     
    
    
DECLARE @id int     
DECLARE @idTabla int 
DECLARE @cont int 
DECLARE @newKey varchar(30)   
DECLARE @newKey2 varchar(30)
    
SET @id = 0     
SET @idTabla = 0     
    
SELECT @id = isnull(idprovider,0) + 1 FROM mtprovider WHERE providerAcronym = @providerAcronym     
SELECT @idTabla = isnull(idProvider,0) FROM tMoneySendTransaction WHERE finalOperation = @finalOperation     
    
    
INSERT INTO tMoneySendTransaction     
SELECT     
providerAcronym,     
codOperation,     
finalOperation,     
codProductType,     
codSender,     
codReceiver,     
amount,     
feeamount,     
exchangeRateApplied,     
sendCountry,     
sendCurrency,     
sendAgent,     
rcvCountry,     
rcvCurrency,     
rcvAgent,     
timeStamp,     
codDestination,     
stateService,     
stateDate,     
paymentDate,     
expirationDate,     
fileName,     
paymentKey,     
smsDate,     
emailDate,     
iossDate,     
createUser,     
createDate,     
createAplication,     
createMachine,     
@id     
FROM tMoneySendTransaction WHERE finalOperation = @finalOperation     
    
UPDATE mtprovider SET idprovider = @id WHERE providerAcronym = @providerAcronym     
    
UPDATE tMoneySendTransaction SET stateService = 'A' WHERE finalOperation = @finalOperation and idprovider = @idTabla     
UPDATE tMoneySendTransaction SET stateService = '', fileName='', Amount = @finalAmount WHERE finalOperation = @finalOperation and idprovider = @id     

--@eldher 23.05.2014

--IF NOT EXISTS(SELECT finalOperation FROM tForwardOperation WHERE finalOperation = @finalOperation)     
--	BEGIN     
--		INSERT INTO tForwardOperation (     
--		finalOperation,     
--		idOld,     
--		idNew,     
--		createDate,     
--		providerAcronym,     
--		createUser     
--	)     
--	VALUES (     
--		@finalOperation,     
--		@idTabla,     
--		@id,     
--		getdate(), @providerAcronym,     
--		@user     
--	)     
--	--select * from tForwardOperation     
--	END     
	
--END


IF (@providerAcronym <> 'TN') -- Proveedor distinto a TITAN
BEGIN	    
	IF NOT EXISTS(SELECT finalOperation FROM tForwardOperation WHERE finalOperation = @finalOperation)     
	BEGIN     
		INSERT INTO tForwardOperation (     
		finalOperation,     
		idOld,     
		idNew,     
		createDate,     
		providerAcronym,     
		createUser     
	)     
	VALUES (     
		@finalOperation,     
		@idTabla,     
		@id,     
		getdate(), @providerAcronym,     
		@user     
	)      
	END     
END
ELSE -- PROVEEDOR TITAN
BEGIN
	INSERT INTO tForwardOperation (     
		finalOperation,     
		idOld,     
		idNew,     
		createDate,     
		providerAcronym,     
		createUser     
	)     
	VALUES (     
		@finalOperation,     
		@idTabla,     
		@id,     
		getdate(), @providerAcronym,     
		@user    
	)     
	

	-- actualiza el payment key para titan
	
	SELECT @cont = count(*) from tForwardOperation t where t.finalOperation = @finalOperation

	-- SI TIENE PAYMENT KEY
	
	IF exists (SELECT * From tMoneySendTransaction where finalOperation =@finalOperation AND idprovider = @id and paymentkey IS NOT NULL)
	BEGIN	
		SELECT @newKey = paymentKey From tMoneySendTransaction where finalOperation = @finalOperation  AND idprovider =@id  
		SELECT @newKey = @newKey + CONVERT(varchar,@cont) 
		UPDATE tMoneySendTransaction SET paymentkey = @newKey WHERE finalOperation = @finalOperation AND idprovider = @id 
	END	
	ELSE
	BEGIN
		SELECT @newKey = CONVERT(varchar,@cont) 
		PRINT @newKey
		SELECT @newKey2 = 'TN' + t.finalOperation + @newKey from tMoneySendTransaction t where t.finalOperation = @finalOperation AND t.idprovider = @id 
		PRINT @newKey2
		UPDATE tMoneySendTransaction SET paymentkey = @newKey2 WHERE finalOperation = @finalOperation AND idprovider = @id
	END
		
 END
	


    
--*******************************************************************************     
--*******************************************************************************     
    
    
    
    --sp_helptext uSpReturnInformationExchangeInstrument