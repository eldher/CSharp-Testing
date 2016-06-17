ALTER  PROCEDURE [dbo].[uSpInsBeneficiario]         
 @Aux_sol varchar(50),        
 @auxiliarbenefactual varchar(50),        
 @nombre_benef1 varchar(50),        
 @nombre_benef2 varchar(50),        
 @apellido_benef1 varchar(50),        
 @apellido_benef2 varchar(50),        
 @direccion_benef varchar(200),        
 @telefono_benef varchar(20),        
 @EmailB varchar(50),        
 @Cod_Ciudad varchar (3),        
 @Cod_Pais varchar(4),        
 @cod_estado varchar(2)             
            
AS            
declare @sendtosql varchar(5000)          
          
          
BEGIN            
                 if not exists (select * from tBeneficiarioSICADII where auxiliar_benef = @auxiliarbenefactual and auxiliar_solic = @aux_sol)            
                    Begin             
      INSERT INTO tBeneficiarioSICADII              
      (Auxiliar_Solic,auxiliar_benef,nombre1_benef,nombre2_benef,            
      apellido1_benef,apellido2_benef,            
      direccion_benef,telefono_benef,Email_benef, Cod_Ciudad, Cod_Pais, cod_estado )            
      VALUES   (@Aux_sol, @auxiliarbenefactual, @nombre_benef1, @nombre_benef2, @apellido_benef1, @apellido_benef2, @direccion_benef, @telefono_benef,@EmailB, @Cod_Ciudad, @Cod_Pais, @cod_estado )             
                    End            
                    else            
                    Begin            
      update tBeneficiarioSICADII set            
      Auxiliar_solic = @aux_sol ,auxiliar_benef = @auxiliarbenefactual,nombre1_benef = @nombre_benef1,nombre2_benef =@nombre_benef2,            
      apellido1_benef = @apellido_benef1,apellido2_benef = @apellido_benef2,  direccion_benef = @direccion_benef,telefono_benef = @telefono_benef, Email_benef=@EmailB,Cod_Ciudad = @Cod_Ciudad, Cod_Pais =@Cod_Pais, cod_estado = @cod_estado             
      where  auxiliar_benef = @auxiliarbenefactual and auxiliar_solic = @aux_sol            
                    End            
                              
              
     set @sendtosql = 'if not exists (select * from tBeneficiarioSICADII where '+      
     +'  auxiliar_benef = '+char(39)+@auxiliarbenefactual+char(39)+      
     +' and  auxiliar_solic = '+char(39)+@aux_sol+char(39)+      
     +')'+            
                  +'  Begin             
      INSERT INTO tBeneficiarioSICADII              
      (Auxiliar_Solic,auxiliar_benef,nombre1_benef,nombre2_benef,            
      apellido1_benef,apellido2_benef,            
      direccion_benef,telefono_benef,Email_benef, Cod_Ciudad, Cod_Pais, cod_estado )            
      VALUES   ('+char(39)+isnull(@Aux_sol,'')+char(39)+','+char(39)+isnull(@auxiliarbenefactual,'')+char(39)+','+char(39)+isnull(@nombre_benef1,'')+char(39)+','+char(39)+isnull(@nombre_benef2,'')          
                 +char(39)+','+char(39)+isnull(@apellido_benef1,'')+char(39)+','+char(39)+isnull(@apellido_benef2,'')          
                 +char(39)+','+char(39)+isnull(@direccion_benef,'')+char(39)+','+char(39)+isnull(@telefono_benef,'')+char(39)+','+char(39)+isnull(@EmailB,'')+char(39)+','+char(39)+isnull(@Cod_Ciudad,'')+char(39)+','+char(39)+isnull(@Cod_Pais,'')+char(39)+
  
     
    ','+char(39)+isnull(@cod_estado,'')+char(39)+')          
                    End            
                    else            
                    Begin            
      update tBeneficiarioSICADII set            
      Auxiliar_solic ='+char(39)+isnull(@aux_sol,'')+char(39)+',auxiliar_benef ='+char(39)+isnull(@auxiliarbenefactual,'')+char(39)+',nombre1_benef ='+char(39)+ isnull(@nombre_benef1,'')+char(39)+',nombre2_benef ='+      
      +char(39)+isnull(@nombre_benef2,'')+char(39)+',            
      apellido1_benef ='+char(39)+isnull(@apellido_benef1,'')+char(39)+',apellido2_benef ='+char(39)+isnull(@apellido_benef2,'')+char(39)+',direccion_benef ='+char(39)+isnull(@direccion_benef,'')+char(39)+',telefono_benef ='+char(39)+      
      +isnull(@telefono_benef,'')+char(39)+',          
      Email_benef='+char(39)+isnull(@EmailB,'')+char(39)+',Cod_Ciudad ='+char(39)+isnull(@Cod_Ciudad,'')+char(39)+', Cod_Pais ='+char(39)+isnull(@Cod_Pais,'')+char(39)+', cod_estado ='+char(39)+isnull(@cod_estado,'')+char(39)+          
      ' where  auxiliar_benef ='+char(39)+@auxiliarbenefactual+char(39)+' and auxiliar_solic ='+char(39)+@aux_sol+char(39)          
                 +'end'          
             
 -- @eldher 09.06.2014             
  IF not(@sendtosql IS NULL)                         
  begin
 declare @agenciappl VARCHAR(4)  
  select @agenciappl = CONVERT(int,valor) from parametros where clave = 'AGENCIAPPAL'                           
   insert into replica(CodAgencia,sqltext,status)values (@agenciappl, @sendtosql,'N')                         
  end                            
                              
                              
END 