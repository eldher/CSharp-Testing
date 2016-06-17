CREATE PROCEDURE uSpupdAutTransferencia @Operacion VARCHAR(25), @Estado VARCHAR(1), @CodUsuarioGer VARCHAR(20)     
/***************************************************      
Creacion: 02/07/2014      
Operador:  Marcos Cortez      
Referencia:  Sp de actualizacion de AutorizacionTransferencia      
****************************************************/      
AS      
      
If @CodUsuarioGer <> ''      
 Update AutorizacionTransferencia set estado = @Estado , CodUsuarioGer = @CodUsuarioGer   
 where operacion = @operacion  
else  
 Update AutorizacionTransferencia set estado = @Estado   
 where operacion = @operacion  
  