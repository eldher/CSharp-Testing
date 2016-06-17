  CREATE PROC uSpInsert_tQueryStatusRCV    
      
  @paymentKey VARCHAR(70),    
  @paymentStatus VARCHAR(5),    
  @queryUser VARCHAR(20),  
  @providerAcronym VARCHAR(5)   
      
  AS    
      
  INSERT INTO tQueryStatusRCV (paymentKey,paymentStatus,queryDate,queryUser,providerAcronym)     
                 VALUES (@paymentKey,@paymentStatus,GETDATE(),@queryUser,@providerAcronym)    
      
  --*********************************** 