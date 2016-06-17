
--DESARROLLO NEW 2 
SELECT VALOR FROM PARAMETROS WHERE CLAVE = 'AGENCIA'
  
select * from uVwItalcambioEnvioMoneda
        
select * from tAutSicad2
  
update tAutSicad2 set Status='A' where OperacionFinal IN('010505201406730006','010505201406730007','010505201406780004')

select * from tREceiptTRansaction

select * from tValidaMontoSicad

sp_helptext UspLocalMOneyPOrtVEN






select * from tValidaMontoSicad



sp_helptext uSpLocalMoneyPortValidacion
EXEC uSpLocalMoneyPortValidacion 'V13444812','TRUE'

select * from TValidaMontoSicad



          
CREATE PROCEDURE [dbo].[uSpLocalMoneyPortValidacion]          
  
  
@idCliente varchar(30)=NULL,         
@validacion varchar(30)=NULL  
        
AS          
BEGIN        
  
IF (NOT EXISTS(SELECT * FROM TvalidaMontoSicad WHERE idClient=@idCliente ))   
BEGIN  
 INSERT INTO TvalidaMontoSicad(idClient,Validacion) VALUES (@idCliente,@validacion)  
END  
ELSE  
BEGIN  
 UPDATE TvalidaMontoSicad SET Validacion= @validacion WHERE idclient = @idCliente  
END  
END  
  