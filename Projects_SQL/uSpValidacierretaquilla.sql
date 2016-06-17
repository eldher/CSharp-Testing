   
    
ALTER  PROCEDURE [dbo].[uSpValidacierretaquilla] @agencia VARCHAR(3),@FechaApertura VARCHAR(10),@ZONA_H INT,@EJECUCION INT,@OPER VARCHAR(20),@FUsuario VARCHAR(20),@statuscierre VARCHAR(2) OUT             
/***************************************************          
Creacion: 17/04/2008          
Operador:  Daniel Ledesma          
Referencia:  Procedimiento de cierre de taquilla          
****************************************************/          
AS          
DECLARE  @CONTADOR INT;            
DECLARE @ERROR VARCHAR(350);          
DECLARE @DIACHEQUE INT;          
DECLARE @DIAS INT;          
DECLARE @MONTO FLOAT;          
DECLARE @DIACHEQPENSION DATETIME;          
DECLARE @DIADEPPENDIENTE DATETIME;          
DECLARE @DIATRAVELPENDTRASP DATETIME;          
DECLARE @DIACHEQPENDTRASP DATETIME;          
DECLARE @DESDE  VARCHAR(12);          
DECLARE @HASTA VARCHAR (12);        
DECLARE @DIASTRANSF INT;          
DECLARE @DIASTESPEC INT;      
--DECLARE @DIASREMFAM INT;      
DECLARE @DIASREMESTUYESPEC INT;    
DECLARE @sendsql   VARCHAR (4000);    
        
BEGIN              
IF @EJECUCION = 1          
BEGIN          
 --'RevisANDo posibles operaciones pendientes...';          
 DECLARE @P INT          
 SELECT @P = (SELECT COUNT(OPERACION) FROM uVwAperturaAgencia WHERE codagencia =@agencia);          
 IF @P = 0           
      BEGIN          
  SELECT @ERROR ='no existe una apertura realizada';           
  SELECT    @CONTADOR = 1          
  --return(50001);          
  SELECT ERROR=(50001),DESCRIP =@ERROR ;          
  RETURN          
   END           
           
 SELECT @P =(SELECT COUNT(OPERACION) FROM uVwSolicitudespendientesnew  WHERE codagencia = @agencia);          
   IF  @P > 0          
    BEGIN          
  SELECT @ERROR ='existen solicitudes nuevas de Remesas Familiares pendientes en el modulo Aprobacion Solicitudes Nuevas'          
  SELECT    @CONTADOR = 1          
      --return(50002);          
  SELECT ERROR=(50002),DESCRIP =@ERROR ;          
  RETURN          
 END         
        
        
         
 --VERIFICA si existen remesas pendientes por pasar a control de cambio diarimente          
 SELECT @P = (SELECT COUNT(*) FROM uVwRemesaspendientescontrolcambio WHERE codagencia = @agencia);          
 IF @P > 0          
    BEGIN          
    SELECT @ERROR ='RECUERDE, las remesas familiares que están control de cambio de este dia...!!!'          
        -- return(50003)          
    SELECT ERROR=(50003),DESCRIP =@ERROR ;          
    RETURN          
 END          
 --VERIFICA si existen Traspasos Pendientes Realizar que sean Mayor a Tres Días **          
 SELECT @P = (SELECT COUNT(*) FROM uVwTraspasoscadivi);          
 IF @P > 0          
    BEGIN          
    SELECT @ERROR ='existen Traspasos de PLANILLAS CADIVI por Realizar Mayores o Iguales a 1 día(s)...!!! '          
        --return(50004)          
    SELECT ERROR=(50004),DESCRIP =@ERROR ;          
    RETURN          
 END          
 --Chequea que no existan operacion de Aereo que no hayan pasado por caja          
 SELECT @P =(SELECT COUNT(*) FROM uVwRelacionaereo);          
 IF @P > 0          
    BEGIN          
     SELECT @ERROR = 'existen operaciones relacionadas con Aereo que estan pendientes por Caja, se le agradece revisar esto para poder realizar el cierre.'          
         --return(50005)          
     SELECT ERROR=(50005),DESCRIP =@ERROR ;          
     RETURN          
        END          
 SELECT @ZONA_H = @ZONA_H;          
 IF @ZONA_H <> 0          
 BEGIN          
   -- Verifica si existen Traspasos Enviados a otras Agencias y que no hayan sido recibidos en su destino          
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasosagencias WHERE DATEDIFF(dd,fecha,GETDATE())> @ZONA_H);          
  IF @P > 0          
       BEGIN          
     SELECT @ERROR ='existen Traspasos enviados y aún están Pendientes por Recibir.'          
           --return(50006)          
       SELECT ERROR=(50006),DESCRIP =@ERROR ;          
       RETURN          
     END          
  --Verifica si existen Traspasos de Cheques pendientes por recibir          
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasoscheques WHERE DATEDIFF(dd,fecha,GETDATE())>@ZONA_H);          
  IF @P > 0       
        BEGIN          
        SELECT @ERROR ='existen Traspasos de Cheques Pendientes por Recibir.'          
           --return(50007)          
       SELECT ERROR=(50007),DESCRIP =@ERROR ;          
       RETURN          
      END          
  --Verifica si existen Traspasos de Travel pendientes por recibir          
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasostravel WHERE DATEDIFF(dd,fecha,GETDATE())>@ZONA_H);          
  IF @P > 0          
        BEGIN          
         SELECT @ERROR ='existen Traspasos de Travel Pendientes por Recibir.'          
             --return(50008)          
         SELECT ERROR=(50008),DESCRIP =@ERROR ;          
         RETURN          
      END          
 END          
  --Verifica si existen Travel Anulados Pendientes por Traspasar          
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasoschequesanulados WHERE codagencia = @agencia);          
  IF @P > 0          
        BEGIN          
   SELECT @ERROR ='existen Cheques de Viajeros Anulados Pendientes por Traspasar.'          
             --return(50009)          
         SELECT ERROR=(50009),DESCRIP =@ERROR ;          
         RETURN          
     END           
            
  SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='SACC' AND clave='VERIFICATRANSF' AND Valor ='SI');           
  IF @P > 0          
        BEGIN          
   SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='sacc' AND clave='TRANPENDIENTE')          
             
   IF @P = 0          
             BEGIN          
    SELECT @DIAS = 4           
       END          
       ELSE          
          SELECT @DIAS = CONVERT(INT ,(SELECT valor  FROM parametros WHERE modulo='sacc' AND clave='TRANPENDIENTE'))              
          SELECT @P =(SELECT COUNT(*) FROM uVwTransferenciasxautorizardias WHERE codagencia = @agencia);          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen transferencias con mas de '+ CONVERT(VARCHAR(2),@DIAS)+ ' dias por autorizar, se le agradece autorice las mismas para poder cerrar la agencia.';            
            -- return(50010)          
         SELECT ERROR=(50010),DESCRIP =@ERROR ;          
         RETURN          
      END          
      END          
  --Buscar operaciones de canje por cheque que no se imprimieron          
  SELECT @P =(SELECT COUNT(*) FROM uVwImpresioncanjecheque WHERE codagencia =@agencia)          
  IF @P > 0          
       BEGIN          
     SELECT @ERROR ='existen operaciones de canje con cheques que no se imprimieron, se le agradece revisar esto para poder realizar el cierre, a continuación la lista de estas operaciones.';            
        --MUESTRA FORMULARIO  FImprewlic.showmodal;           
           --return(50011)          
   SELECT ERROR=(50011),DESCRIP =@ERROR ;          
   RETURN          
       END          
  ---Valida que no transcurran mas de cinco dias sin efectuar la actualizacion          
  SELECT @DESDE =(SELECT valor FROM parametros WHERE Modulo='SACC' AND Clave='ACTUALIZO CLIENTES');          
  SELECT @HASTA = (SELECT CONVERT(CHAR(12), GETDATE(), 3));          
  SET DATEFORMAT DMY          
  IF (SELECT DATEDIFF(DAY, @DESDE,@HASTA))>5          
   BEGIN            
     SELECT @ERROR ='han transcurrido 5 días o mas sin efectuar la Actualización de Clientes'          
     --return(50012)          
    SELECT ERROR=(50012),DESCRIP =@ERROR ;          
    RETURN          
   END          
  --* * * * * * * * * Fin de la validación de actualizacion * * * * * * * * * * *          
  --VALIDA QUE LAS EMISIONES DE VALES IGUALES 0 MAYORES A TRES DIAS ESTEN CERRADAS          
  SELECT @P =(SELECT COUNT(valor) FROM Parametros WHERE modulo='SACC' AND clave='VALETRANS');           
  DECLARE @DIASP INT;          
  IF @P = 0              
            BEGIN          
    SELECT @DIASP = 3           
                 END           
      ELSE          
      SELECT @DIASP = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='VALETRANS'))              
      SELECT @P =(SELECT COUNT(operacion) FROM movimien WHERE codtransaccion = 8           
    AND DATEDIFF(dd,fecha,CONVERT(DATETIME,GETDATE(),103))>=@DIAS          
    AND Estado <> 'R' AND operacion IN (SELECT operacion FROM enlaces WHERE operacioncierre IS NULL))          
    IF @P > 0          
    BEGIN          
          SELECT @ERROR ='existen Emisiones de Vales Mayores a 3 Dias que no han sido cerradas'          
          --return(50013)          
         SELECT ERROR=(50013),DESCRIP =@ERROR ;          
         RETURN          
    END           
  -- Inicio del Codigo que valida que los traspasos de cheques devueltos no tengan mas de 5 dias.          
  SELECT @P =(SELECT COUNT(valor) FROM Parametros WHERE modulo='SACC' AND clave='Traspasos')           
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 5           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='Traspasos'))           
          
  SELECT @P =(SELECT COUNT(Fechatraspaso) FROM uVwTraspasochequesdevueltos)          
     IF @P > 0           
  BEGIN          
      DECLARE @FECHATRASPASO DATETIME          
      SELECT @FECHATRASPASO = (SELECT Fechatraspaso FROM uVwTraspasochequesdevueltos)          
      SELECT @DIACHEQUE = (SELECT DATEPART(dw, DATEADD (dd,@DIAS,@FECHATRASPASO)))          
         IF (@DIACHEQUE) IN (2, 3, 4, 5, 6)          
        BEGIN          
      SELECT @ERROR ='existen operaciones con cheques que no se han recibido por concepto de Traspaso.'          
       --MUESTRA FORMULARIO frmTraspasosPendientes.showmodal;          
   --return(50014)          
   SELECT ERROR=(50014),DESCRIP =@ERROR ;          
   RETURN          
         END          
  END          
  --Fin del Codigo para los traspasos de los cheques devueltos          
          
  SELECT @P =(SELECT COUNT(*) FROM uVwMovimientos WHERE codagencia =@agencia)          
  DECLARE @OPER_S VARCHAR (20)          
  IF @P > 0           
   BEGIN          
      SELECT @OPER_S = (SELECT Operacion FROM uVwMovimientos WHERE codagencia =@agencia)          
      SELECT @P =(SELECT COUNT(operacion) FROM MovBanco WHERE operacion= @OPER_S AND (Estado ='A') AND numeroref IN (SELECT SUBSTRING(N_STOPPAYMENT,5,LEN(n_stoppayment)-8) FROM stopPayment WHERE Usua_Telc IS NOT NULL))          
      IF @P > 0           
    BEGIN          
      SELECT @ERROR ='existen operaciones con cheques que no se imprimieron, se le agradece revisar esto para poder realizar el cierre, a continuación la lista de estas operaciones.'          
         --MUESTRA FORMULARIO FImpreGeneral.showmodal;          
     --return(50015)          
     SELECT ERROR=(50015),DESCRIP =@ERROR ;          
     RETURN          
    END          
   END          
  SELECT @P =(SELECT COUNT(*) FROM uVwOperacionescheqnoimpreso WHERE codagencia =@agencia)          
  IF @P > 0           
   BEGIN          
     SELECT @ERROR ='existen operaciones con cheques que no se imprimieron, se le agradece revisar esto para poder realizar el cierre, a continuación la lista de estas operaciones.'          
       --MUESTRA FORMULARIO FImpreGeneral.showmodal;          
    --return(50016)          
    SELECT ERROR=(50016),DESCRIP =@ERROR ;          
    RETURN          
   END          
  --Valida que no existan Cheq de Pensiones por recibir mayores a ciertos dias          
  SELECT @P =(SELECT COUNT(*) FROM Parametros WHERE modulo='SACC' AND clave='CHEQ_PENS')           
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 4           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='CHEQ_PENS'))           
          
  SELECT @P =(SELECT COUNT(*) FROM cheques WHERE estado = 'E')          
     IF @P > 0           
  BEGIN          
      DECLARE @FECHACHEQPENSION DATETIME          
      SELECT @FECHACHEQPENSION = (SELECT MAX(fechaclasif) AS fechaclasif FROM cheques WHERE estado = 'E')          
      SELECT @DIACHEQPENSION = (SELECT DATEADD (dd,@DIAS,@FECHACHEQPENSION))          
         IF (@DIACHEQPENSION) < GETDATE()          
        BEGIN          
      SELECT @ERROR ='existen Cheques de Pension pendientes por recibir, se le agradece reciba los mismos para poder cerrar la agencia.'          
       --return(50017)          
   SELECT ERROR=(50017),DESCRIP =@ERROR ;          
   RETURN          
         END          
  END          
  --VAlida Cheques de Pensiones que no han sido entregados desde su fecha de emision pasados 5 dias          
  SELECT @P =(SELECT COUNT(*) FROM parametros WHERE modulo='sacc' AND clave='DEVOLCHEQUEPEN')           
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 5           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='DEVOLCHEQUEPEN'))           
          
  SELECT @P =(SELECT COUNT(*) FROM cheques WHERE FechaEntrega IS NULL AND estado IS NULL AND DATEDIFF(dd,fechaemision,GETDATE())>= @DIAS AND numerocheque NOT IN (SELECT numerocheque FROM entregas))          
  IF @P > 0           
  BEGIN          
    SELECT @ERROR ='existen Cheques de Pensiones pendientes por Entregar, con más de 5 dias de Emisión - Ver Modulo de Pensiones la Opcion de Cheques por Vencer'          
    --MUESTRA FORMULARIO FChequevencido.showmodal;          
   --return(50018)          
   SELECT ERROR=(50018),DESCRIP =@ERROR ;          
   RETURN          
  END          
  --VAlida que no existan Depositos por validar mayores a ciertos dias          
  SELECT @P =(SELECT COUNT(*) FROM parametros WHERE modulo='sacc' AND clave='depotrans')           
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 3           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='depotrans'))          
           
  SELECT @P = (SELECT COUNT(*) FROM uVwDepositospendientesvalidar WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
    DECLARE @FECHADEPPENDIENTE DATETIME          
       SELECT @FECHADEPPENDIENTE = (SELECT FECHA  FROM uVwDepositospendientesvalidar WHERE codagencia =@agencia)          
       SELECT @DIADEPPENDIENTE = (SELECT DATEADD (dd,@DIAS,@FECHACHEQPENSION))          
          IF (@DIADEPPENDIENTE) < GETDATE()          
         BEGIN          
       SELECT @ERROR ='existen depositos pendientes por validar,se le agradece valide los mismos para poder cerrar la agencia.'          
        --return(50019)          
    SELECT ERROR=(50019),DESCRIP =@ERROR ;          
    RETURN          
          END          
  END          
  ---RevisANDo posibles operaciones de travel pendientes por caja          
  SELECT @P =(SELECT COUNT(*) FROM uVwTravelPendientecaja WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   SELECT @ERROR ='existen travel pendientes por caja, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
       --return(50020)          
   SELECT ERROR=(50020),DESCRIP =@ERROR ;          
   RETURN          
  END          
  ---RevisANDo posibles travel comprados pendientes por traspasar          
  SELECT @P =(SELECT COUNT(*) FROM  dbo.Parametros WHERE (Modulo = 'sacc') AND (Clave = 'TRAVELTRANS'))          
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 5           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='TRAVELTRANS'))          
            
  SELECT @P =(SELECT COUNT(*) FROM uVwTravelPendienteTraspaso WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   DECLARE @FECHATRAVELPENDTRASP DATETIME          
       SELECT @FECHATRAVELPENDTRASP = (SELECT FECHA  FROM uVwTravelPendienteTraspaso WHERE codagencia =@agencia)          
       SELECT @DIATRAVELPENDTRASP = (SELECT DATEADD (dd,@DIAS,@FECHATRAVELPENDTRASP))          
          IF (@DIATRAVELPENDTRASP) < GETDATE()          
         BEGIN          
       SELECT @ERROR ='existen travel comprados pendientes por traspasar, se le agradece revise esto para poder cerrar la agencia.'          
        --return(50021)          
    SELECT ERROR=(50021),DESCRIP =@ERROR ;          
    RETURN          
          END          
  END          
          
  --RevisANDo posibles cheques comprados pendientes de pasar por Caja.          
  SELECT @P = (SELECT COUNT(*) FROM uVwChequePendienteporcaja WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   SELECT @ERROR ='existen cheques comprados pendientes por caja, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
       --return(50022)          
   --MUESTRA FORMULARIO FcheqP.showmodal;          
   SELECT ERROR=(50022),DESCRIP =@ERROR ;          
   RETURN          
  END          
  --RevisANDo posibles canjes de cheques pendientes de pasar por Caja...          
  SELECT @P = (SELECT COUNT(*) FROM uVwCanjeChequePendienteporcaja WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   SELECT @ERROR ='existen canjes de cheques pendientes por caja, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
       --return(50023)          
   --MUESTRA FORMULARIO FcheqCan.showmodal;          
   SELECT ERROR=(50023),DESCRIP =@ERROR ;          
   RETURN          
  END          
            
  SELECT @P =(SELECT COUNT(*) FROM  dbo.Parametros WHERE (Modulo = 'sacc') AND (Clave = 'chequependxtrasp'))          
  IF @P = 0           
  BEGIN          
   SELECT @DIAS = 7           
             END          
  ELSE          
   SELECT @DIAS = CONVERT(INT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='chequependxtrasp'))          
            
  SELECT @P =(SELECT COUNT(*) FROM uVwCanjeChequePendienteportraspaso WHERE codagencia =@agencia)          
  IF @P > 0           
BEGIN          
   DECLARE @FECHACHEQPENDTRASP DATETIME          
       SELECT @FECHACHEQPENDTRASP = (SELECT FECHA  FROM uVwCanjeChequePendienteportraspaso WHERE codagencia =@agencia)          
       SELECT @DIACHEQPENDTRASP = (SELECT DATEADD (dd,@DIAS,@FECHACHEQPENDTRASP))          
          IF (@DIACHEQPENDTRASP) < GETDATE()          
         BEGIN          
       SELECT @ERROR ='existen cheques comprados pendientes por traspasar, se le agradece revise esto para poder cerrar la agencia.'          
        --return(50024)          
    SELECT ERROR=(50024),DESCRIP =@ERROR ;          
    RETURN          
          END          
  END          
            
  ---          
  ---          
  SELECT @P =(SELECT COUNT(*) FROM  dbo.Parametros WHERE (Modulo = 'sacc') AND (Clave = 'MONTOPENDXTRASP'))          
  IF @P = 0           
  BEGIN          
   SELECT @MONTO = 100000            
             END          
  ELSE          
   SELECT @MONTO = CONVERT(FLOAT ,(SELECT valor FROM Parametros WHERE modulo='SACC' AND clave='MONTOPENDXTRASP'))          
            
  SELECT @P =(SELECT COUNT(*) FROM uVwCanjeChequeCompradoPendportraspaso WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   DECLARE @MONTOCHEQUE FLOAT          
       SELECT @MONTOCHEQUE = (SELECT MONTO FROM uVwCanjeChequeCompradoPendportraspaso WHERE codagencia =@agencia)          
       IF (@MONTOCHEQUE) >= @MONTO          
         BEGIN          
       SELECT @ERROR ='existen cheques comprados pendientes por traspasar, se le agradece revise esto para poder cerrar la agencia.'          
        --return(50025)          
    SELECT ERROR=(50025),DESCRIP =@ERROR ;          
    RETURN          
          END          
  END          
  ---          
  ---          
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasospendienterecibir WHERE codagencia =@agencia)          
  IF @P > 0           
  BEGIN          
   SELECT @ERROR ='existen traspasos pendientes por recibir, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
       --return(50026)          
   --MUESTRA FORMULARIO Ftrasp.showmodal;          
   SELECT ERROR=(50026),DESCRIP =@ERROR ;          
   RETURN          
  END          
   --RevisANDo posibles traspasos MMLC pendientes por Recibir...             
  SELECT @P =(SELECT COUNT(*) FROM uVwTraspasosmmlcpendientes  WHERE codagencia =@agencia);          
  IF @P > 0          
  BEGIN          
         SELECT @ERROR ='existen traspasos de MMLC pendientes por recibir, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
          --return(50027)          
   --MUESTRA FORMULARIO Ftrasp.showmodal;          
   SELECT ERROR=(50027),DESCRIP =@ERROR ;          
   RETURN          
  END           
            
   --RevisANDo posibles MMLC vendidos pendientes por Cancelar...             
  SELECT @P =(SELECT COUNT(*) FROM uVwMmlcvendidosporcancelar WHERE codagencia =@agencia);          
  IF @P > 0          
  BEGIN          
         SELECT @ERROR ='existen MMLC vendidos pendientes por cancelar, la siguiente ventana le mostrará toda la información al respecto, se le agradece revise esto para poder cerrar la agencia.'          
          --return(50028)          
   --MUESTRA FORMULARIO Fventammc.showmodal;          
   SELECT ERROR=(50028),DESCRIP =@ERROR ;          
   RETURN          
  END           
            
   --RevisANDo posibles cajeras activas que no realizaron su Apertura ni su respectivo Cierre...          
  SELECT @P =(SELECT COUNT(*) FROM uVwCajerasactivas WHERE codagencia =@agencia);          
  IF @P > 0          
  BEGIN          
         SELECT @ERROR ='existen cajeras activas que no realizaron su apertura ni su respectivo cierre, la siguiente ventana le mostrará las cajeras que no realizaron su apertura ni su cierre (DERECHA)  y tambien las cajeras que hicieron su apertura pero 
 
     
     
         
no el cierre (IZQUIERDA).'          
          --return(50029)          
   --MUESTRA FORMULARIO           
   --SCaja.fechaO.text := fechaO.text;          
                 --SCaja.showmodal;          
   SELECT ERROR=(50029),DESCRIP =@ERROR ;          
   RETURN          
  END           
   --RevisANDo si existen Operaciones de Moneygram pendientes por pasar por Caja...           
  SELECT @P =(SELECT COUNT(*) FROM uVwMoneygrampendientesporCaja WHERE codagencia =@agencia);          
  IF @P > 0          
  BEGIN          
         SELECT @ERROR ='existen operaciones de Moneygram que fueron pasadas por Taquilla y no han sido completadas en Caja, Por favor Elija una de estas dos opciones:  Reverse la operación o Completela haciendo la Caja correspondiente. '          
          --return(50030)          
   --MUESTRA FORMULARIO           
   --SCaja.fechaO.text := fechaO.text;          
                 --SCaja.showmodal;          
   SELECT ERROR=(50030),DESCRIP =@ERROR ;          
   RETURN          
  END           
   --RevisANDo posibles cajeras activas que no realizaron su respectivo Cierre...          
  SELECT @P =(SELECT COUNT(*) FROM uVwCajerasactivasNocierre  WHERE codagencia =@agencia);          
  IF @P > 0          
  BEGIN          
         SELECT @ERROR ='existen cajeras activas que no realizaron su cierre, la siguiente ventana le mostrará estas cajeras (DERECHA), se le agradece revise esto para poder cerrar la agencia.'          
          --return(50031)          
   --MUESTRA FORMULARIO           
   --SCaja.fechaO.text := fechaO.text;          
                 --SCaja.showmodal;          
   SELECT ERROR=(50031),DESCRIP =@ERROR ;          
   RETURN          
  END           
  --RevisANDo posibles Tarjetas del BSP no reportadas por Cambio...          
  DECLARE @FECHA DATETIME, @VALERROR INT          
  SELECT @FECHA = GETDATE()          
  EXEC @VALERROR = VALIDATARJETABSP @FECHA, 1          
  IF @VALERROR > 0          
  BEGIN          
         SELECT @ERROR ='existen tarjetas del BSP pendientes por procesar por Cambio, se le agradece revise esto para poder cerrar la agencia.'          
          --return(50032)          
   SELECT ERROR=(50032),DESCRIP =@ERROR ;          
   RETURN          
  END           
            
  SELECT @P =(SELECT COUNT(valor) FROM parametros WHERE (modulo = 'SACC') AND (clave = 'OPERADORBCV'))          
     IF @P > 0           
  BEGIN          
      DECLARE @OPERADORBCV INT          
      SELECT @OPERADORBCV = (SELECT valor FROM parametros WHERE (modulo = 'SACC') AND (clave = 'OPERADORBCV'))          
      IF (@OPERADORBCV) = 0          
         BEGIN          
    SELECT @ERROR ='falta el código de operador, favor llamar a sistemas'          
           --return(50033)          
    SELECT ERROR=(50033),DESCRIP =@ERROR ;          
    RETURN          
   END          
  END           
  ELSE          
     BEGIN           
      SELECT @ERROR ='falta el código de operador, favor llamar a sistemas'          
       --return(50033)          
       SELECT ERROR=(50033),DESCRIP =@ERROR ;          
       RETURN             
     END         
        
        
        
        --Verifica si hay Transferencias de Casos Especiales Pendientes Por Montar en Taquilla y Enviar...        
SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='sacc' AND clave='TCASOESPECPENDIENTE')          
   IF @P = 0          
   BEGIN          
    SELECT @DIASTESPEC = 0           
       END          
       ELSE          
          SELECT @DIASTESPEC = CONVERT(INT ,(SELECT valor  FROM parametros WHERE modulo='sacc' AND clave='TCASOESPECPENDIENTE'))              
          SELECT @P =(SELECT COUNT(*) FROM uVwTransferespecialxenviar);          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen transferencias de Casos Especiales Pendientes en Taquilla con '+ CONVERT(VARCHAR(2),@DIASTESPEC)+ ' dias por enviar, se le agradece enviar las mismas para poder cerrar la agencia.';            
                     
         SELECT ERROR=(50034),DESCRIP =@ERROR ;          
         RETURN          
      END          
        
--Verifica si hay Transferencias de Estudiantes Pendientes Por Montar en Taquilla y Enviar...        
SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='sacc' AND clave='TESTUDPENDIENTE')          
   IF @P = 0          
   BEGIN          
    SELECT @DIASTRANSF = 0           
       END          
       ELSE          
          SELECT @DIASTRANSF = CONVERT(INT ,(SELECT valor  FROM parametros WHERE modulo='sacc' AND clave='TESTUDPENDIENTE'))              
          SELECT @P =(SELECT COUNT(*) FROM uVwTransferestudxenviar);          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen transferencias de Estudiantes Pendientes en Taquilla con '+ CONVERT(VARCHAR(2),@DIASTRANSF)+ ' dias por enviar, se le agradece enviar las mismas para poder cerrar la agencia.';            
                     
         SELECT ERROR=(50035),DESCRIP =@ERROR ;          
         RETURN          
      END        
        
--Verifica si hay Remesas Familiares Montadas en Taquilla y que no han sido canceladas en caja.      
/*SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='sacc' AND clave='REMFAMPEND')          
   IF @P = 0          
   BEGIN          
    SELECT @DIASREMFAM = 0           
       END          
       ELSE          
          SELECT @DIASREMFAM = convert(int ,(SELECT valor  FROM parametros WHERE modulo='sacc' AND clave='REMFAMPEND'))              
          SELECT @P =(SELECT COUNT(*) FROM uVwRemfampendcaja);          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen Remesas Familiares pendientes en caja con '+ CONVERT(VARCHAR(2),@DIASREMFAM)+ ' dias por cancelar, se le agradece cancelar o reversar la operación para poder cerrar la agencia.';            
                     
         SELECT ERROR=(50036),DESCRIP =@ERROR ;          
         return          
      END */       
      
--Verifica si hay Remesas Estudiantiles y de Casos Especiales Montadas en Taquilla y que no han sido canceladas en caja.      
SELECT @P =(SELECT COUNT(valor)  FROM parametros WHERE modulo='sacc' AND clave='REMESTUYESPECPENDCAJA')          
   IF @P = 0          
   BEGIN          
    SELECT @DIASREMESTUYESPEC = 0           
       END          
       ELSE          
          SELECT @DIASREMESTUYESPEC = CONVERT(INT ,(SELECT valor  FROM parametros WHERE modulo='sacc' AND clave='REMESTUYESPECPENDCAJA'))              
          SELECT @P =(SELECT COUNT(*) FROM uVwRemestudespecpendcaja);          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen Remesas Estudiantiles y de Casos Especiales pendientes en caja con '+ CONVERT(VARCHAR(2),@DIASREMESTUYESPEC)+ ' dias por cancelar, se le agradece cancelar o reversar la operación para poder cerrar la agencia.';           
 
                     
         SELECT ERROR=(50037),DESCRIP =@ERROR ;          
         RETURN          
      END          
--Verifica si hay envios de documentos de recaudos.      
     SELECT @P =(SELECT COUNT(*) FROM tActualizaRecaudos WHERE estado = 'M');          
          IF @P > 0          
      BEGIN          
          SELECT @ERROR ='existen Envios de Documentos de Recaudos, por favor realizar los envios para poder cerrar la agencia.';            
          SELECT ERROR=(50038),DESCRIP =@ERROR ;          
          RETURN          
      END                          
            
--return(0)             
SELECT @ERROR ='FIN VALIDACIONES'            
SELECT ERROR=(0),DESCRIP =@ERROR ;          
END          
IF @EJECUCION = 2           
BEGIN          
           
  DECLARE @FechaOper DATETIME          
  DECLARE @VALORFECHAVARCHAR VARCHAR(10)          
            
  SET @VALORFECHAVARCHAR =(SELECT VALOR FROM parametros WHERE MODULO = 'SACC' AND clave = 'FECHA')           
  SET @FechaOper = (SELECT SUBSTRING(@VALORFECHAVARCHAR,4,2) +'/'+SUBSTRING(@VALORFECHAVARCHAR,1,2) +'/'+SUBSTRING(@VALORFECHAVARCHAR,7,4))          
             
          
             
  EXEC SP_XCRHIDE @FechaOper          
            
  DECLARE @OPERACION VARCHAR(20)          
  SET @OPERACION ='0'          
  SELECT @P =(SELECT COUNT(Operacion) FROM Pencierre WHERE (DATEDIFF(dd,CONVERT(DATETIME,GETDATE()),Fecha) = 0) AND (CodAgencia = @agencia) AND (Estado <> 'C'))          
  IF @P > 0           
  BEGIN          
           
    DECLARE @resultadoOPcierre INT          
    EXEC getoperacion @agencia, 'CIERRE_DE_AGENCIA', @resultadoOPcierre OUTPUT           
    DECLARE @OPcierre VARCHAR(20)           
    SET  @OPcierre = CONVERT(VARCHAR(20),@resultadoOPcierre)          
              
    DECLARE @O1 VARCHAR(20)          
  /*  declare @OPOPcierre varchar(20)          
              
              
  select @OPOPcierre = @agencia           
         + SUBSTRING(CONVERT(CHAR(10),getdate(),103),1,2)           
         + SUBSTRING(CONVERT(CHAR(10),getdate(),103),4,2)           
           + SUBSTRING(CONVERT(CHAR(10),getdate(),103),7,4)          
         + Ltrim(CONVERT(varchar(6),(SELECT  LEFT('83'+REPLICATE('0',len(@agencia)),len(@agencia)))))          
         + Rtrim(CONVERT(CHAR(6),(SELECT  RIGHT(REPLICATE('0',len(@agencia))+ @OPcierre ,len(@agencia)))))*/          
          
    SELECT @OPERACION = (SELECT operacion FROM Pencierre WHERE (DATEDIFF(dd,CONVERT(DATETIME,GETDATE()),Fecha) = 0) AND (CodAgencia = @agencia) AND (Estado <> 'C'));          
    UPDATE Pencierre SET OperacionCierre = @OPER,FechaCierre =GETDATE(),CodusuarioCierre =@FUsuario,Estado ='C' WHERE operacion =@OPERACION;          
  END          
  BEGIN TRANSACTION          
  INSERT INTO PendienteBCV (Fecha) VALUES (GETDATE());          
               
  IF @OPERACION = '0'          
  BEGIN           
   COMMIT TRANSACTION          
   SELECT @ERROR = 'No se Puede Insertar Dato en Tabla Movimien'          
   SELECT ERROR=(90002),DESCRIP =@ERROR ;          
   RETURN          
  END          
            
  INSERT INTO Movimien (Operacion, Efectivo, Cheque, Impuesto, Tarjeta, Fecha, Reintegro, Auxiliar, CodUsuario, CodTransaccion, Estado, CodBcv, Total, CodAgencia) VALUES (@OPER, 0, 0, 0, 0, GETDATE(), 0, NULL, @FUsuario, 83, 'C', NULL, 0, @agencia);      
  
    
      
 --agregado por sac10032010 Replica a netsql para saber cuales agencias han cerrado     
     
 SET @sendsql= 'INSERT INTO Movimien (Operacion, Efectivo, Cheque, Impuesto, Tarjeta, Fecha, Reintegro, Auxiliar, CodUsuario, CodTransaccion, Estado, CodBcv, Total, CodAgencia) VALUES ('+CHAR(39)+@OPER+CHAR(39)+', 0, 0, 0, 0, '+GETDATE()+', 0, NULL, '+CHA
R(39)+@FUsuario+CHAR(39)+', 83, ''C'', NULL, 0, '+CHAR(39)+@agencia+CHAR(39)+');      '    
      
  IF  NOT(@sendsql IS NULL)             
BEGIN               
 INSERT INTO replica(codagencia,sqltext,status)  VALUES (@agencia, @sendsql,'N');     
END    
  --agregado por sac10032010       
      
      
           
             
  UPDATE Enlaces SET OperacionCierre = @OPER, Comentarios = Comentarios + ', CIERRE DE AGENCIA' WHERE Operacion = (SELECT OPERACION FROM uVwAperturaAgencia WHERE codagencia =@agencia);          
  UPDATE cierre SET fecha = GETDATE();          
          
            
  UPDATE agencias SET StatusCierre = 'S' WHERE codagencia = @agencia;          
          
  --sendsql(FQueryUpdate, FormMain.FAgenPpal, '');          
  INSERT INTO Cierres (Agencia,Codusuario,StatusCierre,TipoCierre,Fecha) VALUES (@agencia,@FUsuario,@statuscierre,'AGENCIA',GETDATE())           
            
  EXEC uSpinsCURInvTravelAperturaCierre @OPER,@agencia          
  EXEC uSpinsCURInvTravelAperturaCierre2 @OPER,@agencia          
  EXEC uSpinsMoneyGram          
            
            
  UPDATE autorizaciongerencia SET estado = 'A' WHERE (operacioncierre IS NULL) AND (estado = 'R')AND (DATEDIFF(dd,CONVERT(DATETIME,GETDATE()),fecha) <= -3)AND CodTransaccion NOT IN (17,25,179,203,204,526)          
            
  DECLARE @concept VARCHAR(30)          
  DECLARE @concept1 VARCHAR(30)          
  DECLARE @concept2 VARCHAR(30)          
  DECLARE @concept3 VARCHAR(30)          
  DECLARE @concept4 VARCHAR(30)          
  DECLARE @concept5 VARCHAR(30)          
  DECLARE @concept6 VARCHAR(30)          
  DECLARE @concept7 VARCHAR(30)          
  DECLARE @concept8 VARCHAR(30)          
  DECLARE @concept9 VARCHAR(30)          
          
  SELECT @concept = '%' + 'Auxiliar' + '%';          
  SELECT @concept1 = '%' + 'PURCHASE' + '%';          
  SELECT @concept2 = '%' + 'MEDALLA' + '%';          
  SELECT @concept3 = '%' + 'CUADRO' + '%';          
  SELECT @concept4 = '%' + 'LINGOTE' + '%';          
  SELECT @concept5 = '%' + 'MONEDA' + '%';          
  SELECT @concept6 = '%' + 'TRASPASO_CHEQUES_DIV' + '%';          
  SELECT @concept7 = '%' + 'REC_TRASPASO_CHEQUES' + '%';          
  SELECT @concept8 = '%' + 'CASH_LETTER' + '%';          
  SELECT @concept9 = '%' + 'GLO_TRASPASO_CHEQUES' + '%';          
          
  UPDATE Correlativos SET Valor = 1          
   WHERE (Concepto NOT LIKE @concept) AND (Concepto NOT LIKE @concept1)AND (Concepto NOT LIKE @concept2) AND (Concepto NOT LIKE @concept3) AND (Concepto NOT LIKE @concept4)           
     AND (Concepto NOT LIKE @concept5) AND (Concepto NOT LIKE @concept6) AND (Concepto NOT LIKE @concept7) AND (Concepto NOT LIKE @concept8) AND (Concepto NOT LIKE @concept9)          
            
            
          
  DECLARE @FECHAACT VARCHAR(10)          
  SELECT  @FECHAACT = (SELECT SUBSTRING(@FechaApertura,1,2)+'/'+ SUBSTRING(@FechaApertura,4,2)+ '/'+SUBSTRING(@FechaApertura,7,4))          
  UPDATE Parametros SET Valor = @FECHAACT WHERE (Modulo = 'SACC') AND (Clave = 'FECHA')          
            
  UPDATE Parametros SET Valor = 'NO' WHERE (Modulo = 'SACC') AND (Clave = 'APERTURA')          
          
            
  --BORRA LAS OPERACIONES PENDIENTES DE VTM, ENVIOS Y RECIBOS DE MONEYGRAM QUE NO FUERON CERRADAS POR CAJA \          
  DELETE Liquidacion_VTM WHERE (OperacionCaja IS NULL)          
  DELETE Mov_VTM WHERE (OperacionCaja IS NULL)          
          
  EXEC uSpupdAutorizacionTransferencia          
          
  --SE INHABILITAN LOS CLIENTES QUE TIENEN CONTRATOS INCUMPLIDOS          
  EXEC uSpupdContratosincumplidos @agencia  
    
    
  -- @eldher 24-04-2014 SE EJECUTA EL INSERT EN POSICION DE REMESAS  
  DECLARE @FECHACIERREPOS varchar(20)  
  SET @FECHACIERREPOS = CONVERT(varchar,GETDATE())  
  EXEC uSpPosicionRemesas @agencia,1, @FECHACIERREPOS  
            
            
  IF @@ERROR = 0          
  BEGIN          
   COMMIT TRANSACTION          
   SELECT @ERROR = 'FIN'          
   SELECT ERROR=(0),DESCRIP =@ERROR ;          
   RETURN          
  END          
  ELSE          
  BEGIN          
   ROLLBACK TRANSACTION          
   SELECT @ERROR = 'error de proceso'          
   SELECT ERROR=(90002),DESCRIP =@ERROR ;          
   RETURN          
  END          
            
           
          
           
END          
END 