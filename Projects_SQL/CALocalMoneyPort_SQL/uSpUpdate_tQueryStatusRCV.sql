   
    
  --CORRER ESTO LUEGO  
  --GRANT ALL ON uSpUpdate_tQueryStatusRCV TO PUBLIC    
        
  CREATE PROC uSpUpdate_tQueryStatusRCV      
        
  @paymentKey VARCHAR(70),      
  @paymentStatus VARCHAR(5),  
  @providerAcronym VARCHAR(5)      
        
  AS      
        
  UPDATE tQueryStatusRCV SET processed = 'A' WHERE paymentKey = @paymentKey AND providerAcronym = @providerAcronym   