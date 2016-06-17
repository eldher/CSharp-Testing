 CREATE procedure [dbo].[countnow]                
                
as                
                
/*              
 ---- **** ----- MARCOS CORTEZ 14-01-2011 AGREGO LAS TRANSACCIONES DE TITAN A LA POSICION              
       CAEN EN LAS VARIABLES DE LA TRANSACCION 66 SUMADAS               
       A LOS MONEYGYRAM Y PASAN TODAS EN CONJUNTO A SER              
       ENCOMIENDAS ELECTRONICAS              
              
09/05/2011*** DENNIS USECHE COMPLETO EL PROCESO AGREGANDO CAMBIAMOS  Y PROVIDENCIAL             
27/06/2011*** DENNIS USECHE AGREGA LAS TRANSACCIONES DE TRANSFAST                  
16/07/2013*** KAREN TROMPETERO AGREGA LAS TRANSACCIONES DE MAGUIEXPRESS                  
              
              
declare @cerrado integer                 
declare @datetoday datetime                
               
select               
   @datetoday = convert(datetime,substring(valor,4,2)+'/'+substring(valor,1,2)+'/'+substring(valor,7,4))                  
from               
   parametros                
where               
   clave = 'fecha'                
                
              
select               
   @cerrado = count(operacion)               
from               
   movimien               
where                  
   estado <> 'R' and codtransaccion = 83                 
   and (DATEDIFF(dd,@datetoday,Fecha) = 0)                 
              
if @cerrado > 0                 
begin                  
   return                
end*/                
                
declare @ag int                
declare @fecha int                
declare @tran int                
declare @tipo int                
declare @oper int                
declare @valu money                
declare @tasa money                
declare @boli money                
declare @divi varchar(3)                
declare @stat varchar(20)                
declare @Umonto_43_1 money                 
declare @Utasa_43_1 money                 
declare @Uoper_43_1 money                 
declare @Umonto_44_1 money                 
declare @Utasa_44_1 money                 
declare @Uoper_44_1 money                 
declare @Umonto_43_2 money                 
declare @Utasa_43_2 money                  
declare @Uoper_43_2 money                  
declare @Umonto_44_2 money                  
declare @Utasa_44_2 money                   
declare @Uoper_44_2 money                   
declare @Umonto_11_2 money                   
declare @Utasa_11_2 money                  
declare @Uoper_11_2 money                  
declare @Umonto_55_2 money                  
declare @Utasa_55_2 money                  
declare @Uoper_55_2 money                  
declare @Umonto_67_67 money                  
declare @Utasa_67_67 money                 
declare @Uoper_67_67 money                  
declare @Umonto_66_66 money                  
declare @Utasa_66_66 money                  
declare @Uoper_66_66 money                  
declare @Umonto_49_3 money                  
declare @Utasa_49_3 money                  
declare @Uoper_49_3 money                  
declare @Umonto_56_3 money                  
declare @Utasa_56_3 money                  
declare @Uoper_56_3 money                  
declare @Umonto_87_8 money                  
declare @Utasa_87_8 money                  
declare @Uoper_87_8 money                  
declare @Umonto_92_9 money      --Monto Efectivo en Euros (Compra)                  
declare @Utasa_92_9 money         --Tasa Efectivo en Euros  (Compra)                 
declare @Uoper_92_9 money         --Operaciones Efectivo en Euros  (Compra)                 
declare @Umonto_93_10 money     --Monto Cheques en Euros  (Compra)                
declare @Utasa_93_10 money       --Tasa Cheques en Euros   (Compra)                
declare @Uoper_93_10 money       --Operaciones Cheques en Euros   (Compra)                 
declare @Umonto_94_11 money     --Monto Transferencias en Euros  (Compra)                 
declare @Utasa_94_11 money       --Tasa Transferencias en Euros   (Compra)                
declare @Uoper_94_11 money       --Operaciones Transferencias en Euros   (Compra)                
declare @Umonto_33_15 money                 
declare @Utasa_33_15 money                 
declare @Uoper_33_15 money                  
declare @Umonto_34_16 money     --Monto Efectivo en Euros (Venta)                 
declare @Utasa_34_16 money    --Tasa Efectivo en Euros  (Venta)                 
declare @Uoper_34_16 money       --Operaciones Efectivo en Euros  (Venta)                 
declare @Dmonto_43_1 money                  
declare @Dtasa_43_1 money                  
declare @Doper_43_1 money                  
declare @Dmonto_44_1 money                  
declare @Dtasa_44_1 money                  
declare @Doper_44_1 money                  
declare @Dmonto_43_2 money                 
declare @Dtasa_43_2 money                 
declare @Doper_43_2 money                  
declare @Dmonto_44_2 money                  
declare @Dtasa_44_2 money                  
declare @Doper_44_2 money                  
declare @Dmonto_11_2 money                  
declare @Dtasa_11_2 money                 
declare @Doper_11_2 money                 
declare @Dmonto_55_2 money                 
declare @Dtasa_55_2 money                  
declare @Doper_55_2 money                  
declare @Dmonto_49_3 money                  
declare @Dtasa_49_3 money                 
declare @Doper_49_3 money                  
declare @Dmonto_56_3 money                 
declare @Dtasa_56_3 money                  
declare @Doper_56_3 money                  
declare @Dmonto_92_9 money                  
declare @Dtasa_92_9 money                 
declare @Doper_92_9 money                 
declare @Dmonto_93_10 money   --Monto Cheques UBS en Euros                   
declare @Dtasa_93_10 money       --Tasa Cheques UBS en Euros                   
declare @Doper_93_10 money      --Operaciones Cheques UBS en Euros                 
declare @Dmonto_94_11 money     --Monto Transferencias en Euros  (Venta)                           
declare @Dtasa_94_11 money       --Tasa Transferencias en Euros  (Venta)                 
declare @Doper_94_11 money       --Operaciones Cheques en Euros  (Venta)                  
declare @Dmonto_562_12 money   --Monto Transferencias CADIVI  (Venta)                    
declare @Dtasa_562_12 money     --Tasa Transferencias CADIVI  (Venta)                
declare @Doper_562_12 money     --Operacion Transferencia REMESA FAMILIAR (Venta)                
declare @umonto_562_12 money   --Monto Transferencias CADIVI  (Venta)                    
declare @utasa_562_12 money      --Tasa Transferencias CADIVI  (Venta)                
declare @uoper_562_12 money      --Operacion Transferencia REMESA FAMILIAR (Venta)                  
declare @CCmonto money                 
declare @CCtasa money                 
declare @CCoper money                  
declare @CVmonto money                  
declare @CVtasa money                  
declare @CVoper money                  
declare @CPCmonto money                  
declare @CPCoper money                  
declare @CPVmonto money                  
declare @CPVoper money                  
declare @CICmonto money                  
declare @CICoper money                  
declare @CIVmonto money                  
declare @CIVoper money                  
declare @CCHmonto money                  
declare @CHCmonto money                 
declare @CHCmontod money                 
declare @EBs money                 
declare @ebsf money                 
declare @EUSD money                  
declare @ECity money                  
declare @EThom money                 
declare @EVisa money                  
declare @EAmex money                 
declare @EThomeur money                  
declare @EAmexeur money                  
declare @Eeur money                 
declare @Umonto_62_2 money                 
declare @Utasa_62_2 money                 
declare @Uoper_62_2 money                 
declare @Umonto_62_2_C money                 
declare @Utasa_62_2_C money                   
declare @Uoper_62_2_C money                   
declare @EThomd money            
declare @evisad money                  
declare @eamexd money                
declare @valesbs money                
declare @valesbsf money                
declare @valesusd money                 
declare @valesdiv money                
declare @edivisa money                  
declare @Umonto_43_12 money                  
declare @Utasa_43_12 money                  
declare @Uoper_43_12 money                  
declare @Umonto_44_12 money       
declare @Utasa_44_12 money                 
declare @Uoper_44_12 money                 
declare @Dmonto_43_12 money                  
declare @Dtasa_43_12 money                  
declare @Doper_43_12 money                 
declare @Dmonto_44_12 money                 
declare @Dtasa_44_12 money                 
declare @Doper_44_12 money                  
declare @emonto_43_2 money             
declare @etasa_43_2 money                 
declare @eoper_43_2 money                 
declare @emonto_44_2 money                 
declare @etasa_44_2 money                 
declare @eoper_44_2 money                 
declare @chctasa money                 
declare @chcoper money                
declare @chctasad money                 
declare @chcoperd money                 
declare @chcmontoe money            
declare @chctasae money                 
declare @chcopere money                
                  
select @Umonto_43_1 = 0                
select @Utasa_43_1 = 0                
select @Uoper_43_1 = 0                 
select @Umonto_44_1 = 0                 
select @Utasa_44_1 = 0                
select @Uoper_44_1 = 0                 
select @Umonto_43_2 = 0                  
select @Utasa_43_2 = 0                 
select @Uoper_43_2 = 0                
select @Umonto_44_2 = 0                 
select @Utasa_44_2 = 0                 
select @Uoper_44_2 = 0                  
select @Umonto_11_2 = 0                
select @Utasa_11_2 = 0                 
select @Uoper_11_2 = 0                 
select @Umonto_55_2 = 0                 
select @Utasa_55_2 = 0                
select @Uoper_55_2 = 0                 
select @Umonto_67_67 = 0                 
select @Utasa_67_67 = 0                 
select @Uoper_67_67 = 0                 
select @Umonto_66_66 = 0                
select @Utasa_66_66 = 0                 
select @Uoper_66_66 = 0                
select @Umonto_49_3 = 0                 
select @Utasa_49_3 = 0                 
select @Uoper_49_3 = 0                
select @Umonto_56_3 = 0                
select @Utasa_56_3 = 0                 
select @Uoper_56_3 = 0                 
select @Umonto_87_8 = 0                 
select @Utasa_87_8 = 0                
select @Uoper_87_8 = 0                
select @Umonto_92_9 = 0                
select @Utasa_92_9 = 0                
select @Uoper_92_9 = 0                
select @Umonto_93_10 = 0                
select @Utasa_93_10 = 0                
select @Uoper_93_10 = 0                
select @Umonto_94_11 = 0                
select @Utasa_94_11 = 0                
select @Uoper_94_11 = 0                
select @Umonto_33_15 = 0                
select @Utasa_33_15 = 0                 
select @Uoper_33_15 = 0                
select @Umonto_34_16 = 0                
select @Utasa_34_16 = 0                
select @Uoper_34_16 = 0                
select @Dmonto_43_1 = 0                
select @Dtasa_43_1 = 0                
select @Doper_43_1 = 0                
select @Dmonto_44_1 = 0                
select @Dtasa_44_1 = 0                
select @Doper_44_1 = 0                
select @Dmonto_43_2 = 0                 
select @Dtasa_43_2 = 0                
select @Doper_43_2 = 0                
select @Dmonto_44_2 = 0                 
select @Dtasa_44_2 = 0                
select @Doper_44_2 = 0                 
select @Dmonto_11_2 = 0                 
select @Dtasa_11_2 = 0                 
select @Doper_11_2 = 0                 
select @Dmonto_55_2 = 0                  
select @Dtasa_55_2 = 0                 
select @Doper_55_2 = 0                 
select @Dmonto_49_3 = 0                 
select @Dtasa_49_3 = 0                 
select @Doper_49_3 = 0                 
select @Dmonto_56_3 = 0                
select @Dtasa_56_3 = 0                
select @Doper_56_3 = 0                 
select @Dmonto_92_9 = 0                 
select @Dtasa_92_9 = 0                 
select @Doper_92_9 = 0                 
select @Dmonto_93_10 = 0                
select @Dtasa_93_10 = 0                 
select @Doper_93_10 = 0                 
select @Dmonto_94_11 = 0                 
select @Dtasa_94_11 = 0                
select @Doper_94_11 = 0                   
select @Dmonto_562_12 = 0 -- transferencias de cadivi, remesas familiares                 
select @Dtasa_562_12 = 0                 
select @Doper_562_12 = 0                
select @umonto_562_12 = 0 -- transferencias de cadivi, remesas familiares                 
select @utasa_562_12 = 0                 
select @uoper_562_12 = 0                  
select @CCmonto = 0                 
select @CCtasa = 0                 
select @CCoper = 0                
select @CVmonto = 0                
select @CVtasa = 0                 
select @CVoper = 0                 
select @CPCmonto = 0                
select @CPCoper = 0                
select @CPVmonto = 0                 
select @CPVoper = 0                
select @CICmonto = 0                 
select @CICoper = 0           
select @CIVmonto = 0                
select @CIVoper = 0                
select @CCHmonto = 0                
select @CHCmonto = 0                
select @CHCmontod = 0                 
select @EBs = 0                
select @EUSD = 0                
select @ECity = 0                
select @EThom = 0                
select @EVisa = 0                
select @EAmex = 0                
select @EThomeur = 0                 
select @EAmexeur = 0                 
select @Eeur = 0                
select @Umonto_62_2 = 0                
select @Utasa_62_2 = 0                
select @Uoper_62_2 = 0                
select @Umonto_62_2_C = 0                
select @Utasa_62_2_C = 0                 
select @Uoper_62_2_C = 0                 
select @EThomd = 0                
select @evisad = 0                
select @eamexd = 0                 
select @valesbs = 0                
select @valesusd = 0                
select @valesdiv = 0                
select @edivisa = 0                  
select @Umonto_43_12 = 0                
select @Utasa_43_12 = 0                
select @Uoper_43_12 = 0                
select @Umonto_44_12 = 0                
select @Utasa_44_12 = 0                 
select @Uoper_44_12 = 0                
select @Dmonto_43_12 = 0                
select @Dtasa_43_12 = 0                
select @Doper_43_12 = 0                
select @Dmonto_44_12 = 0                 
select @Dtasa_44_12 = 0                
select @Doper_44_12 = 0                 
select @emonto_43_2 = 0                
select @etasa_43_2 = 0                 
select @eoper_43_2 = 0                 
select @emonto_44_2 = 0                 
select @etasa_44_2 = 0                
select @eoper_44_2 = 0                
select @chctasa = 0                 
select @chcoper = 0                
select @chctasad = 0                 
select @chcoperd = 0                
select @chcmontoe = 0                 
select @chctasae = 0                
select @chcopere = 0                
                 
                
select @ag = convert(int,valor) from parametros where clave = 'AGENCIA'                
                
--select @fecha = convert(int,convert(varchar,@datetoday,112))                
                
select @fecha = convert(int,convert(varchar,getdate(),112))                
set @umonto_66_66 = 0              
set @utasa_66_66 = 0                
set @uoper_66_66 = 0                    
                 
declare tabla cursor                 
for               
SELECT               
   divisa, codtransaccion, codtipo, count(operacion) as Cantidad,                 
  sum(montodivisa/fixingref) as MontoDivisa,                 
   sum(MontoBs)/sum(montodivisa/fixingref) as TasaCambio,                 
   CodUsuarioRec                
FROM               
   posicion    
  -- left join mtProvider m on (p.CodTransaccion =m.codSendCaja)  
               
WHERE                   
   --(DATEDIFF(dd,@datetoday,Fecha)=0)                 
   (DATEDIFF(dd,getdate(),Fecha)=0)                
   AND (operacion not in (SELECT f.operacioncierre FROM final_contratos f, contratos c where (c.nro_contrato=f.nro_contrato)))                
   --AND (operacion not in (SELECT operacioncierre FROM Enlaces WHERE Substring(Operacion,11,2) = '17'))                
   AND (CodTransaccion in (10,11,25,33,44,43,49,55,56,66,67,77,87,92,562,637,672,674,712,716,781,977,985,987,992,1001,1066,1076))              
   --(CodTransaccion = 93) or                 
   --(CodTransaccion = 94) or               
   --or (CodTransaccion = 34))                
   --and m.status='A'  
   AND (Estado <> 'R')                 
   AND (MontoDivisa > 0)               
   AND (Divisa not in ('35','44'))                
   AND (fixingref > 0)                 
   AND (codagencia = @ag)                 
GROUP BY               
   divisa, codtipo, codtransaccion, codusuariorec                
ORDER BY               
   divisa, codtipo, codtransaccion, codusuariorec              
for read only                
open tabla                  
if @@cursor_rows <> 0                
begin                 
    fetch next from tabla                
       into @divi, @tran, @tipo, @oper, @valu, @tasa, @stat                
                
       while (@@fetch_status <> -1) begin                
           if (@@fetch_status <> -2) begin                
               if (@divi = '1')begin   /* EFECTIVO */                
                  if (@tipo = 1)  begin                
                     if (@tran = 43)  begin                 
                         select @umonto_43_1 = @valu                
            select @utasa_43_1 = @tasa                
                         select @uoper_43_1 = @oper                
                     end                
                 
                     if (@tran = 44) begin                
                         select @umonto_44_1 = @valu                
                         select @utasa_44_1 = @tasa                
                         select @uoper_44_1 = @oper                
                     end                
                
                     if (@tran = 49) begin                
                         select @cchmonto = @valu                
                     end                
                 end                     
                
                 /* TRAVELLERS */                
                
                if (@tipo = 2)begin                
                   if (@tran = 43) begin                
                       select @umonto_43_2 = @valu                
                       select @utasa_43_2 = @tasa                
                       select @uoper_43_2 = @oper                
                   end                
              
                if (@tran = 44) begin                
                    select @umonto_44_2 = @valu                
                    select @utasa_44_2 = @tasa                
                    select @uoper_44_2 = @oper                
                end                
              
                if (@tran = 11) begin                
                    select @umonto_11_2 = @valu                
                    select @utasa_11_2 = @tasa                
                    select @uoper_11_2 = @oper                
                end                
                
                if (@tran = 55) begin                
                    select @umonto_55_2 = @valu                
                    select @utasa_55_2 = @tasa                
                    select @uoper_55_2 = @oper                
            end                
                
                if (@tran = 56) begin                
                    select @umonto_56_3 = @valu                
                    select @utasa_56_3 = @tasa                
                    select @uoper_56_3 = @oper               
                end                
             end                     
                 
             /* MONEYGRAM RECIBOS */                
             if (@tipo = 67) begin                
                if (@tran = 67) begin                
                    select @umonto_67_67 = @valu                
                    select @utasa_67_67 = @tasa                
                    select @uoper_67_67 = @oper                
                end                
             end                
                
             /* MONEYGRAM ENVIOS */                
             if (@tipo in (66,637,672,674,712,716,781,977,985,987,992,1001,1066,1076))   begin  
            --if (@tipo in( select codsendcaja from MtProvider where status='A' )) begin            
                if (@tran in (66,637,672,674,712,716,781,977,985,987,992,1001,1066,1076)) begin                
              --if (@tran in( select codsendcaja from MtProvider where status='A' )) begin     
                    select @umonto_66_66 = @umonto_66_66 + @valu                
                    select @utasa_66_66 = @tasa                
                    select @uoper_66_66 = @uoper_66_66 + @oper                
                end                
             end                
                
             /* CHEQUES */                
         if (@tipo = 3) begin                
                if (@tran = 49) begin                
                    select @umonto_49_3 = @valu /*- @cchmonto*/                
                    select @utasa_49_3 = @tasa                
                    select @uoper_49_3 = @oper                
                end                
                
                if (@tran = 77) begin                
                   select @chcmonto = @valu                
                   select @chctasa = @tasa                
                   select @chcoper = @oper                
                end                
             end                
                
             /* VTM */                
             if (@tipo = 8) begin                
                if (@tran = 87) begin                
                   select @umonto_87_8 = @valu                
                   select @utasa_87_8 = @tasa                
                   select @uoper_87_8 = @oper                
                end                
             end       
                
             /* WORLD LINK CHEQUE                 
             if (@tipo = 9) begin                
                if (@tran = 92) begin                
                   select @umonto_92_9 = @valu                
                   select @utasa_92_9 = @tasa                
                   select @uoper_92_9 = @oper                
                end                
             end*/                
                
             /* WORLD LINK CHEQUE                 
             if (@tipo = 10) begin                  
                if (@tran = 93) begin                
                    select @umonto_93_10 = @valu                
                    select @utasa_93_10 = @tasa                
                    select @uoper_93_10 = @oper                
                end                
             end                
                 
             if (@tipo = 11) begin                
                if (@tran = 94) begin                
                   select @umonto_94_11 = @valu                
                   select @utasa_94_11 = @tasa                
                   select @uoper_94_11 = @oper                
                end                
            end*/                
                
            /*TRANSFERENCIA IC*/                
            if (@tipo = 12) begin                
               if (@tran = 43) begin                
                   select @umonto_43_12 = @valu                
                   select @utasa_43_12 = @tasa                
                   select @uoper_43_12 = @oper                
               end                
                               if (@tran = 44) begin                
                   select @umonto_44_12 = @valu                
                   select @utasa_44_12 = @tasa                
                   select @uoper_44_12 = @oper                
               end                
                
               if (@tran = 562) begin                
                   select @umonto_562_12 = @valu                
                   select @utasa_562_12 = @tasa                
                   select @uoper_562_12 = @oper                
               end                
            end                     
                
            if (@tipo = 15) begin                
               if (@tran = 33)begin                
                  select @umonto_33_15 = @valu               
                  select @utasa_33_15 = @tasa                                                                   
                  select @uoper_33_15 = @oper                
               end                
            end                
               
            /*if (@tipo = 16) begin                
                 if (@tran = 34) begin                
                    select @umonto_34_16 = @valu                
                    select @utasa_34_16 = @tasa                
                    select @uoper_34_16 = @oper                
                 end                
             end*/                
          end                
                
          if (@divi <> '1') begin                
if (@divi <> '904')begin                
                 if (@tipo = 1) begin                
                    if (@tran = 43)begin                
                        select @boli = @dmonto_43_1 * @dtasa_43_1                
                        select @dmonto_43_1 = @dmonto_43_1 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_43_1 = @boli / @dmonto_43_1                 
                        select @doper_43_1 = @doper_43_1 + @oper                
                    end                
                
                    if (@tran = 44)begin                
  select @boli = @dmonto_44_1 * @dtasa_44_1                
                        select @dmonto_44_1 = @dmonto_44_1 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_44_1 = @boli / @dmonto_44_1                 
                        select @doper_44_1 = @doper_44_1 + @oper                
                    end                
                 end                
                
                 if (@tipo = 2) begin                
                    if (@tran = 43) begin                
                        select @boli = @dmonto_43_2 * @dtasa_43_2                
                        select @dmonto_43_2 = @dmonto_43_2 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_43_2 = @boli / @dmonto_43_2                
                        select @doper_43_2 = @doper_43_2 + @oper                
                    end                
                  
                    if (@tran = 44) begin                
                        select @boli = @dmonto_44_2 * @dtasa_44_2                
                        select @dmonto_44_2 = @dmonto_44_2 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_44_2 = @boli / @dmonto_44_2                 
                        select @doper_44_2 = @doper_44_2 + @oper                
                    end                
                
                    if (@tran = 11) begin                
                        select @boli = @dmonto_11_2 * @dtasa_11_2                
                        select @dmonto_11_2 = @dmonto_11_2 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                       select @dtasa_11_2 = @boli / @dmonto_11_2                 
                        select @doper_11_2 = @doper_11_2 + @oper                
                    end                
                
                    if (@tran = 55) begin                
                        select @boli = @dmonto_55_2 * @dtasa_55_2                
                        select @dmonto_55_2 = @dmonto_55_2 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_55_2 = @boli / @dmonto_55_2                 
                        select @doper_55_2 = @doper_55_2 + @oper                
                    end                
              
                    if (@tran = 56) begin                
                        select @boli = @dmonto_56_3 * @dtasa_56_3                
                        select @dmonto_56_3 = @dmonto_56_3 + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @dtasa_56_3 = @boli / @dmonto_56_3                 
                        select @doper_56_3 = @doper_56_3 + @oper                
                    end                
                 end                     
                 
                 if (@tipo = 3) begin                
                    if (@tran = 49) begin                
                        select @boli = @dmonto_49_3 * @dtasa_49_3                
                        select @dmonto_49_3 = @dmonto_49_3 + @valu                
                        select @boli = @boli + (@valu*@tasa)          
                        select @dtasa_49_3 = @boli / @dmonto_49_3                 
                        select @doper_49_3 = @doper_49_3 + @oper                
                    end                
                
                    if (@tran = 77) begin                
                        select @boli = @chcmontod * @chctasad                
                        select @chcmontod = @chcmontod + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @chctasad = @boli / @chcmontod                
                        select @chcoperd = @chcoperd + @oper                
                    end                
                end                
                
                if (@tipo = 9) begin                
                   if (@tran = 92) begin                
                       select @boli = @dmonto_92_9 * @dtasa_92_9                
                       select @dmonto_92_9 = @dmonto_92_9 + @valu                
                       select @boli = @boli + (@valu*@tasa)                
                       select @dtasa_92_9 = @boli / @dmonto_92_9                 
                       select @doper_92_9 = @doper_92_9 + @oper                
                   end                
                end                
                
         /*if (@tipo = 10) begin                
                     if (@tran = 93) begin                
                         select @boli = @dmonto_93_10 * @dtasa_93_10                
                         select @dmonto_93_10 = @dmonto_93_10 + @valu                
                         select @boli = @boli + (@valu*@tasa)                
                         select @dtasa_93_10 = @boli / @dmonto_93_10                 
                         select @doper_93_10 = @doper_93_10 + @oper                
                      end                
                  end                
                
                  if (@tipo = 11) begin                
                      if (@tran = 94) begin                
                          select @boli = @dmonto_94_11 * @dtasa_94_11                
                          select @dmonto_94_11 = @dmonto_94_11 + @valu                
                          select @boli = @boli + (@valu*@tasa)                
                          select @dtasa_94_11 = @boli / @dmonto_94_11                 
                          select @doper_94_11 = @doper_94_11 + @oper                
                      end                
                  end*/                
                
                  /*TRANSFERENCIA IC*/                
                  if (@tipo = 12) begin                
                     if (@tran = 43) begin                
     select @boli = @dmonto_43_12 * @dtasa_43_12                
                         select @dmonto_43_12 = @dmonto_43_12 + @valu                
                         select @boli = @boli + (@valu*@tasa)                                                                  
                         select @dtasa_43_12 = @boli / @dmonto_43_12                 
                         select @doper_43_12 = @doper_43_12 + @oper                
                     end                
                
                     if (@tran = 44) begin                
                         select @boli = @dmonto_44_12 * @dtasa_44_12                
                         select @dmonto_44_12 = @dmonto_44_12 + @valu                
                         select @boli = @boli + (@valu*@tasa)                
                         select @dtasa_44_12 = @boli / @dmonto_44_12                 
                         select @doper_44_12 = @doper_44_12 + @oper                
                     end                
                
                     if (@tran = 562) begin                
                         select @boli = @dmonto_562_12 * @dtasa_562_12                
                         select @dmonto_562_12 = @dmonto_562_12 + @valu                
                         select @boli = @boli + (@valu*@tasa)                
                         select @dtasa_562_12 = @boli / @dmonto_562_12                 
                         select @doper_562_12 = @doper_562_12 + @oper                
                     end               
                  end                
               end                
                 
               if (@divi = '904') begin                
                  if (@tipo = 1) begin                
                      if (@tran = 43) begin                
                          select @boli = @umonto_92_9 * @utasa_92_9                
                          select @umonto_92_9 = @umonto_92_9 + @valu                
                          select @boli = @boli + (@valu*@tasa)                
                          select @utasa_92_9 = @boli / @umonto_92_9                 
                          select @uoper_92_9 = @uoper_92_9 + @oper                
                      end                
                                    
                      if (@tran = 44) begin                
                          select @boli = @umonto_34_16 * @utasa_34_16                
                          select @umonto_34_16 = @umonto_34_16 + @valu                
                          select @boli = @boli + (@valu*@tasa)                
                          select @utasa_34_16 = @boli / @umonto_34_16                 
                          select @uoper_34_16 = @uoper_34_16 + @oper                
                      end                
                   end                
            
                   if (@tipo = 2) begin                
                       if (@tran = 43) begin                
                           select @boli = @emonto_43_2 * @etasa_43_2                
                           select @emonto_43_2 = @emonto_43_2 + @valu                
                           select @boli = @boli + (@valu*@tasa)                
             select @etasa_43_2 = @boli / @emonto_43_2                
                           select @eoper_43_2 = @eoper_43_2 + @oper                
                       end                
                
                       if (@tran = 44) begin                
                           select @boli = @emonto_44_2 * @etasa_44_2                
                           select @emonto_44_2 = @emonto_44_2 + @valu                
                           select @boli = @boli + (@valu*@tasa)                
                           select @etasa_44_2 = @boli / @emonto_44_2                 
                           select @eoper_44_2 = @eoper_44_2 + @oper                
                       end                
                
                       if (@tran = 56) begin                
                           select @boli = @dmonto_93_10 * @dtasa_93_10                
                           select @dmonto_93_10 = @dmonto_93_10 + @valu                
                           select @boli = @boli + (@valu*@tasa)                
                           select @dtasa_93_10 = @boli / @dmonto_92_9                 
   select @doper_93_10 = @doper_93_10 + @oper                
                       end                
                    end                
                
                    if (@tipo = 3)begin                
                        if (@tran = 49)begin                
                            select @boli = @umonto_93_10 * @utasa_93_10                
                            select @umonto_93_10 = @umonto_93_10 + @valu                
                            select @boli = @boli + (@valu*@tasa)                
                            select @utasa_93_10 = @boli / @umonto_93_10                 
                            select @uoper_93_10 = @uoper_93_10 + @oper                
                        end                
                
                        if (@tran = 77) begin                
                            select @boli = @chcmontoe * @chctasae                
                            select @chcmontoe = @chcmontoe + @valu                
                            select @boli = @boli + (@valu*@tasa)                
                            select @chctasae = @boli / @chcmontoe               
                            select @chcopere = @chcopere + @oper                
                        end                
                     end                
                
                     /*TRANSFERENCIA IC*/                
                     if (@tipo = 12) begin                
                         if (@tran = 43) begin                
                             select @boli = @umonto_94_11 * @utasa_94_11                
                             select @umonto_94_11 = @umonto_94_11 + @valu                
                             select @boli = @boli + (@valu*@tasa)              
                             select @dtasa_43_12 = @boli / @dmonto_43_12                 
                             select @uoper_94_11 = @uoper_94_11 + @oper                
                         end                
                 
                         if (@tran = 44) begin                
                             select @boli = @dmonto_94_11 * @dtasa_94_11                
                             select @dmonto_94_11 = @dmonto_94_11 + @valu                
                             select @boli = @boli + (@valu*@tasa)                
                             select @dtasa_94_11 = @boli / @dmonto_94_11                 
                             select @doper_94_11 = @doper_94_11 + @oper                
                         end                
                
                         if (@tran = 562) begin                
                             select @boli = @dmonto_562_12 * @dtasa_562_12                
                             select @dmonto_562_12 = @dmonto_562_12 + @valu                
                             select @boli = @boli + (@valu*@tasa)                
                             select @dtasa_562_12 = @boli / @dmonto_562_12                 
                             select @doper_562_12 = @doper_562_12 + @oper                
                         end                
                      end                
                   end                
                end                                       
                
           if (@tran = 25) and (@divi = '1') begin                
                    if (@stat = 'E') begin                
                        select @boli = @ccmonto * @cctasa                
                        select @ccmonto = @ccmonto + @valu                
 select @boli = @boli + (@valu*@tasa)                
                        select @cctasa = @boli / @ccmonto                
                        select @ccoper = @ccoper + @oper                
                    end                
                
                    if (@stat = 'S')begin                
                        select @boli = @cvmonto * @cvtasa                
                        select @cvmonto = @cvmonto + @valu                
                        select @boli = @boli + (@valu*@tasa)                
                        select @cvtasa = @boli / @cvmonto                
                        select @cvoper = @cvoper + @oper                
                    end                
                 end                
             end                
          fetch next from tabla                
              into @divi, @tran, @tipo, @oper, @valu, @tasa, @stat                
       end                
    end                
                  
    deallocate tabla                
                
   /*            
    set @umonto_66_66 = 0                
    set @uoper_66_66 = 0                
    set @boli = 0                
    set @utasa_66_66 = 0    */            
              
                
declare tabla cursor                
for               
SELECT               
   divisa, codtransaccion, codtipo, count(operacion) as Cantidad,                 
   sum(montodivisa/fixingref) as MontoDivisa,                   
   sum(MontoBs)/sum(montodivisa/fixingref) as TasaCambio,                 
   CodUsuarioRec                
FROM               
   posicion   
  --inner join mtprovider m on (p.codtransaccion = m.codSendCaja)  
WHERE                 
  (DATEDIFF(dd,getdate(),Fecha)=0)                 
  AND (operacion in (SELECT f.operacioncierre FROM final_contratos f, contratos c where (c.nro_contrato=f.nro_contrato)))               
--and datediff(dd,getdate(),c.fecha)=0              
  AND (CodTransaccion in (10,11,25,33,44,43,49,55,56,66,67,77,87,92,562,637,672,674,712,716,781,977,985,987,992,1001,1066,1076))                
  --and m.status='A'  
--(CodTransaccion = 93) or                   
--(CodTransaccion = 94) or                 
--or (CodTransaccion = 34))                
  AND (Estado <> 'R') AND (MontoDivisa > 0) AND (Divisa not in ('35','44'))                
  AND (fixingref > 0) AND (codagencia = @ag)                  
GROUP BY               
   divisa, codtipo, codtransaccion, codusuariorec,operacion                
ORDER BY               
   divisa, codtipo, codtransaccion, codusuariorec,operacion                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0 begin                
   fetch next from tabla                
      into @divi, @tran, @tipo, @oper, @valu, @tasa, @stat                
                
      while (@@fetch_status <> -1) begin                
          if (@@fetch_status <> -2) begin                
             if (@divi = '1') begin  /* EFECTIVO */                
            if (@tipo = 1) begin                
                   if (@tran = 43) begin                
                       select @boli = @umonto_43_1*@utasa_43_1                
                       select @umonto_43_1 = @umonto_43_1 + @valu                
                       select @uoper_43_1 = @uoper_43_1 + @oper                
                       select @boli = @boli + (@valu*@tasa)                
                       select @utasa_43_1 = @boli / @umonto_43_1                 
                    end                
                
                    if (@tran = 44) begin                
                        select @boli = @umonto_44_1*@utasa_44_1                
                        select @umonto_44_1 = @umonto_44_1 + @valu                
                        select @uoper_44_1 = @uoper_44_1 + @oper                
                        select @boli = @boli + (@valu*@tasa)                
                        select @utasa_44_1 = @boli / @umonto_44_1                 
                    end                
                
                    if (@tran = 49) begin                
                        select @cchmonto = @cchmonto + @valu                
                    end                
                 end                     
                 
                 /* TRAVELLERS */                
                 if (@tipo = 2) begin                
                    if (@tran = 43) begin                
                        select @boli = @umonto_43_2*@utasa_43_2                
                        select @umonto_43_2 = @umonto_43_2 + @valu                
                        select @uoper_43_2 = @uoper_43_2 + @oper                
                        select @boli = @boli + (@valu*@tasa)                
                        select @utasa_43_2 = @boli / @umonto_43_2                 
                     end                
                
                     if (@tran = 44)begin                
                         select @boli = @umonto_44_2*@utasa_44_2                
          select @umonto_44_2 = @umonto_44_2 + @valu                
                         select @uoper_44_2 = @uoper_44_2 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_44_2 = @boli / @umonto_44_2                
                     end                
                
                     if (@tran = 11) begin                
                         select @boli = @umonto_11_2*@utasa_11_2                
                         select @umonto_11_2 = @umonto_11_2 + @valu                
                         select @uoper_11_2 = @uoper_11_2 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_11_2 = @boli / @umonto_11_2                
                     end                
              
                     if (@tran = 55) begin         
                         select @boli = @umonto_55_2*@utasa_55_2                
                         select @umonto_55_2 = @umonto_55_2 + @valu                
                         select @uoper_55_2 = @uoper_55_2 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_55_2 = @boli / @umonto_55_2                
                     end                
                
                     if (@tran = 56) begin                
                         select @boli = @umonto_56_3*@utasa_56_3                
                         select @umonto_56_3 = @umonto_56_3 + @valu                
                         select @uoper_56_3 = @uoper_56_3 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_56_3 = @boli / @umonto_56_3                
                     end                
                 end                     
                
                 /* MONEYGRAM RECIBOS */                
                 if (@tipo = 67) begin                
                     if (@tran = 67) begin                
                         select @boli = @umonto_67_67*@utasa_67_67                
                         select @umonto_67_67 = @umonto_67_67 + @valu                
                         select @uoper_67_67 = @uoper_67_67 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_67_67 = @boli / @umonto_67_67                
                end                
                  end                
                
                  /* MONEYGRAM ENVIOS */                
              if (@tipo in (66,637,672,674,712,716)) begin                
                     if (@tran in (66,637,672,674,712,716)) begin                
                         -- select @boli = @boli + (@umonto_66_66*@utasa_66_66)              
                         select @umonto_66_66 = @umonto_66_66 + @valu                
                         select @uoper_66_66 = @uoper_66_66 + @oper                
                         select @boli = @boli + (@valu*@tasa)                
                         select @utasa_66_66 = @boli / @umonto_66_66                
                      end                
                   end                
                
                   /* CHEQUES */                
                   if (@tipo = 3) begin                
                       if (@tran = 49) begin                
                           select @boli = @umonto_49_3*@utasa_49_3                
                           select @umonto_49_3 = @umonto_49_3 + @valu /*-@cchmonto)*/                
                           select @uoper_49_3 = @uoper_49_3 + @oper                
                           select @boli = @boli + (@valu*@tasa)                
                           select @utasa_49_3 = @boli / @umonto_49_3                
                        end                
                
                        if (@tran = 77) begin                
                            select @boli = @chcmonto * @chctasa                
                            select @chcmonto = @chcmonto + @valu                
                            select @boli = @boli + (@valu*@tasa)                
                            select @chctasa = @boli / @chcmonto                
                            select @chcoper = @chcoper + @oper                
                        end                
                     end                
                
                     /* VTM */                
                     if (@tipo = 8) begin                
                         if (@tran = 87)begin                
 select @boli = @umonto_87_8*@utasa_87_8                
                             select @umonto_87_8 = @umonto_87_8 + @valu                
   select @uoper_87_8 = @uoper_87_8 + @oper                
                             select @boli = @boli + (@valu*@tasa)                
                             select @utasa_87_8 = @boli / @umonto_87_8                
                         end                
                      end                
                 
                      /* WORLD LINK CHEQUE                 
                      if (@tipo = 9) begin                
                          if (@tran = 92) begin                
                              select @boli = @umonto_92_9*@utasa_92_9                
                              select @umonto_92_9 = @umonto_92_9 + @valu                
                              select @uoper_92_9 = @uoper_92_9 + @oper                
                              select @boli = @boli + (@valu*@tasa)                
                              select @utasa_92_9 = @boli / @umonto_92_9                
                           end                
                       end*/                
                 
                       /* WORLD LINK CHEQUE                 
                       if (@tipo = 10) begin                  
                           if (@tran = 93) begin                
                               select @boli = @umonto_93_10*@utasa_93_10                
                               select @umonto_93_10 = @umonto_93_10 + @valu                
                               select @uoper_93_10 = @uoper_93_10 + @oper                
                               select @boli = @boli + (@valu*@tasa)                
                               select @utasa_93_10 = @boli / @umonto_93_10                
                            end                
                         end                
                 
                         if (@tipo = 11) begin                
                             if (@tran = 94) begin                
                                 select @boli = @umonto_94_11*@utasa_94_11                
                                 select @umonto_94_11 = @umonto_94_11 + @valu                
                                 select @uoper_94_11 = @uoper_94_11 + @oper                
     select @boli = @boli + (@valu*@tasa)                
                                 select @utasa_94_11 = @boli / @umonto_94_11                
                              end                
                          end*/                
                
                          /*TRANSFERENCIA IC*/                
                          if (@tipo = 12) begin                
                              if (@tran = 43)begin                
                                  select @boli = @umonto_43_12*@utasa_43_12                
                                  select @umonto_43_12 = @umonto_43_12 + @valu                
                                  select @uoper_43_12 = @uoper_43_12 + @oper                
                                  select @boli = @boli + (@valu*@tasa)                
                                  select @utasa_43_12 = @boli / @umonto_43_12                
                              end                
                
                              if (@tran = 44) begin                
                                  select @boli = @umonto_44_12*@utasa_44_12                
                                  select @umonto_44_12 = @umonto_44_12 + @valu                
                                  select @uoper_44_12 = @uoper_44_12 + @oper                
                                  select @boli = @boli + (@valu*@tasa)                
                                  select @utasa_44_12 = @boli / @umonto_44_12                
                              end                
                 
                              if (@tran = 562) begin                
                                  select @boli = @umonto_562_12*@utasa_562_12                
                                  select @umonto_562_12 = @umonto_562_12 + @valu                
                                  select @uoper_562_12 = @uoper_562_12 + @oper                
                                  select @boli = @boli + (@valu*@tasa)                
                                  select @utasa_562_12 = @boli / @umonto_562_12                
                               end             
                            end                
               
                        if (@tipo = 15) begin                
if (@tran = 33)begin                
                                    select @boli = @umonto_33_15*@utasa_33_15                
                                    select @umonto_33_15 = @umonto_33_15 + @valu                
                                    select @uoper_33_15 = @uoper_33_15 + @oper                
                                    select @boli = @boli + (@valu*@tasa)                
                                    select @utasa_33_15 = @boli / @umonto_33_15                
                                 end                
                              end                
                
                              /*if (@tipo = 16) begin                
                                   if (@tran = 34) begin                
                                       select @boli = @umonto_34_16*@utasa_34_16                
                                       select @umonto_34_16 = @umonto_34_16 + @valu                
                                       select @uoper_34_16 = @uoper_34_16 + @oper                
                                       select @boli = @boli + (@valu*@tasa)                
                                       select @utasa_34_16 = @boli / @umonto_34_16                
                                    end                
                               end*/                
      end                
                
                            if (@divi <> '1') begin                
                                if (@divi<>'904') begin                
                                    if (@tipo = 1) begin                
                                        if (@tran = 43) begin                
                                            select @boli = @dmonto_43_1 * @dtasa_43_1                
                                            select @dmonto_43_1 = @dmonto_43_1 + @valu                
                                            select @boli = @boli + (@valu*@tasa)                
                                            select @dtasa_43_1 = @boli / @dmonto_43_1                 
                                            select @doper_43_1 = @doper_43_1 + @oper                
               end                
                
                                         if (@tran = 44) begin                
                                             select @boli = @dmonto_44_1 * @dtasa_44_1                
                                          select @dmonto_44_1 = @dmonto_44_1 + @valu                
                                             select @boli = @boli + (@valu*@tasa)                
                                             select @dtasa_44_1 = @boli / @dmonto_44_1                 
                                             select @doper_44_1 = @doper_44_1 + @oper                
                                         end                
                                      end                
                
                                      if (@tipo = 2) begin                
                                          if (@tran = 43) begin                
                                              select @boli = @dmonto_43_2 * @dtasa_43_2                
                                              select @dmonto_43_2 = @dmonto_43_2 + @valu                
                                              select @boli = @boli + (@valu*@tasa)                
                                              select @dtasa_43_2 = @boli / @dmonto_43_2                
                                              select @doper_43_2 = @doper_43_2 + @oper                
                                           end                
                
                                           if (@tran = 44) begin                
                                               select @boli = @dmonto_44_2 * @dtasa_44_2                
                                               select @dmonto_44_2 = @dmonto_44_2 + @valu                
                                               select @boli = @boli + (@valu*@tasa)                
                                               select @dtasa_44_2 = @boli / @dmonto_44_2                 
                                               select @doper_44_2 = @doper_44_2 + @oper                
                                           end                
                 
                                           if (@tran = 11) begin                
                                               select @boli = @dmonto_11_2 * @dtasa_11_2                
                                              select @dmonto_11_2 = @dmonto_11_2 + @valu                
                                               select @boli = @boli + (@valu*@tasa)                
                                               select @dtasa_11_2 = @boli / @dmonto_11_2                 
                                               select @doper_11_2 = @doper_11_2 + @oper                
                                           end                
                
                                           if (@tran = 55) begin                
                                               select @boli = @dmonto_55_2 * @dtasa_55_2                
                                               select @dmonto_55_2 = @dmonto_55_2 + @valu                
                  select @boli = @boli + (@valu*@tasa)                
                                               select @dtasa_55_2 = @boli / @dmonto_55_2                 
                                               select @doper_55_2 = @doper_55_2 + @oper                
                                           end                
                 
                                           if (@tran = 56) begin                
                                               select @boli = @dmonto_56_3 * @dtasa_56_3                
                                               select @dmonto_56_3 = @dmonto_56_3 + @valu                
                                               select @boli = @boli + (@valu*@tasa)                
                                               select @dtasa_56_3 = @boli / @dmonto_56_3                 
                                               select @doper_56_3 = @doper_56_3 + @oper                
                                            end                
                                         end                     
                 
                                         if (@tipo = 3) begin                
                                             if (@tran = 49) begin                
                                     select @boli = @dmonto_49_3 * @dtasa_49_3                
                                                 select @dmonto_49_3 = @dmonto_49_3 + @valu                
                                                 select @boli = @boli + (@valu*@tasa)                
                                                 select @dtasa_49_3 = @boli / @dmonto_49_3                 
         select @doper_49_3 = @doper_49_3 + @oper                
                                             end                
                
                                             if (@tran = 77) begin                
                                                 select @boli = @chcmontod * @chctasad                
                                                 select @chcmontod = @chcmontod + @valu                
                                                 select @boli = @boli + (@valu*@tasa)                
                                                 select @chctasad = @boli / @chcmontod                
                                                 select @chcoperd = @chcoperd + @oper                
                                             end                
                                          end                
                                                        
                                          if (@tipo = 9) begin                
  if (@tran = 92) begin                
                                                  select @boli = @dmonto_92_9 * @dtasa_92_9                
                                                  select @dmonto_92_9 = @dmonto_92_9 + @valu                
                                                  select @boli = @boli + (@valu*@tasa)                
                                                  select @dtasa_92_9 = @boli / @dmonto_92_9                 
        select @doper_92_9 = @doper_92_9 + @oper                
                                               end                
                                           end                
                
                                           /*TRANSFERENCIA IC*/                
                                           if (@tipo = 12) begin                
                                               if (@tran = 43)begin                
                                                   select @boli = @dmonto_43_12 * @dtasa_43_12                
                                                   select @dmonto_43_12 = @dmonto_43_12 + @valu                
                                                   select @boli = @boli + (@valu*@tasa)                                                                  
select @dtasa_43_12 = @boli / @dmonto_43_12                 
                                                   select @doper_43_12 = @doper_43_12 + @oper                
                                                end                
                 
                                                if (@tran = 44)begin                
                                                    select @boli = @dmonto_44_12 * @dtasa_44_12                
                                                    select @dmonto_44_12 = @dmonto_44_12 + @valu                
                                                    select @boli = @boli + (@valu*@tasa)                
                                                    select @dtasa_44_12 = @boli / @dmonto_44_12                 
                                                    select @doper_44_12 = @doper_44_12 + @oper                
                                                 end                
                
                                                 if (@tran = 562) begin                
                                               select @boli = @dmonto_562_12 * @dtasa_562_12                
                                                     select @dmonto_562_12 = @dmonto_562_12 + @valu                
                                                     select @boli = @boli + (@valu*@tasa)                
                                                     select @dtasa_562_12 = @boli / @dmonto_562_12                 
                                                     select @doper_562_12 = @doper_562_12 + @oper                
                                                  end                
                                               end                
                                            end                
                                            if (@divi='904')begin                
                                                if (@tipo = 1)begin                
                                                    if (@tran = 43) begin                
                                                        select @boli = @umonto_92_9 * @utasa_92_9                
                       select @umonto_92_9 = @umonto_92_9 + @valu                
                                                        select @boli = @boli + (@valu*@tasa)                
                                                        select @utasa_92_9 = @boli / @umonto_92_9                 
                                                        select @uoper_92_9 = @uoper_92_9 + @oper                
                                                     end                
                
                                                     if (@tran = 44) begin                
                
                                                                  select @boli = @umonto_34_16 * @utasa_34_16                
                
                                                                  select @umonto_34_16 = @umonto_34_16 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @utasa_34_16 = @boli / @umonto_34_16                 
                
                                                                  select @uoper_34_16 = @uoper_34_16 + @oper                
                
                                                        end                
                
                                               end                
                
                                                               
                
                                               if (@tipo = 2)                
                
                                               begin                
                
                                                         if (@tran = 43)   
                
                                                        begin                
                
                                                                  select @boli = @emonto_43_2 * @etasa_43_2                
                                                                        select @emonto_43_2 = @emonto_43_2 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @etasa_43_2 = @boli / @emonto_43_2                
                
                                                                  select @eoper_43_2 = @eoper_43_2 + @oper                
                
                                                        end                
                
                                                        if (@tran = 44)                
                
                                                        begin                
                
                                                                  select @boli = @emonto_44_2 * @etasa_44_2                
                
                                                                  select @emonto_44_2 = @emonto_44_2 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @etasa_44_2 = @boli / @emonto_44_2                 
                
                                                                  select @eoper_44_2 = @eoper_44_2 + @oper                
                
                                                        end                
                
                                                        if (@tran = 56)                
                
                                                        begin                
                
                                                                  select @boli = @dmonto_93_10 * @dtasa_93_10                
                
                                                                  select @dmonto_93_10 = @dmonto_93_10 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @dtasa_93_10 = @boli / @dmonto_93_10                 
                
                                                                  select @doper_93_10 = @doper_93_10 + @oper                
                
                                                        end                
                
  end                
                
                 
                
                                               if (@tipo = 3)                
                
                                               begin                
                
                   if (@tran = 49)                
                
                begin                
                
                                                                  select @boli = @umonto_93_10 * @utasa_93_10                
                
                                                                  select @umonto_93_10 = @umonto_93_10 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @utasa_93_10 = @boli / @umonto_93_10                 
                
                                                                  select @uoper_93_10 = @uoper_93_10 + @oper                
                
                                                        end                
  
                                                        if (@tran = 77)                
                
                                                        begin                
                
                                                                  select @boli = @chcmontoe * @chctasae                
                
                                                                  select @chcmontoe = @chcmontoe + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @chctasae = @boli / @chcmontoe                
                
                                                                  select @chcopere = @chcopere + @oper                
                
                                                        end                
                
                                               end                
                
                                            
                
                                               /*TRANSFERENCIA IC*/                
                
                                               if (@tipo = 12)                
                
                                               begin                
                
                                                        if (@tran = 43)                
                
                                                        begin                
      
                                                                  select @boli = @umonto_94_11 * @utasa_94_11                
                
                                                                  select @umonto_94_11 = @umonto_94_11 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                                                    select @dtasa_43_12 = @boli / @dmonto_43_12                 
                
                                                                  select @uoper_94_11 = @uoper_94_11 + @oper                
                
                                                        end                
                
                                                        if (@tran = 44)                
                
                                                        begin                
                
                                                                  select @boli = @dmonto_94_11 * @dtasa_94_11                
                
                                                                  select @dmonto_94_11 = @dmonto_94_11 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @dtasa_94_11 = @boli / @dmonto_94_11                 
                
                                                                  select @doper_94_11 = @doper_94_11 + @oper                
                
                                                        end                
                
                                                        if (@tran = 562)                
                
                                                        begin                
                
                                                                  select @boli = @dmonto_562_12 * @dtasa_562_12                
                
                                                                  select @dmonto_562_12 = @dmonto_562_12 + @valu                
                
                                                                  select @boli = @boli + (@valu*@tasa)                
                
                                                                  select @dtasa_562_12 = @boli / @dmonto_562_12                 
                
                                   select @doper_562_12 = @doper_562_12 + @oper                
                
                                                        end                
                
                 
                
                              end                
                
                                     end                
                
                            end                
                
                            if (@tran = 25) and (@divi = '1')                
                
                            begin                
                
                                      if (@stat = 'E')                
                
                                      begin                
                
                                               select @boli = @ccmonto * @cctasa                
                
                                               select @ccmonto = @ccmonto + @valu                
                
                                               select @boli = @boli + (@valu*@tasa)                
                
                                               select @cctasa = @boli / @ccmonto                
                
                                               select @ccoper = @ccoper + @oper                
                
                                      end                
                
                                      if (@stat = 'S')                
                
                                      begin                
                
                                               select @boli = @cvmonto * @cvtasa                
                
                                               select @cvmonto = @cvmonto + @valu                
                
     select @boli = @boli + (@valu*@tasa)                
                
                                               select @cvtasa = @boli / @cvmonto                
                
                                               select @cvoper = @cvoper + @oper                
                
                                      end                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                   into @divi, @tran, @tipo, @oper, @valu, @tasa, @stat                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
select @umonto_49_3 = @umonto_49_3 - @cchmonto                
                
                 
                
declare @consig int                
                
declare tabla cursor                
                
for SELECT CONVERT(int,Cantidad) as Consignacion,                
                
count(operacion) as Cantidad,                 
                
sum(montodivisa) as MontoDivisa,                 
                
sum(MontoBs)/sum(montodivisa) as TasaCambio                 
                
FROM posicion                 
         
WHERE                 
                
--(DATEDIFF(dd,@datetoday,Fecha)=0)                 
                
(DATEDIFF(dd,getdate(),Fecha)=0)                 
                
AND (CodTransaccion = 62)                
                
AND (Estado <> 'R')                 
                
AND (MontoDivisa > 0)                 
                
AND (Divisa = '1')                
                
AND (CodTipo = 2)                
               
AND (fixingref > 0)                 
                
AND (codagencia = @ag)                 
                
GROUP BY CONVERT(int,Cantidad)                
                
ORDER BY CONVERT(int,Cantidad)                
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @consig, @oper, @valu, @tasa                 
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
                            /* TRAVELLERS CONSIGNACION*/                
                
                            if (@consig <> 15) and (@consig <> 17)                
                
                            begin                
                
                                      select @boli = @Umonto_62_2 * @Utasa_62_2                
                
                                      select @Umonto_62_2 = @Umonto_62_2 + @valu                
                
                                      select @boli = @boli + (@valu*@tasa)                
                
                                      select @Utasa_62_2 = @boli / @Umonto_62_2                 
                
                                      select @Uoper_62_2 = @Uoper_62_2 + @oper                
                
                            end                
                
                            if (@consig = 15) or (@consig = 17)                
                
                            begin                
                
                                      select @boli = @Umonto_62_2_C * @Utasa_62_2_C                
                
                                      select @Umonto_62_2_C = @Umonto_62_2_C + @valu                
                
                                      select @boli = @boli + (@valu*@tasa)                
                
                                      select @Utasa_62_2_C = @boli / @Umonto_62_2_C                 
                
                                      select @Uoper_62_2_C = @Uoper_62_2_C + @oper                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                   into @consig, @oper, @valu, @tasa                
                
         end                
                
end                            
deallocate tabla                
                
                 
                
declare @op varchar(10)                
                
declare tabla cursor                
                
for Select a.Tipo, SUM(b.MontoDivisa/b.FixingRef) as "Monto", COUNT(a.Nro_Contrato) as "Cantidad"                
                
from Contratos a, Contratos_Detalle b                   
where (a.Nro_Contrato = b.Nro_Contrato)                 
                
AND (a.Estado <> 'R')                 
                
AND (a.Nro_Contrato NOT IN(Select c.Nro_Contrato from Final_Contratos c where (c.Nro_Contrato = a.Nro_Contrato)))                 
                
AND (b.Divisa not in ('35','44'))                
                
AND (a.CodAgencia = @ag)                 
                
--AND (DATEDIFF(dd,@datetoday,a.FechaValor) >= 0)                 
                
--AND (DATEDIFF(dd,@datetoday, getdate()) >= 0)                
                
AND (DATEDIFF(dd,getdate(),a.FechaValor) >= 0)                 
                
AND (DATEDIFF(dd,a.Fecha, getdate()) >= 0)         
                
GROUP BY a.Tipo                 
                
ORDER BY a.Tipo                 
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @op, @valu, @oper                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)      
                
                   begin                
                
                            if (@op = 'C')                
                
                            begin                
                
                                      select @cpcmonto = @valu                
                
                                      select @cpcoper = @oper                
                
                            end                
                
                            if (@op = 'V')                
                
                            begin                
                
                                      select @cpvmonto = @valu                
                
 select @cpvoper = @oper                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                   into @op, @valu, @oper                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
declare tabla cursor                
                
for Select a.Tipo, SUM(b.MontoDivisa/b.FixingRef) as "Monto", COUNT(a.Nro_Contrato) as "Cantidad"                
                
from Contratos a, Contratos_Detalle b                 
                
where (a.Nro_Contrato = b.Nro_Contrato)                 
                
AND (a.Estado <> 'R')                 
                
AND (a.Nro_Contrato NOT IN(Select c.Nro_Contrato from Final_Contratos c where (c.Nro_Contrato = a.Nro_Contrato)))                 
                
AND (b.Divisa not in ('35','44'))                 
                
AND (a.CodAgencia = @ag)                 
                
--AND (DATEDIFF(dd, a.FechaValor, @datetoday) = 1)                 
                
AND (DATEDIFF(dd, a.FechaValor, getdate()) = 1)                 
                
GROUP BY a.Tipo                 
                
ORDER BY a.Tipo                 
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @op, @valu, @oper                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
                            if (@op = 'C')                
                
                            begin                
                
                                      select @cicmonto = @valu                
                
                select @cicoper = @oper                
                
                            end                
                
                            if (@op = 'V')                
                
                            begin                
                
                                      select @civmonto = @valu                
                
                                      select @civoper = @oper                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                   into @op, @valu, @oper                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
declare tabla cursor                
                
for                 
                
Select divisa, sum(monto) as monto                
                
from invdiv a, usuarios b                 
                
where (a.divisa in ('35','1','904','44'))                 
                
and (a.codusuario = b.codusuario)                
                
and (b.codagencia = @ag)                
                
group by divisa                
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @divi, @valu                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
                            if (@divi = '1')                
                
                            begin                
                
                
                                      select @eusd = @valu                
                
                            end                
                
                            if (@divi = '35')                
                
                            begin                
                
       select @ebs = @valu                
                
                            end                
                
                            if (@divi = '44')                
                
                            begin                
                
                                      select @ebsf = @valu                
                
                            end                
                
                            if (@divi = '904')                
                
                            begin                
                
                                      select @eeur = @valu                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
             
                
                   into @divi, @valu                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
declare tabla cursor                
                
for                 
                
Select sum(a.monto/c.fixing) as monto                
                
from invdiv a, usuarios b, pdivisas c                 
                
where (a.divisa <> '35' and a.divisa <> '1' and a.divisa <> '904' and a.divisa <> '44')                 
                
and (a.codusuario = b.codusuario)                
                
and (c.codagencia=b.codagencia)                
                
and (c.divisa = a.divisa)                 
                
and (c.codtipo=1)                
                
and (b.codagencia = @ag)                
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @valu                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
      select @edivisa = @valu                
                
                   end                
                
                   fetch next from tabla                
                
                   into @valu                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
declare tabla cursor                
                
for                 
                
Select divisa, codmarca, sum(denominacion*cantidad) as monto                
                
from                 
                
valoresblancos                 
                
where ((divisa = '1') or (divisa = '904'))                
                
and (tipo = 'T')                
                
group by divisa, codmarca                
                
for read only                
                
open tabla                
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @divi, @tipo, @valu                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
                            if (@divi = '1')                
                
                            begin                
                
                                      if (@tipo = 1)                
                
                                      begin                
                
                                               select @ecity = @valu                
                
                                      end                
                
                                      if (@tipo = 2)                
                
                                      begin                
                
                                               select @ethom = @valu                
                
                                      end                
                
                                      if (@tipo = 3)                
                
                                      begin                
                
                                               select @evisa = @valu                
                
                                      end                
                
                                      if (@tipo = 4)                
                
                                      begin                
                
                                               select @eamex = @valu                
                
                                      end                
                
                            end                
                
                            if (@divi = '904')                
                
           begin                
                
                                      if (@tipo = 2)                
                
                                      begin                
                
                                               select @ethomeur = @valu                
                
                                      end                
                
                                      if (@tipo = 4)                
                
      begin                
                
                                               select @eamexeur = @valu                
                
                                      end                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                into @divi, @tipo, @valu                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
declare tabla cursor                
                
for                 
                
Select a.codmarca, sum((a.denominacion*a.cantidad)/b.fixing) as monto                
                
from                 
                
valoresblancos a, pdivisas b                
                
where (a.divisa <> '1') and (a.divisa <> '904')                
                
and (a.tipo = 'T') and (a.divisa = b.divisa) and (b.codtipo = 2) and (b.codagencia = @ag)                
                
and (a.codmarca in (2,3,4))                
                
group by codmarca                
                
for read only                
                
open tabla           
                
if @@cursor_rows <> 0                
                
begin                
                
         fetch next from tabla                
                
         into @tipo, @valu                
                
         while (@@fetch_status <> -1)                
                
         begin                
                
                   if (@@fetch_status <> -2)                
                
                   begin                
                
                            if (@tipo = 2)                
                
                            begin                
                
                                      select @ethomd = @valu                
                
                            end                
                
                            if (@tipo = 3)                
                
                            begin                
                
                                      select @evisad = @valu                
                
                            end                
                
                            if (@tipo = 4)                
                
                            begin                
                
                                      select @eamexd = @valu                
                
                            end                
                
                   end                
                
                   fetch next from tabla                
                
                   into @tipo, @valu                
                
         end                
                
end                
                
deallocate tabla                
                
                 
                
select @valesbs = sum(a.montodivisa) from movdivisa a, movimien b                
                
where a.operacion in (select operacion from enlaces where operacion = a.operacion and operacioncierre is null)                
                
and a.codtipo = 7 and a.divisa = '35' and a.operacion = b.operacion and b.estado <> 'R' and b.codtransaccion = 8                
                
                 
                
select @valesbsf = sum(a.montodivisa) from movdivisa a, movimien b                
                
where a.operacion in (select operacion from enlaces where operacion = a.operacion and operacioncierre is null)                
                
and a.codtipo = 7 and a.divisa = '44' and a.operacion = b.operacion and b.estado <> 'R' and b.codtransaccion = 8                
                
                 
                
select @valesusd = sum(a.montodivisa) from movdivisa a, movimien b                
                
where a.operacion in (select operacion from enlaces where operacion = a.operacion and operacioncierre is null)                
                
and a.codtipo = 7 and a.divisa = '1' and a.operacion = b.operacion and b.estado <> 'R' and b.codtransaccion = 8                
                
                 
                
select @valesdiv = sum(a.montodivisa/a.fixingref) from movdivisa a, movimien b                
                
where a.operacion in (select operacion from enlaces where operacion = a.operacion and operacioncierre is null)                
                
and a.codtipo = 7 and a.divisa not in ('35','44') and a.divisa <> '1' and a.operacion = b.operacion and b.estado <> 'R' and b.codtransaccion = 8                
                
and a.fixingref>0                
                
                 
                
if @valesbs is null                 
                
begin                
                
         select @valesbs = 0                
                
end                
                
                 
                
                 
                
if @valesbsf is null                 
                
begin                
                
         select @valesbsf = 0                
                
end                
                
                 
                
                 
                
if @valesusd is null                 
                
begin                
                
         select @valesusd = 0                
                
end                
                
                 
                
if @valesdiv is null                 
                
begin                
                
         select @valesdiv = 0             
               
end                
                
                 
                
/*update counters set Umonto_43_1=@Umonto_43_1,Utasa_43_1=@Utasa_43_1,Uoper_43_1=@Uoper_43_1,                
                
Umonto_44_1=@Umonto_44_1,Utasa_44_1=@Utasa_44_1,Uoper_44_1=@Uoper_44_1,Umonto_43_2=@Umonto_43_2,                
                
Utasa_43_2=@Utasa_43_2,Uoper_43_2=@Uoper_43_2,Umonto_44_2=@Umonto_44_2,Utasa_44_2=@Utasa_44_2,                
                
Uoper_44_2=@Uoper_44_2,Umonto_11_2=@Umonto_11_2,Utasa_11_2=@Utasa_11_2,Uoper_11_2=@Uoper_11_2,                
                
Umonto_55_2=@Umonto_55_2,Utasa_55_2=@Utasa_55_2,Uoper_55_2=@Uoper_55_2,Umonto_67_67=@Umonto_67_67,                
                
                
Utasa_67_67=@Utasa_67_67,Uoper_67_67=@Uoper_67_67,Umonto_66_66=@Umonto_66_66,Utasa_66_66=@Utasa_66_66,                
                
Uoper_66_66=@Uoper_66_66,Umonto_49_3=@Umonto_49_3,Utasa_49_3=@Utasa_49_3,Uoper_49_3=@Uoper_49_3,                
                
Umonto_56_3=@Umonto_56_3,Utasa_56_3=@Utasa_56_3,Uoper_56_3=@Uoper_56_3,Umonto_87_8=@Umonto_87_8,                
                
Utasa_87_8=@Utasa_87_8,Uoper_87_8=@Uoper_87_8,Umonto_92_9=@Umonto_92_9,Utasa_92_9=@Utasa_92_9,                
                
Uoper_92_9=@Uoper_92_9,Umonto_93_10=@Umonto_93_10,Utasa_93_10=@Utasa_93_10,Uoper_93_10=@Uoper_93_10,                
                
Umonto_94_11=@Umonto_94_11,Utasa_94_11=@Utasa_94_11,Uoper_94_11=@Uoper_94_11,Umonto_33_15=@Umonto_33_15,                
                
Utasa_33_15=@Utasa_33_15,Uoper_33_15=@Uoper_33_15,Umonto_34_16=@Umonto_34_16,Utasa_34_16=@Utasa_34_16,                
                
Uoper_34_16=@Uoper_34_16,Dmonto_43_1=@Dmonto_43_1,Dtasa_43_1=@Dtasa_43_1,Doper_43_1=@Doper_43_1,                
                
Dmonto_44_1=@Dmonto_44_1,Dtasa_44_1=@Dtasa_44_1,Doper_44_1=@Doper_44_1,Dmonto_43_2=@Dmonto_43_2,                
                
Dtasa_43_2=@Dtasa_43_2,Doper_43_2=@Doper_43_2,Dmonto_44_2=@Dmonto_44_2,Dtasa_44_2=@Dtasa_44_2,                
                
Doper_44_2=@Doper_44_2,Dmonto_11_2=@Dmonto_11_2,Dtasa_11_2=@Dtasa_11_2,Doper_11_2=@Doper_11_2,                
                
Dmonto_55_2=@Dmonto_55_2,Dtasa_55_2=@Dtasa_55_2,Doper_55_2=@Doper_55_2,Dmonto_49_3=@Dmonto_49_3,                
                
Dtasa_49_3=@Dtasa_49_3,Doper_49_3=@Doper_49_3,Dmonto_56_3=@Dmonto_56_3,Dtasa_56_3=@Dtasa_56_3,                
                
Doper_56_3=@Doper_56_3,Dmonto_92_9=@Dmonto_92_9,Dtasa_92_9=@Dtasa_92_9,Doper_92_9=@Doper_92_9,                
                
Dmonto_93_10=@Dmonto_93_10,Dtasa_93_10=@Dtasa_93_10,Doper_93_10=@Doper_93_10,Dmonto_94_11=@Dmonto_94_11,                
                
Dtasa_94_11=@Dtasa_94_11,Doper_94_11=@Doper_94_11,CCmonto=@CCmonto,CCtasa=@CCtasa,CCoper=@CCoper,                
                
CVmonto=@CVmonto,CVtasa=@CVtasa,CVoper=@CVoper,CPCmonto=@CPCmonto,CPCoper=@CPCoper,CPVmonto=@CPVmonto,                
                
CPVoper=@CPVoper,CICmonto=@CICmonto,CICoper=@CICoper,CIVmonto=@CIVmonto,CIVoper=@CIVoper,                
                
CCHmonto=@CCHmonto,CHCmonto=@CHCmonto,EBs=@EBs,EUSD=@EUSD,ECity=@ECity,EThom=@EThom,EVisa=@EVisa,                
                
EAmex=@EAmex,Umonto_62_2=@Umonto_62_2,Utasa_62_2=@Utasa_62_2,Uoper_62_2=@Uoper_62_2,                
                
Umonto_62_2_C=@Umonto_62_2_C,Utasa_62_2_C=@Utasa_62_2_C,Uoper_62_2_C=@Uoper_62_2_C,Chcmontod=@Chcmontod,                
                
Eeur=@Eeur,EThomeur=@EThomeur,EAmexeur=@EAmexeur,EThomd=@EThomd,EVisad=@EVisad,valesbs=@valesbs,                
                
valesusd=@valesusd,valesdiv=@valesdiv,Umonto_43_12=@Umonto_43_12,Utasa_43_12=@Utasa_43_12,                
                
Uoper_43_12=@Uoper_43_12,Umonto_44_12=@Umonto_44_12,Utasa_44_12=@Utasa_44_12,Uoper_44_12=@Uoper_44_12,                
                
Dmonto_43_12=@Dmonto_43_12,Dtasa_43_12=@Dtasa_43_12,Doper_43_12=@Doper_43_12,Dmonto_44_12=@Dmonto_44_12,                
                
Dtasa_44_12=@Dtasa_44_12,Doper_44_12=@Doper_44_12,edivisa=@edivisa,eamexd=@eamexd,chctasa=@chctasa,                
                
chcoper=@chcoper,chctasad=@chctasad,chcoperd=@chcoperd,chcmontoe=@chcmontoe,chctasae=@chctasae,chcopere=@chcopere                 
                
where fecha = @fecha and codagencia = @ag                
                
                 
                
insert into replica (codagencia, sqltext, status) values (1, 'update                 
                
counters set Umonto_43_1='+convert(varchar(20),@Umonto_43_1)+',Utasa_43_1='+convert(varchar(20),@Utasa_43_1)+',                
                
Uoper_43_1='+convert(varchar(20),@Uoper_43_1)+',Umonto_44_1='+convert(varchar(20),@Umonto_44_1)+',                
                
Utasa_44_1='+convert(varchar(20),@Utasa_44_1)+',Uoper_44_1='+convert(varchar(20),@Uoper_44_1)+',                
                
Umonto_43_2='+convert(varchar(20),@Umonto_43_2)+',Utasa_43_2='+convert(varchar(20),@Utasa_43_2)+',                
                
Uoper_43_2='+convert(varchar(20),@Uoper_43_2)+',Umonto_44_2='+convert(varchar(20),@Umonto_44_2)+',                
                
Utasa_44_2='+convert(varchar(20),@Utasa_44_2)+',Uoper_44_2='+convert(varchar(20),@Uoper_44_2)+',                
                
Umonto_11_2='+convert(varchar(20),@Umonto_11_2)+',Utasa_11_2='+convert(varchar(20),@Utasa_11_2)+',                
                
Uoper_11_2='+convert(varchar(20),@Uoper_11_2)+',Umonto_55_2='+convert(varchar(20),@Umonto_55_2)+',                
                
Utasa_55_2='+convert(varchar(20),@Utasa_55_2)+',Uoper_55_2='+convert(varchar(20),@Uoper_55_2)+',                
                
Umonto_67_67='+convert(varchar(20),@Umonto_67_67)+',Utasa_67_67='+convert(varchar(20),@Utasa_67_67)+',                
                
Uoper_67_67='+convert(varchar(20),@Uoper_67_67)+',Umonto_66_66='+convert(varchar(20),@Umonto_66_66)+',                
                
Utasa_66_66='+convert(varchar(20),@Utasa_66_66)+',Uoper_66_66='+convert(varchar(20),@Uoper_66_66)+',                
                
Umonto_49_3='+convert(varchar(20),@Umonto_49_3)+',Utasa_49_3='+convert(varchar(20),@Utasa_49_3)+',                
                
Uoper_49_3='+convert(varchar(20),@Utasa_49_3)+',Umonto_56_3='+convert(varchar(20),@Umonto_56_3)+',                
                
Utasa_56_3='+convert(varchar(20),@Utasa_56_3)+',Uoper_56_3='+convert(varchar(20),@Uoper_56_3)+',                
                
Umonto_87_8='+convert(varchar(20),@Umonto_87_8)+',Utasa_87_8='+convert(varchar(20),@Utasa_87_8)+',                
                
Uoper_87_8='+convert(varchar(20),@Uoper_87_8)+',Umonto_92_9='+convert(varchar(20),@Umonto_92_9)+',                
                
Utasa_92_9='+convert(varchar(20),@Utasa_92_9)+',Uoper_92_9='+convert(varchar(20),@Uoper_92_9)+',                
                
Umonto_93_10='+convert(varchar(20),@Umonto_93_10)+',Utasa_93_10='+convert(varchar(20),@Utasa_93_10)+',                
                
Uoper_93_10='+convert(varchar(20),@Uoper_93_10)+',Umonto_94_11='+convert(varchar(20),@Umonto_94_11)+',                
                
Utasa_94_11='+convert(varchar(20),@Utasa_94_11)+',Uoper_94_11='+convert(varchar(20),@Uoper_94_11)+',                
                
Umonto_33_15='+convert(varchar(20),@Umonto_33_15)+',Utasa_33_15='+convert(varchar(20),@Utasa_33_15)+',                
                
Uoper_33_15='+convert(varchar(20),@Umonto_33_15)+',Umonto_34_16='+convert(varchar(20),@Umonto_34_16)+',                                
Utasa_34_16='+convert(varchar(20),@Utasa_34_16)+',Uoper_34_16='+convert(varchar(20),@Uoper_34_16)+',                
                
Dmonto_43_1='+convert(varchar(20),@Dmonto_43_1)+',Dtasa_43_1='+convert(varchar(20),@Dtasa_43_1)+',                
                
Doper_43_1='+convert(varchar(20),@Doper_43_1)+',Dmonto_44_1='+convert(varchar(20),@Dmonto_44_1)+',                
                
Dtasa_44_1='+convert(varchar(20),@DTasa_44_1)+',Doper_44_1='+convert(varchar(20),@Doper_44_1)+',                
                
Dmonto_43_2='+convert(varchar(20),@Dmonto_43_2)+',Dtasa_43_2='+convert(varchar(20),@DTasa_43_2)+',                
                
Doper_43_2='+convert(varchar(20),@Doper_43_2)+',Dmonto_44_2='+convert(varchar(20),@Dmonto_44_2)+',                
                
Dtasa_44_2='+convert(varchar(20),@DTasa_44_2)+',Doper_44_2='+convert(varchar(20),@Doper_44_2)+',                
                
Dmonto_11_2='+convert(varchar(20),@Dmonto_11_2)+',Dtasa_11_2='+convert(varchar(20),@Dtasa_11_2)+',                
                
Doper_11_2='+convert(varchar(20),@Doper_11_2)+',Dmonto_55_2='+convert(varchar(20),@Dmonto_55_2)+',                
                
Dtasa_55_2='+convert(varchar(20),@DTasa_55_2)+',Doper_55_2='+convert(varchar(20),@DOper_55_2)+',                
                
Dmonto_49_3='+convert(varchar(20),@Dmonto_49_3)+',Dtasa_49_3='+convert(varchar(20),@DTasa_49_3)+',                
                
Doper_49_3='+convert(varchar(20),@DOper_49_3)+',Dmonto_56_3='+convert(varchar(20),@Dmonto_56_3)+',                
                
Dtasa_56_3='+convert(varchar(20),@DTasa_56_3)+',Doper_56_3='+convert(varchar(20),@Doper_56_3)+',                
                
Dmonto_92_9='+convert(varchar(20),@Dmonto_92_9)+',Dtasa_92_9='+convert(varchar(20),@Dtasa_92_9)+',                
                
Doper_92_9='+convert(varchar(20),@Doper_92_9)+',Dmonto_93_10='+convert(varchar(20),@Dmonto_93_10)+',                
                
Dtasa_93_10='+convert(varchar(20),@Dtasa_93_10)+',Doper_93_10='+convert(varchar(20),@Doper_93_10)+',                
                
Dmonto_94_11='+convert(varchar(20),@Dmonto_94_11)+',Dtasa_94_11='+convert(varchar(20),@Dtasa_94_11)+',                
                
Doper_94_11='+convert(varchar(20),@Doper_94_11)+',CCmonto='+convert(varchar(20),@ccmonto)+',                
                
CCtasa='+convert(varchar(20),@CCtasa)+',CCoper='+convert(varchar(20),@CCoper)+',                
                
CVmonto='+convert(varchar(20),@CVmonto)+',CVtasa='+convert(varchar(20),@CVtasa)+',                
                
CVoper='+convert(varchar(20),@CVoper)+',CPCmonto='+convert(varchar(20),@CPCmonto)+',                
                
CPCoper='+convert(varchar(20),@CPCOper)+',CPVmonto='+convert(varchar(20),@CPVMonto)+',                
                
CPVoper='+convert(varchar(20),@CPVOper)+',CICmonto='+convert(varchar(20),@CICmonto)+',                
                
CICoper='+convert(varchar(20),@CICoper)+',CIVmonto='+convert(varchar(20),@CIVmonto)+',                
                
CIVoper='+convert(varchar(20),@CIVoper)+',CCHmonto='+convert(varchar(20),@CCHmonto)+',                
                
CHCmonto='+convert(varchar(20),@CHCmonto)+',EBs='+convert(varchar(20),@EBs)+',                
                
EUSD='+convert(varchar(20),@EUSD)+',ECity='+convert(varchar(20),@ECity)+',                
                
EThom='+convert(varchar(20),@EThom)+',EVisa='+convert(varchar(20),@EVisa)+',EAmex='+convert(varchar(20),@EAmex)+',                
                
Umonto_62_2='+convert(varchar(20),@Umonto_62_2)+',Utasa_62_2='+convert(varchar(20),@Utasa_62_2)+',                
                
Uoper_62_2='+convert(varchar(20),@Uoper_62_2)+',Umonto_62_2_C='+convert(varchar(20),@Umonto_62_2_C)+',                
                
Utasa_62_2_C='+convert(varchar(20),@Utasa_62_2_C)+',Uoper_62_2_C='+convert(varchar(20),@Uoper_62_2_C)+',                
                
Chcmontod='+convert(varchar(20),@Chcmontod)+',Eeur='+convert(varchar(20),@Eeur)+',EThomeur='+convert(varchar(20),@EThomeur)+',                
                
EAmexeur='+convert(varchar(20),@EAmexeur)+',EThomd='+convert(varchar(20),@EThomd)+',                
                
EVisad='+convert(varchar(20),@EVisad)+',valesbs='+convert(varchar(20),@valesbs)+',valesusd='+convert(varchar(20),@valesusd)+',                
                
valesdiv='+convert(varchar(20),@valesdiv)+',Umonto_43_12='+convert(varchar(20),@Umonto_43_12)+',                
                
Utasa_43_12='+convert(varchar(20),@Utasa_43_12)+',Uoper_43_12='+convert(varchar(20),@Uoper_43_12)+',                
                
Umonto_44_12='+convert(varchar(20),@Umonto_44_12)+',Utasa_44_12='+convert(varchar(20),@Utasa_44_12)+',                
                
Uoper_44_12='+convert(varchar(20),@Uoper_44_12)+',Dmonto_43_12='+convert(varchar(20),@Dmonto_43_12)+',     
                
Dtasa_43_12='+convert(varchar(20),@Dtasa_43_12)+',Doper_43_12='+convert(varchar(20),@Doper_43_12)+',                
                
Dmonto_44_12='+convert(varchar(20),@Dmonto_44_12)+',Dtasa_44_12='+convert(varchar(20),@Dtasa_44_12)+',                
                
Doper_44_12='+convert(varchar(20),@Doper_44_12)+',edivisa='+convert(varchar(20),@edivisa)+',eamexd='+convert(varchar(20),@eamexd)+',                
                
chctasa='+convert(varchar(20),@chctasa)+',chcoper='+convert(varchar(20),@chcoper)+',chctasad='+convert(varchar(20),@chctasad)+',                
                
chcoperd='+convert(varchar(20),@chcoperd)+',chcmontoe='+convert(varchar(20),@chcmontoe)+',                 
                
chctasae='+convert(varchar(20),@chctasae)+',chcopere='+convert(varchar(20),@chcopere)+'                
                
where fecha = '+convert(varchar(10),@fecha)+'and codagencia = '+convert(varchar(3),@ag)+'','N')                
                
*/                 
                
                 
                
delete counters where codagencia = @ag and fecha = @fecha                
                
                 
                
insert into replica (codagencia, sqltext, status) values (1, 'delete counters where (codagencia = '+convert(varchar(3),@ag)+') and (fecha = '+convert(varchar(10),@fecha)+')', 'N')                
                
                 
                
insert into                 
                
counters(fecha, codagencia, Umonto_43_1,Utasa_43_1,Uoper_43_1,Umonto_44_1,Utasa_44_1,Uoper_44_1,Umonto_43_2,Utasa_43_2,                
                
Uoper_43_2,Umonto_44_2,Utasa_44_2,Uoper_44_2,Umonto_11_2,Utasa_11_2,Uoper_11_2,Umonto_55_2,Utasa_55_2,Uoper_55_2,                
                
Umonto_67_67,Utasa_67_67,Uoper_67_67,Umonto_66_66,Utasa_66_66,Uoper_66_66,Umonto_49_3,Utasa_49_3,Uoper_49_3,Umonto_56_3,                
                
Utasa_56_3,Uoper_56_3,Umonto_87_8,Utasa_87_8,Uoper_87_8,Umonto_92_9,Utasa_92_9,Uoper_92_9,                
                
Umonto_93_10,Utasa_93_10,Uoper_93_10,Umonto_94_11,Utasa_94_11,Uoper_94_11,Umonto_33_15,                
                
Utasa_33_15,Uoper_33_15,Umonto_34_16,Utasa_34_16,Uoper_34_16,Dmonto_43_1,Dtasa_43_1,Doper_43_1,                
                
Dmonto_44_1,Dtasa_44_1,Doper_44_1,Dmonto_43_2,Dtasa_43_2,Doper_43_2,Dmonto_44_2,Dtasa_44_2,                
                
Doper_44_2,Dmonto_11_2,Dtasa_11_2,Doper_11_2,Dmonto_55_2,Dtasa_55_2,Doper_55_2,Dmonto_49_3,                
                
Dtasa_49_3,Doper_49_3,Dmonto_56_3,Dtasa_56_3,Doper_56_3,Dmonto_92_9,Dtasa_92_9,Doper_92_9,                
                
Dmonto_93_10,Dtasa_93_10,Doper_93_10,Dmonto_94_11,Dtasa_94_11,Doper_94_11,CCmonto,CCtasa,CCoper,                
                
CVmonto,CVtasa,CVoper,CPCmonto,CPCoper,CPVmonto,CPVoper,CICmonto,CICoper,CIVmonto,CIVoper,                
                
CCHmonto,CHCmonto,EBs,EUSD,ECity,EThom,EVisa,EAmex,Umonto_62_2,Utasa_62_2,Uoper_62_2,                
                
Umonto_62_2_C,Utasa_62_2_C,Uoper_62_2_C,Chcmontod,Eeur,EThomeur,EAmexeur,EThomd,EVisad,                
                
valesbs,valesusd,valesdiv,Umonto_43_12,Utasa_43_12,Uoper_43_12,Umonto_44_12,Utasa_44_12,                
                
Uoper_44_12,Dmonto_43_12,Dtasa_43_12,Doper_43_12,Dmonto_44_12,Dtasa_44_12,Doper_44_12,edivisa,                
                
eamexd,emonto_43_2,etasa_43_2,eoper_43_2,emonto_44_2,etasa_44_2,eoper_44_2,chctasa,chcoper,                
                
chctasad,chcoperd,chcmontoe,chctasae,chcopere, Dmonto_562_12,Dtasa_562_12,Doper_562_12, umonto_562_12,utasa_562_12,uoper_562_12)                
                
values                
                
(@fecha, @ag,@Umonto_43_1,@Utasa_43_1,@Uoper_43_1,@Umonto_44_1,@Utasa_44_1,@Uoper_44_1,                
                
@Umonto_43_2,@Utasa_43_2,@Uoper_43_2,@Umonto_44_2,@Utasa_44_2,@Uoper_44_2,@Umonto_11_2,                
                
@Utasa_11_2,@Uoper_11_2,@Umonto_55_2,@Utasa_55_2,@Uoper_55_2,@Umonto_67_67,@Utasa_67_67,                
                
@Uoper_67_67,@Umonto_66_66,@Utasa_66_66,@Uoper_66_66,@Umonto_49_3,@Utasa_49_3,@Uoper_49_3,               
                
@Umonto_56_3,@Utasa_56_3,@Uoper_56_3,@Umonto_87_8,@Utasa_87_8,@Uoper_87_8,@Umonto_92_9,                
                
@Utasa_92_9,@Uoper_92_9,@Umonto_93_10,@Utasa_93_10,@Uoper_93_10,@Umonto_94_11,@Utasa_94_11,                
                
@Uoper_94_11,@Umonto_33_15,@Utasa_33_15,@Uoper_33_15,@Umonto_34_16,@Utasa_34_16,@Uoper_34_16,                
                
@Dmonto_43_1,@Dtasa_43_1,@Doper_43_1,@Dmonto_44_1,@Dtasa_44_1,@Doper_44_1,@Dmonto_43_2,                
                
@Dtasa_43_2,@Doper_43_2,@Dmonto_44_2,@Dtasa_44_2,@Doper_44_2,@Dmonto_11_2,@Dtasa_11_2,                
                
@Doper_11_2,@Dmonto_55_2,@Dtasa_55_2,@Doper_55_2,@Dmonto_49_3,@Dtasa_49_3,@Doper_49_3,                
                
@Dmonto_56_3,@Dtasa_56_3,@Doper_56_3,@Dmonto_92_9,@Dtasa_92_9,@Doper_92_9,@Dmonto_93_10,                
                
@Dtasa_93_10,@Doper_93_10,@Dmonto_94_11,@Dtasa_94_11,@Doper_94_11,@CCmonto,@CCtasa,@CCoper,                
                
@CVmonto,@CVtasa,@CVoper,@CPCmonto,@CPCoper,@CPVmonto,@CPVoper,@CICmonto,@CICoper,@CIVmonto,                
                
@CIVoper,@CCHmonto,@CHCmonto,@EBs,@EUSD,@ECity,@EThom,@EVisa,@EAmex,@Umonto_62_2,@Utasa_62_2,                 
                
@Uoper_62_2,@Umonto_62_2_C,@Utasa_62_2_C,@Uoper_62_2_C,@Chcmontod,@Eeur,@EThomeur,@EAmexeur,                
                
@EThomd,@EVisad,@valesbs,@valesusd,@valesdiv,@Umonto_43_12,@Utasa_43_12,@Uoper_43_12,                
                
@Umonto_44_12,@Utasa_44_12,@Uoper_44_12,@Dmonto_43_12,@Dtasa_43_12,@Doper_43_12,@Dmonto_44_12,                
                
@Dtasa_44_12,@Doper_44_12,isnull(@edivisa,0),@eamexd,@emonto_43_2,@etasa_43_2,@eoper_43_2,@emonto_44_2,                
                
@etasa_44_2,@eoper_44_2,@chctasa,@chcoper,@chctasad,@chcoperd,@chcmontoe,@chctasae,@chcopere,                
                
@Dmonto_562_12,@Dtasa_562_12,@Doper_562_12, @umonto_562_12,@utasa_562_12,@uoper_562_12)                
                
                 
             
insert into replica (codagencia, sqltext, status) values (1, 'insert into                 
                
counters(fecha, codagencia, Umonto_43_1,Utasa_43_1,Uoper_43_1,Umonto_44_1,Utasa_44_1,Uoper_44_1,                
                
Umonto_43_2,Utasa_43_2,Uoper_43_2,Umonto_44_2,Utasa_44_2,Uoper_44_2,Umonto_11_2,Utasa_11_2,                
                
Uoper_11_2,Umonto_55_2,Utasa_55_2,Uoper_55_2,Umonto_67_67,Utasa_67_67,Uoper_67_67,Umonto_66_66,                
                
Utasa_66_66,Uoper_66_66,Umonto_49_3,Utasa_49_3,Uoper_49_3,Umonto_56_3,Utasa_56_3,Uoper_56_3,                
                
Umonto_87_8,Utasa_87_8,Uoper_87_8,Umonto_92_9,Utasa_92_9,Uoper_92_9,Umonto_93_10,Utasa_93_10,                
                
Uoper_93_10,Umonto_94_11,Utasa_94_11,Uoper_94_11,Umonto_33_15,Utasa_33_15,Uoper_33_15,                
                
Umonto_34_16,Utasa_34_16,Uoper_34_16,Dmonto_43_1,Dtasa_43_1,Doper_43_1,Dmonto_44_1,Dtasa_44_1,                
                
Doper_44_1,Dmonto_43_2,Dtasa_43_2,Doper_43_2,Dmonto_44_2,Dtasa_44_2,Doper_44_2,Dmonto_11_2,                
                
Dtasa_11_2,Doper_11_2,Dmonto_55_2,Dtasa_55_2,Doper_55_2,Dmonto_49_3,Dtasa_49_3,Doper_49_3,                
                
Dmonto_56_3,Dtasa_56_3,Doper_56_3,Dmonto_92_9,Dtasa_92_9,Doper_92_9,Dmonto_93_10,Dtasa_93_10,                
                
Doper_93_10,Dmonto_94_11,Dtasa_94_11,Doper_94_11,CCmonto,CCtasa,CCoper,CVmonto,CVtasa,CVoper,                
                
CPCmonto,CPCoper,CPVmonto,CPVoper,CICmonto,CICoper,CIVmonto,CIVoper,CCHmonto,CHCmonto,EBs,EUSD,                
                
ECity,EThom,EVisa,EAmex,Umonto_62_2,Utasa_62_2,Uoper_62_2,Umonto_62_2_C,Utasa_62_2_C,                
                
Uoper_62_2_C,Chcmontod,Eeur,EThomeur,EAmexeur,EThomd,EVisad,valesbs,valesusd,valesdiv,                
                
Umonto_43_12,Utasa_43_12,Uoper_43_12,Umonto_44_12,Utasa_44_12,Uoper_44_12,Dmonto_43_12,                
                
Dtasa_43_12,Doper_43_12,Dmonto_44_12,Dtasa_44_12,Doper_44_12,edivisa,eamexd,emonto_43_2,                
                
etasa_43_2,eoper_43_2,emonto_44_2,etasa_44_2,eoper_44_2,chctasa,chcoper,chctasad,chcoperd,                
                
chcmontoe,chctasae,chcopere, Dmonto_562_12,Dtasa_562_12,Doper_562_12, umonto_562_12,utasa_562_12,uoper_562_12)                
                
values                
                
('+convert(varchar(10),@fecha)+', '+convert(varchar(3),@ag)+',                
                
'+convert(varchar(20),@Umonto_43_1)+','+convert(varchar(20),@Utasa_43_1)+','+                
                
convert(varchar(20),@Uoper_43_1)+','+convert(varchar(20),@Umonto_44_1)+','+                
                
convert(varchar(20),@Utasa_44_1)+','+convert(varchar(20),@Uoper_44_1)+','+                
                
convert(varchar(20),@Umonto_43_2)+','+convert(varchar(20),@Utasa_43_2)+','+                
                
convert(varchar(20),@Uoper_43_2)+','+convert(varchar(20),@Umonto_44_2)+','+                
                
convert(varchar(20),@Utasa_44_2)+','+convert(varchar(20),@Uoper_44_2)+','+                
                
convert(varchar(20),@Umonto_11_2)+','+convert(varchar(20),@Utasa_11_2)+','+                
                
convert(varchar(20),@Uoper_11_2)+','+convert(varchar(20),@Umonto_55_2)+','+                
                
convert(varchar(20),@Utasa_55_2)+','+convert(varchar(20),@Uoper_55_2)+','+                
                
convert(varchar(20),@Umonto_67_67)+','+convert(varchar(20),@Utasa_67_67)+','+                
                
convert(varchar(20),@Uoper_67_67)+','+convert(varchar(20),@Umonto_66_66)+','+                
                
convert(varchar(20),@Utasa_66_66)+','+convert(varchar(20),@Uoper_66_66)+','+                
                
convert(varchar(20),@Umonto_49_3)+','+convert(varchar(20),@Utasa_49_3)+','+                
                
convert(varchar(20),@Uoper_49_3)+','+convert(varchar(20),@Umonto_56_3)+','+                
                
convert(varchar(20),@Utasa_56_3)+','+convert(varchar(20),@Uoper_56_3)+','+                
                
convert(varchar(20),@Umonto_87_8)+','+convert(varchar(20),@Utasa_87_8)+','+                
                
convert(varchar(20),@Uoper_87_8)+','+convert(varchar(20),@umonto_92_9)+','+                
                
convert(varchar(20),@utasa_92_9)+','+convert(varchar(20),@uoper_92_9)+','+                
                
convert(varchar(20),@umonto_93_10)+','+convert(varchar(20),@utasa_93_10)+','+                
                
convert(varchar(20),@uoper_93_10)+','+convert(varchar(20),@umonto_94_11)+','+                
                
convert(varchar(20),@utasa_94_11)+','+convert(varchar(20),@uoper_94_11)+','+                
                
convert(varchar(20),@Umonto_33_15)+','+convert(varchar(20),@Utasa_33_15)+','+                
                
convert(varchar(20),@Uoper_33_15)+','+convert(varchar(20),@umonto_34_16)+','+                
                
convert(varchar(20),@utasa_34_16)+','+convert(varchar(20),@uoper_34_16)+','+                
                
convert(varchar(20),@Dmonto_43_1)+','+convert(varchar(20),@Dtasa_43_1)+','+                
                
convert(varchar(20),@Doper_43_1)+','+convert(varchar(20),@Dmonto_44_1)+','+                
                
convert(varchar(20),@Dtasa_44_1)+','+convert(varchar(20),@Doper_44_1)+','+                
                
convert(varchar(20),@Dmonto_43_2)+','+convert(varchar(20),@Dtasa_43_2)+','+                
                
convert(varchar(20),@Doper_43_2)+','+convert(varchar(20),@Dmonto_44_2)+','+                
                
convert(varchar(20),@Dtasa_44_2)+','+convert(varchar(20),@Doper_44_2)+','+                
                
convert(varchar(20),@Dmonto_11_2)+','+convert(varchar(20),@Dtasa_11_2)+','+                
                
convert(varchar(20),@Doper_11_2)+','+convert(varchar(20),@Dmonto_55_2)+','+                
                
convert(varchar(20),@Dtasa_55_2)+','+convert(varchar(20),@Doper_55_2)+','+                
                
convert(varchar(20),@Dmonto_49_3)+','+convert(varchar(20),@Dtasa_49_3)+','+                
                
convert(varchar(20),@Doper_49_3)+','+convert(varchar(20),@Dmonto_56_3)+','+                
                
convert(varchar(20),@Dtasa_56_3)+','+convert(varchar(20),@Doper_56_3)+','+                
                
convert(varchar(20),@Dmonto_92_9)+','+convert(varchar(20),@Dtasa_92_9)+','+                
                
convert(varchar(20),@Doper_92_9)+','+convert(varchar(20),@dmonto_93_10)+','+                
                
convert(varchar(20),@dtasa_93_10)+','+convert(varchar(20),@doper_93_10)+','+                
                
convert(varchar(20),@dmonto_94_11)+','+convert(varchar(20),@dtasa_94_11)+','+                
                
convert(varchar(20),@doper_94_11)+','+convert(varchar(20),@CCmonto)+','+                
                
convert(varchar(20),@CCtasa)+','+convert(varchar(20),@CCoper)+','+                
                
convert(varchar(20),@CVmonto)+','+convert(varchar(20),@CVtasa)+','+                
                
convert(varchar(20),@CVoper)+','+convert(varchar(20),@CPCmonto)+','+                
                
convert(varchar(20),@CPCoper)+','+convert(varchar(20),@CPVmonto)+','+                
               
convert(varchar(20),@CPVoper)+','+convert(varchar(20),@CICmonto)+','+                
                
convert(varchar(20),@CICoper)+','+convert(varchar(20),@CIVmonto)+','+                
                
convert(varchar(20),@CIVoper)+','+convert(varchar(20),@CCHmonto)+','+                
                
convert(varchar(20),@CHCmonto)+','+convert(varchar(20),@EBs)+','+                
                
convert(varchar(20),@EUSD)+','+convert(varchar(20),@ECity)+','+convert(varchar(20),@EThom)+','+                
                
convert(varchar(20),@EVisa)+','+convert(varchar(20),@EAmex)+','+convert(varchar(20),@Umonto_62_2)+','+                
                
convert(varchar(20),@Utasa_62_2)+','+convert(varchar(20),@Uoper_62_2)+','+                
                
convert(varchar(20),@Umonto_62_2_C)+','+convert(varchar(20),@Utasa_62_2_C)+','+                
                
convert(varchar(20),@Uoper_62_2_C)+','+convert(varchar(20),@Chcmontod)+','+                
              
convert(varchar(20),@Eeur)+','+convert(varchar(20),@EThomeur)+','+                
                
convert(varchar(20),@EAmexeur)+','+convert(varchar(20),@EThomd)+','+                
                
convert(varchar(20),@EVisad)+','+convert(varchar(20),@valesbs)+','+                
                
convert(varchar(20),@valesusd)+','+convert(varchar(20),@valesdiv)+','+                
                
convert(varchar(20),@Umonto_43_12)+','+convert(varchar(20),@Utasa_43_12)+','+                
                
convert(varchar(20),@Uoper_43_12)+','+convert(varchar(20),@Umonto_44_12)+','+                
                
convert(varchar(20),@Utasa_44_12)+','+convert(varchar(20),@Uoper_44_12)+','+                
                
convert(varchar(20),@Dmonto_43_12)+','+convert(varchar(20),@Dtasa_43_12)+','+                
                
convert(varchar(20),@Doper_43_12)+','+convert(varchar(20),@Dmonto_44_12)+','+                
                
convert(varchar(20),@Dtasa_44_12)+','+convert(varchar(20),@Doper_44_12)+','+                
                
convert(varchar(20),isnull(@edivisa,0))+','+convert(varchar(20),@eamexd)+','+                
                
convert(varchar(20),@emonto_43_2)+','+convert(varchar(20),@etasa_43_2)+','+                
                
convert(varchar(20),@eoper_43_2)+','+convert(varchar(20),@emonto_44_2)+','+                
                
convert(varchar(20),@etasa_44_2)+','+convert(varchar(20),@eoper_44_2)+','+                
                
convert(varchar(20),@chctasa)+','+convert(varchar(20),@chcoper)+','+                
                
convert(varchar(20),@chctasad)+','+convert(varchar(20),@chcoperd)+','+                
                
convert(varchar(20),@chcmontoe)+','+convert(varchar(20),@chctasae)+','+                
                
convert(varchar(20),@chcopere)+','+                
                
convert(varchar(20),@Dmonto_562_12)+','+convert(varchar(20),@Dtasa_562_12)+','+                
                
convert(varchar(20),@Doper_562_12)+','+convert(varchar(20),@umonto_562_12)+','+                
                
convert(varchar(20),@utasa_562_12)+','+convert(varchar(20),@uoper_562_12)  +')', 'N')               
    
    