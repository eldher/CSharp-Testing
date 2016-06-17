	  
--CORRER ESTO LUEGO      
--GRANT ALL ON uSpRectificaIdProvider TO PUBLIC       
	
--select * from tmoneysendtransaction where provideracronym ='RY'    AND stateDate IS NULL 
 
--update tmoneysendtransaction set idProvider=101 where provideracronym ='RY'    AND stateDate IS NULL 

	   
CREATE PROC uSpRectificaIdProviderOtros        
/* Creado por: Vladimir Yépez 31-07-2013
   Modificado por: Eldher Hernandez 21-05-2014	        
   Verifica si hay idProvider duplicados y si existen duplicados se genera uno nuevo        
   al registro de la tabla que fue afectado.        
*/        
@providerAcronym varchar(5)        
AS        
DECLARE @id INT        
DECLARE @finalOperation VARCHAR(30)       
DECLARE @idProvider INT

DECLARE @newId VARCHAR(30)

		 
DECLARE idprovider_cursor CURSOR FOR  
	   
	SELECT m.idProvider      
	FROM tMoneySendTransaction m        
	WHERE         
		datediff(dd,convert(datetime,m.createDate,103),convert(datetime,GETDATE()- 15,103))<=0         
	AND datediff(dd,convert(datetime,m.createDate,103),convert(datetime,GETDATE(),103))>=0      
	AND m.ProviderAcronym = @providerAcronym      
	AND m.stateDate IS NULL      
	GROUP BY m.idProvider      
	HAVING count(m.idProvider) > 1 
			
			 
	OPEN idprovider_cursor        
	FETCH NEXT FROM idprovider_cursor INTO @idProvider        
	WHILE @@FETCH_STATUS = 0         
	BEGIN         
	--************************************************      
	 
		DECLARE id_cursor CURSOR FOR        
	   
		SELECT t.id,t.finalOperation      
		FROM tMoneySendTransaction t        
		WHERE t.idProvider = @idProvider      
		AND t.ProviderAcronym = @providerAcronym       
		ORDER BY t.id DESC      
		  
		OPEN id_cursor        
		FETCH NEXT FROM id_cursor INTO @id,@finalOperation      
		WHILE @@FETCH_STATUS = 0         
		BEGIN
		
			SELECT @newId = idProvider from mtProvider where providerAcronym=@ProviderAcronym
			SELECT @newId = CONVERT(varchar,CONVERT(integer,@newId) + 1)   
			
			UPDATE tMoneySendTransaction SET idProvider = @newId     
			WHERE       
			providerAcronym = @providerAcronym      
			AND finalOperation = @finalOperation 
			
			UPDATE mtProvider SET idProvider = @newId     
			WHERE       
			providerAcronym = @providerAcronym      			     
		 
			
			FETCH NEXT FROM id_cursor       
			INTO @id,@finalOperation      
		END       
		   
		CLOSE id_cursor         
		DEALLOCATE id_cursor   
			 
	--************************************************      
		FETCH NEXT FROM idprovider_cursor         
		INTO @idProvider        
	END         
		
CLOSE idprovider_cursor         
DEALLOCATE idprovider_cursor        
		 
 --*****************************************************************************   
   
--select * from mtprovider  where providerACronym = 'RY'

--uSpRectificaIdProviderOtros 'RY'