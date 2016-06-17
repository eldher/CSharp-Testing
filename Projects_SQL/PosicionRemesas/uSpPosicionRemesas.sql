
ALTER PROCEDURE [dbo].[uSpPosicionRemesas]
/* INPUT (@codagencia,@opcion, @fechaCierre,@fechaFinal)

@codagencia : Codigo de agencia origen
@opcion: 
 1-Remesas por fecha especifica
 2-Remesas sin fecha
 3-Remesas en rango de fechas
@fechaCierre: Fecha de Cierre de Agencia ó fecha de Inicio de Busqueda
@fechaFinal: Fecha final de busqueda
*/

@codagencia varchar(10)=NULL,
@opcion varchar(10)=NULL,
@fechaCierre varchar(20)=NULL,
@fechaFinal varchar(20)=NULL

AS

BEGIN
DECLARE @SQLTEXT VARCHAR(4000)  
DECLARE @Frecuencia VARCHAR(2)
DECLARE @Cantidad varchar(10)
DECLARE @FechaSol varchar(20)

-- Bandera para ver si se generaron remesas ese dia SI o NO. En caso de NO se graba una fila indicando
DECLARE @FLAG varchar(2)     
DECLARE @AGENCIAPPAL int
SELECT @AGENCIAPPAL = VALOR FROM PARAMETROS WHERE CLAVE = 'AGENCIAPPAL'
SET @FLAG='NO'
--SET @fechaCierre = CONVERT(datetime,@fechaCierre,120)

-- Buscar por fecha unica
-- Inserta Replica
IF @opcion = '1'
BEGIN
	SELECT isnull(RFS.Frecuencia,'') as Frecuencia, COUNT(RFS.OperacionCierre) AS Cantidad INTO #pos1   
	FROM Remesas_FamiliaresSol RFS
	INNER JOIN Remesas_FamiliaresBenef RFB ON RFS.Solicitud = RFB.Solicitud
	INNER JOIN Movimien M ON RFS.OperacionCierre = M.Operacion
	WHERE RFS.Fecha_Sol = CONVERT(datetime,@fechaCierre) 
	AND RFS.OperacionCierre IS NOT NULL
	AND M.Estado ='C'
	GROUP BY RFS.Frecuencia
	SET @FLAG = 'SI'

	
	-- CURSOR PARA REPLICA	
	DECLARE cursor_Posiciones CURSOR FOR SELECT * FROM #pos1
	OPEN cursor_Posiciones    
	FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQLTEXT = 'INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad,fechaRegistro) VALUES ('
		+CONVERT(varchar,@codAgencia)+','+CHAR(39)+CONVERT(varchar,CONVERT(datetime,@fechaCierre))+CHAR(39)+','
		+CHAR(39)+'FAMILIAR'+CHAR(39)+','+CHAR(39)+CONVERT(varchar,@Frecuencia)+CHAR(39)+','
		+CHAR(39)+CONVERT(varchar,@Cantidad)+CHAR(39)+','+CHAR(39)+CONVERT(varchar,GETDATE())+CHAR(39)+')'
		--PRINT @SQLTEXT
		EXEC(@SQLTEXT)
		INSERT INTO replica (codagencia,SQLtext,Status) VALUES (@AGENCIAPPAL,@SQLTEXT,'N')
		FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad			
	END
	CLOSE cursor_Posiciones
	DEALLOCATE cursor_Posiciones
END



--Buscar sin fecha 
-- Inserta Replica

IF @opcion = '2'
BEGIN

	--SELECT isnull(RFS.Frecuencia,'') as Frecuencia, COUNT(RFS.OperacionCierre) AS Cantidad, DATEADD(day, DATEDIFF(day, 0,RFS.Fecha_sol), 0) AS FechaSol INTO #pos2
	SELECT isnull(RFS.Frecuencia,'') as Frecuencia, COUNT(RFS.OperacionCierre) AS Cantidad INTO #pos2 
	FROM Remesas_FamiliaresSol RFS
	INNER JOIN Remesas_FamiliaresBenef RFB ON RFS.Solicitud = RFB.Solicitud
	INNER JOIN Movimien M ON RFS.OperacionCierre = M.Operacion
	WHERE RFS.OperacionCierre IS NOT NULL
	AND M.Estado ='C'
	GROUP BY RFS.Frecuencia
	SET @FLAG = 'SI'
	
	-- CURSOR PARA REPLICA	
	DECLARE cursor_Posiciones CURSOR FOR SELECT * FROM #pos2
	OPEN cursor_Posiciones    
	FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQLTEXT = 'INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad,fechaRegistro) VALUES ('
		+CONVERT(varchar,@codAgencia)+','+CHAR(39)+CONVERT(varchar,CONVERT(datetime,@fechaCierre))+
		+CHAR(39)+','+CHAR(39)+'RESUMEN'+CHAR(39)+','+CHAR(39)+CONVERT(varchar,@Frecuencia)+CHAR(39)+','
		+CHAR(39)+CONVERT(varchar,@Cantidad)+CHAR(39)+','+CHAR(39)+CONVERT(varchar,GETDATE())+CHAR(39)+')'
		--PRINT @SQLTEXT
		EXEC(@SQLTEXT)
		INSERT INTO replica (codagencia,SQLtext,Status) VALUES (@AGENCIAPPAL,@SQLTEXT,'N')
		FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad			
	END
	CLOSE cursor_Posiciones	
	DEALLOCATE cursor_Posiciones			
END




-- Buscar en Rango de Fechas
-- Inserta Replica
IF @opcion = '3'
BEGIN
    SELECT isnull(RFS.Frecuencia,'') as Frecuencia, COUNT(RFS.OperacionCierre) AS Cantidad, DATEADD(day, DATEDIFF(day, 0,RFS.Fecha_sol), 0) AS FechaSol INTO #pos3	
	FROM Remesas_FamiliaresSol RFS
	INNER JOIN Remesas_FamiliaresBenef RFB ON RFS.Solicitud = RFB.Solicitud
	INNER JOIN Movimien M ON RFS.OperacionCierre = M.Operacion
	WHERE 
	DATEDIFF(DAY,CONVERT(datetime,@FechaCierre),RFS.Fecha_Sol) >= 0  AND DATEDIFF(DAY,CONVERT(datetime,@FechaFinal),RFS.Fecha_Sol) <=0
	AND RFS.OperacionCierre IS NOT NULL
	AND M.Estado ='C'
	GROUP BY RFS.Frecuencia, DATEADD(day, DATEDIFF(day, 0,RFS.Fecha_sol), 0)
	SET @FLAG = 'SI'
	
	-- CURSOR PARA REPLICA	
	DECLARE cursor_Posiciones CURSOR	FOR SELECT * FROM #pos3
	OPEN cursor_Posiciones    
	FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad,@FechaSol
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQLTEXT = 'INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad,FechaRegistro) VALUES ('
		+CONVERT(varchar,@codAgencia)+','+CHAR(39)+CONVERT(varchar,CONVERT(datetime,@FechaSol))+CHAR(39)+','+
		+CHAR(39)+'FAMILIAR'+CHAR(39)+','+CHAR(39)+CONVERT(varchar,@Frecuencia)+CHAR(39)+','
		+CHAR(39)+CONVERT(varchar,@Cantidad)+CHAR(39)+','+char(39)+CONVERT(varchar,GETDATE())+CHAR(39)+')'
		--PRINT @SQLTEXT
		EXEC(@SQLTEXT)
		INSERT INTO replica (codagencia,SQLtext,Status) VALUES (@AGENCIAPPAL,@SQLTEXT,'N')
		FETCH NEXT FROM cursor_Posiciones INTO @Frecuencia,@Cantidad,@FechaSol		
	END
	CLOSE cursor_Posiciones	
	DEALLOCATE cursor_Posiciones	
END

IF @FLAG='NO'
BEGIN
	SET @SQLTEXT = 'INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad) VALUES ('
	+CONVERT(varchar,@codAgencia)+','+CHAR(39)+CONVERT(datetime,@fechaCierre,120)
	+CHAR(39)+','+CHAR(39)+'FAMILIAR'+CHAR(39)+','+CHAR(39)+'Z'+CHAR(39)+','
	+CHAR(39)+CONVERT(varchar,0)+CHAR(39)+')'
	--PRINT @SQLTEXT
	EXEC(@SQLTEXT)
END



END

-- Ejemplos
-- uSpPosicionRemesas 1,1,'2014-04-22'
-- uSpPosicionRemesas 1,2,'2014-04-24'
-- uSpPosicionRemesas 1,3,'2014-01-01','2014-04-22'

--SELECT * FROM PosicionRemesas

-- Verificacion de Replica
--SELECT * FROM replica WHERE Sqltext LIKE '%INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad,FechaRegistro) VALUES%' ORDER BY INSERT_DATE DESC
--INSERT INTO PosicionRemesas (codagencia,fechaCierre,tipoRemesa,Frecuencia,Cantidad,FechaRegistro) VALUES (8,'Apr 22 2014 12:00AM','FAMILIAR','N','4','Apr 24 2014 11:02AM')