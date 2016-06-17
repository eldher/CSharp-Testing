ALTER view uVwGirosTitan           
as          
select  distinct           
  'ITF' AS CODECOMPANY,           
  CASE         
     WHEN LEN(T.OPERACIONCIERRE)<=20 THEN T.OPERACIONCIERRE         
     ELSE SUBSTRING(T.OPERACIONCIERRE,ABS((20-LEN(T.OPERACIONCIERRE))),20)         
  END AS AUXREFERENCE,          
  REPLACE(SUBSTRING((ISNULL(Nombre1_Benef,'')+' '+ISNULL(Nombre2_Benef,'')+' '+          
  ISNULL(Apellido1_Benef,'')+' '+ISNULL(Apellido2_Benef,'')),1,60),',','') AS BENEFICIARIO,          
  TRB.TELEFONO_BENEF,           
  REPLACE(TRB.Direccion_Benef,',','') AS DIRECCION_BENEF,           
  REPLACE(TRB.Cod_Ciudad,',','') AS CIUDAD_BENEF,          
  REPLACE(SUBSTRING((ISNULL(TRS.NombreS,'')+' '+          
  ISNULL(TRS.Apellido1,'')+' '+ISNULL(TRS.Apellido2,'')),1,60),',','') AS NOMBRE_SOLICITANTE,           
  ' ' AS MENSAJE,           
  T.MONTO AS VALORGIRO,          
  CONVERT(DECIMAL(15,2),T.MONTO*CONVERT(FLOAT,P.VALOR)) AS VALORGIROBS,            
  REPLACE(TOC.NOMBREOFICINA,',','') AS NOMBREOFICINA,          
  ' ' AS NOMBREBANCO,          
  ' ' AS TIPOCUENTA,          
  ' ' AS NROCUENTA,        
  T.OPERACIONCIERRE AS OperacionFinal,                      
  ' ' AS Solicitud,                       
  ' '  AS Auxiliar_Sol,                       
  getdate() AS Fecha_Sol,                       
  ' '  AS Solicitante,                       
  ' ' AS Auxiliar_Benef,                       
  ' ' AS Beneficiario_IOSS,                       
  convert(money,0) AS Monto,                       
  ' ' AS Clave_IOSS,    
  getdate() AS fecha_aprob_cadivi,    
  getdate() AS fecha_bcv,    
  getdate() AS fecha_devolucion    
FROM          
  ttitan t          
INNER JOIN     
   TBENEFICIARIO TRB     
      ON (t.Auxiliar_Benef = TRB.Auxiliar_Benef)          
INNER JOIN     
   CLIENTES TRS     
      ON (T.AUXILIAR = TRB.Auxiliar_SOLIC AND TRS.AUXILIAR = TRB.Auxiliar_SOLIC)          
INNER JOIN     
   PARAMETROS P     
      ON (P.CLAVE='TASA TITAN')          
INNER JOIN     
   tblDetallePagoCambiamos TDP     
      ON (T.OPERACION = TDP.OPERACION)          
INNER JOIN     
   tblOficinasCambiamos TOC     
      ON (TDP.OFICINA = TOC.CODOFICINA)          
INNER JOIN     
   tblDptosColombia TDC     
      ON (TDP.DEPARTAMENTO = TDC.CODDPTOS)          
where     
   ISNULL(T.MGSERVICE,'')='' AND ISNULL(T.OPERACIONCIERRE,'')<>'' 