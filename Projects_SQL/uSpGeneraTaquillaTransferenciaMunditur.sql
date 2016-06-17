  
CREATE  PROCEDURE [dbo].[uSpGeneraTaquillaTransferenciaIC]                                  
/*---------------------------------------------                                  
CREATE BY: Dennis Useche              
DATE:09/03/2012                                
DESCRPTION: PROCESO PARA GENERAR LA TAQUILLA Y LA CAJA DE LAS TRANSFERENCIAS. ES UNA COPIA DE  [uSpGeneraTaquillaTransferencia]                              
----------------------------------------------*/                                  
@Agencia varchar(3),                                  
@Username varchar(40),                                  
@OperacionB varchar(20),                                  
@OperacionMoneygram varchar(20) Output                                  
as                                  
                                  
DECLARE @OP VARCHAR(20)                                  
DECLARE @resultado int                                  
DECLARE @Fecha DATETIME                                  
DECLARE @Transaccion int                                  
DECLARE @TASAVENTA FLOAT                                  
DECLARE @TOTAL FLOAT                                  
DECLARE @SUBTOTAL FLOAT                                  
DECLARE @MONTOIMPUESTO FLOAT                                  
DECLARE @COMISION_MONEYGRAM FLOAT                                  
DECLARE @FECHACAMBIOCOMISION DATETIME                                  
DECLARE @transicioncomision CHAR(1)                                  
DECLARE @USERCAJA VARCHAR(20)                                  
DECLARE @codusuario varchar(30)                                  
DECLARE @agenciaint int                                  
DECLARE @agenciavc varchar(3)                                
DECLARE @simbolo  varchar(10)                                
DECLARE @strSqlFami varchar(2000)                                  
DECLARE @comiMG FLOAT                                  
DECLARE @agenprincipal varchar(3)                  
DECLARE @sqltext1 varchar(3000)                    
DECLARE @sqltext2 varchar(3000)                          
DECLARE @sqltext5 varchar(3000)                
DECLARE @codpais varchar(20)               
declare @Tasa float              
declare @fixing float               
SET @comiMG = 0                             
                                 
                            
select @agenprincipal=valor from parametros where clave ='AGENCIAPPAL'                            
SELECT @USERCAJA=CODUSUARIO FROM USUARIOS WHERE REFERENCIA LIKE 'CAJA%' AND CODUSUARIO LIKE 'CAJAI%'                                  
                                  
Select @FECHACAMBIOCOMISION = convert(datetime,valor,103) from parametros where modulo='SACC' and clave= 'CADIVICAMBIOCOMISION'                              
                                 
SET @Fecha = GETDATE()                                  
set @Transaccion =154                                
                                  
set @agenciaint = convert(int,@Agencia)                                  
set @agenciavc = convert(varchar(3),@agenciaint)                                  
                                  
exec getoperacion @agenciavc, 'SOLICITUD_VENTA_DE_T', @resultado OUTPUT                                  
                                  
                                   
 DECLARE @O VARCHAR(40)                                  
 SELECT  @O = convert(varchar(6),@resultado)                                  
 SELECT @O = (SELECT  RIGHT(REPLICATE('0',4) + @O ,4))                                   
                                    
 if (SELECT LEN(@agencia)) = 1                                  
     select @agencia = '0'+@agencia                                   
                                  
set @OP = @agencia + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),1,2) + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),4,2) + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),7,4)+ CONVERT(CHAR(3),@Transaccion) + CONVERT(CHAR(4),@O)                                  
                                  
                          
----------------------------------------------------------------------------------------------------------------------------------------------------                                  
----------------------------------------------------------------------------------------------------------------------------------------------------                                  
                          
declare @diaspermitido int                                  
set @diaspermitido =isnull((select convert(int,valor) as valordias from parametros where modulo='SACC' and clave='DIAPARADEVOLVERALBCV'),0)                                  
                                  
                       
declare @Operacion varchar(20)                                  
declare @Auxiliar varchar(20)                                  
declare @Cliente varchar(50)                                
declare @Beneficiario varchar(50)                                  
declare @PaisBenef varchar(50)                                  
declare @DirBenef varchar(250)                                  
declare @MontoBenef float                                  
declare @Oprecdep varchar(20)                                  
declare @montorecibido float                                  
declare @fecha_ger datetime                            
declare @solicitud varchar(20)                                  
declare @Fecha_Aprob_Cadivi datetime                                  
declare @TipoRemesa varchar(3)                                  
declare @Fecha_Caja datetime                              
DECLARE @destino VARCHAR(30)                
declare @auxiliar_benef VARCHAR(50)                               
                                  
declare @ControlCambio varchar(3)                                  
set @ControlCambio  = (Select top 1 valor from parametros where clave = 'CONTROLDECAMBIO')                                  
                                  
declare CURSOR_ENTRYDATA  cursor for                                    
    --// SELECT de consulta de los datos de la remesa                                    
                                
      SELECT c.operacion, a.auxiliar_sol AS 'Auxiliar',               
          b.Nombres+' '+b.Apellido1+' '+b.Apellido2 as 'Cliente',                                   
          c.beneficiario,               
          r.Cod_Pais as pais_benef,              
          c.dir_benef,               
          c.monto_benef,               
          isnull(a.oprecdep,'''') as oprecdep,                                   
          a.montorecibido,              
          a.fecha_ger, c.solicitud,               
          c.fecha_aprob_cadivi,              
          'RF' as TipoRemesa,               
          mo.fecha as Fecha_Caja,              
          c.destino as destino,              
          d.simbolo,Auxiliar_Benef, c.tasa, c.fixing                               
   FROM remesas_familiaressol a              
   inner join Clientes b on (a.Auxiliar_Sol = b.Auxiliar)              
   inner join remesas_familiaresbenef c on (a.operacion = c.operacionsol)               
   inner join movimien mo on (a.operacioncierre=mo.operacion)              
   inner join divisas d on (d.divisa =c.divisa)              
   inner join trusadbeneficiario r on (r.auxiliarbenef = c.auxiliar_benef and r.solicitud=c.solicitud)              
                            
   WHERE  (a.Estado in ('C','H')) AND (Instrumento = 'TF')                                   
   AND dbo.uFnDiasLaborales(c.fecha_bcv,getdate(),mo.codagencia)<=30--@diaspermitido                             
   AND (c.operacion =@OperacionB) -- @OperacionB'01260120115560261'   '01080220125560189'                            
   and c.operacion not in (select operacion from enlaces where comentarios='REMESAS FAMILIARES')                            
   and mo.estado<>'R'  
      and c.auxiliar_sol not in 
   ('V1197977',  
'V3611972',  
'V3611972',  
'V6056068',  
'V6305139',  
'V1155280',  
'V2954368',  
'V1155280',  
'V1413261',  
'V2954368',  
'V3635867',  
'V3027309',  
'V3027309',  
'V14840492',  
'V5884324',  
'V1892162',  
'V3822911',  
'V1892162',  
'V1892162',  
'V2773583',  
'V2773583',  
'V5247407',  
'V3832094',  
'V3832094',  
'V3082822',  
'V3082822',  
'V4058788',  
'V4058788',  
'V4058788',  
'V8003340',  
'V3405261',  
'V3405261',  
'V3405261',  
'V2932901',  
'V2932901',  
'V5440850',  
'V5440850',  
'V5440850',  
'V3896988',  
'V5288864',  
'V12607375',  
'V17032699',  
'V4088206',  
'V4088206',  
'V4088206',  
'V4451397',  
'V4451397',  
'V8177797',  
'V11568366',  
'V3564647',  
'V1272220',  
'V3178987',  
'V2159044',  
'V3713819',  
'V10547717',  
'V3713819',  
'V2669921',  
'V2669921',  
'V2669921',  
'V2920481')            
   
   -- ************************   B L O Q U E O S  D E   U S A **********************************
   
                                  
               
                                  
open CURSOR_ENTRYDATA       
fetch next from CURSOR_ENTRYDATA                                    
--//CAPTURA DE VARIABLES                                     
into @Operacion,@Auxiliar,@Cliente,@Beneficiario,@PaisBenef,@DirBenef,@MontoBenef,@Oprecdep,@montorecibido,@fecha_ger,              
     @solicitud,@Fecha_Aprob_Cadivi,@TipoRemesa,@Fecha_Caja,@destino,@simbolo,@auxiliar_benef,@tasa,@fixing                                  
while @@fetch_status = 0                                    
   begin                                    
    fetch next from CURSOR_ENTRYDATA                                    
    into @Operacion,@Auxiliar,@Cliente,@Beneficiario,@PaisBenef,@DirBenef,@MontoBenef,@Oprecdep,@montorecibido,@fecha_ger,              
         @solicitud,@Fecha_Aprob_Cadivi,@TipoRemesa,@Fecha_Caja,@destino,@simbolo,@auxiliar_benef,@tasa,@fixing                                 
   end                                    
close CURSOR_ENTRYDATA                                    
deallocate CURSOR_ENTRYDATA                                    
              
                   
                                  
     IF datediff(dd,@Fecha_Caja,@FECHACAMBIOCOMISION)>=0 AND (@oprecdep <> '') AND (@montorecibido > 0)                                  
           BEGIN                                   
               SET @transicioncomision = '1'                                  
           END                
           ELSE                                  
           BEGIN                                  
               SET @transicioncomision = '0'                                  
           END                                  
                        
                                              
           declare @tipo varchar(15)                                  
           DECLARE @codimpuesto INT                         
           EXEC ComisionTipo @solicitud, @tipo output                                              
                                                      
            if @tipo = 'NORMAL'                                   
            begin                                  
             IF @transicioncomision='1'                                  
                BEGIN                                  
                  SET @codimpuesto = 256                                  
                END                                  
            ELSE                                  
                BEGIN                                  
                  SET @codimpuesto = 229                     
                END                                  
            end                                  
            else                                  
            begin              
            if @tipo = 'ZONA'                                   
               begin                                  
     IF @transicioncomision='1'                                  
       begin                                  
         SET @codimpuesto = 284                                  
       end                                  
          else                                  
       begin                                  
         SET @codimpuesto = 266                                  
       end                                  
    end                                  
    else                                  
    if @tipo = 'APODERADO'                                   
    begin                                  
      IF @transicioncomision='1'                                  
       begin                                  
      SET @codimpuesto = 256                                  
       end                                  
       else                                  
     begin                                  
       SET @codimpuesto = 265                                  
     end                              
    end               
     end                        
                                      
   SET @COMISION_MONEYGRAM = 0                                               
   SET @MONTOIMPUESTO = (Select Monto from Impuesto where codimpuesto= @codimpuesto)                                  
   SET @COMISION_MONEYGRAM = @MONTOIMPUESTO                                  
   set @TASAVENTA= (Select top 1 tasaventa from PDIVISAS Where divisa =1 and codtipo =1 and codAgencia=@agencia)                
   declare @CodDestinoenvio int                                  
         
   begin tran                               
                                  
    IF NOT EXISTS                                   
     (Select * from Movimien                                   
     where operacion=@OP)                                   
     Insert Into Movimien                                   
     (Operacion,Efectivo,Cheque,Impuesto,                                  
     Tarjeta,Fecha,Reintegro,Auxiliar,                                  
     CodUsuario,CodTransaccion,Estado, Total,codagencia)                                  
     values                                  
     (@OP,(@MontoBenef * @TASAVENTA) + @MONTOIMPUESTO,0.0,0.0,0.0,getdate(),0.0,'','System_Aut',@Transaccion,'C',                                  
     @MontoBenef * @TASAVENTA,@Agencia)                                  
         
                             
     declare @strSqlMovimien varchar(2000)                                  
     set @strSqlMovimien = 'IF NOT EXISTS(Select * from Movimien'+                                  
                      ' where Operacion='+char(39)+@OP+char(39)+') Insert Into Movimien'+                                  
                      ' (Operacion,Efectivo,Cheque,Impuesto,'+                                  
       'Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,Total,codagencia)'+                                  
       'values('+char(39)+@OP+char(39)+','+convert(varchar(50),(@MontoBenef * @TASAVENTA) + @MONTOIMPUESTO) +','                                  
     +convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+ 'getdate()'+','                                  
     +convert(varchar(10),0.0)+','+char(39)+char(39)+','+char(39)+'System_Aut'+char(39)+','+convert(varchar(10),@Transaccion)+','+char(39)+'C'+ char(39)+','                                  
     +convert(varchar(50),@MontoBenef * @TASAVENTA)+','+char(39)+@Agencia+Char(39)+')'                                  
                                       
                                       
     insert into replica                                   
      (codagencia,sqltext,status)                                  
     values                                  
      (convert(int,@agenprincipal), @strSqlMovimien,'N')                                  
                                      
                 
        declare @divisa varchar(20)                                 
  declare @codbanco varchar(20)                                  
  declare @Direccion varchar(50)                                
  declare @abba varchar(50)                                  
  declare @codcuenta varchar(50)                                  
  declare @direccion_benef varchar(500)                                  
  declare @PaisBenef1 varchar(20)                                  
  declare @EstadoBenef varchar(20)                                  
  declare @ciudadBenef varchar(3)              
  declare @CodPostal varchar(20)              
  declare @bancoInt int              
  declare @DireccionInt varchar(500)              
  declare @AbbaInt varchar(100)              
  declare @PaisInt varchar(10)              
  declare @EstadoInt varchar(10)              
  declare @CiudadInt varchar(10)              
  declare @CodPostalInt varchar(10)              
  declare @CodSwif varchar(100)              
                        
        declare CURSOR_TRANSFERENCIA  cursor for               
                            
      select '1' as divisa, t.codbanco,t.Direccion,t.abba,t.codcuenta,b.direccion_benef,PAI_NOMBRE as PaisBenef,              
       me.est_nombre as EstadoBenef,Nombre_ciudad as ciudadBenef,t.CodPostal,              
       tb.banco as bancoInt,tb.Direccion as DireccionInt,tb.Abba as AbbaInt,tb.Pais as PaisInt,              
       tb.Estado as EstadoInt,tb.Ciudad as CiudadInt,tb.CodPostal as CodPostalInt,tb.CodSwif              
      from tblrusadtransferencia t               
      inner join trusadbeneficiario b on (b.auxiliarbenef =t.auxiliarbenef)              
      left outer join tdatosbancointermediario tb on (t.solicitud=tb.solicitud and t.auxiliarbenef=tb.auxiliarbenef)              
      inner join mtpaisesmundo mp on b.cod_pais= PAI_ISO3              
      inner join mtestadosmundo me on mp.PAI_ISO2= me.PAI_ISO2 and b.cod_estado=me.cod_estado              
      inner join mtciudadesmundo mc on mp.PAI_ISO2= mc.PAI_ISO2 and b.Cod_Ciudad=mc.Cod_Ciudad              
      where b.auxiliarbenef=@auxiliar_benef and isnull(t.estatus,'') in ('A','')              
              
  open CURSOR_TRANSFERENCIA                                    
  fetch next from CURSOR_TRANSFERENCIA                                    
  --//CAPTURA DE VARIABLES                                     
    into @divisa, @codbanco,@Direccion,@abba,@codcuenta,@direccion_benef,@PaisBenef1,@EstadoBenef,@ciudadBenef,              
                 @CodPostal,@bancoInt,@DireccionInt,@AbbaInt,@PaisInt,@EstadoInt,@CiudadInt,@CodPostalInt,@CodSwif                                 
    while @@fetch_status = 0                                    
       begin                                    
     fetch next from CURSOR_TRANSFERENCIA                                    
     into @divisa, @codbanco,@Direccion,@abba,@codcuenta,@direccion_benef,@PaisBenef1,@EstadoBenef,@ciudadBenef,              
                       @CodPostal,@bancoInt,@DireccionInt,@AbbaInt,@PaisInt,@EstadoInt,@CiudadInt,@CodPostalInt,@CodSwif                               
       end                                    
    close CURSOR_TRANSFERENCIA                                    
    deallocate CURSOR_TRANSFERENCIA               
                   
                  
                   
              insert into autorizaciontransferencia (operacion,codtipo,divisa,auxiliar,codusuariotaq,codtransaccion,montodivisa,tasaref,fixingref,              
                                              operacioncierre,codbancobenef,dirbancobenef,abbabenef,codcuentabenef,ordenante,codagencia,fecha,              
                                              estado,dirbenef,paisbenef,estadobenef,ciudadbenef,zipbenef,              
                                              bancointermed,direccbancointermed,abbabancointermed, paisinterm,              
                                              estadointerm,ciudadinterm,zipinterm,codswift,auxiliar_benef)              
              values(@OP,12,@divisa,@Auxiliar,'System_Aut',154,@montobenef,@tasa,@fixing,@OperacionB,@codbanco,@Direccion,@abba,@codcuenta,@beneficiario,@Agencia, getdate(),              
              'X',@direccion_benef,@PaisBenef,@EstadoBenef,@ciudadBenef,@CodPostal,@bancoInt,@DireccionInt,@AbbaInt,@PaisInt,@EstadoInt,@CiudadInt,@CodPostalInt,@CodSwif,@auxiliar_benef)                                               
                                                            
                   
   declare @strsql varchar(5000)                
                                
   set @strsql=' insert into autorizaciontransferencia (operacion,codtipo,divisa,auxiliar,codusuariotaq,codtransaccion,montodivisa,tasaref,fixingref, '+  
              +'operacioncierre,codbancobenef,dirbancobenef,abbabenef,codcuentabenef,ordenante,codagencia,fecha, '+  
              +'estado,dirbenef,paisbenef,estadobenef,ciudadbenef,zipbenef, '+  
              +'bancointermed,direccbancointermed,abbabancointermed, paisinterm, '+  
              +'estadointerm,ciudadinterm,zipinterm,codswift,auxiliar_benef) '+              
              +'values ('+char(39)+@OP+char(39)+','+convert(varchar,12)+','+char(39)+@divisa+char(39)+','+char(39)+@Auxiliar+char(39)+','+  
              +char(39)+'System_Aut'+char(39)+','+convert(varchar,154)+','+convert(varchar,@montobenef)+','+convert(varchar,@tasa)+','+  
     +convert(varchar,@fixing)+','+char(39)+@OperacionB+char(39)+','+char(39)+convert(varchar,@codbanco)+char(39)+','+char(39)+@Direccion+char(39)+','+  
     +char(39)+@abba+char(39)+','+char(39)+@codcuenta+char(39)+','+char(39)+@beneficiario+char(39)+','+char(39)+@Agencia+char(39)+','+  
     +'getdate()'+','+char(39)+'X'+char(39)+','+char(39)+@direccion_benef+char(39)+','+char(39)+@PaisBenef+char(39)+','+char(39)+  
     +@EstadoBenef+char(39)+','+char(39)+@ciudadBenef+char(39)+','+char(39)+@CodPostal+char(39)+','+isnull(convert(varchar,@bancoInt),0)+  
     +','+char(39)+isnull(@DireccionInt,'')+char(39)+','+char(39)+isnull(@AbbaInt,'')+char(39)+','+char(39)+isnull(@PaisInt,'')+char(39)+  
     +','+char(39)+isnull(@EstadoInt,'')+char(39)+','+char(39)+isnull(@CiudadInt,'')+char(39)+','+char(39)+isnull(@CodPostalInt,'')+  
     +char(39)+','+char(39)+isnull(@CodSwif,'')+char(39)+','+char(39)+@auxiliar_benef+char(39)+')'/**/              
                          
   insert into replica(codagencia,sqltext,status)                                  
   values                                   
      (convert(int,@agenprincipal) , @strsql, 'N')                                  
                                         
    insert into MovImp(Operacion,CodImpuesto,MontoImpuesto,MontoBase,PorcentajeBase,TotalImpuesto) values                                   
     (@OP, @codimpuesto,@MONTOIMPUESTO, @MontoBenef * @TASAVENTA,((@MONTOIMPUESTO*100)/(@MontoBenef * @TASAVENTA)), @MONTOIMPUESTO)               
                   
                   
    update remesas_familiaresbenef set operacionfinal=@op where operacion=@OperacionB              
                  
   declare @strsql1 varchar(500)                                  
   set @strsql1= 'update remesas_familiaresbenef set operacionfinal='+char(39)+@op+char(39)+'where operacion='+char(39)+@OperacionB+char(39)              
                                        
   insert into replica                                   
    (codagencia,sqltext,status)                                  
   values (convert(int,@agenprincipal) , @strsql1, 'N')                
                            
                                      
                                   
--------------- ************************************************ ----------------------                                  
---------------------------------------------------------------------------------------                                  
---       PROCESO DE CAJA                                  
---------------------------------------------------------------------------------------                                  
--------------- ************************************************ ----------------------                                  
                                  
   DECLARE @OperacionMoneygramCAJA VARCHAR(20)                                  
   SET @OperacionMoneygramCAJA =@OP                                  
                                     
   SET @Fecha = GETDATE()                                  
   set @Transaccion =562                                  
                                  
   exec getoperacion @agenciavc, 'Transferencias_Caja Remesas_Fam', @resultado OUTPUT                                  
                                  
   SELECT  @O = convert(varchar(6),@resultado)                                  
   SELECT @O = (SELECT  RIGHT(REPLICATE('0',4) + @O ,4))                                   
                                       
   if (SELECT LEN(@agencia)) = 1                                  
       select @agencia = '0'+@agencia                                   
                                  
   set @OP = @agencia + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),1,2) + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),4,2) + SUBSTRING(CONVERT(CHAR(10),@Fecha,103),7,4)+ CONVERT(CHAR(3),@Transaccion) + CONVERT(CHAR(4),@O)                                  
                 
   --print (@OP)              
                                  
   ----------------------------------------------------------------------------------------------------------------------------------------------------                                  
   ----------------------------------------------------------------------------------------------------------------------------------------------------                                  
                                                     
   set @diaspermitido =isnull((select convert(int,valor) as valordias from parametros where modulo='SACC' and clave='DIAPARADEVOLVERALBCV'),0)                                  
                                  
                                                     
   declare @OperacionCierre varchar(20)                                  
   declare @TipoMoneyGram int                                        
   declare @Monto float                   
   declare @MtoImpuesto float                   
   declare @coddestino varchar(50)                              
   declare @TasadeCambio float                       
   declare @Comision float                                  
   declare @MontoBs float                                  
   declare @telbenef varchar(50)                                  
   declare @ComisionMG1 float                                  
   declare @monto_benef float                                  
   declare @operremesa varchar(20)                                  
   declare @operacionsol varchar(20)                                  
   declare @OperDetalleCadivi varchar(20)                                  
   declare @OperDepoTranX varchar(25)                
                                  
                                
   set @ControlCambio  = (Select top 1 valor from parametros where clave = 'CONTROLDECAMBIO')                                  
                                  
    declare CURSOR_ENTRYDATACAJA  cursor for                                    
    --// SELECT de consulta de los datos de la remesa                                    
                
        select t.operacion,t.codtipo, r.auxiliar_sol,t.montodivisa, t.tasaref, 0 as FeeAmount, 0 as CodDestination,              
               r.monto_benef,r.solicitud,r.beneficiario, r.operacion as operremesa, r.operacionsol,              
              'RF' as TipoRemesa, '' as OperDetalleCadivi, m1.codusuario,               
               rs.oprecdep as OperDepoTranX, mv.MontoImpuesto                            
        from autorizaciontransferencia t              
        inner join remesas_familiaresbenef r on (t.operacion=r.operacionfinal)              
        inner join divisas d on (t.divisa=d.divisa)              
        inner join movimp mv on (r.operacion = mv.operacion)              
        inner join movimien m1 on (t.Operacion= m1.operacion)              
        inner join remesas_familiaressol rs on (rs.operacion=r.operacionsol)              
        where --(t.operacion='01160220121540022')and              
         r.estado in ('A','X')              
              and (t.estado='X') and (r.cod_aprobacion is not null)               
              and  m1.codusuario='System_Aut'               
        
          and r.auxiliar_sol not in ('V1197977',  
'V3611972',  
'V3611972',  
'V6056068',  
'V6305139',  
'V1155280',  
'V2954368',  
'V1155280',  
'V1413261',  
'V2954368',  
'V3635867',  
'V3027309',  
'V3027309',  
'V14840492',  
'V5884324',  
'V1892162',  
'V3822911',  
'V1892162',  
'V1892162',  
'V2773583',  
'V2773583',  
'V5247407',  
'V3832094',  
'V3832094',  
'V3082822',  
'V3082822',  
'V4058788',  
'V4058788',  
'V4058788',  
'V8003340',  
'V3405261',  
'V3405261',  
'V3405261',  
'V2932901',  
'V2932901',  
'V5440850',  
'V5440850',  
'V5440850',  
'V3896988',  
'V5288864',  
'V12607375',  
'V17032699',  
'V4088206',  
'V4088206',  
'V4088206',  
'V4451397',  
'V4451397',  
'V8177797',  
'V11568366',  
'V3564647',  
'V1272220',  
'V3178987',  
'V2159044',  
'V3713819',  
'V10547717',  
'V3713819',  
'V2669921',  
'V2669921',  
'V2669921',  
'V2920481')            
   
   -- ************************   B L O Q U E O S  D E   U S A **********************************
                     
                      
                                      
   open CURSOR_ENTRYDATACAJA                                    
   fetch next from CURSOR_ENTRYDATACAJA                                   
   --//CAPTURA DE VARIABLES                                     
   into @Operacion,@TipoMoneyGram,@Auxiliar,@Monto,@TasadeCambio,@Comision,@CodDestino,@monto_benef,                
   @solicitud,@beneficiario,@operremesa,@operacionsol,@TipoRemesa,@OperDetalleCadivi,@codusuario, @OperDepoTranX,                
   @MtoImpuesto                                  
   while @@fetch_status = 0                                    
      begin           
                                  
  SET @MONTOIMPUESTO = @MtoImpuesto                                  
  SET @MontoBs = @Monto * @TasadeCambio                  
  SET @MontoBs = ROUND(@MontoBs,2)                              
                                  
    Insert into Movimien                                   
    (Operacion,Efectivo,Cheque,Impuesto,Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,CodBcv,Total,Codagencia)                                  
    values                                   
    (@OP,@MontoBs,0.0,@MONTOIMPUESTO,0.0,getdate(),0.0,@Auxiliar,@USERCAJA,@Transaccion,'C',0,@MontoBs,@Agencia)                                  
                                  
       declare @strSqlMovimien2 varchar(2000)                                  
       set @strSqlMovimien2 = 'Insert Into Movimien'+                                  
                              ' (Operacion,Efectivo,Cheque,Impuesto,'+                                  
                              'Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,CodBcv,Total,codagencia)'+                                  
                              'values('+char(39)+@OP+char(39)+','+convert(varchar(50),@MontoBs) +','                                  
            +convert(varchar(10),0.0)+','+convert(varchar(10),@MONTOIMPUESTO)+','+convert(varchar(10),0.0)+','+ 'getdate()'+','                          
            +convert(varchar(10),0.0)+','+char(39)+@Auxiliar+char(39)+','+char(39)+@USERCAJA+char(39)+','+convert(varchar(10),@Transaccion)+','+char(39)+'C'+ char(39)+','                                  
            +convert(varchar(50),0)+','+convert(varchar(50),@MontoBs)+','+char(39)+@agenprincipal+Char(39)+')'                                  
                                  
         insert into replica(codagencia,sqltext,status)                                  
         values (convert(int,@agenprincipal) , @strSqlMovimien2, 'N')                                  
                                         
                 
    Insert Into SolicituPen_BCV (Solicitud, Monto_Sol, Estado,Fecha_Caja, Operacion)                                  
    Values (@solicitud, @Monto, 'P', getdate(),@operremesa )                           
                    
    declare @strSqlsol varchar(2000)               
    set @strSqlsol ='Insert Into SolicituPen_BCV (Solicitud, Monto_Sol, Estado,Fecha_Caja,Operacion)'+                                  
     'Values ('+char(39)+@solicitud+char(39)+','+convert(varchar(20),@Monto)+','+char(39)+'P'+char(39)+','                                  
     +char(39)+convert(varchar(50),getdate())+char(39)+','+char(39)+@operremesa+char(39)+')'                                   
                                     
     if @strSqlsol <> ''              
     insert into replica (codagencia,sqltext,status)                                   
     values (convert(int,@agenprincipal),@strSqlsol,'N')                
                     
                           
                 
   update remesas_familiaresbenef set operacionfinal = @OP, estado='C'               
   where operacionfinal = @Operacion              
              
              
   declare @strSqlbenef varchar(2000)                                  
   Update Remesas_FamiliaresBenef Set Estado = 'C', Operacionfinal = @Op                                  
   Where Operacion = @operremesa                                  
                                    
   set @strSqlbenef ='Update Remesas_FamiliaresBenef Set Estado = '+char(39)+'C'+char(39)+', Operacionfinal = '+char(39)+@Op+char(39)+                                  
   ' Where Operacion = '+char(39)+@operremesa+char(39)                                  
                                     
   insert into replica(codagencia,sqltext,status)                                   
   values (convert(int,@agenprincipal),@strSqlbenef,'N')               
                      
                               
   declare @strSqlsol1 varchar(2000)                
   Update Remesas_FamiliaresSol Set statusdep='P', montoconsumido= ROUND(isnull(montoconsumido,0)+(@MontoBs+@MONTOIMPUESTO),2)                                  
   Where Operacion = @operacionsol                                  
                                    
   set @strSqlsol1 = 'Update Remesas_FamiliaresSol Set statusdep= '+char(39)+'P'+char(39)+                                  
    +', montoconsumido= ROUND(isnull(montoconsumido,0)+'+convert(varchar,(@MontoBs+@MONTOIMPUESTO))+                                  
     ',2) Where Operacion = '+char(39)+@operacionsol+char(39)                                  
                      
                 
   if @strSqlsol1 <> ''               
   insert into replica(codagencia,sqltext,status)                                   
   values (convert(int,@agenprincipal),@strSqlsol1,'N')                  
                      
                      
     declare @strSqlAUT varchar(2000)               
     update autorizaciontransferencia set operacioncierre= @Op,              
     estado='A' , codusuarioger =@Username , tasaref=@TasadeCambio where operacion=@Operacion              
                    
                    
     set @strSqlAUT='update autorizaciontransferencia set operacioncierre= '+char(39)+@Op+char(39)+','+              
     'estado='+char(39)+'A' +char(39)+',codusuarioger ='+char(39)+@Username+char(39)+', tasaref='+char(39)+convert(varchar(20),@TasadeCambio)+char(39)+'where operacion='+char(39)+@Operacion+char(39)              
                         
            if @strSqlAUT <> ''              
   insert into replica(codagencia,sqltext,status)                                   
   values (convert(int,@agenprincipal),@strSqlAUT,'N')               
                     
                   
   insert into posicion                                   
   (Operacion,CodTipo,Divisa,MontoDivisa,TasaCambio,MontoBs,TasaRef,                                  
    FixingRef,Fecha,CodUsuario,CodUsuarioRec,CodAgencia,CodTransaccion,Estado,Cantidad)                                   
   values                                   
   (@OP,12,'1',@Monto,@TasadeCambio,@MontoBs,@TasadeCambio,1.0,getdate(),@Username,null,@Agencia,@Transaccion,'C',null)                                  
                            
              
     if not exists (select operacion from autotesoreria where operacion=@operacion)               
     insert into autotesoreria(operacion,status)              
     values(@operacion,'A')                         
                    
     declare @strSqlaut1 varchar(2000)               
      set @strSqlaut1='if not exists (select operacion from autotesoreria where operacion='+char(39)+@operacion+char(39)+')'               
     +'insert into autotesoreria(operacion,status)'+              
     +'values('+char(39)+@operacion+char(39)+','+char(39)+'A'+char(39)+')'              
                           
     insert into replica(codagencia,sqltext,status)                                   
     values (convert(int,@agenprincipal),@strSqlaut1,'N')               
              
                
                 
                    
     --Contabilidad                       
                   
     declare @ContCuenta varchar(30)                            
                                                                                               
              
     set @ContCuenta = (Select top 1 acccode from accounts Where SecAcccode = '00-620101050001-01')                            
     if @ContCuenta <> ''                            
     begin                            
        Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia)                            
        values (@OP, @ContCuenta, 0, 0, @MtoImpuesto, 0,@OP , '', @OperDepoTranX)                                           
                   
        set @sqltext1 ='Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia) '+  
        +'values ('+char(39)+@OP+char(39)+','+char(39)+@ContCuenta+char(39)+','+convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+  
        +convert(varchar(50),(@MtoImpuesto))+','+convert(varchar(10),0.0)+','+char(39)+@OperDepoTranX+char(39)+','+ char(39)+char(39)+','+@OP+')' --3                     
     end              
                   
     /*if  @sqltext1 <> ''                  
     begin                   
     insert into replica(codagencia,sqltext,status)                                
     values (convert(int,@agenprincipal) , @sqltext1, 'N')                     
     end               */  
                   
                   
                             
    set @ContCuenta = (Select top 1 acccode from accounts Where SecAcccode = '00-620101900001-02')     
      
--select * from Mov_Cuentas where refedoc='08110420125620001'  
                 
    if @ContCuenta <> ''                        
     begin                     
          Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia)                        
          values (@OP, @ContCuenta, 0 ,0, (@MONTOIMPUESTO/@TasadeCambio), 0, @OP, '', @OperDepoTranX)                      
                  
          set @sqltext1 ='Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia) '+  
                 +'values ('+char(39)+@OP+char(39)+','+char(39)+@ContCuenta+char(39)+','+convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+  
                 +convert(varchar(50),(@MONTOIMPUESTO/@TasadeCambio))+','+convert(varchar(10),0.0)+','+char(39)+@OP+char(39)+','+ char(39)+char(39)+','+@OperDepoTranX+')' --3                     
      end              
              
  /* if  @sqltext1 <> ''                  
   begin                   
     insert into replica(codagencia,sqltext,status)                                
     values (convert(int,@agenprincipal) , @sqltext1, 'N')                      
   end             */  
                 
              
     set @ContCuenta = (Select top 1 acccode from accounts Where SecAcccode = '00-210201110001-09')                            
     if @ContCuenta <> ''                            
     begin                            
              
        Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia)                            
        values (@OP, @ContCuenta, 0 , 0, (@MontoBs),@Monto, @OP, '', @OperDepoTranX) --2                    
                        
                           
        set @sqltext5 ='Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia) '+  
            +'values ('+char(39)+@OP+char(39)+','+char(39)+@ContCuenta+char(39)+','+convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+  
            +convert(varchar(50),(@MontoBs))+','+convert(varchar(10),@Monto)+','+char(39)+@OP+char(39)+','+ char(39)+char(39)+','+@OperDepoTranX+')'   
        end                            
                  
       /*if  @sqltext5 <> ''                  
        begin                   
          insert into replica(codagencia,sqltext,status)                                
          values (convert(int,@agenprincipal) , @sqltext5, 'N')                      
        end                       */  
              
     set @ContCuenta = (Select top 1 acccode from accounts Where SecAcccode ='00-210201110001-10')                        
     if @ContCuenta <> ''                        
     begin                        
          Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia)                        
          values (@OP, @ContCuenta, @MontoBs + @MONTOIMPUESTO,0 , 0,0, @OperDepoTranX, '', @Op)                 
                         
         set @sqltext2 ='Insert Mov_Cuentas (Operacion, Cuenta, Debito, DebitoPiezas, Credito, CreditoPiezas, RefeDoc, TipoTransacc, Referencia) '+  
                 +'values ('+char(39)+@OP+char(39)+','+char(39)+@ContCuenta+char(39)+','+convert(varchar(50),(@MontoBs + @MONTOIMPUESTO )) +','+  
                 +convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+convert(varchar(10),0.0)+','+char(39)+@OperDepoTranX+char(39)+','+ char(39)+char(39)+','+@Op+')' --3                                         
      end               
               
    /* if  @sqltext2 <> ''                  
          begin                   
     insert into replica(codagencia,sqltext,status)                                
     values (convert(int,@agenprincipal) , @sqltext2, 'N')                      
          end                              */  
                                                     
   fetch next from CURSOR_ENTRYDATACAJA                                    
       into @Operacion,@TipoMoneyGram,@Auxiliar,@Monto,@TasadeCambio,@Comision,@CodDestino,@monto_benef,                
       @solicitud,@beneficiario,@operremesa,@operacionsol,@TipoRemesa,@OperDetalleCadivi,@codusuario, @OperDepoTranX,                
       @MtoImpuesto                                  
      end                                    
  close CURSOR_ENTRYDATACAJA                                    
  deallocate CURSOR_ENTRYDATACAJA                                    
                                 
------------- ************************************************ ----------------------                                  
---------------------------------------------------------------------------------------                                  
---        FIN DEL PROCESO DE CAJA                                  
---------------------------------------------------------------------------------------                                  
--------------- ************************************************ ----------------------                                      
                                       
     if @@error = 0                                        
     commit tran                                  
     else                                  
     rollback tran                                  
  --end                              
                                     
 --end                                 
                                
select @OP AS OpMoneygram                  
  
  