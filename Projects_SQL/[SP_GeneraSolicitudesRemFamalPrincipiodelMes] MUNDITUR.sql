    CREATE Procedure  [dbo].[SP_GeneraSolicitudesRemFamalPrincipiodelMes]              
as               
-- SE AGREGO QUE NO SE GENEREN SOLICITUDES CON MENOS DE 3 BENEFICIARIOS              
-- VALIDANDO CONTRA A TABLA TSOLNOAUT  (MARCOS CORTEZ 28-12-2009)              
--              
-- Se adapto para funcionar con el proceso de solicitudes automaticas...              
-- Marcos Cortez 30/11/2009               
-- Se corrigio error en replicacion, Marcos Cortez 05082009              
-- **************************************************************************************************              
-- Alter 29072009              
-- Modificado por:Daniel ledesma              
-- Modificado para que genere solo las solicitudes que fueron unificadas              
-- **************************************************************************************************              
-- **************************************************************************************************              
-- Alter 01032009              
-- Se modifico para que funcionara con Italgram              
-- para el 1ero de marzo no se van a generar automaticas              
-- se generaran en el transcurso del mes de marzo (Marcos Cortez)              
-- **************************************************************************************************              
--**************************************************************************************************            
--Alter 24082010            
--Modificado por VY , ya que la validacion de las cartas vencidas de los familiares y beneficiarios tiene que ser la misma que se             
--aplique al mismo criterio que Solicitudes y Conceptos a Cancelar en Caja            
--**************************************************************************************************            
--**************************************************************************************************            
--Alter 10092010            
--Modificado por VY , Se realiza un insert en Movimien con la Operacion de remesas_familiaressol, en vista de que se quiere             
--guardar con exactitud la fecha en que fue creada la solicitud ya que la fecha_sol de esta tabla es modificable.            
--**************************************************************************************************      
--**************************************************************************************************            
--Alter 04012012            
--Modificado por VY , Cuando el Instrumento sea IC se coloca II cuando la remesa vaya para Italgram Internacional.     
--**************************************************************************************************             
            
-- Variables del SP              
declare @Solicitud varchar(10)                
declare @OperacionSol varchar(20)                
declare @FecFinSem datetime                
                
-- Variables para Remesas_FamiliaresSol                
declare @OperacionRS varchar(20)                
declare @OperacionCierreRS varchar(20)                
declare @SolicitudRS varchar(10)                 
declare @Cod_SeguridadRS varchar(10)                 
declare @Auxiliar_SolRS varchar(11)                 
declare @email_SolRS varchar(50)                 
declare @Usuario_SolRS varchar(20)                 
declare @Fecha_SolRS datetime                
declare @Usuario_GerRS varchar(20)                 
declare @Fecha_GerRS datetime                
declare @EstadoRS varchar(1)                 
declare @Monto_SolRS money                
declare @CodAgenciaRS int                
declare @CantidadBenefRS int                
declare @REVISADARS varchar(1)                
declare @asistenciaplanillaRS varchar(1)                
declare @markRS char(1)                
declare @oprecdepRS varchar(20)                
declare @montorecibidoRS money                
declare @depositonroRS varchar(30)                
declare @statusdepRS char(1)                
declare @montoconsumidoRS money       
declare @ObservacionRS varchar(60)                
declare @Monto_TaquillaRS money                
declare @Monto_DevolverRS money                
declare @Fecha_Residencia datetime                
                
                
-- Variables para Remesas_FamiliaresBenef                
declare @OperacionBenefRB varchar(20)                 
declare @OperacionSolRB varchar(20)                
declare @SolicitudRB varchar(10)                 
declare @Auxiliar_BenefRB varchar(20)                
declare @BeneficiarioRB varchar(100)                 
declare @Auxiliar_SolRB varchar(11)                 
declare @ParentescoRB varchar(20)                 
declare @Dir_BenefRB varchar(200)                 
declare @Ciudad_BenefRB varchar(20)                 
declare @Pais_BenefRB varchar(40)                 
declare @ObservacionRB varchar(100)                
declare @Usuario_TaqRB varchar(20)                 
declare @Usuario_GerRB varchar(20)                
declare @Fecha_TaqRB datetime              
declare @Fecha_GerRB datetime                
declare @Requisitos_TaqRB varchar                
declare @Requisitos_GerRB varchar(20)                
declare @InstrumentoRB varchar(2)                 
declare @EstadoRB varchar(1)                 
declare @Monto_BenefRB money                
declare @Cod_AprobacionRB varchar(20)                
declare @AADRB varchar(15)                
declare @ALDRB varchar(15)                
declare @ClaveRB varchar(16)                
declare @SRADRB varchar(15)                
declare @usuario_aprob_CadiviRB varchar(20)                
declare @fecha_aprob_cadiviRB datetime                
declare @fecha_residenciaRB datetime                
declare @divisaRB varchar(6)                
declare @montodivisaRB money                
declare @tasaRB money                
declare @fixingRB money                
declare @OperacionFinalRB varchar(20)                
declare @destinoRB varchar(40)                
declare @serialislrRB varchar(10)                
declare @perimpRB int                
declare @Requisitos_CadiviRB varchar(10)                
declare @monto_instrumentoRB money                
declare @monto_recaudoRB money                
declare @RAFAGARB varchar(50)                
declare @fecha_denegRB datetime                
declare @nroconsecutivoRB varchar(20)                
declare @fecliqdevRB datetime                
declare @aux_rep varchar(40)                
declare @rep_nom1 varchar(50)                
declare @rep_nom2 varchar(50)                
declare @rep_apellido1 varchar(50)                
declare @rep_apellido2 varchar(50)                
declare @nombre_benef1 varchar(50)                
declare @nombre_benef2 varchar(50)                
declare @apellido_benef1 varchar(50)                
declare @apellido_benef2 varchar(50)                
declare @carta_auto varchar(10)                
declare @cod_ciudad varchar(3)                 
declare @cod_pais varchar(4)                
declare @cod_estado varchar(2)           
declare @FechaVencCartResi datetime              
                
-- Variable para enviar Datos a la Agencia                
DECLARE @sqltext varchar(5000)                
DECLARE @filtrarauto varchar(10)                
-- Variables para las nuevas solicitudes                
declare @OperacionSolNueva varchar(20)                
declare @TransaccionSol int                
set @TransaccionSol=533                
                
declare @OperacionBenefNueva varchar(20)                
declare @TransaccionBenef int                
set @TransaccionBenef=556                
                
declare @FechaSol datetime                
set @FechaSol=getdate()                
                
declare @agenciappal int                
set @agenciappal=1                
                
declare @conta int                
set @conta=0                
                
declare @contabenef int                
set @contabenef=0                
                
declare @agenciaactual int                
select @agenciaactual=convert(int,valor) from parametros where modulo='sacc' and clave='agencia'           
          
     
declare @tasaactual money                
select @tasaactual=tasaventa from Pdivisas where divisa='1' and codagencia=@agenciaactual  and codtipo=1      
                   
            
 -- update parametros set valor='SI' where clave like 'ACTTXPENS'  INACTIVADO POR ORDEN DEL SR CARLOS (MGCM MAYO 2013)   
   
-- ESTO ACTUALIZA DE TRASPASOS AQUELLAS SOLICITUDES QUE MONTARON EL MES PASADO PERO QUE REVERSARON LA CAJA, CON EL USUARIO DE SISTEMAS              
  
update traspasoplanillascadivi set observacion ='SYSTEM_AUT', operacioncierre='SYSTEM_AUT', tipo='R'   
from traspasoplanillascadivi t   
inner join remesas_familiaressol s on (s.operacion = t.opercarga)  
where t.fenviada is null and t.codtransaccion = 661  
and datediff(mm,s.fecha_ger,getdate()) > 0  
  
  
-- ESTO REVERSA DE ACTUALIZACION DE RECAUDOS AQUELLAS SOLICITUDES QUE MONTARON EL MES PASADO PERO QUE REVERSARON LA CAJA  
update tar set estado='R', user_contraloria='SISTEMAS'  
from traspasoplanillascadivi t   
inner join remesas_familiaressol s on (s.operacion = t.opercarga)  
inner join remesas_familiaresbenef b on (b.operacionsol = s.operacion)  
inner join tactualizarecaudos tar on (tar.operacion = b.operacion)  
where t.fenviada is null and t.codtransaccion = 661  
and datediff(mm,s.fecha_ger,getdate()) > 0    
   
                
/******** Agregado por Marcos Cortez el 08/04/2008 ********/                
/******** Para que si se corre varias veces este Sp no se dupliquen las remesas ********/                
delete solicitudesremfamxgenerar                
                
select   distinct r.solicitud,                 
            r.operacion                 
into  #solicitudxgenerartemp                 
from     remesas_familiaressol r                
    ---inner join tvalidaremesa tv on tv.solicitudunificada = r.solicitud                 
            inner join remesas_familiaresbenef b                
            on (r.operacion = b.operacionsol)                
          inner join uVwTrusadBenef t                
          on (t.auxiliarbenef = b.auxiliar_benef)                
where    datediff(mm,r.fecha_sol,getdate())=1                
            and r.operacioncierre is not null                 
            and b.estado not in ('R','D')      
            and r.estado not in ('D','R','E')    
            and b.instrumento not in ('JP')             
                          
-- Si alguna Solicitud este mes ya esta generada, la borro de solicitudesremfamxgenerar                
delete #solicitudxgenerartemp                
from remesas_familiaressol r, #solicitudxgenerartemp s                
where r.solicitud = s.solicitud and datediff(mm,r.fecha_sol,getdate())=0                
                
              
-- Inserto en solicitudesremfamxgenerar todo lo que debe generarse este mes                
insert    into       solicitudesremfamxgenerar                
select   solicitud,                
            operacion,                 
            substring(convert(varchar,getdate(),110),1,2)+'/01/'+substring(convert(varchar,getdate(),110),7,4) as fechadesde,                
            substring(convert(varchar,getdate()+35,110),1,2)+'/01/'+substring(convert(varchar,getdate()+35,110),7,4) as fechahasta,                
            'P' as status                
from     #solicitudxgenerartemp                
                
                
-- Codigo agregado el 31-05-2008 para que no se generen automaticamente                 
-- aquellas solicitudes que tienen env+os pendientes por hacer ... Marcos Cortez                
                
delete solicitudesremfamxgenerar                
from     remesas_familiaresbenef b                 
            inner join                 
            solicitudesremfamxgenerar s     on (s.solicitud=b.solicitud)                
where   b.cod_aprobacion is not null                 
            and b.usuario_aprob_cadivi is not null                
            and b.estado in ('X','A')       
            and isnull(b.operacionfinal,'') = ''                
                
--marcos cortez.... para no generarsolicitudes que tienen la carta de residencia vencida         
--Karen Trompetero..se comento para que se generen automaticamente las solicitudes a renovar        
/*                 
delete solicitudesremfamxgenerar                
from remesas_Familiaresbenef b inner join                 
solicitudesremfamxgenerar s on (b.solicitud=s.solicitud and b.operacionsol=s.operacion)                
inner join remesas_familiaressol r on (r.operacion=b.operacionsol)                
where             
                        datediff(mm,fecha_taq,getdate()) = 1            
AND ((dbo.uFnVencimiento(r.fecha_residencia,getdate()) = 1 OR dbo.uFnVencimiento(b.fecha_residencia,getdate()) = 1) AND r.Solicitud in ( Select Solicitud From tActualizarecaudos Where estado in ('E','M') and Operacion = b.Operacion and Solicitud = r.Soli
   
   
       
       
citud))             
AND b.estado <> 'R' */             
            
--Comentado y Modificado por VY 24-08-2010, ya que esta validacion tiene que ser la misma que se             
--aplique el mismo criterio que Solicitudes y Conceptos a Cancelar en Caja            
/*datediff(mm,fecha_taq,getdate())=1                
and               
(datediff(mm,b.fecha_residencia,getdate())>6                
 or datediff(mm,r.fecha_residencia,getdate())>6)              
and b.estado<>'R' */               
       
                
/*********** Codigo agregado por Marcos Cortez el 08/04/2008 ********************/                
/*********** Sirve para reversar aquellas remesas montadas en meses anteriores **/                
/*********** y que nunca pasaron por caja **************************************/              
                
update  remesas_familiaresbenef                 
set       estado='R'                 
from     remesas_familiaressol r                
inner     join       remesas_familiaresbenef b                 
            on (b.operacionsol=r.operacion)                
where    datediff(mm,r.fecha_sol,getdate())>0                 
            and r.operacioncierre is null                
            and isnull(b.cod_aprobacion,'')=''                
                
update remesas_familiaressol                 
set       operacioncierre='SISTEMAS_AUT',                 
            estado='R',                 
            observacion='no cancelada'                
from     remesas_familiaressol r                
inner     join       remesas_familiaresbenef b                 
            on (b.operacionsol=r.operacion)                
where    datediff(mm,r.fecha_sol,getdate())>0                 
  and r.operacioncierre is null                
            and isnull(b.cod_aprobacion,'')=''                
                
/***********************************************************************/                  
                
                
/* INICIO - ESTO VA A EVITAR QUE SE GENEREN AUTOMATICAMENTE SOLICITUDES QUE ALGUNA VEZ FUERON RECHAZADAS POR CONTRALORIA*/                
delete solicitudesremfamxgenerar                
from contraloria_cadivi c inner join                 
solicitudesremfamxgenerar s on (s.solicitud=c.solicitud)                
where estado='N'                
/* FIN - ESTO VA A EVITAR QUE SE GENEREN AUTOMATICAMENTE SOLICITUDES QUE ALGUNA VEZ FUERON RECHAZADAS POR CONTRALORIA*/                
              
              
SELECT @filtrarauto = valor FROM PARAMETROS WHERE CLAVE='FILTRAR_AUTOMATICAS' AND MODULO='SACC'              
              
If @filtrarauto='SI'              
begin              
    /* ESTO VA A EVITAR QUE SE GENEREN SOLICITUDES CON MENOS DE 3 BENEFICIARIOS */              
    delete solicitudesremfamxgenerar                
    from tsolnoaut c inner join                 
    solicitudesremfamxgenerar s on (s.solicitud=c.solicitud)                
    /* ESTO VA A EVITAR QUE SE GENEREN SOLICITUDES CON MENOS DE 3 BENEFICIARIOS */              
end                
                
/********************************************/                
-- CODIGO TEMPORAL AGREGADO PARA NO GENERAR AUTOMATICAS ..... EVENTUALMENTE, CUANDO SE SUSPENDEN               
--delete solicitudesremfamxgenerar                
--/********************************************/                
                
                 
set @contabenef = 0                   
DECLARE SOL CURSOR FOR                   
            Select   distinct s.Solicitud, s.Operacion, s.FecFinSem, R.Operacion, R.OperacionCierre, R.Solicitud,                
                        R.Cod_Seguridad,R.Auxiliar_Sol, R.email_Sol, R.Usuario_Sol, getdate(), R.Usuario_Ger, getdate(),                 
                        R.Estado, R.Monto_Sol, R.CodAgencia, R.CantidadBenef, R.REVISADA, R.asistenciaplanilla, R.mark,                 
                        R.oprecdep, R.montorecibido, R.depositonro, R.statusdep, R.montoconsumido, R.Observacion,                 
                        R.Monto_Taquilla, R.Monto_Devolver, R.Fecha_Residencia                
            from      solicitudesremfamxgenerar s                
                        inner     join       Remesas_FamiliaresSol R                
                        on         (s.solicitud=R.solicitud                 
                                    and s.operacion=R.Operacion                 
                                    and r.operacioncierre is not null                 
                                    and r.estado<>'R' )                
            where    datediff(dd,s.FecIniSem,getdate())>=0                 
                        and datediff(dd,s.FecFinSem,getdate())<=0                 
                        and s.Status='P'                 
OPEN SOL                
FETCH NEXT FROM  SOL                
INTO    @Solicitud, @OperacionSol, @FecFinSem, @OperacionRS, @OperacionCierreRS, @SolicitudRS,                 
            @Cod_SeguridadRS, @Auxiliar_SolRS, @email_SolRS, @Usuario_SolRS, @Fecha_SolRS, @Usuario_GerRS, @Fecha_GerRS,                 
            @EstadoRS, @Monto_SolRS, @CodAgenciaRS, @CantidadBenefRS, @REVISADARS, @asistenciaplanillaRS, @markRS,                 
            @oprecdepRS, @montorecibidoRS, @depositonroRS, @statusdepRS, @montoconsumidoRS, @ObservacionRS,                 
            @Monto_TaquillaRS, @Monto_DevolverRS, @Fecha_Residencia                
            WHILE @@FETCH_STATUS = 0                
            BEGIN                 
                        set @conta = @conta + 1                
                
                -- Generamos la Operacion de Remesa Familiar                
                        exec PutOperacion3 @agenciaactual, @FechaSol, @TransaccionSol, 'REMESAS FAMILIARES', @OperacionSolNueva OUTPUT                
                 
                        print 'SOLICITUD NRO: '+ @OperacionSolNueva                
                
                        print 'solicitud nro : '+@Solicitud+' y el contador va en: '+convert(varchar,@conta)                
                
                -- Hacemos otro cursor con los datos para hacer los registros de los beneficiarios                
                
                        DECLARE BENEF CURSOR FOR                   
                        Select  R.Solicitud, t.auxiliarbenef as Auxiliar_Benef, R.Beneficiario, R.Auxiliar_Sol, t.Parentesco,                 
                        t.direccion_benef as Dir_Benef, t.Ciudad_Benef, t.pais_residencia as Pais_Benef, '' as Observacion, R.Usuario_Taq,                 
                        R.Requisitos_Taq, R.Instrumento, 'G' as Estado, R.Monto_Benef, convert(datetime,t.cartaresid,103) as fecha_residencia, isnull(Auxiliar_TerceraPer,'') as aux_rep,                
                        isnull(b.nombre_benef1,'') as rep_nom1, isnull(b.nombre_benef2,'') as rep_nom2, isnull(b.apellido_benef1,'') as rep_apellido1, isnull(b.apellido_benef2,'') as rep_apellido2, R.divisa,                
                        R.montodivisa, R.tasa, R.fixing, R.destino, t.nombre_benef1, t.nombre_benef2,                
                    t.apellido_benef1, t.apellido_benef2, R.carta_auto, t.cod_ciudad, t.cod_pais, t.cod_estado, R.serialislr, R.perimp, r.FechaVencCartResi                
                     from      remesas_familiaressol s                
                        inner     join       Remesas_FamiliaresBenef R                
                                    on         (s.solicitud=R.solicitud and s.operacion=R.OperacionSol)                  
                                    ---inner join tvalidaremesa tv on tv.solicitudunificada = r.solicitud                          
                  inner join uVwTrusadBenef t on (t.auxiliarbenef = R.auxiliar_benef and t.solicitud=r.solicitud)                
                  left outer join tTercerasPersonasBenef p on (p.solicitud = s.solicitud and p.auxiliar_benef=r.auxiliar_benef)                
                  left outer join trusadbeneficiario b on (b.auxiliarbenef = p.Auxiliar_TerceraPer and b.solicitud=p.solicitud)                
                        where R.solicitud=@Solicitud                
                        and s.estado NOT IN ('R','D','E')                 
                                and s.operacioncierre is not null                
                                and r.parentesco not like 'CU_ADO%'                
                                AND R.ESTADO NOT IN ('R')                
                                and datediff(mm,r.fecha_taq,getdate())=1                
                                and datediff(mm,r.fecha_taq,r.fecha_ger)=0                                                    
                  OPEN BENEF                
    FETCH NEXT FROM BENEF                
                        INTO    @SolicitudRB, @Auxiliar_BenefRB, @BeneficiarioRB, @Auxiliar_SolRB,@ParentescoRB,                 
                        @Dir_BenefRB, @Ciudad_BenefRB, @Pais_BenefRB, @ObservacionRB, @Usuario_TaqRB,                 
                                @Requisitos_TaqRB, @InstrumentoRB, @EstadoRB, @Monto_BenefRB, @fecha_residenciaRB, @aux_rep,                 
                        @rep_nom1, @rep_nom2, @rep_apellido1, @rep_apellido2, @divisaRB,                 
                                @montodivisaRB, @tasaRB, @fixingRB, @destinoRB, @nombre_benef1, @nombre_benef2,                 
                        @apellido_benef1, @apellido_benef2, @carta_auto, @cod_ciudad, @cod_pais, @cod_estado, @serialislrRB, @perimpRB,@FechaVencCartResi                 
                        WHILE @@FETCH_STATUS = 0                
                        BEGIN                
                                    set @contabenef = @contabenef + 1                
                
                                    -- Generamos la Operacion de Remesa Familiar Beneficiario                
                
                                    print 'Solicitud #: '+@Solicitud+' beneficiario # :'+convert(varchar,@contabenef)     
                                        
                                    --****Agregado por VY 04-01-2012*************************************************    
                                    IF(@InstrumentoRB = 'IC')       
                                    BEGIN    
          SET @InstrumentoRB = 'II'    
                                    END    
                                    --******************************************************************************            
                
                                 exec uSpRegistroBenefGA   @SolicitudRB, @Auxiliar_BenefRB, @BeneficiarioRB, @Auxiliar_SolRB, @ParentescoRB,                 
                                                @Dir_BenefRB, @Ciudad_BenefRB, @Pais_BenefRB, @ObservacionRB, @Usuario_TaqRB,                 
                                                @Requisitos_TaqRB, @InstrumentoRB, @EstadoRB, @Monto_BenefRB, @fecha_residenciaRB, @FechaVencCartResi, @aux_rep,                 
                                                @rep_nom1, @rep_nom2, @rep_apellido1, @rep_apellido2, @divisaRB,                 
                                                @montodivisaRB, /*@tasaRB*/@tasaactual, @fixingRB, @destinoRB, @nombre_benef1, @nombre_benef2,                 
                                                @apellido_benef1, @apellido_benef2, @carta_auto, @cod_ciudad, @cod_pais, @cod_estado, @serialislrRB, @perimpRB,                
                                                @OperacionSolNueva, @OperacionBenefNueva output                
                
                                    print 'Operacion: '+@OperacionBenefNueva                
                
                
                                    FETCH NEXT FROM BENEF                
                              INTO   @SolicitudRB, @Auxiliar_BenefRB, @BeneficiarioRB, @Auxiliar_SolRB,@ParentescoRB,                 
                                 @Dir_BenefRB, @Ciudad_BenefRB, @Pais_BenefRB, @ObservacionRB, @Usuario_TaqRB,                 
                                     @Requisitos_TaqRB, @InstrumentoRB, @EstadoRB, @Monto_BenefRB, @fecha_residenciaRB, @aux_rep,                 
                                 @rep_nom1, @rep_nom2, @rep_apellido1, @rep_apellido2, @divisaRB,                 
                                     @montodivisaRB, @tasaRB, @fixingRB, @destinoRB, @nombre_benef1, @nombre_benef2,                 
                                 @apellido_benef1, @apellido_benef2, @carta_auto, @cod_ciudad, @cod_pais, @cod_estado, @serialislrRB, @perimpRB,@FechaVencCartResi                 
                
                                    END                
                        CLOSE BENEF                
                        DEALLOCATE BENEF                
                        IF @contabenef > 0                
                        BEGIN                
                                  -- Generamos la Solicitud de Remesa Familiar                
                                    Insert into Remesas_FamiliaresSol                                           (Operacion,Solicitud,Cod_Seguridad,                
                                    Auxiliar_Sol,email_Sol,Usuario_Sol,Fecha_Sol,Usuario_Ger,Fecha_Ger,Estado,                
                                    Monto_Sol,CodAgencia,CantidadBenef,REVISADA,asistenciaplanilla, fecha_residencia)                 
                                    values (@OperacionSolNueva, @Solicitud, @Cod_SeguridadRS,                 
                                    @Auxiliar_SolRS, @email_SolRS, 'SISTEMAS_AUT', @Fecha_SolRS, @Usuario_GerRS, @FechaSol, 'G',                 
                                    @Monto_SolRS, @agenciaactual, @CantidadBenefRS, @REVISADARS, @asistenciaplanillaRS, @Fecha_Residencia)                
                
                                   -- Generamos el script para replicar la Solicitud a la agencia correspondiente                
                                    Set @SqlText = 'Insert into Remesas_FamiliaresSol (Operacion,Solicitud,Cod_Seguridad, Auxiliar_Sol,email_Sol,'                
                                    +'Usuario_Sol,Fecha_Sol,Usuario_Ger,Fecha_Ger,Estado, Monto_Sol,CodAgencia,CantidadBenef,REVISADA,'                
                                    +'asistenciaplanilla, fecha_residencia) values ('+char(39)+@OperacionSolNueva+char(39)+','+char(39)+@Solicitud+char(39)                
                                    +','+char(39)+@Cod_SeguridadRS+char(39)+','+char(39)+@Auxiliar_SolRS+char(39)                
                                    +','+char(39)+@email_SolRS+char(39)+','+char(39)+@Usuario_SolRS+char(39)                
                                    +','+char(39)+convert(varchar(10),@Fecha_SolRS,110)+char(39)+','+char(39)+@Usuario_GerRS+char(39)                
                                    +','+char(39)+convert(varchar(10),@FechaSol,110)+char(39)+','+char(39)+'G'+Char(39)                
                                    +','+convert(varchar,@Monto_SolRS)+','+convert(varchar,@agenciaactual)                
                                    +','+convert(varchar,@CantidadBenefRS)+','+char(39)+@REVISADARS+char(39)                
                                    +','+char(39)+@asistenciaplanillaRS+char(39)                
                                    +','+char(39)+convert(varchar(10),@Fecha_Residencia,110)+char(39)+')'                
                
  -- Enviamos la Solicitud a la agencia correspondiente                
                                    insert into replica(codagencia,sqltext,status)  values (@agenciappal, @SqlText, 'N')                              
                                          set @contabenef = 0                
                                                      
                                                
                                    --Se Genera un movimien para saber exactamente la fecha de creacion de la solicitud            
                                                
                                    set @Sqltext = ''            
                                                
                                    Insert Into Movimien (Operacion,Efectivo,Cheque,Impuesto,Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,CodBcv,Total,CodAgencia)            
                                                 VALUES (@OperacionSolNueva,0,0,0,0,GETDATE(),0,@Auxiliar_SolRS,@Usuario_SolRS,533,'T',0,0,@agenciaactual)            
                                                
                                   set @Sqltext = 'Insert Into Movimien (Operacion,Efectivo,Cheque,Impuesto,Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,CodBcv,Total,CodAgencia) VALUES (' + char(39) +  @OperacionSolNueva + char(39) + 
  
   
       
        
          
',0,0,0,0,GETDATE(),0,' + char(39) + @Auxiliar_SolRS + char(39) + ',' + char(39) + @Usuario_SolRS + char(39) + ',533,''T'',0,0,'  + char(39) + convert(varchar(10),@agenciaactual) + char(39) + ')'            
                                                
                                               
                                   set @Sqltext = 'Insert Into Movimien (Operacion,Efectivo,Cheque,Impuesto,Tarjeta,Fecha,Reintegro,Auxiliar,CodUsuario,CodTransaccion,Estado,CodBcv,Total,CodAgencia) VALUES (' + char(39) +  @OperacionSolNueva + char(39) +'
  
    
      
        
          
,'+ convert(varchar(10),0)+','+convert(varchar(10),0)+','+convert(varchar(10),0)+','+convert(varchar(10),0)+','+'GETDATE()'+','+convert(varchar(10),0)+',' + char(39) + @Auxiliar_SolRS + char(39) + ',' + char(39) + @Usuario_SolRS + char(39) + ','+char(39)+
  
    
      
        
          
'533'+char(39)+','+char(39)+'T'+char(39)+','+convert(varchar(10),0)+','+convert(varchar(10),0)+','+ char(39) + convert(varchar(10),@agenciaactual) + char(39) + ')'             
                 
                                                                                                                                                                                                
                                   insert into replica(codagencia,sqltext,status)  values (@agenciappal, @SqlText, 'N')                 
                                   --**********************************************************************             
                                               
                                                   
                        END                
                        FETCH NEXT FROM  SOL                
                            INTO  @Solicitud, @OperacionSol, @FecFinSem, @OperacionRS, @OperacionCierreRS, @SolicitudRS, @Cod_SeguridadRS,                 
                        @Auxiliar_SolRS, @email_SolRS, @Usuario_SolRS, @Fecha_SolRS, @Usuario_GerRS, @Fecha_GerRS, @EstadoRS,           
                        @Monto_SolRS, @CodAgenciaRS, @CantidadBenefRS, @REVISADARS, @asistenciaplanillaRS, @markRS, @oprecdepRS,                 
                        @montorecibidoRS, @depositonroRS, @statusdepRS, @montoconsumidoRS, @ObservacionRS, @Monto_TaquillaRS,                 
                        @Monto_DevolverRS, @Fecha_Residencia                
            END                
CLOSE SOL                   
DEALLOCATE SOL     
  
  
  