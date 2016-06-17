DECLARE @text varchar(30)
DECLARE @num integer
DECLARE @fra varchar(30)
DECLARE @operacionFinal varchar(40)
DECLARE @cont integer
--DECLARE @amountOld money = NULL
--DECLARE @amountNew money = NULL   

SET @cont=1
SELECT @operacionFinal= '010205201407810004'
SET @text = '02121321321001231221-01'  --- EJEMPLO


WHILE CONT<=2
BEGIN

	IF CONT=1
	
	BEGIN

		SELECT TOP 1 FinalOperation FROM tMoneySendTransaction WHERE FinalOperation  = @operacionFinal 
		
		-- SI TIENE FORMATO -01, -02 .... 
		IF ( CHARINDEX('-',@operacionFinal) <> 0 )
		BEGIN		
			SET @num = CONVERT(integer, SUBSTRING(@text,CHARINDEX('-',@text)+1,LEN(@text)))
			SELECT @fra = RIGHT ('00'+ CAST(@num +1 AS varchar), 2)
			PRINT @fra	
			
			UPDATE TOP(1) tMoneySendtransaction SET FinalOperation = @operacionFinal + @fra WHERE FinalOperation = @operacionFinal	
			CONT = CONT + 1
		END
		
		-- SI NO TIENE FORMATO -01, se le agrega, ya que es la primera división
		ELSE
		BEGIN
			UPDATE TOP (1) tMoneySendtransaction SET FinalOperation = @operacionFinal + '-01' WHERE FinalOperation = @operacionFinal	
		END
		
		
		
		--UPDATE TOP (1) tMoneySendtransaction SET FinalOperation = @operacionFinal + @fra WHERE FinalOperation = @operacionFinal
		--UPDATE tMoneySendtransaction SET amount = @amountNew + @fra WHERE FinalOperation = @operacionFinal 
	END
	
	--IF CONT=2
	--BEGIN
	----- CAMBIAR MONTO
	
	--END

END
