  
 -----------------------------------------------------------------------                                
CREATE PROC [dbo].[uSpFichaCliente]                                            
/*                                              
Creado por Vladimir Yepez 14-09-2011                                              
Este SP, Inserta, modifica o consulta a un turista que realize operaciones en la taquilla                                              
de cambio, con datos basicos.                                              
0: Inserta                                              
1: Modifica Gerencia                                              
2: Consulta                                              
3: Modifica Agencia                                  
                                
27/11/2012 Jesus Garcia. Se realizo una modificacion para almacenar la imagen del pasaporte en la tabla tsign.                                            
                      
05/03/2014 Eldher Hernandez. Se modifico la parte de Consulta para la Ficha Tipo 2 para para incluir los campos adicionales.                      
          
28/04/2014 Iris Uzcategui. Se modifico la parte de Consulta para Envio Encomienda Electronica para incluir el campo TC_Numero,        
tambien se agrego la columna  TC_Numero para insertar            
*/                             
                                              
@Tipo int = NULL,                                              
@Auxiliar varchar(50) = NULL,                                              
@TipoBcv varchar(5) = NULL,                                              
@Id varchar(50) = NULL,                                              
@Nombres varchar(100) = NULL,                                              
@SegundoNombre varchar(100 )= NULL,                                              
@Nacionalidad varchar(100) = NULL,                                              
@Fecha_Nac varchar(20) = NULL,                                              
@LugarNac varchar(40) = NULL,                                              
@Sexo varchar(5) = NULL,                                              
@Codusuario varchar(20) = NULL,                                              
@Status varchar(5)= null,                                              
@CodAgencia int = null,                                              
@Apellido1 varchar(100) = null,                                              
@Apellido2 varchar(100) = null,                                              
@TipoBCV_Perfil varchar(5) = null,                                            
@TipoFicha int = null,                                      
@Comentarios varchar(500)= null,                                  
@imagen IMAGE = NULL,                     
@Estado_Civil varchar(20)= null,                      
@Cargo varchar(60)= null,                      
@MotivoServicio varchar(600)= null,                      
@OrigenFondos varchar(600)= null,                      
@Correo varchar(60)= null,                      
@nombreRepLegal varchar(60)= null,                      
@cedulaRepLegal varchar(20)= null,                      
@tipoPoder varchar(20)= null,                      
@fechaVencPoder varchar(30)=null,                      
@paisODFondos varchar(60)= null,                       
@tipoCambio varchar(20) = null,                       
@equivalDivisas varchar(20)= null,                       
@montoDivisas varchar(20) = null,                       
@tipoOperacion varchar(60)= null,      
@TC_Numero varchar(50)= null                       
                                    
                                              
AS                                              
                                              
DECLARE @sqlText varchar(5000)                                  
DECLARE @sqlTextPas varchar(5000)                                               
DECLARE @AgenPpal INT                                                
                                              
Select @AgenPpal = Valor from parametros where Clave = 'AGENCIAPPAL'                                                  
SET @AgenPpal = convert(int,@AgenPpal)                                                  
                                            
--***********************************************************                                            
--********Ficha de Cliente de Operaciones de US$ 1 a US$ 1000                                         
--***********************************************************                                            
IF @TipoFicha = 1                                             
BEGIN                                   
 --Inserta                                              
 IF @Tipo = 0                                               
 BEGIN                                              
  SET @sqlText = 'Insert Into Clientes ( Auxiliar,                             
     Id,                                              
     TipoBCV,                                              
     Nombres,                        
     Apellido1,                                              
     Apellido2,                                              
     Fecha_Carga,                   
     Fecha_Nac,                                              
     Sexo,                                              
     Nacionalidad,                                              
     CodUsuario,                                            
     Status,                                              
     CodAgencia,                                              
     LugarNac,                                               
     SegundoNombre,                             
     Calif_Cliente,                                        
     Tipo_Cliente,                                      
     comment,                      
     Estado_Civil,                      
     Cargo,                       
     MotivoServicio,                      
     OrigenFondos,                      
     Correo,                      
     nombreRepLegal,                      
     cedulaRepLegal,                      
     tipoPoder,                      
     fechaVencPoder,                      
     paisODFondos,                      
     tipoCambio,                      
     equivalDivisas,                      
     montoDivisas,                      
     tipoOperacion,        
     TC_Numero                       
     )                                              
   Values (                                               
     '+char(39)+ISNULL(@Auxiliar,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Id,'')+char(39)+',                                               
     '+char(39)+ISNULL(@TipoBcv,'')+char(39)+',                                               
     '+char(39)+ISNULL(@Nombres,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Apellido1,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Apellido2,'')+char(39)+',                                              
     getdate(),                                              
     '+char(39)+ISNULL(@Fecha_Nac,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Sexo,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Nacionalidad,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Codusuario,'')+char(39)+',                                              
     '+char(39)+ISNULL(@Status,'')+char(39)+',                                              
     '+char(39)+CONVERT(VARCHAR(10),ISNULL(@CodAgencia,0))+char(39)+',                                              
     '+char(39)+ISNULL(@LugarNac,'')+char(39)+',                                               
    '+char(39)+ISNULL(@SegundoNombre,'')+char(39)+',                                        
     ''A'',                                        
     ''OCASIONAL'',       
     '+char(39)+ISNULL(@Comentarios,'')+char(39)+',                      
     '+CHAR(39)+ISNULL(@Estado_Civil,'')+CHAR(39)+',                       
     '+CHAR(39)+ISNULL(@Cargo,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@MotivoServicio,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@OrigenFondos,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@Correo,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@nombreRepLegal,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@cedulaRepLegal,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@tipoPoder,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@fechaVencPoder,'')+CHAR(39)+',                      
     '+CHAR(39)+ISNULL(@paisODFondos,'')+CHAR(39)+',                      
     '+CONVERT(VARCHAR,ISNULL(@tipoCambio,0))+',                      
     '+CONVERT(VARCHAR,ISNULL(@equivalDivisas,0))+',                      
     '+CONVERT(VARCHAR,ISNULL(@montoDivisas,0))+',                      
     '+CHAR(39)+ISNULL(@tipoOperacion,'')+CHAR(39)+',        
     '+CHAR(39)+ISNULL(@TC_Numero,'')+CHAR(39)+')'           
  --PRINT @sqltext                      
  EXEC (@sqltext)                                     
                               
 If @imagen is not null                               
 begin                                   
   -- Inserta Imnagen de Pasaporte en tsign                                  
  INSERT INTO tsign (CodCountry,CodFilial,CodAgency,CodClient,CodDocument,Sign,CreateDateTime,CreateUser,enviado)                 
  VALUES('VEN','ITA',@CodAgencia,@Auxiliar,'PAS',@imagen,GETDATE(),@Codusuario,0)                                  
                                               
  --Replica a Principal                                              
   insert into replica(codagencia,sqltext,status)                                                                    
   values (@AgenPpal, @Sqltext, 'N')                                  
   --*******************                                              
 end                              
                               
  IF (@AgenPpal = 1)                                               
  BEGIN                                              
   insert into replica(codagencia,sqltext,status)                                                             
   values (95, @Sqltext, 'N')         --Gisrvbcvdb Bcv                                              
   --***                                             
   IF (@Status = 'P')                                            
   BEGIN                                                 
    insert into replica(codagencia,sqltext,status)                                                                    
    values (1127, @Sqltext, 'N')       --Net01 pensiones                                             
   END                                             
  END                                               
  --********************                                      
  IF EXISTS(Select numeroPasaporte from tDataPasaporte Where tipoDocumento = @TipoBcv AND numeroPasaporte = @Auxiliar)                                    
  BEGIN                                     
 UPDATE tDataPasaporte SET estado = 'C' WHERE tipoDocumento = @TipoBcv AND numeroPasaporte = @Auxiliar                                    
  END                                     
  --********************                       
 END                                              
                                               
 --Modifica GERENCIA                                              
 IF @Tipo = 1                                        
 BEGIN                        
 PRINT @fechaVencPoder                                            
   SET @sqlText =                      
    'UPDATE Clientes SET                       
     Nombres = '+CHAR(39)+ISNULL(@Nombres,'')+CHAR(39)+',                                              
     Apellido1 = '+CHAR(39)+ISNULL(@Apellido1,'')+CHAR(39)+',                                              
     Apellido2 = '+CHAR(39)+ISNULL(@Apellido2,'')+CHAR(39)+',                                              
     Fecha_Nac = '+CHAR(39)+ISNULL(@Fecha_Nac,'')+CHAR(39)+',                                              
     Sexo = '+CHAR(39)+ISNULL(@Sexo,'')+CHAR(39)+',                                              
     Nacionalidad = '+CHAR(39)+ISNULL(@Nacionalidad,'')+CHAR(39)+',                                              
     Status = '+CHAR(39)+ISNULL(@Status,'')+CHAR(39)+',                                              
     LugarNac = '+CHAR(39)+ISNULL(@LugarNac,'')+CHAR(39)+',                                              
     SegundoNombre =  '+CHAR(39)+ISNULL(@SegundoNombre,'')+CHAR(39)+',                                              
     TipoBCV_Perfil = '+CHAR(39)+ISNULL(@TipoBCV_Perfil,'')+CHAR(39)+',                                        
     Calif_Cliente = ''A'',                                        
     Tipo_Cliente = ''OCASIONAL'',                      
     comment = '+CHAR(39)+ISNULL(@Comentarios,'')+CHAR(39)+',                      
     Estado_Civil = '+CHAR(39)+ISNULL(@Estado_Civil,'')+CHAR(39)+',                       
     Cargo = '+CHAR(39)+ISNULL(@Cargo,'')+CHAR(39)+',                      
     MotivoServicio = '+CHAR(39)+ISNULL(@MotivoServicio,'')+CHAR(39)+',                      
     OrigenFondos  = '+CHAR(39)+ISNULL(@OrigenFondos,'')+CHAR(39)+',                      
     Correo  = '+CHAR(39)+ISNULL(@Correo,'')+CHAR(39)+',                      
     nombreRepLegal = '+CHAR(39)+ISNULL(@nombreRepLegal,'')+CHAR(39)+',                      
     cedulaRepLegal = '+CHAR(39)+ISNULL(@cedulaRepLegal,'')+CHAR(39)+',                      
     tipoPoder = '+CHAR(39)+ISNULL(@tipoPoder,'') +CHAR(39)+',                      
     fechaVencPoder = '+CHAR(39)+ISNULL(@fechaVencPoder,'')+CHAR(39)+',                      
     paisODFondos = '+ CHAR(39)+ISNULL(@paisODFondos,'') +CHAR(39)+ ',                      
     tipoCambio = '+ CONVERT(VARCHAR,ISNULL(@tipoCambio,0)) + ',                      
     equivalDivisas = '+ CONVERT(VARCHAR,ISNULL(@equivalDivisas,0)) + ',                      
     montoDivisas = '+ CONVERT(VARCHAR,ISNULL(@montoDivisas,0)) +',                      
     tipoOperacion = '+CHAR(39)+ISNULL(@tipoOperacion,'')+CHAR(39)+'         
     TC_Numero = '+ CHAR(39)+ ISNULL(@TC_Numero,'') +CHAR(39) +'                     
  WHERE Auxiliar = '+CHAR(39)+ISNULL(@Auxiliar,'')+CHAR(39)                      
--PRINT @sqlText                        
EXEC (@sqltext)                        
                                               
   --Replica a Principal                                              
   INSERT INTO replica(codagencia,sqltext,status) VALUES (@AgenPpal, @Sqltext, 'N')                                                
   --*******************                        
                                               
   IF (@AgenPpal = 1)                                               
   BEGIN                                              
    INSERT INTO replica(codagencia,sqltext,status) VALUES (95, @Sqltext, 'N') --Gisrvbcvdb Bcv                                              
    --***                                              
    IF (@Status = 'P')                                            
    BEGIN                                                 
   insert into replica(codagencia,sqltext,status)                                                                    
   values (1127, @Sqltext, 'N')       --Net01 pensiones                                              
    END                                            
   END                                               
   --********************                                                 
 END                                              
                                               
 --Consulta     //@eldher 05.03.2014                   
 IF @Tipo = 2                                               
 BEGIN                                
  SELECT                       
  ISNULL(Auxiliar,'') AS Auxiliar,                      
  isnull(Id,'') as Id,                      
  isnull(TipoBCV,'') as TipoBCV,                      
  isnull(Nombres,'') as Nombres,                      
  isnull(Apellido1,'') as Apellido1,                                              
  isnull(Apellido2,'') AS Apellido2,                      
  ISNULL(Fecha_Carga,'1900-01-01') AS Fecha_Carga,                      
  ISNULL(Fecha_Nac,'01/01/1900') AS Fecha_Nac,                      
  ISNULL(Sexo,'') AS Sexo,                      
  ISNULL(Estado_Civil,'') as Estado_Civil,                                              
  isnull(Nacionalidad,'') as Nacionalidad,                      
  isnull(CodUsuario,'') as CodUsuario,                      
  isnull(Status,'') as Status,                      
  isnull(CodAgencia,0) as CodAgencia,                                              
  isnull(LugarNac,'') as LugarNac,                      
  isnull(SegundoNombre,'') as SegundoNombre,                      
  isnull(TipoBCV_Perfil,'') as TipoBCV_Perfil,                      
  isnull(Calif_Cliente,'A') as Calif_Cliente,                                        
  isnull(Tipo_Cliente,'OCASIONAL') as Tipo_Cliente,                       
  isnull(comment,'') as comment,                      
  ISNULL(Cargo,'') as Cargo,                      
  ISNULL(MotivoServicio,'') as MotivoServicio,                      
  ISNULL(OrigenFondos,'') as OrigenFondos,                      
  ISNULL(TranFrecuencia,'') as TranFrecuencia,                      
  ISNULL(Correo,'') as Correo,                      
  ISNULL(nombreRepLegal,'') as nombreRepLegal,                      
  ISNULL(cedulaRepLegal,'') as cedulaRepLegal,                      
  ISNULL(tipoPoder,'') as tipoPoder,                      
  ISNULL(fechaVencPoder,'1900-01-01') as fechaVencPoder,   --@eldher 05.03.2014                          
  ISNULL(paisODFondos,'') as paisODFondos,                      
  ISNULL(tipoCambio,0) as tipoCambio,                      
  ISNULL(equivalDivisas,0) as equivalDivisas,                      
  ISNULL(montoDivisas,0) as montoDivisas,                      
  ISNULL(tipoOperacion,'') as tipoOperacion,          
  ISNULL(TC_Numero, '') as Telefono  --@ IvUz 28-05-14                                   
  FROM Clientes                                              
  WHERE Auxiliar = @Auxiliar                                              
 END                                          
                                               
 --Modifica AGENCIA                                              
 IF @Tipo = 3                                               
 BEGIN                                              
   SET @sqlText =                       
 'UPDATE Clientes SET                       
  Fecha_Nac = '+CHAR(39)+ISNULL(@Fecha_Nac,'')+CHAR(39)+',                                              
  Sexo = '+CHAR(39)+ISNULL(@Sexo,'')+CHAR(39)+',                                              
     Nacionalidad = '+CHAR(39)+ISNULL(@Nacionalidad,'')+CHAR(39)+',                                              
     Status = '+CHAR(39)+ISNULL(@Status,'')+CHAR(39)+',                                              
     LugarNac = '+CHAR(39)+ISNULL(@LugarNac,'')+CHAR(39)+',                                              
     TipoBCV_Perfil = '+CHAR(39)+ISNULL(@TipoBCV_Perfil,'')+CHAR(39)+',                                         
     Calif_Cliente = ''A'',                                        
     Tipo_Cliente = ''OCASIONAL'',                                      
     comment = '+CHAR(39)+ISNULL(@Comentarios,'')+CHAR(39)+',                      
     Estado_Civil ='+CHAR(39)+ISNULL(@Estado_Civil,'') +CHAR(39)+',                       
     Cargo = ' +CHAR(39)+ISNULL(@Cargo,'') +CHAR(39)+',                      
     MotivoServicio = '+CHAR(39)+ISNULL(@MotivoServicio,'') +CHAR(39)+',                      
     OrigenFondos  = '+CHAR(39)+ISNULL(@OrigenFondos,'') +CHAR(39)+',                      
     Correo  = ' +CHAR(39)+ISNULL(@Correo,'') +CHAR(39) +',                      
     nombreRepLegal = ' +CHAR(39)+ISNULL(@nombreRepLegal,'') +CHAR(39) +',                      
     cedulaRepLegal = ' +CHAR(39)+ISNULL(@cedulaRepLegal,'') +CHAR(39) +',                      
     tipoPoder = ' +CHAR(39)+ISNULL(@tipoPoder,'') +CHAR(39) +',                      
     fechaVencPoder = ' +CHAR(39)+ISNULL(@fechaVencPoder,'') +CHAR(39) +',                      
     paisODFondos = ' +CHAR(39)+ISNULL(@paisODFondos,'') +CHAR(39) +',                      
     tipoCambio = '+ CONVERT(VARCHAR,ISNULL(@tipoCambio,0))+',                      
     equivalDivisas = '+ CONVERT(VARCHAR,ISNULL(@equivalDivisas,0)) + ',                      
     montoDivisas = '+ CONVERT(VARCHAR,ISNULL(@montoDivisas,0))+ ',                      
     tipoOperacion = '+CHAR(39)+ISNULL(@tipoOperacion,'')+CHAR(39)+' ,        
     TC_Numero = '+ CHAR(39)+ ISNULL(@TC_Numero,'') +CHAR(39) +'         
     WHERE Auxiliar = '+CHAR(39)+ISNULL(@Auxiliar,'')+CHAR(39)             
   --PRINT @sqltext                                             
   EXEC (@sqltext)                                               
   --Replica a Principal                                          
   insert into replica(codagencia,sqltext,status)                                                                    
   values (@AgenPpal, @Sqltext, 'N')                              
   --*******************                                              
   IF (@AgenPpal = 1)                                               
   BEGIN                                              
    insert into replica(codagencia,sqltext,status)                                                                    
    values (95, @Sqltext, 'N')         --Gisrvbcvdb Bcv                                              
    --***                                             
  IF (@Status = 'P')                               
  BEGIN                                                  
   insert into replica(codagencia,sqltext,status)                                                                    
   values (1127, @Sqltext, 'N')       --Net01 pensiones                                            
  END                                              
   END                                               
   --********************                                               
 END                                              
                                            
 IF (@Tipo = 1) OR (@Tipo = 3)                                             
 BEGIN                                            
  IF EXISTS(Select auxiliar from ListaLeg where auxiliar = @Auxiliar)                            
BEGIN                                            
    SET @sqlText = 'update listaleg set status=''M'',                                            
          codagencia='+CHAR(39)+CONVERT(VARCHAR(10),ISNULL(@CodAgencia,0))+CHAR(39)+',                                            
          fecha=getdate(),                                            
          statusleg=''C'',                                             
          usertaq='+CHAR(39)+ISNULL(@Codusuario,'')+CHAR(39)+',                                             
          userleg = null                                             
        where auxiliar = '+CHAR(39)+ISNULL(@Auxiliar,'')+CHAR(39)  
    --PRINT @sqltext                                             
    EXEC (@sqltext)                                             
    --Replica a Principal                                              
    insert into replica(codagencia,sqltext,status)                                                              
    values (@AgenPpal, @Sqltext, 'N')                                               
  END                                            
  ELSE                                            
  BEGIN                                            
   SET @sqlText = 'insert into listaleg                           
       (auxiliar,status,codagencia,fecha,statusleg,usertaq)                                            
     values                                             
       ('+CHAR(39)+ISNULL(@Auxiliar,'')+CHAR(39)+',''M'','+CHAR(39)+CONVERT(VARCHAR(10),ISNULL(@CodAgencia,0))+CHAR(39)+',getdate(),''C'','+CHAR(39)+ISNULL(@Codusuario,'')+CHAR(39)+')'     
   --PRINT (@sqltext)                                            
   EXEC (@sqltext)                                             
   --Replica a Principal                                              
   insert into replica(codagencia,sqltext,status)                                                                    
   values (@AgenPpal, @Sqltext, 'N')                                 
  END                                            
 END                                            
 --Permite Controlar que tipo de Ficha tiene el cliente para procesar o no una operacion.                                            
 IF NOT EXISTS(Select idCliente From tClientFileType where idCliente = @Auxiliar)                                            
 BEGIN                                            
  Insert Into tClientFileType (idCliente,Type,description) Values (@Auxiliar,@TipoFicha,'Compra o Venta de Divisas en efectivo >>>> Operaciones de US$ 1 a US$ 1000')                                  
 END                                     
 ELSE                                            
 BEGIN                                            
  Update tClientFileType Set Type = @TipoFicha, description = 'Compra o Venta de Divisas en efectivo >>>> Operaciones de US$ 1 a US$ 1000' Where idCliente = @Auxiliar                                            
 END                                            
END   