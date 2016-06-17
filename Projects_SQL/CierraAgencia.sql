ALTER  Procedure [dbo].[cierreagencia] @operacion varchar(25)              
/*Modificado el 31/12/2007               
  Se agrego el filtro para la divisa 44, debido a la reconversion monetaria. (Marcos Cortez 31/12/2007)              
  Modificado el 05/03/2008              
  
  Se agrego script para sincerar las tasas ponderadas, ya que hacen caer contabilidad de inventarios en Bs antiguos.              
              
Mod  10/04/2008  Se modifico el filtro de la divisa (35,44) para las operaciones 41 Notas  de Credito o Debito (Norka Vasquez)              
         
Modificado por Karen Trompetero el dia 06/10/2010        
Se comento el cursor que hace la replica de las operaciones de Moneygram.        
      
Modificado por Karen Trompetero el dia 10/02/2011      
Se agregaron en las consultas de las tablas planilla_cadivi, planilla_cadiviespecial e importaciones los campos divisa y montodivisa,      
con el objetivo de hacerlas replicar a principal.Cambio solicitado por Contraloria de control de cambio.      
  
Modificado por Karen Trompetero el dia 17/07/2012  
Se agregaron en las consultas de las tablas planilla_cadivi campos frecuencia,CodAreaConoc,CodSubAreaConoc,AreaAdicional     
con el objetivo de hacerlas replicar a principal.Cambio solicitado por Contraloria de control de cambio.      
*/                
as                
              
declare @Auxiliar_Rep varchar (10)                
declare @Auxiliar_est varchar (10)                
declare @Auxiliar_sol varchar (10)              
declare @Auxiliar_Benef varchar (10)               
declare @Nombre_Benef varchar (100)              
declare @Nombre_Rep varchar (100)              
declare @Dir_Benef varchar (200)              
declare @Parantesco varchar(20)               
declare @Profesion varchar (100)              
declare @Registro varchar(20)                
declare @institucion varchar (100)                
declare @Dir_Est varchar (200)                
declare @Dir_Rep varchar (200)               
declare @Ciudad_Est varchar (20)                
declare @Pais_Est varchar (20)              
declare @Mail_Benef varchar (20)                
declare @Mail_Rep varchar (20)               
declare @Tlf_Est varchar (20)                 
declare @Tlf_Benef varchar (20)              
declare @Tlf_Rep varchar (20)              
declare @Fax_Est varchar (20)                
declare @Pasaporte_Est varchar (11)                
declare @Solicitud varchar (10)                
declare @Cod_Seguridad varchar (30)                
declare @Usuario_Taq  varchar (20)                
declare @Usuario_Ger varchar (20)                
declare @Usuario_Italcadivi varchar (20)                
declare @Fecha_Taq datetime                
declare @Fecha_Ger datetime                
declare @Fecha_Italcadivi datetime                
declare @Requisitos_Taq  varchar (20)                
declare @Requisitos_Ger varchar (20)                
declare @Requisitos_Italcadivi varchar (20)                
declare @Fecha_enviocadivi datetime                
declare @Usuario_enviocadivi varchar (20)              
declare @Observacion varchar (100)                 
declare @Universidad varchar (50)               
declare @Actividad varchar (1)               
declare @email varchar (50)              
declare @monto_sol money              
declare @anoestudia int               
select @anoestudia = 0              
select @monto_sol = 0              
declare @agencia int                
declare @fecha datetime                
  
select @agencia = CodAgencia, @fecha = fecha from movimien where operacion = @operacion                
              
declare @divisa varchar(6)                
declare @transaccion int               
declare @oper varchar(25)                
declare @tasaponderada real                
select @tasaponderada = 0               
declare @tasadecompra real                
select @tasadecompra = 0               
declare @fixingponderado real                
select @fixingponderado = 0                
declare @utilidad real                
select @utilidad = 0                
declare @TotalDebito money                
select @TotalDebito = 0                
declare @TotalCredito money                
select @TotalCredito = 0                
declare @SecAccCode varchar(40)                
declare @MontoDivisa money                
select @MontoDivisa = 0                
declare @MontoBs money                
select @MontoBs = 0                
declare @Efectivo money                
select @Efectivo = 0                
declare @Cheque money                
select @Cheque = 0                
declare @Impuesto money                
select @Impuesto = 0                
declare @reintegro money                
select @reintegro = 0                
declare @tarjeta money                
select @tarjeta = 0                
declare @codtransaccion money                
select @codtransaccion = 0                
declare @total money                
select @total = 0                
declare @codusuario varchar(20)                
declare @auxiliar varchar(20)                
declare @codBcv int                
select @codBcv = 0                
declare @cantidad int                
select @cantidad = 0                
declare @codagencia int                
select @codagencia = 0                
declare @nrocheque varchar(15)                
declare @AccCode varchar(40)                
declare @BsDebit money                
declare @BsCredit money                
declare @RefDoc varchar(40)                
declare @TipoTran varchar(40)                
declare @OffiCode varchar(40)                
declare @index varchar(20)                
declare @vcode varchar(20)                
declare @PiezasDebit money                
declare @PiezasCredit money                
declare @regname varchar(11)                
declare @LongDesc varchar(230)                
declare @Status char(1)                
declare @indice int                
Select @indice = 0                
              
select @regname = 'AUTOMATICO'                
select @LongDesc = 'ASIENTO AUTOMATICO'                
select @Status = 'C'                
select @BsDebit = 0                
select @BsCredit = 0                
select @PiezasDebit = 0                
select @PiezasCredit = 0                
  
declare @contabilidad varchar(2)                
select @contabilidad = 'SI'                
  
declare @marca int                
declare @denominacion money                
select @denominacion = 0                
  
declare @cantidadtravel int                
declare @OperAmerican varchar(17)                
declare @Posicion int                
declare @coddivisa varchar(6)                
declare @tasacambio real                
declare @prefijo varchar(2)                
declare @serialinicial varchar (15)                
declare @CantidadAmerican int                
declare @denominacionAmerican money                
declare @vendedorId varchar (10)                
declare @statusamerican char(1)                
declare @fechaamerican datetime                
declare @servicio varchar (2)                
declare @codautoriz varchar (10)                
declare @vendedorIdThomas varchar(10)                
declare @tasacambioThomas real                
declare @OperacionThomas varchar(17)                
declare @PosicionThomas int                
declare @coddivisaThomas varchar(6)                
declare @prefijoThomas varchar(2)                
declare @serialinicialThomas varchar (15)                
declare @CantidadThomas int                
declare @denominacionThomas money                
declare @statusThomas char(1)                
declare @fechaThomas datetime                
declare @Nro_Tarjeta varchar(17)                
declare @Tipo varchar(2)                
declare @FechaVencimiento varchar(10)                
declare @CodTipo int                
declare @Autorizacion varchar(17)                
declare @puntovta int                
declare @OperCiticorp varchar(17)                
declare @PosicionCiticorp int                
declare @coddivisaciticorp varchar(6)                
declare @tasacambiociticorp real                
declare @serialinicialciticorp varchar (15)                    
declare @Cantidadciticorp int                
declare @denominacionciticorp money                
declare @vendedorIdciticorp varchar (10)                
declare @statusciticorp char(1)                
declare @fechaciticorp datetime                
  
declare @monto money                
select @monto = 0                
  
declare @OPERACIONCIERRE varchar(25)                
declare @FORMA_ENVIO char(1)                
declare @TIPO_ENVIO varchar(2)                
declare @PESO_REAL varchar(8)                
declare @PESO_DIM varchar(8)                
declare @DESCRIPCION varchar(100)                
declare @VALOR_SEGURO varchar(13)                
declare @VALOR_ADUANA varchar(13)                
declare @REFERENCIA1 varchar(15)                
declare @REFERENCIA2 varchar(15)                
declare @PAIS_ORIGEN varchar(30)                
declare @INSTRUCC_ESP varchar(200)                
declare @FECHA_ENVIO varchar(10)                
declare @MONTOUSA money                
declare @combustible money                
declare @franqueo money                
declare @iva money                
declare @opermoney varchar(17)                
declare @opermoneycierre varchar(17)                
declare @tipomoney int                
declare @auxiliarmoney varchar(11)                
declare @montomoney money                
declare @tasamoney real                
declare @comisionmoney money                
declare @destinomoney int                
declare @montobsmoney money                 
declare @paismoney varchar(20)                
declare @dirbenef varchar(100)                
declare @telbenef varchar(20)                
declare @comisionmg real              
declare @codbanco int                
declare @codcuenta varchar(20)                
declare @codigo int                
declare @motivo varchar(4)                
declare @estado char(1)                
declare @reterror int                
declare @taq varchar (19)              
declare @caja varchar (19)              
declare @ref varchar (19)              
declare @cc varchar (2)              
declare @cs varchar (2)              
DECLARE @USU VARCHAR (50)                          
               
DECLARE @frecuencia char(1)  
DECLARE @CodAreaConoc varchar(3)  
DECLARE @CodSubAreaConoc varchar(6)            
DECLARE @AreaAdicional varchar(100)  
DECLARE @ActividadAcad varchar(150)              
              
select @montomoney = 0                
select @tasamoney = 0                
select @comisionmoney = 0                
select @montobsmoney = 0                
select @comisionmg = 0              
              
declare @tranname varchar(20)                
              
exec countnow                
              
select @tranname ='Cierre'                
              
begin transaction @tranname                
              
declare tabla cursor                
for                
Select b.Divisa, ROUND(SUM(b.MontoBs)/SUM(b.MontoDivisa),4) as                
'TasaPonderada', ROUND(SUM(b.MontoDivisa/b.fixingref)/SUM(b.MontoDivisa),4)                
as 'TasaPonderadaDolar'                
from movimien a, movdivisa b                
where (a.operacion = b.operacion)                
and (a.estado = 'C')                
and (b.fixingref > 0)                
and (b.montodivisa > 0)                
and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
and (((a.CodTransaccion = 7) and (a.operacion in (select z.operacioncierre                
from enlaces z, movimien y where (z.operacioncierre = a.operacion)                
and (z.operacion = y.operacion) and (y.codusuario like '%CAJAPRINCIPAL%'))))                
or (a.CodTransaccion = 0) or (a.CodTransaccion = 85) or (a.CodTransaccion =103) or ((a.CodTransaccion = 25) and (b.Debito > 0)) or a.CodTransaccion =43)                
and (b.CodTipo = 1)                
and (b.Divisa not in ('35','44'))                
and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
group by b.Divisa                
having                
((SUM(b.MontoBs)/SUM(b.MontoDivisa)) is not null)                
order by b.Divisa                
open tabla                
if @@cursor_rows <> 0                
begin                
fetch next from tabla                
into @divisa,@tasaponderada,@fixingponderado                
while (@@fetch_status <> -1)                
begin                
if (@@fetch_status <> -2)                
begin                
  
Delete TasaPonderada where (Divisa = @divisa) and (CodTipo = 1)                
  
                        if  @@error <>0                
      begin                
                          rollback transaction @tranname                
                          RETURN                
      end                
  
                        Insert into TasaPonderada (CodTipo, Divisa,TasaPonde, FixingPonde) values (1, @divisa, @tasaponderada,@fixingponderado)                
  
                        if  @@error <>0                
                        begin                
                          rollback transaction @tranname                
                          RETURN                
                        end                
              
   Select @TasadeCompra=TasaCompra from Pdivisas where Divisa=1 and Codtipo=1 --and CodAgencia=1              
              
   /* agregado por marcos cortez para mantener la tasa ponderada del dolar en el precio actual segun instrucciones del tomas fernandez el 16022005 */                
              
   update tasaponderada set tasaponde=@TasadeCompra where divisa=1                
              
   /* fin de lo agreagado para la tasa ponderada el 16022005*/                
              
            /* Codigo agregado para sincerar las tasas ponderadas -- Marcos Cortez -- 05/03/2008 */              
              
            update tasaponderada set tasaponde=p.tasacompra, fixingponde=p.fixing from               
                        pdivisas p               
            inner join               
                        tasaponderada t               
            on (p.codtipo=t.codtipo and t.divisa=p.divisa)              
            where p.codtipo=1              
              
        /* Este codigo se puede comentar luego que la contabilidad de inventarios tenga dos dias cayendo bien*/               
              
Select @utilidad = SUM(b.MontoBs) - (SUM(b.MontoDivisa) * @tasaponderada)                            
from movimien a, movdivisa b                
where (a.operacion = b.operacion)                
and (a.estado = 'C')                
and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
and ((a.CodTransaccion = 44) or (a.CodTransaccion = 116) or                
(a.CodTransaccion = 28) or (a.CodTransaccion = 27) or (a.CodTransaccion =  98)               
or (a.CodTransaccion = 49) or ((a.CodTransaccion = 25) and (b.credito >  0))                
or ((a.CodTransaccion = 6) and (a.operacion in (Select operacion from                
Traspaso_Valores where (operacion = a.operacion)                
and (CodUsuario_Recibe like '%CAJAPRINCIPAL%')))))                
and (b.CodTipo = 1)                
and (b.Divisa = @divisa)                
and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
group by b.Divisa                
order by b.Divisa                
              
if @utilidad <> 0                
begin                
 Select @utilidad = SUM(b.MontoBs) - (SUM(b.MontoDivisa) * @tasaponderada)                
 from movimien a, movdivisa b                
where (a.operacion = b.operacion)                
and (a.estado = 'C')                
and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
and ((a.CodTransaccion = 44) or (a.CodTransaccion = 116) or                
(a.CodTransaccion = 28) or (a.CodTransaccion = 46) or (a.CodTransaccion = 27)   
or (a.CodTransaccion = 98) or (a.CodTransaccion = 49) or                
((a.CodTransaccion = 25) and (b.credito > 0))                
or ((a.CodTransaccion = 6) and (a.operacion in (Select operacion from          
Traspaso_Valores where (operacion = a.operacion)                
and (CodUsuario_Recibe like '%CAJAPRINCIPAL%')))))                
and (b.CodTipo = 1)                
and (b.Divisa = @divisa)                
and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
group by b.Divisa                
order by b.Divisa                
     end                
else                
begin select @utilidad = 0                
end                
              
if @utilidad >= 0                
begin                
 select @TotalDebito = @TotalDebito + @utilidad                
  
 delete movdivisa where (operacion = @operacion) and (CodTipo = 1) and (Divisa = @divisa)                
  
                  if  @@error <>0                
                      begin                
                          rollback transaction @tranname                
                          RETURN                
                        end                
                 
 insert into MovDivisa  values(@operacion,1,@divisa,@utilidad,1,@utilidad,1,1,@utilidad,0,0)                
  
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
  RETURN                
 end                
              
 select @SecAccCode ='00-83'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000000-02'                
  
 exec insertacontable @SecAccCode,@operacion, 0, @utilidad, 0, 0, '', '', ''                
  
end                
           
if @utilidad <= 0                
begin                
  
 select @TotalCredito = @TotalCredito + (@utilidad * -1)                
  
 delete movdivisa where (operacion = @operacion) and (CodTipo = 1) and (Divisa = @divisa)                
  
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
  RETURN                
 end                
   
 insert into MovDivisa values(@operacion,1,@divisa,@utilidad*-1,1,@utilidad*-1,1,1,0,@utilidad*-1,0)                
  
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
              
  RETURN                
 end                
              
 select @SecAccCode ='00-83'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000000-02'                
  
 select @utilidad = @utilidad * -1                
  
 exec insertacontable @SecAccCode,@operacion, @utilidad, 0, 0, 0,'', '', ''                
  
end                
              
select @utilidad = 0                
  
end                
  
fetch next from tabla                
into @divisa,@tasaponderada,@fixingponderado                
end                
  
end                
              
close tabla                
deallocate tabla                
              
  
declare tabla cursor                
for                
  
 Select a.codtransaccion, b.Divisa, SUM(b.MontoBs) as 'MontoBs',                
 SUM(b.MontoDivisa) as 'MontoDivisa'                
 from movimien a, movdivisa b                
 where (a.operacion = b.operacion)                
 and (a.estado = 'C')                
 and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
 and (((a.CodTransaccion = 7) and (a.operacion in (select z.operacioncierre                
 from enlaces z, movimien y where (z.operacioncierre = a.operacion)                
 and (z.operacion = y.operacion) and (y.codusuario like '%CAJAPRINCIPAL%'))))                
 or (a.CodTransaccion = 0) or (a.CodTransaccion = 116)                
 or (a.CodTransaccion = 28) or (a.CodTransaccion = 27) or (a.CodTransaccion = 85)   
 or (a.CodTransaccion = 103) or (a.CodTransaccion = 43) or                
 (a.CodTransaccion = 44) or (a.CodTransaccion = 98) or (a.CodTransaccion = 46) or (a.CodTransaccion = 49)                
 or ((a.CodTransaccion = 6) and (a.operacion in (Select operacion from                
 Traspaso_Valores where (operacion = a.operacion)                
 and (CodUsuario_Recibe LIKE '%CAJAPRINCIPAL%'))))) and (b.CodTipo = 1)                
 and (b.Divisa not in ('35','44'))                
 and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
 and a.operacion not in (Select i.operacion from infsharedcr i where a.operacion=i.operacion)               
 group by a.CodTransaccion, b.Divisa                
 order by a.CodTransaccion, b.Divisa                
              
open tabla                
if @@cursor_rows <> 0                
begin            
 fetch next from tabla                
 into @transaccion, @divisa, @MontoBs, @MontoDivisa                
 while (@@fetch_status <> -1)                
 begin                
  if (@@fetch_status <> -2)                
  begin                
   if @transaccion = 0                
   begin  
                   
    select @SecAccCode ='00-83'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000000-01'  
     
    exec insertacontable @SecAccCode,@operacion, 0, @MontoBs, 0, @MontoDivisa, '', '', ''                
   end                
     
   if @transaccion = 7                
   begin                
    select @SecAccCode ='00-06'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-03'  
      
    exec insertacontable @SecAccCode,@operacion, 0, @MontoBs, 0, @MontoDivisa, '', '', ''                
   end                
     
   if (@transaccion = 43) or (@transaccion = 116) or (@transaccion = 85) or  (@transaccion = 103)                
   begin                
    if (@transaccion = 85) or (@transaccion = 103)                
    begin                
     select @SecAccCode ='00-43'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-09'  
       
     exec insertacontable @SecAccCode,@operacion, 0, @MontoBs, 0, @MontoDivisa, '', '', ''                
    end                
    else                
    begin                
     select @SecAccCode ='00-43'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-01'                
       
     exec insertacontable @SecAccCode,@operacion, 0, @MontoBs, 0, @MontoDivisa, '', '', ''                
    end                
   end                
  
   if (@transaccion = 44) or (@transaccion = 98) or (@transaccion = 28) or  (@transaccion = 27)                
   begin                
    if (@transaccion = 28) or (@transaccion = 27)                
    begin                
     select @SecAccCode ='00-44'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-09'  
       
     exec insertacontable @SecAccCode,@operacion, @MontoBs, 0, @MontoDivisa, 0, '', '', ''                
    end                
    else                
    begin                
     select @SecAccCode ='00-44'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-01'                
       
     exec insertacontable @SecAccCode,@operacion, @MontoBs, 0, @MontoDivisa, 0, '', '', ''                
    end                
   end                
  
   if @transaccion = 49                
   begin                
    select @SecAccCode ='00-44'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-09'  
  
    exec insertacontable @SecAccCode,@operacion, @MontoBs, 0, @MontoDivisa, 0, '', '', ''                
   end                
     
   if @transaccion = 46                
   begin                
    select @SecAccCode ='00-83'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000000-01'  
      
    exec insertacontable @SecAccCode,@operacion, @MontoBs, 0, @MontoDivisa, 0, '', '', ''                
   end                
  
   if @transaccion = 6                
   begin             
    select @SecAccCode ='00-06'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-01'  
  
    exec insertacontable @SecAccCode,@operacion, @MontoBs, 0, @MontoDivisa, 0, '', '', ''                
  
   end                
  
   delete cierrediario where (fecha = convert(varchar(10),@fecha,103)) and (CodAgencia = @agencia) and (CodTransaccion = @transaccion) and (Tipo = 'E') and (Divisa = @divisa)  
  
   if  @@error <>0                
   begin                
    rollback transaction @tranname                
    RETURN                
   end                
              
   insert into cierrediario   
   (Fecha, CodAgencia, CodTransaccion, Tipo,  Divisa, MontoDivisa, MontoBs)   
   values   
   (convert(varchar(10),@fecha,103),@agencia, @transaccion, 'E', @divisa, @MontoDivisa, @MontoBs)                
     
   if  @@error <>0                
   begin                
    rollback transaction @tranname                
    RETURN                
   end                
     
   insert into replica (CodAgencia, SqlText, Status) values (1, 'insert into cierrediario (Fecha, CodAgencia, CodTransaccion, Tipo, Divisa, MontoDivisa,MontoBs) values ('''+  
   +convert(varchar(10),@fecha,103)+''','+convert(varchar,@agencia)+', '+convert(varchar,@transaccion)+', ''E'','''+@divisa+''', '+convert(varchar,@MontoDivisa)+','+convert(varchar,@MontoBs)+')','N')   
  
   if  @@error <>0                
   begin                
    rollback transaction @tranname                
    
    RETURN                
   end                
  end                
  
  fetch next from tabla                
  into @transaccion, @divisa, @MontoBs, @MontoDivisa                            
 end                
end                
close tabla                
deallocate tabla                
              
declare tabla cursor                
for                
Select a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, SUM(a.total) as                
'MontoBs', SUM(b.Monto) as 'MontoDivisa', b.estado, b.endosable, c.codigo                
from movimien a, movbanco b, cuenbanc c                
where (a.operacion = b.operacion)                
and (a.estado = 'C')                
and (b.codbanco = c.codbanco)                
and (b.codcuenta = c.codcuenta)                
and (c.divisa  in ('35','44'))               
and (a.estado <> 'R')                
and (a.CodTransaccion = 41)                
and (a.codagencia = @agencia)                
and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
group by a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, b.estado,                
b.endosable, c.codigo                
order by a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, b.estado,                
b.endosable, c.codigo                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @transaccion, @codbanco, @codcuenta, @divisa, @MontoBs, @MontoDivisa,                
  @estado, @motivo, @codigo                
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    delete cierrediariobancos where (fecha = convert(varchar(10),@fecha,103))                
    and (CodAgencia = @agencia) and (CodTransaccion = @transaccion) and (Tipo =  @estado) and (codbanco = @codbanco) and (codcuenta = @codcuenta) and (Divisa  = @divisa) and (motivo = @motivo)  
      
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into cierrediariobancos (Fecha, CodAgencia, CodTransaccion, Tipo,codbanco, codcuenta, Divisa, Motivo, MontoDivisa, MontoBs)   
    values   
    (convert(varchar(10),@fecha,103), @agencia, @transaccion, @estado,@codbanco, @codcuenta, @divisa, @motivo, @MontoDivisa, @MontoBs)                
  
    if  @@error <>0                
    begin     
     rollback transaction @tranname                
       
     RETURN                
    end  
  
    insert into replica (CodAgencia, SqlText, Status) values (1, 'insert into cierrediariobancos (Fecha, CodAgencia, CodTransaccion, Tipo, codbanco,codcuenta, Divisa, Motivo, MontoDivisa, MontoBs) values('''+convert(varchar(10),@fecha,103)+''', '+convert
(varchar,@agencia)+','+convert(varchar,@transaccion)+', '''+@estado+''','+convert(varchar(6),@codbanco)+', '''+@codcuenta+''', '''+@divisa+''','+char(39)+isnull(@motivo,'')+char(39)+','+convert(varchar,@MontoDivisa)+', '+convert(varchar,@MontoBs)+')','N')
      
  
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @transaccion, @codbanco, @codcuenta, @divisa, @MontoBs, @MontoDivisa,  @estado, @motivo, @codigo                
  end                
 end                
  
close tabla                
deallocate tabla                
  
  
declare tabla cursor                
for                
 Select a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, SUM(a.total) as                
 'MontoBs', SUM(b.Monto) as 'MontoDivisa', b.estado, c.codigo                
 from movimien a, movbanco b, cuenbanc c                
 where (a.operacion = b.operacion)                
 and (a.estado = 'C')                
 and (b.codbanco = c.codbanco)                
 and (b.codcuenta = c.codcuenta)                
 and (c.divisa not in ('35','44'))               
 and (a.estado <> 'R')                
 and (a.CodTransaccion = 33)                
 and (b.estado in ('I','A'))                
 and (a.codagencia = @agencia)                
 and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
group by a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, b.estado,c.codigo                
order by a.CodTransaccion, b.codbanco, b.codcuenta, c.divisa, b.estado,c.codigo                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @transaccion, @codbanco, @codcuenta, @divisa, @MontoBs, @MontoDivisa,  @estado, @codigo                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    delete cierrediariobancos where (fecha = convert(varchar(10),@fecha,103))                
    and (CodAgencia = @agencia) and (CodTransaccion = @transaccion)   
    and (Tipo = @estado) and (codbanco = @codbanco) and (codcuenta = @codcuenta)   
    and (Divisa = @divisa)                
  
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into cierrediariobancos (Fecha, CodAgencia, CodTransaccion, Tipo,codbanco, codcuenta, Divisa, MontoDivisa, MontoBs)   
    values (convert(varchar(10),@fecha,103), @agencia, @transaccion, @estado,@codbanco, @codcuenta, @divisa, @MontoDivisa, @MontoBs)  
      
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
      
    insert into replica (CodAgencia, SqlText, Status) values (1, 'insert into cierrediariobancos (Fecha, CodAgencia, CodTransaccion, Tipo, codbanco,codcuenta, Divisa, MontoDivisa, MontoBs) values('''+convert(varchar(10),@fecha,103)+''', '+convert(varchar,
@agencia)+','+convert(varchar,@transaccion)+', '''+@estado+''','+convert(varchar(6),@codbanco)+', '''+@codcuenta+''', '''+@divisa+''','+convert(varchar,@MontoDivisa)+', '+convert(varchar,@MontoBs)+')','N')                
  
    if  @@error <>0                
    begin                
       
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla     
   into @transaccion, @codbanco, @codcuenta, @divisa, @MontoBs, @MontoDivisa, @estado, @codigo  
     
   end                
     
  end                
  
close tabla                
deallocate tabla                
               
              
declare tabla cursor                
for                
 Select b.Divisa, SUM(b.MontoBs) as 'MontoBs', SUM(b.MontoDivisa) as 'MontoDivisa'                
 from movimien a, movdivisa b                
 where (a.operacion = b.operacion) and (a.estado = 'C')                
 and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
 and (a.CodTransaccion = 25)                
 and (b.Debito > 0)                
 and (b.CodTipo = 1)                
 and (b.Divisa not in ('35','44'))                
 and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
 group by b.Divisa                
 order by b.Divisa                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @divisa, @MontoBs, @MontoDivisa                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    select @SecAccCode ='00-43'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-09'                
  
    exec insertacontable @SecAccCode, @operacion, 0,@MontoBs, 0, @MontoDivisa, '', '', ''                
      
    delete cierrediario where (fecha = convert(varchar(10),@fecha,103))   
    and (CodAgencia = @agencia) and (CodTransaccion = 25) and (Tipo = 'E') and (Divisa = @divisa)                
              
    if  @@error <>0                
    begin                
       
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into cierrediario (Fecha, CodAgencia, CodTransaccion, Tipo,Divisa, MontoDivisa, MontoBs) values (convert(varchar(10),@fecha,103),@agencia, 25, 'E', @divisa, @MontoDivisa, @MontoBs)                
  
    if  @@error <>0                
    begin                
       
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into replica (CodAgencia, SqlText, Status) values (1, 'insert into cierrediario (Fecha, CodAgencia, CodTransaccion, Tipo, Divisa, MontoDivisa,MontoBs) values ('''+convert(varchar(10),@fecha,103)+''','+convert(varchar,@agencia)+', 25, ''E'', ''
'+@divisa+''','+convert(varchar,@MontoDivisa)+', '+convert(varchar,@MontoBs)+')','N')                
  
    if  @@error <>0                
    begin                
  
     rollback transaction @tranname                
  
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @divisa, @MontoBs, @MontoDivisa                
     
  end                
 end                
  
close tabla                
deallocate tabla                
  
  
declare tabla cursor                
for                
 Select b.Divisa, SUM(b.MontoBs) as 'MontoBs', SUM(b.MontoDivisa) as 'MontoDivisa'                
 from movimien a, movdivisa b                
 where (a.operacion = b.operacion) and (a.estado = 'C')                
 and (a.CodUsuario NOT LIKE '%CAJAPRINCIPAL%')                
 and (a.CodTransaccion = 25)                
 and (b.credito > 0)                
 and (b.CodTipo = 1)                
 and (b.Divisa not in ('35','44'))                
 and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
 group by b.Divisa                
 order by b.Divisa                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @divisa, @MontoBs, @MontoDivisa                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    select @SecAccCode ='00-44'+REPLACE(space(4-len(convert(varchar(4),convert(int,@divisa))))+convert(varchar(4),convert(int,@divisa)),' ','0')+'000100-09'                
  
    exec insertacontable @SecAccCode, @operacion,@MontoBs, 0, @MontoDivisa, 0, '', '', ''                
      
    delete cierrediario where (fecha = convert(varchar(10),@fecha,103))   
    and (CodAgencia = @agencia) and (CodTransaccion = 25) and (Tipo = 'S') and                
    (Divisa = @divisa)                
  
    if  @@error <>0                
    begin                
  
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into cierrediario (Fecha, CodAgencia, CodTransaccion, Tipo, Divisa, MontoDivisa, MontoBs) values (convert(varchar(10),@fecha,103),  @agencia, 25, 'S', @divisa, @MontoDivisa, @MontoBs)                
  
    if  @@error <>0                
    begin                
       
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    insert into replica (CodAgencia, SqlText, Status) values (1, 'insert into cierrediario (Fecha, CodAgencia, CodTransaccion, Tipo, Divisa, MontoDivisa,MontoBs) values ('''+convert(varchar(10),@fecha,103)+''','+convert(varchar,@agencia)+', 25, ''S'', '''
+@divisa+''', '+convert(varchar,@MontoDivisa)+','+convert(varchar,@MontoBs)+')','N')                
  
    if  @@error <>0                
    begin                
  
     rollback transaction @tranname                
  
     RETURN                
    end                
   end                
  
   fetch next from tabla                
   into @divisa, @MontoBs, @MontoDivisa                
  end                
 end                
  
close tabla                
deallocate tabla                
  
                           
declare tabla cursor                
for                
 Select a.NroCheque, count(a.operacion) as 'cantidad' from worldlink a,                
 movimien b                
 where (a.operacion = b.operacion) and (b.estado <> 'R') and (b.codtransaccion = 95)                
 and (DATEDIFF(dd,@fecha,a.Fecha) = 0)                
 and (a.operacion in (Select operacion from enlaces where operacion = a.operacion))  
group by NroCheque                
order by NroCheque                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @nrocheque, @cantidad                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    select @SecAccCode = '00-920000000000-01'                
      
    set @nrocheque = isnull(@nrocheque,'')               
              
    exec insertacontable @SecAccCode, @operacion, 0, 0,0, @cantidad, @nrocheque, '', ''                
  
    select @SecAccCode = '00-920000000000-02'                
  
    exec insertacontable @SecAccCode, @operacion, 0, 0,@cantidad, 0, @nrocheque, '', ''                
   end                
     
   fetch next from tabla                
   into @nrocheque, @cantidad                
  end                
 end                
  
close tabla                
deallocate tabla                
              
  
              
if @contabilidad = 'SI'                
begin                
    
    update mov_cuentas              
    set referencia = operacion              
    where len(referencia) = 0              
    and operacion in (select operacion from movimien where codagencia <> 98 and Estado <> 'R'               
    and DATEDIFF(dd,CONVERT(datetime,convert(varchar, convert(datetime, convert(varchar,@fecha)),101)),Fecha) =0 )              
    
declare tabla cursor                
for                
    
    Select a.Cuenta, ROUND(SUM(a.Debito),2) as Debito,  
 B.CODAGENCIA as Agencia, isnull(a.RefeDoc,'') as RefeDoc, a.TipoTransacc,  
 ROUND(SUM(a.DebitoPiezas),2) as DebitoPiezas,  
 substring((isnull(c.nomtransaccion,'') + ' - ' + isnull(a.referencia,'')),1,230) as NomTransaccion  
 from mov_cuentas a  
 INNER JOIN Movimien b ON (a.operacion = b.operacion)  
 LEFT OUTER JOIN transacc c ON (c.codtransaccion=b.codtransaccion)  
 where (a.Debito > 0) and (b.Estado <> 'R')  
 and (DATEDIFF(dd,CONVERT(datetime,convert(varchar, convert(datetime,convert(varchar,@fecha)),101)),b.Fecha) =0)  
 group by b.codagencia, a.Cuenta, a.RefeDoc, a.TipoTransacc, c.nomtransaccion, a.referencia                
 order by a.cuenta                
              
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @AccCode,@BsDebit,@OffiCode,@RefDoc,@TipoTran,@PiezasDebit,@longdesc                
    
  while (@@fetch_status <> -1)                
  begin                
     
   if (@@fetch_status <> -2)                
   begin                
     
   If Len(@OffiCode) = 1                
   select @OffiCode = '0' + @OffiCode--Codigo introducido por Alexander                
  
   select @indice = @indice + 1                
  
   select @index = substring(@Officode+substring(convert(varchar(8),@fecha,12),5,2)+substring(convert(varchar(8),@fecha,12),3,2)+  
   +substring(convert(varchar(8),@fecha,12),1,2)+REPLACE(space(6-len(convert(varchar(6),@indice)))+  
   +convert(varchar(6),@indice),' ','0'),1, 20)                
  
   select @vcode = substring(@Officode+substring(convert(varchar(8),@fecha,112),7,2)+substring(convert(varchar(8),@fecha,112),5,2)+  
   +substring(convert(varchar(8),@fecha,112),1,4)+'1',1,11)                
  
   Delete Comprobantes where indice = @index                
  
   if  @@error <>0                
   begin                
    rollback transaction @tranname                
  
    RETURN                
   end                
  
   Insert Comprobantes(Indice,VouchCode,AccCode,BsDebit,BsCredit,TransDate,RegName,RefDoc,TipoTran,Status,OffiCode,PiezasDebit,PiezasCredit,LongDesc)                
   values(@index,@vcode,@AccCode,@BsDebit,0,convert(int,convert(varchar,@fecha,112)),@regname,@RefDoc,@TipoTran,@Status,@OffiCode,@PiezasDebit,0,@LongDesc)                
  
   if  @@error <>0                
   begin                
     rollback transaction @tranname                
       
     RETURN                
   end                
              
   insert into replica (codagencia, sqltext, status)   
   values (208, 'Insert Comprobantes(Indice,VouchCode,AccCode,BsDebit,BsCredit,TransDate,RegName,RefDoc,TipoTran,Status,OffiCode,PiezasDebit,PiezasCredit,LongDesc)  values('''+  
   +@index+''','''+@vcode+''','''+@AccCode+''','+convert(varchar,@BsDebit)+',0,'+convert(varchar,convert(int,convert(varchar,@fecha,112)))+','''+@regname+''','''+@RefDoc+''','''+  
   +@TipoTran+''','''+@Status+''','''+@OffiCode+''','+convert(varchar,@PiezasDebit)+',0,'''+@LongDesc+''')', 'N')      
  
   if  @@error <>0                
   begin                
    rollback transaction @tranname                
  
    RETURN                
   end                          
   end                
   fetch next from tabla                
   into @AccCode,@BsDebit,@OffiCode,@RefDoc,@TipoTran,@PiezasDebit,@longdesc                
  end                
 end                
close tabla                
deallocate tabla                
              
select @BsDebit = 0                
select @BsCredit = 0                
select @PiezasDebit = 0                
select @PiezasCredit = 0                
  
declare tabla cursor                
for                
 Select a.Cuenta, ROUND(SUM(a.credito),2) as Credito,                
 b.codagencia AS Agencia, isnull(a.RefeDoc,'') as RefeDoc, a.TipoTransacc,                
 ROUND(SUM(a.CreditoPiezas),2) as CreditoPiezas, substring((isnull(c.nomtransaccion,'') + ' - ' + isnull(a.referencia,'')),1,230) as NomTransaccion    
 from mov_cuentas a   
 inner join Movimien b on (a.operacion = b.operacion)  
 left outer join transacc c on (c.codtransaccion=b.codtransaccion)                
 where (a.Credito > 0) and (b.Estado <> 'R')                            
 and (DATEDIFF(dd,CONVERT(datetime,convert(varchar, convert(datetime,convert(varchar,@fecha)),101)),b.Fecha) = 0)  
 group by b.codagencia, a.Cuenta, a.RefeDoc, a.TipoTransacc, c.nomtransaccion, a.referencia                
 order by a.cuenta                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @AccCode,@BsCredit,@OffiCode,@RefDoc,@TipoTran,@PiezasCredit,@longdesc                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    If Len(@OffiCode) = 1                
    select @OffiCode = '0' + @OffiCode--Codigo introducido por Alexander                
      
    select @indice = @indice + 1                
  
    select @index = substring(@Officode+substring(convert(varchar(8),@fecha,12),5,2)+substring(convert(varchar(8),@fecha,12),3,2)+  
    +substring(convert(varchar(8),@fecha,12),1,2)+REPLACE(space(6-len(convert(varchar(6),@indice)))+convert(varchar(6),@indice),' ','0'),1, 20)  
  
    select @vcode = substring(@Officode+substring(convert(varchar(8),@fecha,112),7,2)+substring(convert(varchar(8),@fecha,112),5,2)+  
    +substring(convert(varchar(8),@fecha,112),1,4)+'1',1,11)                
  
    Delete Comprobantes where indice = @index                
  
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
  
     RETURN                
    end                
  
    Insert into Comprobantes                
    (Indice,VouchCode,AccCode,BsDebit,BsCredit,TransDate,RegName,RefDoc,TipoTran,Status,OffiCode,PiezasDebit,PiezasCredit,LongDesc)                
    values (@index,@vcode,@AccCode,0,@BsCredit,convert(int,convert(varchar,@fecha,112)),@regname,@RefDoc,@TipoTran,@status,@OffiCode,0,@PiezasCredit,@LongDesc)  
  
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
  
     RETURN                
    end                
      
    insert into replica (codagencia, sqltext, status) values (208, 'Insert Comprobantes(Indice,VouchCode,AccCode,BsDebit,BsCredit,TransDate,RegName,RefDoc,TipoTran,Status,OffiCode,PiezasDebit,PiezasCredit,LongDesc)values('''+  
    +@index+''','''+@vcode+''','''+@AccCode+''',0,'+convert(varchar,isnull(@BsCredit,0))+','+convert(varchar,convert(int,convert(varchar,@fecha,112)))+','''+@regname+''','''+isnull(@RefDoc,0)+''','''+isnull(@TipoTran,0)+''','''+  
    +@Status+''','''+@OffiCode+''',0,'+convert(varchar,isnull(@PiezasCredit,0))+','''+@LongDesc+''')', 'N')  
              
    if  @@error <>0                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @AccCode,@BsCredit,@OffiCode,@RefDoc,@TipoTran,@PiezasCredit,@longdesc               
  end  
 end                
close tabla                
deallocate tabla                
              
end                
              
              
if (@TotalDebito - @TotalCredito) >= 0                
begin                
  
    delete movdivisa where (operacion = @operacion) and (CodTipo = 1) and (Divisa = '35')                
  
    if  @@error <>0                
    begin                
        rollback transaction @tranname                
        RETURN                
    end                
  
    insert MovDivisa (Operacion, CodTipo, Divisa, MontoDivisa, TasaCambio, MontoBs, TasaRef, FixingRef, Debito, Credito)  
    values (@operacion, 1, '35', @TotalDebito - @TotalCredito, 1,@TotalDebito - @TotalCredito, 1, 1, @TotalDebito - @TotalCredito, 0)  
  
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
  
        RETURN                
 end                
end                
else                
begin                
 delete movdivisa where (operacion = @operacion) and (CodTipo = 1) and (Divisa = '35')                
  
 if  @@error <>0                
 begin         
  rollback transaction @tranname                
  
  RETURN                
 end                
  
 insert MovDivisa (Operacion, CodTipo, Divisa, MontoDivisa, TasaCambio, MontoBs, TasaRef, FixingRef, Debito, Credito)  
 values (@operacion, 1, '35', @TotalCredito - @TotalDebito, 1,  @TotalCredito - @TotalDebito, 1, 1, 0, @TotalCredito - @TotalDebito)  
  
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
  
  RETURN                
 end                
end                
              
-- // */* /*/* /*/*/ */*/*/*/ CODIGO AGREGADO PARA EVITAR QUE ENTRE EN CONTABILIDAD              
              
-- // LAS OPERACIONES TRASPASOS CR              
            
insert into tblxpos            
select  p.Operacion, p.CodTipo, p.Divisa, p.MontoDivisa, p.TasaCambio, p.MontoBs, p.TasaRef, p.FixingRef,            
 p.Fecha, p.CodUsuario, p.CodUsuarioRec, p.CodAgencia, p.CodTransaccion, p.Estado, p.Cantidad             
from  tblxpens t            
inner join movimien m on (m.operacion = t.operacion)              
inner join posicion p on (p.operacion = m.operacion)            
left outer join tblxpos tp on (t.operacion = tp.operacion)            
where tp.operacion is null            
            
delete posicion             
from  tblxpens t            
inner join movimien m on (m.operacion = t.operacion)              
inner join posicion p on (p.operacion = m.operacion)            
inner join tblxpos tp on (t.operacion = tp.operacion)            
              
update movimien set estado='R' from infsharedcr i, movimien m where               
m.operacion=i.operacion and i.estado<>'R' and datediff(dd,m.fecha,@fecha)=0           
              
--UPDATE MOVIMIEN SET ESTADO='R' FROM TRASPASOSCR C, MOVIMIEN M WHERE M.OPERACION=C.OPERACION              
-- // */* /*/* /*/*/ */*/*/*/ CODIGO AGREGADO PARA EVITAR QUE ENTRE EN CONTABILIDAD              
-- // LAS OPERACIONES TRASPASOS CR              
  
  
declare tabla cursor                
for                
select a.Operacion, a.Posicion, a.coddivisa, a.tasacambio, a.prefijo,                
a.serialinicial, a.cantidad, a.denominacion, a.vendedorId, a.status,                
a.fecha, a.servicio, isnull(a.codautoriz,' ') as codautoriz                
from american a, travel t                
where (DATEDIFF(dd,@fecha,a.Fecha) = 0) and (a.operacion=t.operacion) and                
(t.estado='V')                
open tabla                
if @@cursor_rows <> 0                
begin                
fetch next from tabla                
into @OperAmerican, @Posicion, @coddivisa, @tasacambio, @prefijo,                
@serialinicial, @CantidadAmerican, @denominacionAmerican, @vendedorId,                
@statusamerican, @fechaamerican, @servicio, @codautoriz                
while (@@fetch_status <> -1)                
begin                
if (@@fetch_status <> -2)                
begin                
   
 exec @reterror=insamericanA @OperAmerican, @Posicion, @coddivisa,                
 @tasacambio, @prefijo, @serialinicial, @CantidadAmerican,                
 @denominacionAmerican, @vendedorId, @statusamerican, @fechaamerican,                
 @servicio, @codautoriz                
  
 if @reterror=-2                
 begin                
  rollback transaction @tranname                
  
  RETURN                
 end                
              
end                
fetch next from tabla                
into @OperAmerican, @Posicion, @coddivisa, @tasacambio, @prefijo,                
@serialinicial, @CantidadAmerican, @denominacionAmerican, @vendedorId,                
@statusamerican, @fechaamerican, @servicio, @codautoriz                
end                
end                
close tabla                
deallocate tabla                
  
  
declare tabla cursor                
for                
select Operacion, Posicion, coddivisa, tasacambio, serialinicial, cantidad,                
denominacion, vendedorId, status, fecha from citicorp                
where (DATEDIFF(dd,@fecha,Fecha) = 0)                open tabla                
if @@cursor_rows <> 0                
begin                
fetch next from tabla                
into @OperCiticorp, @PosicionCiticorp, @coddivisaciticorp,                
@tasacambiociticorp, @serialinicialciticorp, @CantidadCiticorp,                
@denominacionciticorp, @vendedorIdciticorp, @statusciticorp, @fechaciticorp                
while (@@fetch_status <> -1)                
begin                
if (@@fetch_status <> -2)                
begin                
exec @reterror=insciticorpA @OperCiticorp, @PosicionCiticorp,                
@serialinicialciticorp, @CantidadCiticorp, @vendedorIdciticorp,                
@denominacionciticorp, @coddivisaciticorp, @tasacambiociticorp,                
@statusciticorp, @fechaciticorp                
  
 if @reterror=-2                
 begin                
  rollback transaction @tranname                
  
  RETURN                
 end                
end                
  
fetch next from tabla                
into @OperCiticorp, @PosicionCiticorp, @coddivisaciticorp,                
@tasacambiociticorp, @serialinicialciticorp, @CantidadCiticorp,                
@denominacionciticorp, @vendedorIdciticorp, @statusciticorp, @fechaciticorp                
end                
end                
close tabla                
deallocate tabla                
  
declare tabla cursor                
for                
select Operacion, posicion, prefijo, serialinicial, cantidad, vendedorId,                
denominacion, coddivisa, tasacambio, fecha, isnull(status,'') as status from                
Thomascook                
where (DATEDIFF(dd,@fecha,Fecha) = 0)                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @OperacionThomas, @posicionThomas, @prefijoThomas,                
  @serialinicialThomas, @cantidadThomas, @vendedorIdThomas,                
  @denominacionThomas, @coddivisaThomas, @tasacambioThomas, @fechaThomas,                
  @statusthomas                            
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
    exec @reterror=insThomasC @OperacionThomas, @posicionThomas,                
    @prefijoThomas, @serialinicialThomas, @cantidadThomas, @vendedorIdThomas,                
    @denominacionThomas, @coddivisaThomas, @tasacambioThomas, @fechaThomas,                
    @statusthomas                
      
    if @reterror=-2                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @OperacionThomas, @posicionThomas, @prefijoThomas,                
   @serialinicialThomas, @cantidadThomas, @vendedorIdThomas,                
   @denominacionThomas, @coddivisaThomas, @tasacambioThomas, @fechaThomas,                
   @statusthomas                
  end                
 end                
close tabla                
deallocate tabla                
  
  
declare tabla cursor                
for                
 select a.Divisa, SUM(a.Monto) as 'monto'                
 from invdiv a where a.codusuario not like '%CAJAPRINCIPAL%'                
 group by a.divisa                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @Divisa, @Monto                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    exec @reterror=insinventariosA @Operacion, @Divisa, @Monto                
      
    if @reterror=-2                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @Divisa, @Monto                
  end         
 end                
close tabla                            
deallocate tabla  
  
  
 insert into replica (CodAgencia, SqlText, status) values (1, 'insert into cierreconsolidado (fecha, codagencia, status)values('''+convert(varchar(10),@fecha,103)+''','+convert(varchar(3),@agencia)+', ''C'')', 'N')                
                           
 if  @@error <>0                
 begin                
  rollback transaction @tranname                
    
  RETURN                
 end                
  
declare tabla cursor                
for                
 --Modificado el 18/08/2004 para que repliquen las operaciones de Envio cuando pasen por Caja              
 select e.OPERACION, OPERACIONCIERRE, e.AUXILIAR, FORMA_ENVIO, TIPO_ENVIO, CANTIDAD,               
 PESO_REAL, PESO_DIM, DESCRIPCION, VALOR_SEGURO, VALOR_ADUANA, REFERENCIA1,               
 isnull(REFERENCIA2,' ') as REFERENCIA2, isnull(PAIS_ORIGEN,'')as PAIS_ORIGEN, isnull(INSTRUCC_ESP,' ')              
 as INSTRUCC_ESP, FECHA_ENVIO,STATUS, MONTOUSA, MONTOBS, combustible, franqueo, iva ,Usuario                
 from envio_ups e, movimien m                 
 where e.operacioncierre = m.operacion               
 and datediff(dd,@fecha,m.fecha)=0                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @OPERACION, @OPERACIONCIERRE, @AUXILIAR, @FORMA_ENVIO, @TIPO_ENVIO,                
  @CANTIDAD, @PESO_REAL, @PESO_DIM, @DESCRIPCION, @VALOR_SEGURO,                
  @VALOR_ADUANA, @REFERENCIA1, @REFERENCIA2, @PAIS_ORIGEN, @INSTRUCC_ESP,                
  @FECHA_ENVIO, @STATUS, @MONTOUSA, @MONTOBS, @combustible, @franqueo, @iva,@USU                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
      
    exec @reterror=insenvioups @OPERACION, @OPERACIONCIERRE, @AUXILIAR,@FORMA_ENVIO, @TIPO_ENVIO, @CANTIDAD, @PESO_REAL, @PESO_DIM, @DESCRIPCION,                
    @VALOR_SEGURO, @VALOR_ADUANA, @REFERENCIA1, @REFERENCIA2, @PAIS_ORIGEN,@INSTRUCC_ESP, @FECHA_ENVIO, @STATUS, @MONTOUSA, @MONTOBS, @combustible, @franqueo, @iva,@USU                
      
    if @reterror=-2                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @OPERACION, @OPERACIONCIERRE, @AUXILIAR, @FORMA_ENVIO, @TIPO_ENVIO,                
   @CANTIDAD, @PESO_REAL, @PESO_DIM, @DESCRIPCION, @VALOR_SEGURO,                
   @VALOR_ADUANA, @REFERENCIA1, @REFERENCIA2, @PAIS_ORIGEN, @INSTRUCC_ESP,                
   @FECHA_ENVIO, @STATUS, @MONTOUSA, @MONTOBS, @combustible, @franqueo, @iva, @USU                
  end                
 end                
close tabla                
deallocate tabla                
               
              
declare tabla cursor                
for                
 select Operacion, Nro_Tarjeta, Tipo, CodBanco, isnull(FechaVencimiento,' '),                
 isnull(CodTipo,' '), Autorizacion, Monto, puntovta from tarjetas                
 where operacion in (select distinct operacion from movimien where                
 datediff(dd,getdate(),fecha)=0 and (estado='C'))                
open tabla                
 if @@cursor_rows <> 0                
 begin                
  fetch next from tabla                
  into @Operacion, @Nro_Tarjeta, @Tipo, @CodBanco, @FechaVencimiento,                
  @CodTipo, @Autorizacion, @Monto, @puntovta                
    
  while (@@fetch_status <> -1)                
  begin                
   if (@@fetch_status <> -2)                
   begin                
    exec @reterror=insTarjetas @Operacion, @Nro_Tarjeta, @Tipo, @CodBanco,                
    @FechaVencimiento, @CodTipo, @Autorizacion, @Monto, @puntovta                
      
    if @reterror=-2                
    begin                
     rollback transaction @tranname                
       
     RETURN                
    end                
   end                
     
   fetch next from tabla                
   into @Operacion, @Nro_Tarjeta, @Tipo, @CodBanco, @FechaVencimiento,                
   @CodTipo, @Autorizacion, @Monto, @puntovta                
  end                
 end                
close tabla                
deallocate tabla                
  
/*REPLICACION DE LAS DEVOLUCIONES DE ITALENCOMIENDAS DEL DIA*/              
              
DECLARE Env_Dev CURSOR FOR              
 select d.OperacionTaq,d.OperacionCaja,d.OperacionRefer,d.ComisionC,d.ComisionS              
 from devoluciones_mg d, movimien m               
 where datediff(dd,m.fecha,getdate())=0 and m.codtransaccion in ('78','525') and               
 m.operacion=d.OperacionCaja and m.estado<>'R'              
OPEN Env_Dev               
 FETCH NEXT FROM Env_Dev               
 INTO  @taq, @caja, @ref, @cc,@cs              
   
 WHILE @@FETCH_STATUS <> - 1               
 BEGIN               
  IF @@FETCH_STATUS <> - 2               
  BEGIN                  
     
   insert into replica (CodAgencia, SqlText, status)               
   values (1, 'insert into Devoluciones_mg (OperacionTaq, OperacionCaja, OperacionRefer,ComisionC,ComisionS) values('''+  
   +@Taq +''','''+ @caja+''','''+@ref+''','''+isnull(@cc,0)+''','''+isnull(@cs,0)+''')', 'N')  
  END               
    
  FETCH NEXT FROM Env_Dev               
  INTO  @taq, @caja, @ref, @cc,@cs              
 END              
CLOSE Env_Dev              
DEALLOCATE Env_Dev              
  
  
/*Planilla_CadiviEspecial*/              
declare tabla cursor              
for              
 select               
 p.Operacion, isnull(p.OperacionCierre,''), p.Auxiliar_Sol, p.Auxiliar_Benef, isnull(p.Nombre_Benef,''), isnull(p.Profesion,''), isnull(p.Dir_Benef,''),    
 isnull(p.Tlf_Benef,''), isnull(p.Mail_Benef,''), p.Auxiliar_Rep, isnull(p.Nombre_Rep,''), isnull(p.Dir_Rep,''), isnull(p.Tlf_Rep,''), p.Mail_Rep, isnull(p.Solicitud,''),    
 p.Cod_Seguridad, p.Usuario_Taq, isnull(p.Usuario_Ger, ''), isnull(p.Usuario_Italcadivi, ''), p.Fecha_Taq, isnull(p.Fecha_Ger, ''), isnull(p.Fecha_Italcadivi, ''),               
 isnull(p.Requisitos_Taq,''), isnull(p.Requisitos_Ger,''), isnull(p.Requisitos_Italcadivi,''), p.Status, p.CodAgencia, isnull(p.Fecha_enviocadivi,''),    
 isnull(p.Usuario_enviocadivi,''), p.tipo, isnull(p.Observacion,''), isnull(p.Email,''), p.Monto_Sol, p.divisa, p.montodivisa             
 from Planilla_CadiviEspecial p              
 inner join Movimien m on (m.operacion = p.operacioncierre)     
 where (datediff(dd,@fecha,m.fecha)= 0)    
 and ((Operacioncierre <> '') or (Operacioncierre is not  null))              
open tabla              
 if @@cursor_rows <> 0              
 begin              
  fetch next from tabla              
  into @Operacion, @OperacionCierre, @Auxiliar_Sol, @Auxiliar_Benef, @Nombre_Benef,               
  @Profesion, @Dir_Benef, @Tlf_Benef, @Mail_Benef, @Auxiliar_Rep, @Nombre_Rep,               
  @Dir_Rep, @Tlf_Rep, @Mail_Rep, @Solicitud, @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger,               
  @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger, @Fecha_Italcadivi, @Requisitos_Taq,               
  @Requisitos_Ger, @Requisitos_Italcadivi, @Status, @CodAgencia, @Fecha_enviocadivi,               
  @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol ,@divisa, @montodivisa             
  while (@@fetch_status <> -1)              
  begin             
   if (@@fetch_status <> -2)              
   begin              
    exec @reterror=Planilla_CadiviEspecialA @Operacion, @OperacionCierre, @Auxiliar_Sol, @Auxiliar_Benef,               
    @Nombre_Benef, @Profesion, @Dir_Benef, @Tlf_Benef, @Mail_Benef, @Auxiliar_Rep, @Nombre_Rep,               
    @Dir_Rep, @Tlf_Rep, @Mail_Rep, @Solicitud, @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger,               
    @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger, @Fecha_Italcadivi, @Requisitos_Taq,               
    @Requisitos_Ger, @Requisitos_Italcadivi, @Status, @CodAgencia, @Fecha_enviocadivi,               
    @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol, @divisa, @montodivisa               
      
    if @reterror=-2              
    begin              
     rollback transaction @tranname              
     RETURN              
    end              
   end              
   fetch next from tabla              
   into @Operacion, @OperacionCierre, @Auxiliar_Sol, @Auxiliar_Benef, @Nombre_Benef,               
   @Profesion, @Dir_Benef, @Tlf_Benef, @Mail_Benef, @Auxiliar_Rep, @Nombre_Rep,               
   @Dir_Rep, @Tlf_Rep, @Mail_Rep, @Solicitud, @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger,               
   @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger, @Fecha_Italcadivi, @Requisitos_Taq,               
   @Requisitos_Ger, @Requisitos_Italcadivi, @Status, @CodAgencia, @Fecha_enviocadivi,               
   @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol, @divisa, @montodivisa               
  end              
 end              
close tabla              
deallocate tabla              
              
              
-- CADIVI ESTUDIANTES                          
declare tabla cursor              
for              
 select p.Operacion, p.OperacionCierre, p.Auxiliar_Rep, p.Auxiliar_Est, p.Institucion,               
 p.Dir_Est, p.Ciudad_Est, p.Pais_Est, p.Tlf_Est, isnull(p.Fax_Est,''), p.Pasaporte_Est, p.Solicitud,               
 p.Cod_Seguridad, p.Usuario_Taq, p.Usuario_Ger, isnull(p.Usuario_Italcadivi,''), p.Fecha_Taq, p.Fecha_Ger,               
 isnull(p.Fecha_Italcadivi,''), p.Requisitos_Taq, p.Requisitos_Ger, isnull(p.Requisitos_Italcadivi,''),               
 p.Status, p.CodAgencia, isnull(p.Fecha_enviocadivi,''), isnull(p.Usuario_enviocadivi,''), p.tipo,               
 isnull(p.Universidad,''), p.AnoEstudia, isnull(p.email,''), p.monto_sol, p.divisa, p.montodivisa,isnull(p.frecuencia,''),isnull(p.CodAreaConoc,''),isnull(p.CodSubAreaConoc,''),isnull(p.AreaAdicional,''),isnull(p.ActividadAcad,'')     
 from planilla_cadivi p             
 inner join movimien m on (m.operacion = p.operacioncierre)    
 where     
 (datediff(dd,@fecha,m.fecha)= 0)        
 and ((p.Operacioncierre <> '') or (p.Operacioncierre is not  null))              
open tabla              
 if @@cursor_rows <> 0              
 begin              
  fetch next from tabla              
  into @Operacion, @OperacionCierre, @Auxiliar_Rep, @Auxiliar_Est, @Institucion,               
  @Dir_Est, @Ciudad_Est, @Pais_Est, @Tlf_Est, @Fax_Est, @Pasaporte_Est, @Solicitud,               
  @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger,               
  @Fecha_Italcadivi, @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi, @Status,               
  @CodAgencia, @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @universidad, @anoestudia,              
  @email, @monto_sol,@divisa, @montodivisa,@frecuencia,@CodAreaConoc, @CodSubAreaConoc,@AreaAdicional,@ActividadAcad            
  while (@@fetch_status <> -1)              
  begin              
   if (@@fetch_status <> -2)              
   begin              
    exec @reterror=planilla_cadiviA @Operacion, @OperacionCierre, @Auxiliar_Rep, @Auxiliar_Est, @Institucion,               
    @Dir_Est, @Ciudad_Est, @Pais_Est, @Tlf_Est, @Fax_Est, @Pasaporte_Est, @Solicitud,               
    @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger,               
    @Fecha_Italcadivi, @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi, @Status,               
    @CodAgencia, @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @universidad, @anoestudia,              
    @email, @monto_sol,@divisa, @montodivisa,@frecuencia,@CodAreaConoc, @CodSubAreaConoc,@AreaAdicional,@ActividadAcad             
      
    if @reterror=-2              
    begin              
     rollback transaction @tranname              
     RETURN              
    end      
   end              
     
   fetch next from tabla              
   into @Operacion, @OperacionCierre, @Auxiliar_Rep, @Auxiliar_Est, @Institucion,               
   @Dir_Est, @Ciudad_Est, @Pais_Est, @Tlf_Est, @Fax_Est, @Pasaporte_Est, @Solicitud,               
   @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger,               
   @Fecha_Italcadivi, @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi, @Status,               
   @CodAgencia, @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @universidad, @anoestudia,              
   @email, @monto_sol,@divisa, @montodivisa,@frecuencia,@CodAreaConoc, @CodSubAreaConoc,@AreaAdicional,@ActividadAcad              
  end              
 end              
close tabla              
deallocate tabla              
               
/*Planilla_Importaciones*/              
declare tabla cursor              
for             
 select               
 p.Operacion, isnull(p.OperacionCierre,''), p.Auxiliar, p.Actividad, isnull(p.Solicitud,''),         
 p.Cod_Seguridad, p.Usuario_Taq, isnull(p.Usuario_Ger, ''), isnull(p.Usuario_Italcadivi, ''),               
 p.Fecha_Taq, isnull(p.Fecha_Ger, ''), isnull(p.Fecha_Italcadivi, ''), isnull(p.Requisitos_Taq,''),               
 isnull(p.Requisitos_Ger,''), isnull(p.Requisitos_Italcadivi,''), p.Status, p.CodAgencia,               
 isnull(p.Fecha_enviocadivi,''), isnull(p.Usuario_enviocadivi,''), p.tipo, isnull(p.Observacion,''),              
 isnull(p.email,''), p.monto_sol, p.divisa, p.montodivisa               
 from Planilla_Importaciones p              
 inner join movimien m on (m.operacion = p.operacioncierre)    
 where     
 (datediff(dd,@fecha,m.fecha)= 0)               
 and ((p.Operacioncierre <> '') or (p.Operacioncierre is not  null))              
open tabla              
 if @@cursor_rows <> 0              
 begin              
  fetch next from tabla              
  into @Operacion, @OperacionCierre, @Auxiliar, @Actividad, @Solicitud, @Cod_Seguridad,               
  @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger,               
  @Fecha_Italcadivi, @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi, @Status,               
  @CodAgencia, @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol,@divisa, @montodivisa              
  while (@@fetch_status <> -1)              
  begin              
   if (@@fetch_status <> -2)              
   begin              
    exec @reterror=Planilla_ImportacionesA @Operacion, @OperacionCierre, @Auxiliar, @Actividad,               
    @Solicitud, @Cod_Seguridad, @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq,               
    @Fecha_Ger, @Fecha_Italcadivi, @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi,               
    @Status, @CodAgencia, @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol,@divisa, @montodivisa              
      
    if @reterror=-2              
    begin              
     rollback transaction @tranname              
     RETURN              
    end              
   end              
     
   fetch next from tabla              
   into @Operacion, @OperacionCierre, @Auxiliar, @Actividad, @Solicitud, @Cod_Seguridad,               
   @Usuario_Taq, @Usuario_Ger, @Usuario_Italcadivi, @Fecha_Taq, @Fecha_Ger, @Fecha_Italcadivi,               
   @Requisitos_Taq, @Requisitos_Ger, @Requisitos_Italcadivi, @Status, @CodAgencia,               
   @Fecha_enviocadivi, @Usuario_enviocadivi, @tipo, @Observacion, @email, @monto_sol,@divisa, @montodivisa              
  end              
 end              
close tabla              
deallocate tabla              
               
/*Remesas_Familiares*/              
  
declare tabla cursor              
for              
 select               
 Operacion,isnull(OperacionCierre,''), AuxiliarSol, AuxiliarBenef,               
 Beneficiario, Parantesco, Dir_Benef, Ciudad_Benef, Pais_Benef, isnull(Registro,''),               
 isnull(Solicitud,''), Cod_Seguridad, Usuario_Taq, isnull(Usuario_Ger, ''),               
 isnull(Usuario_Italcadivi, ''), Fecha_Taq, isnull(Fecha_Ger, ''),               
 isnull(Fecha_Italcadivi, ''), isnull(Requisitos_Taq,''), isnull(Requisitos_Ger,''),               
 isnull(Requisitos_Italcadivi,''),Status,CodAgencia,isnull(Fecha_enviocadivi,''),               
 isnull(Usuario_enviocadivi,''),isnull(Observacion,''),isnull(email,''),Monto_Sol              
 from Remesas_Familiares              
 where (DATEDIFF(dd,@fecha,Fecha_Ger) = 0)              
 and ((Operacioncierre <> '') or (Operacioncierre is not  null))              
open tabla              
 if @@cursor_rows <> 0              
 begin              
  fetch next from tabla              
  into @Operacion,@OperacionCierre,@Auxiliar_Sol,@Auxiliar_Benef,@Nombre_Benef,@Parantesco,              
  @Dir_Benef,@Ciudad_Est,@Pais_Est,@Registro,@Solicitud,@Cod_Seguridad,@Usuario_Taq,              
  @Usuario_Ger,@Usuario_Italcadivi,@Fecha_Taq,@Fecha_Ger,@Fecha_Italcadivi,@Requisitos_Taq,              
  @Requisitos_Ger,@Requisitos_Italcadivi,@Status,@CodAgencia,@Fecha_enviocadivi,              
  @Usuario_enviocadivi,@Observacion,@email,@monto_sol              
  while (@@fetch_status <> -1)              
  begin              
   if (@@fetch_status <> -2)              
   begin              
    exec @reterror=Remesas_FamiliaresA @Operacion,@OperacionCierre,@Auxiliar_Sol,@Auxiliar_Benef,               
    @Nombre_Benef,@Parantesco,@Dir_Benef,@Ciudad_Est,@Pais_Est,@Registro,@Solicitud,               
    @Cod_Seguridad,@Usuario_Taq,@Usuario_Ger,@Usuario_Italcadivi,@Fecha_Taq,@Fecha_Ger,               
    @Fecha_Italcadivi,@Requisitos_Taq,@Requisitos_Ger,@Requisitos_Italcadivi,@Status,@CodAgencia,               
    @Fecha_enviocadivi,@Usuario_enviocadivi,@Observacion,@email,@monto_sol              
      
    if @reterror=-2              
    begin              
     rollback transaction @tranname              
     RETURN              
    end              
   end              
   fetch next from tabla              
   into @Operacion,@OperacionCierre,@Auxiliar_Sol,@Auxiliar_Benef,@Nombre_Benef,@Parantesco,              
   @Dir_Benef,@Ciudad_Est,@Pais_Est,@Registro,@Solicitud,@Cod_Seguridad,@Usuario_Taq,              
   @Usuario_Ger,@Usuario_Italcadivi,@Fecha_Taq,@Fecha_Ger,@Fecha_Italcadivi,@Requisitos_Taq,              
   @Requisitos_Ger,@Requisitos_Italcadivi,@Status,@CodAgencia,@Fecha_enviocadivi,              
   @Usuario_enviocadivi,@Observacion,@email,@monto_sol              
  end              
 end              
close tabla              
deallocate tabla              
    

-- INICIO MODIFICACION PARA POSICION DE REMESAS CIERRE DE AGENCIA 05-05-2014

  DECLARE @AGENCIACIERRE INT                 
  DECLARE @FECHACIERREPOS varchar(20)  
  SET @FECHACIERREPOS = CONVERT(varchar,GETDATE())  
  SELECT @AGENCIACIERRE = VALOR FROM PARAMETROS WHERE CLAVE = 'AGENCIA'
  
  EXEC uSpPosicionRemesas @AGENCIACIERRE,1, @FECHACIERREPOS  
  --                                     ^ parametro del usp

-- FIN MODIFICACION PARA POSICION DE REMESAS CIERRE DE AGENCIA 05-05-2014



              
DECLARE @ERROR INT                
              
EXEC @ERROR = OPERMOVIMIEN @FECHA                
              
if @ERROR <> 0                
BEGIN                
 rollback transaction @tranname                
  
 RETURN                
END                
  
commit transaction @tranname                
  
RETURN                

  