        
ALTER PROCEDURE [dbo].[uSpLocalMoneyPortValidacion]        


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

