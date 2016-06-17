    
    
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
*/                          
                          
@Tipo int,                          
@Auxiliar varchar(50),                          
@TipoBcv varchar(5),                          
@Id varchar(50),                          
@Nombres varchar(100),                          
@SegundoNombre varchar(100),                          
@Nacionalidad varchar(100),                          
@Fecha_Nac varchar(20),                          
@LugarNac varchar(40),                          
@Sexo varchar(5),                          
@Codusuario varchar(20),                          
@Status varchar(5),                          
@CodAgencia int,                          
@Apellido1 varchar(100),                          
@Apellido2 varchar(100),                          
@TipoBCV_Perfil varchar(5),                        
@TipoFicha int,                  
@Ocupacion varchar(80),              
@Telefono varchar(50)                
                          
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
     cargo,      
     TH_Numero )                          
   Values (                           
     '+char(39)+@Auxiliar+char(39)+',                          
     '+char(39)+@Id+char(39)+',                           
     '+char(39)+@TipoBcv+char(39)+',                           
     '+char(39)+@Nombres+char(39)+',                          
     '+char(39)+@Apellido1+char(39)+',                          
     '+char(39)+@Apellido2+char(39)+',                          
     getdate(),                          
     '+char(39)+@Fecha_Nac+char(39)+',                          
     '+char(39)+@Sexo+char(39)+',                          
     '+char(39)+@Nacionalidad+char(39)+',                          
     '+char(39)+@Codusuario+char(39)+',                          
     '+char(39)+@Status+char(39)+',                          
     '+char(39)+CONVERT(VARCHAR(10),@CodAgencia)+char(39)+',                          
     '+char(39)+@LugarNac+char(39)+',                           
     '+char(39)+@SegundoNombre+char(39)+',                       ''A'',                    
     ''OCASIONAL'',                  
     '+char(39)+@Ocupacion+char(39) + ',      
     '+char(39)+@Telefono+char(39) + ')'                          
  EXEC (@sqltext)                 
           
 --If @imagen is not null           
 --begin               
 --  -- Inserta Imnagen de Pasaporte en tsign              
 -- INSERT INTO tsign (CodCountry,CodFilial,CodAgency,CodClient,CodDocument,Sign,CreateDateTime,CreateUser,enviado)               
 -- VALUES('VEN','ITA',@CodAgencia,@Auxiliar,'PAS',@imagen,GETDATE(),@Codusuario,0)              
                     
 --  --Replica a Principal                          
   insert into replica(codagencia,sqltext,status)                                                
   values (@AgenPpal, @Sqltext, 'N')                            
 --  --*******************                          
 --end          
           
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
   SET @sqlText = 'Update Clientes Set Nombres = '+CHAR(39)+@Nombres+CHAR(39)+',                          
     Apellido1 = '+CHAR(39)+@Apellido1+CHAR(39)+',                          
     Apellido2 = '+CHAR(39)+@Apellido2+CHAR(39)+',                          
     Fecha_Nac = '+CHAR(39)+@Fecha_Nac+CHAR(39)+',                          
     Sexo = '+CHAR(39)+@Sexo+CHAR(39)+',                          
     Nacionalidad = '+CHAR(39)+@Nacionalidad+CHAR(39)+',                          
     Status = '+CHAR(39)+@Status+CHAR(39)+',                          
     LugarNac = '+CHAR(39)+@LugarNac+CHAR(39)+',                          
     SegundoNombre =  '+CHAR(39)+@SegundoNombre+CHAR(39)+',                          
     TipoBCV_Perfil = '+CHAR(39)+@TipoBCV_Perfil+CHAR(39)+',                    
     Calif_Cliente = ''A'',                    
     Tipo_Cliente = ''OCASIONAL'',                  
     cargo = '+ CHAR(39)+@Ocupacion+CHAR(39) +',       
     TH_Numero = '+ CHAR(39)+ @Telefono +CHAR(39) +'                         
   Where Auxiliar = '+CHAR(39)+@Auxiliar+CHAR(39)                          
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
                           
 --Consulta                          
 IF @Tipo = 2                           
 BEGIN                          
  Select ISNULL(Auxiliar,'') AS Auxiliar,isnull(Id,'') as Id,isnull(TipoBCV,'') as TipoBCV,isnull(Nombres,'') as Nombres,isnull(Apellido1,'') as Apellido1,           
  isnull(Apellido2,'') AS Apellido2,ISNULL(Fecha_Carga,'1900-01-01') AS Fecha_Carga,ISNULL(Fecha_Nac,'01/01/1900') AS Fecha_Nac,ISNULL(Sexo,'') AS Sexo,                          
  isnull(Nacionalidad,'') as Nacionalidad,isnull(CodUsuario,'') as CodUsuario,isnull(Status,'') as Status,isnull(CodAgencia,0) as CodAgencia,                          
  isnull(LugarNac,'') as LugarNac,isnull(SegundoNombre,'') as SegundoNombre,isnull(TipoBCV_Perfil,'') as TipoBCV_Perfil,isnull(Calif_Cliente,'A') as Calif_Cliente,                    
  isnull(Tipo_Cliente,'OCASIONAL') as Tipo_Cliente, ISNULL(cargo,'') as Ocupacion, isnull(TH_Numero,'') as Telefono                          
  From Clientes                          
  Where Auxiliar = @Auxiliar              
 END                          
                           
 --Modifica AGENCIA                          
 IF @Tipo = 3                           
 BEGIN                          
   SET @sqlText = 'Update Clientes Set Fecha_Nac = '+CHAR(39)+@Fecha_Nac+CHAR(39)+',                          
     Sexo = '+CHAR(39)+@Sexo+CHAR(39)+',                          
     Nacionalidad = '+CHAR(39)+@Nacionalidad+CHAR(39)+',                          
     Status = '+CHAR(39)+@Status+CHAR(39)+',                          
     LugarNac = '+CHAR(39)+@LugarNac+CHAR(39)+',                          
     TipoBCV_Perfil = '+CHAR(39)+@TipoBCV_Perfil+CHAR(39)+',                     
     Calif_Cliente = ''A'',                    
     Tipo_Cliente = ''OCASIONAL'',                  
     cargo = '+ CHAR(39)+@Ocupacion+CHAR(39) +',       
     TH_Numero = '+ CHAR(39)+ @Telefono +CHAR(39) +'                        
   Where Auxiliar = '+CHAR(39)+@Auxiliar+CHAR(39)                          
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
          codagencia='+CHAR(39)+CONVERT(VARCHAR(10),@CodAgencia)+CHAR(39)+',                        
          fecha=getdate(),                        
          statusleg=''C'',                         
          usertaq='+CHAR(39)+@Codusuario+CHAR(39)+',                         
          userleg = null                         
        where auxiliar = '+CHAR(39)+@Auxiliar+CHAR(39)                         
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
       ('+CHAR(39)+@Auxiliar+CHAR(39)+',''M'','+CHAR(39)+CONVERT(VARCHAR(10),@CodAgencia)+CHAR(39)+',getdate(),''C'','+CHAR(39)+@Codusuario+CHAR(39)+')'                        
   EXEC (@sqltext)                         
   --Replica a Principal                          
   insert into replica(codagencia,sqltext,status)                                                
   values (@AgenPpal, @Sqltext, 'N')                           
  END                        
 --END  kt                      
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
END