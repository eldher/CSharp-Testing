ALTER VIEW uVwBuscasolicitante                  
AS                  
SELECT DISTINCT                   
                      ISNULL(s.solicitud, '') AS solicitud,                 
                      CONVERT(VARCHAR(10),ISNULL(s.fecha_sol, '1900-01-01'),103) AS fecha_sol,                
                      ISNULL(s.codseguridad, '') AS codseguridad,                 
                      ISNULL(s.auxiliarsol, '') AS auxiliarsol,                 
                      ISNULL(c.TipoBCV, '') AS tipobcv,                 
                      ISNULL(c.Id, '') AS Id,                
                      ISNULL(c.Nombres, '') + ' ' + ISNULL(c.SegundoNombre, '') + ' ' + ISNULL(c.Apellido1, '')+ ' ' + ISNULL(c.Apellido2, '') AS Nombre,                 
                      ISNULL(c.Correo, '') AS correo,                 
                      ISNULL(c.TF_Numero, '') AS tf_numero, --10                
                      ISNULL(c.TH_Numero, '') AS th_numero,                   
                      ISNULL(c.DH_Sector, '') + ' ' + ISNULL(c.DH_Avenida, '') + ' ' + ISNULL(c.DH_Residencia, '') + ' ' + ISNULL(c.DH_Numero, '') + ' ' + ISNULL(c.DH_Piso, '') AS direccion,                  
                      ISNULL(s.emailrusad, '') AS emailrusad,                
                      ISNULL(c.tipoExtranjero, '') AS tipoextranjero,                 
                      ISNULL(c.Auxiliar, '') AS Auxiliar,                 
                      ISNULL(s.nroRif, '') AS nroRif,                
                      CONVERT(VARCHAR(10),ISNULL(s.FechaEmiRefBanc, '1900-01-01'),103) AS FechaEmiRefBanc,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaVencRefBanc, '1900-01-01'),103) AS FechaVencRefBanc,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEmiEdoCuenta,'1900-01-01'),103) AS FechaEmiEdoCuenta,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaVenEdoCuenta, '1900-01-01'),103) AS FechaVenEdoCuenta, --20                
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEmiResidencia, '1900-01-01'),103) AS FechaEmiResidencia,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaVencResidencia, '1900-01-01'),103) AS FechaVencResidencia,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaEmisionRif, '1900-01-01'),103) AS fechaEmisionRif,                
                       CONVERT(VARCHAR(10),ISNULL(s.fechaVencimientoRif, '1900-01-01'),103) AS fechaVencimientoRif,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaEmisionPasaporte, '1900-01-01'),103) AS fechaEmisionPasaporte,                
                       CONVERT(VARCHAR(10),ISNULL(s.FechaVencPas, '1900-01-01'),103) AS FechaVencPas,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaEmisionCedula, '1900-01-01'),103) AS fechaEmisionCedula,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaVencimientoCedula, '1900-01-01'),103) AS fechaVencimientoCedula,                 
                       CONVERT(VARCHAR(10),ISNULL(s.DateFirstAprob, '1900-01-01'),103) AS DateFirstAprob,                 
                       CONVERT(VARCHAR(10),ISNULL(c.FechaConIngresos, '1900-01-01'),103) AS FechaConIngresos,--30                 
                       CONVERT(VARCHAR(10),ISNULL(c.FechaVencCartResi, '1900-01-01'),103) AS FechaVencCartResi,                 
                       ISNULL(s.cartaContador, '') AS cartaContador,                   
                      SUBSTRING(ISNULL(s.PasaporteSol, ''), 2, LEN(s.PasaporteSol)) AS pasaporte,                 
                      SUBSTRING(ISNULL(s.PasaporteSol, ''), 1, 1) AS tipoPasaporte,                   
                       CONVERT(VARCHAR(10),ISNULL(s.FechaCartaInstruccion, '1900-01-01'),103) AS FechaCartaInstruccion,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEmisionConstTrabajo, '1900-01-01'),103) AS FechaEmisionConstTrabajo,      
                       CONVERT(VARCHAR(10),ISNULL(s.FechaVencimientoConstTrabajo, '1900-01-01'),103) AS FechaVencimientoConstTrabajo,              
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEDISLR, '1900-01-01'),103) AS FechaEDISLR,                   
                      ISNULL(s.nroISLR, '') AS nroISLR,                 
                      ISNULL(s.TipoUsuario, '') AS TipoUsuario,--40                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEnEmpresa, '1900-01-01'),103) AS FechaEnEmpresa,                 
                      ISNULL(s.municipio, '') AS municipio,                 
                      ISNULL(s.pai_iso2, '') AS pai_iso2,                 
                      ISNULL(s.cod_ciudad, '') AS cod_ciudad,                 
                      ISNULL(s.oficina, '') AS oficina,                 
                      ISNULL(s.departamento, '') AS departamento,                 
                      ISNULL(s.pai_iso2CRE, '') AS pai_iso2CRE,                 
                      ISNULL(s.cod_ciudadCRE, '') AS cod_ciudadCRE,                 
                      ISNULL(s.municipioCRE, '') AS municipioCRE,                   
                      ISNULL(s.nombresAutCRE, '') AS nombresAutCRE,--50                 
                      ISNULL(s.rifempresa, '') AS rifempresa,                 
                      ISNULL(s.cod_estado, '') AS cod_estado,                 
                      ISNULL(s.representanteLegal, '') AS representanteLegal,                 
                      ISNULL(s.auxiliarRL, '') AS auxiliarRL,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaEmisionPoder, '1900-01-01'),103) AS fechaEmisionPoder,                 
                       CONVERT(VARCHAR(10),ISNULL(s.fechaVencimientoPoder,'1900-01-01'),103) AS fechaVencimientoPoder,                 
                      ISNULL(s.aplicaVenPoder, '') AS aplicaVenPoder,                 
                       CONVERT(VARCHAR(10),ISNULL(s.FechaEmisionRifRL, '1900-01-01'),103) AS FechaEmisionRifRL,                   
                      CONVERT(VARCHAR(10),ISNULL(s.FechaVencimientoRifRL,'1900-01-01'),103) AS FechaVencimientoRifRL,                 
                      ISNULL(s.providencia, '') AS providencia,--60                
                      ISNULL(c.Empresa, '') AS empresa,                 
                      ISNULL(m.codigo, 'S96') AS codigo,                 
                      ISNULL(m.sector, 'Otras actividades de servicios') AS sector,                  
                          (SELECT     ISNULL(PAI_NOMBRE, '') AS Expr1                  
                            FROM          dbo.MtPaisesmundo                  
                            WHERE      (PAI_ISO2 = s.pai_iso2)) AS pai_nombreSolicitante,                  
                          (SELECT     ISNULL(PAI_NOMBRE, '') AS Expr1                  
                            FROM          dbo.MtPaisesmundo AS MtPaisesmundo_1                  
                            WHERE      (PAI_ISO2 = s.pai_iso2CRE)) AS pai_nombreCRE,                  
                          (SELECT     ISNULL(NOMBRE_CIUDAD, '') AS Expr1                  
                            FROM          dbo.MtCiudadesmundo                  
                            WHERE      (COD_CIUDAD = s.cod_ciudad) AND (PAI_ISO2 = s.pai_iso2)) AS nombre_ciudadSolicitante,                  
                          (SELECT     ISNULL(NOMBRE_CIUDAD, '') AS Expr1                  
                            FROM          dbo.MtCiudadesmundo AS MtCiudadesmundo_1                  
                            WHERE      (COD_CIUDAD = s.cod_ciudadCRE) AND (PAI_ISO2 = s.pai_iso2CRE)) AS nombre_ciudadCRE,                  
                          (SELECT     ISNULL(EST_NOMBRE, '') AS Expr1                  
                            FROM          dbo.MtEstadosmundo                  
                            WHERE      (COD_ESTADO = s.cod_estado) AND (PAI_ISO2 = s.pai_iso2)) AS est_nombreSolicitante,                
                      ISNULL(c.Cargo, '') AS cargo,                
                      ISNULL(c.DO_Sector, '') AS sectorDirOficina,                 
                      ISNULL(c.DO_Avenida, '') AS avenidaDirOficina,                 
                      ISNULL(c.DO_Residencia, '') AS residenciaDirOficina,                 
                      ISNULL(c.DO_Piso, '') AS pisoDirOficina,                   
                      ISNULL(c.TC_Numero, '') AS tc_numero,                 
                      ISNULL(c.DO_ZonaPostal, '') AS zonaPostalDirOficina,                 
                      ISNULL(s.primerNombreRL, '') AS primerNombreRL,  --70             
                      ISNULL(s.primerApellidoRL, '') AS primerApellidoRL,                 
                      ISNULL(os.DocumentoRL, '') AS DocumentoRL,                 
       ISNULL(os.RifRL, '') AS RifRL,                 
                      ISNULL(os.MediosElectronicos, '') AS MediosElectronicos,                 
                      ISNULL(os.CI, '') AS CI,                 
                      ISNULL(os.Residencia, '') AS Residencia,                 
                      ISNULL(os.RIF, '') AS RIF,                 
                      ISNULL(os.CartaInstruccion, '') AS CartaInstruccion,                   
                      ISNULL(os.ConstTrabajo, '') AS ConstTrabajo,                 
                      ISNULL(os.CertTrabajo, '') AS CertTrabajo,--80                 
                      ISNULL(os.EdoCuenta, '') AS EdoCuenta,                 
                      ISNULL(os.OtrosDocumentos, '') AS OtrosDocumentos,  --82              
                      ISNULL(os.ISLR,'') as ISLR,      
                      ISNULL(os.Pasaporte,'') as ObervPasaporte ,    
                      /*****************/    
                      ISNULL(c.DO_Pais, '') AS PaisOficina,                 
                      ISNULL(c.DO_Ciudad, '') AS ciudadOficina,                 
                      ISNULL(c.DO_Estado, '') AS EstadoOficina,  
                      ISNULL(c.DO_Municipio, '') AS MunicipioOficina            
FROM         dbo.Clientes AS c       
INNER JOIN dbo.tRusadsolicitante AS s ON c.Auxiliar = s.auxiliarsol       
LEFT OUTER JOIN dbo.mtActividadesEconomicasSudeban AS m ON c.activEconomica = m.codigo       
LEFT OUTER JOIN dbo.TobservacionesSolicitante AS os ON s.solicitud = os.Solicitud                              
/***********************************************************************************************************/          