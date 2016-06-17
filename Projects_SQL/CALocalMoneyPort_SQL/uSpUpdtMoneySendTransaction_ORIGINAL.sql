  
    
/*     
CREATE BY: DENNIS USECHE     
CREATE DATE: 23/07/2012     
DESCRIPTION: SP QUE CAMBIA EL STATUS A ENVIADO EN LA TABLA tMoneySendTransaction     
*/     
CREATE PROCEDURE [dbo].[uSpUpdtMoneySendTransaction]     
@id int,     
@clave varchar(25),     
@Date datetime,     
@NombreArchivo VARCHAR(25),     
@status varchar(1),     
@provideracronym varchar(2)  
AS     
    
DECLARE @claveAnticipada VARCHAR(40)    
    
IF (@status ='A')     
BEGIN     
 UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, expirationDate = @Date     
 WHERE idprovider = @id AND providerAcronym = @provideracronym   
END     
    
IF (@status = 'E')     
BEGIN    
    IF EXISTS(SELECT tm.idProvider     
     FROM tMoneySendTransaction tm    
     INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
     WHERE     
   tm.idProvider = @id     
     AND tm.providerAcronym = @provideracronym  
      )    
 BEGIN    
     --*******    
   SELECT @claveAnticipada = tc.Clave    
   FROM tMoneySendTransaction tm    
   INNER JOIN tClavesAnticipadas tc ON tm.finalOperation = tc.operacionFinal    
   WHERE     
    tm.idProvider = @id     
   AND tm.providerAcronym = @provideracronym   
       
     --*******    
     UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, StateDate = GETDATE(), paymentKey = @claveAnticipada, IOSSDate = GETDATE()     
     WHERE idprovider = @id and providerAcronym = @provideracronym    
     --*******    
 END    
 ELSE    
 BEGIN    
       UPDATE tMoneySendTransaction SET fileName = @NombreArchivo, stateService = @status, StateDate = GETDATE(), paymentKey = @clave, IOSSDate = GETDATE()     
        WHERE idprovider = @id and providerAcronym = @provideracronym   
 END     
END     
    
IF (@status = 'P')     
BEGIN     
 UPDATE tMoneySendTransaction SET paymentDate = @Date WHERE idprovider = @id and providerAcronym = @provideracronym    
END     
    
--******************************************************************************    
--****************************************************************************** 