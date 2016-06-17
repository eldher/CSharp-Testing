
/*      
DESCRIPTION: SP QUE CAMBIA EL STATUS A ENVIADO EN LA TABLA tMoneySendTransaction     

@eldher 10.06.2014

SP EN PRINCIPAL ITALCAMBIO
- REPLICA UPDATE EN AGENCIA DE ORIGEN DEL GIRO
- SE MODIFICO EL FORMATO A REPLICA

*/     
ALTER PROCEDURE [dbo].[uSpUpdtMoneySendTransaction]     
@id int,     
@clave varchar(30),     
@Date datetime,     
@NombreArchivo VARCHAR(100),     
@status varchar(1),     
@provideracronym varchar(2)  
AS     

DECLARE @sqltext VARCHAR(5000)    
DECLARE @claveAnticipada VARCHAR(40)
DECLARE @AgenciaOrigen VARCHAR(4)    

IF (@status ='A')     
BEGIN     
	SET @sqltext = 'UPDATE tMoneySendTransaction SET fileName =' + CHAR(39)+ @NombreArchivo + CHAR(39)+
	', stateService = ' + CHAR(39)+ @status + CHAR(39)+', expirationDate = ' + CHAR(39) 
	+ CONVERT(VARCHAR,@Date) + CHAR(39)+ ' WHERE idprovider = ' + CHAR(39) + CONVERT(varchar,@id) + CHAR(39) 
	+ 'AND providerAcronym = ' + CHAR(39)+ @provideracronym + CHAR(39) 

	--print (@sqltext)
	EXEC(@sqltext)

	-- INSERTA REPLICA SI TIENE AGENCIA DE ORIGEN 
	IF EXISTS (SELECT m.codagencia FROM tMOneySendTRansaction t 
	INNER JOIN movimien m ON t.codoperation = m.operacion
	WHERE t.PaymentKey = @clave)  
	BEGIN
		SELECT @AgenciaOrigen = m.codagencia FROM tMOneySendTRansaction t 
		INNER JOIN movimien m ON t.codoperation = m.operacion
		WHERE t.PaymentKey = @clave  	
		INSERT INTO replica (codagencia,SQLtext,status) VALUES (@AgenciaOrigen,@sqltext,'N')  	
	END 
END  


-----------------
    
--IF (@status ='A')     
--BEGIN     
-- UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, expirationDate = @Date     
-- WHERE idprovider = @id AND providerAcronym = @provideracronym   
--END     
-----------------


IF (@status = 'E')     
BEGIN    
	IF EXISTS(SELECT tm.idProvider FROM tMoneySendTransaction tm    
	INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
	WHERE  tm.idProvider = @id AND tm.providerAcronym = @provideracronym)    
	
	BEGIN    
		--*******    
		SELECT @claveAnticipada = tc.Clave    
		FROM tMoneySendTransaction tm    
		INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
		WHERE tm.idProvider = @id AND tm.providerAcronym = @provideracronym   
   
		--*******    
		SET @sqltext = 'UPDATE tMoneySendTransaction SET fileName = ' +CHAR(39)+ @NombreArchivo +CHAR(39)+
		', stateService = ' +CHAR(39)+ @status +CHAR(39)+ ', StateDate = GETDATE(), paymentKey =' +CHAR(39)+
		@claveAnticipada +CHAR(39)+ ', IOSSDate = GETDATE()'+     
		'WHERE idprovider = ' +CHAR(39)+ CONVERT(varchar,@id) +CHAR(39)+ 
		'and providerAcronym = '+CHAR(39)+	@provideracronym+CHAR(39)
   
		EXEC(@sqltext)	
		 
		-- INSERTA REPLICA SI TIENE AGENCIA DE ORIGEN 
		IF EXISTS (SELECT m.codagencia FROM tMOneySendTRansaction t 
		INNER JOIN movimien m ON t.codoperation = m.operacion
		WHERE t.PaymentKey = @clave)  
		BEGIN
			SELECT @AgenciaOrigen = m.codagencia FROM tMOneySendTRansaction t 
			INNER JOIN movimien m ON t.codoperation = m.operacion
			WHERE t.PaymentKey = @clave 	
			INSERT INTO replica (codagencia,SQLtext,status) VALUES (@AgenciaOrigen,@sqltext,'N')  	
		END 
		--*******    
	END    
	ELSE    
	BEGIN 

		SET @sqltext = 'UPDATE tMoneySendTransaction SET fileName = ' +CHAR(39)+ @NombreArchivo +CHAR(39)+', stateService = '
		+CHAR(39)+ @status +CHAR(39)+ ', StateDate = GETDATE(), paymentKey = ' +CHAR(39)+ @clave +CHAR(39)+
		', IOSSDate = GETDATE() WHERE idprovider = ' +CHAR(39)+ CONVERT(varchar,@id) +CHAR(39)+ 'and providerAcronym = '
		+CHAR(39)+@provideracronym  +CHAR(39)
		--print (@sqltext)
		EXEC(@sqltext)

		-- INSERTA REPLICA SI TIENE AGENCIA DE ORIGEN 
		IF EXISTS (SELECT m.codagencia FROM tMOneySendTRansaction t 
		INNER JOIN movimien m ON t.codoperation = m.operacion
		WHERE t.PaymentKey = @clave)  
		BEGIN
			SELECT @AgenciaOrigen = m.codagencia FROM tMOneySendTRansaction t 
			INNER JOIN movimien m ON t.codoperation = m.operacion
			WHERE t.PaymentKey = @clave 	
			INSERT INTO replica (codagencia,SQLtext,status) VALUES (@AgenciaOrigen,@sqltext,'N')  	
		END 
	END  

END

---------------------    
--IF (@status = 'E')     
--BEGIN    
--    IF EXISTS(SELECT tm.idProvider     
--     FROM tMoneySendTransaction tm    
--     INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
--     WHERE     
--   tm.idProvider = @id     
--     AND tm.providerAcronym = @provideracronym  
--      )    
-- BEGIN    
--     --*******    
--   SELECT @claveAnticipada = tc.Clave    
--   FROM tMoneySendTransaction tm    
--   INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
--   WHERE     
--    tm.idProvider = @id     
--   AND tm.providerAcronym = @provideracronym   
       
--     --*******    
--     UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, StateDate = GETDATE(), paymentKey = @claveAnticipada, IOSSDate = GETDATE()     
--     WHERE idprovider = @id and providerAcronym = @provideracronym    
--     --*******    
-- END    
-- ELSE    
-- BEGIN    
--       UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, StateDate = GETDATE(), paymentKey = @clave, IOSSDate = GETDATE()     
--        WHERE idprovider = @id and providerAcronym = @provideracronym   
-- END     
--END     

------------------------------------------------------------
    
IF (@status = 'P')     
BEGIN

	SET @sqltext = 'UPDATE tMoneySendTransaction SET paymentDate = ' +CHAR(39)+ CONVERT(varchar,@Date) +CHAR(39)+ 
	'WHERE idprovider = ' +CHAR(39)+ CONVERT(varchar,@id) +CHAR(39)+ 'and providerAcronym = ' +CHAR(39)+ @provideracronym +CHAR(39)

	--print (@sqltext)
	EXEC(@sqltext)

	-- INSERTA REPLICA SI TIENE AGENCIA DE ORIGEN 
	IF EXISTS (SELECT m.codagencia FROM tMOneySendTRansaction t 
	INNER JOIN movimien m ON t.codoperation = m.operacion
	WHERE t.PaymentKey = @clave)  
	BEGIN
		SELECT @AgenciaOrigen = m.codagencia FROM tMOneySendTRansaction t 
		INNER JOIN movimien m ON t.codoperation = m.operacion
		WHERE t.PaymentKey = @clave  	
		INSERT INTO replica (codagencia,SQLtext,status) VALUES (@AgenciaOrigen,@sqltext,'N')  	
	END 
END  
   
    
--******************************************************************************    
--****************************************************************************** 