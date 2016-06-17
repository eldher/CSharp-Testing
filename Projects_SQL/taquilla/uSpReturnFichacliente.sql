--************************************************************************************************                          
--************************************************************************************************                               
 ALTER PROCEDURE [dbo].[uSpReturnFichaCliente]                           
/*                          
Creado por Vladimir Yepez 12-04-2011                          
Este Store Procedure retorna los datos necesarios para Imprimir los clientes,                        
tanto juridicos, naturales y servira para las aplicaciones de taquilla e intranet, de manera                         
standard para todas.                          
*/                          
@Cedula varchar(30)                              
AS                        
--******************************************************                          
SELECT DISTINCT                              
                        
isnull(c.Auxiliar,'') as Auxiliar,                        
isnull(c.Id,'') as Id,                        
isnull(convert(varchar(3),c.TipoBCV),'') as TipoBCV,                        
isnull(c.Nombres,'') as Nombres,                       
isnull(c.SegundoNombre,'') as SegundoNombre,                        
isnull(c.Apellido1,'') as Apellido1,                        
isnull(c.Apellido2,'') as Apellido2,                        
isnull(convert(varchar(10),c.Fecha_Carga,103),'') as Fecha_Carga,                          
isnull(convert(varchar(2),DATEPART(hh, c.Fecha_Carga) ) + ':' +  convert(varchar(2),DATEPART(n, c.Fecha_Carga) ) + ':' +  convert(varchar(2),DATEPART(ss,  c.Fecha_Carga) ),'') as horaCarga,                          
isnull(c.Fecha_Nac,'') as Fecha_Nac,                        
case when c.Sexo is null or c.Sexo = '' then                         
  convert(varchar(3),'-')                         
  else                         
  convert(varchar(3),c.Sexo)                         
end as Sexo,                        
isnull(c.Estado_Civil,'') as Estado_Civil,                        
isnull(c.Nacionalidad,'') as Nacionalidad,                          
isnull(c.Reg_Mercantil,'') as Reg_Mercantil,                        
isnull(c.Nit,'') as Nit,                                 
isnull(c.CodUsuario,'') as CodUsuario,                        
isnull(c.DH_Sector,'') as DH_Sector,                        
isnull(c.DH_Avenida,'') as DH_Avenida,                        
isnull(c.DH_Residencia,'') as DH_Residencia,                          
isnull(c.DH_Numero,'') as DH_Numero,                        
isnull(c.DH_Piso,'') as DH_Piso,                        
isnull(c.DH_Municipio,'') as DH_Municipio,                        
isnull(c.DH_Ciudad,'') as DH_Ciudad,                          
isnull(c.DH_Estado,'') as DH_Estado,                        
isnull(c.DH_Pais,'') as DH_Pais,                        
isnull(c.DH_ZonaPostal,'') as DH_ZonaPostal,                        
isnull(c.DO_Sector,'') as DO_Sector,                            
isnull(c.DO_Avenida,'') as DO_Avenida,                        
isnull(c.DO_Residencia,'') as DO_Residencia,                        
isnull(c.DO_Numero,'') as DO_Numero,                        
isnull(c.DO_Piso,'') as DO_Piso,                          
isnull(c.DO_Municipio,'') as DO_Municipio,                        
isnull(c.DO_Ciudad,'') as DO_Ciudad,                        
isnull(c.DO_Estado,'') as DO_Estado,                        
isnull(c.DO_Pais,'') as DO_Pais,                          
isnull(c.DO_ZonaPostal,'') as DO_ZonaPostal,                        
case when TH_Numero is null Or TH_Numero = '' then                        
  'NO POSEE'                        
  else                        
     TH_Numero                        
  end as TH_Numero2,                        
case when TO_Numero is null Or TO_Numero = '' then                        
  'NO POSEE'                        
  else                        
     TO_Numero                        
  end as TO_Numero2,                        
case when TC_Numero is null Or TC_Numero = '' then                        
  'NO POSEE'                        
  else                        
     TC_Numero                        
  end as TC_Numero2,                            
case when TF_Numero is null Or TF_Numero = '' then                      'NO POSEE'                        
  else                        
     TF_Numero                        
  end as TF_Numero2,                        
isnull(c.Empresa,'') as Empresa,                        
isnull(c.Cargo,'') as CargoOcupacion,                        
isnull(c.Antiguedad,'') as Antiguedad,                          
isnull(c.Correo,'') as Correo,                        
isnull(convert(varchar(3),c.Status),'') as Status,                        
isnull(c.CodAgencia,0) as CodAgencia,                        
case when c.registrofirma is null or c.registrofirma = '' then                         
   '-'                         
  else                         
   c.registrofirma                         
end as registrofirma,                          
isnull(c.LugarNac,'') as LugarNac,                        
isnull(c.MotivoServicio,'') as MotivoServicio,                        
isnull(c.TranFrecuencia,'') as TranFrecuencia,                                  
case when c.SalarioMensual is null Or c.SalarioMensual = '' then                        
            'NO POSEE'                        
     else                        
   c.SalarioMensual                        
end as SalarioMensual,                        
isnull(c.Empresas_Relacionadas,'') as Empresas_Relacionadas,                         
isnull(c.Volumen_Mensual,0.00) as Volumen_Mensual,                          
isnull(c.Tipo_cliente,'') as Tipo_cliente,                        
case when c.Calif_Cliente is null or c.Calif_Cliente = '' then                         
   convert(varchar(3),'-')                         
  else                         
   convert(varchar(3),c.Calif_Cliente)                         
end as Calif_Cliente,                        
case when c.OtrosIngresos is null Or c.OtrosIngresos = '' then                        
   'NO POSEE'                        
  else                        
   c.OtrosIngresos                        
end as OtrosIngresos,                        
isnull(c.correocompania,'') as correocompania,                          
isnull(c.detalleing,'') as detalleing,                        
isnull(c.comment,'') as comment,                        
isnull(c.Razoncalif_Riesgo,'') as Razoncalif_Riesgo,                        
isnull(c.Tomo,0) as Tomo,                        
isnull(c.Numero,0) as Numero,                          
isnull(c.Coddivisa,'') as Coddivisa,                        
isnull(c.activEconomica,'') as activEconomica,                        
isnull(convert(varchar(10),c.FechaConIngresos,103),'') as FechaConIngresos,     
ISNULL(c.tipoExtranjero,'') as tipoExtranjero,                        
isnull(c.fechaVecVisa,'') as fechaVecVisa,                           
isnull(c.Contacto,'') as Contacto,                        
isnull(c.TelContacto,'') as TelContacto,                        
isnull(c.Id_Perfil,'') as Id_Perfil,                        
isnull(c.TipoBcv_Perfil,'') as TipoBcv_Perfil,                        
isnull(c.Seguridad,'') as Seguridad,                                     
isnull((select distinct sector from mtActividadesEconomicasSudeban where codigo = c.activEconomica ),'') as sector,                         
isnull((select distinct codigo from mtActividadesEconomicasSudeban where codigo = c.activEconomica ),'') as codigo,                     
isnull(r.nombres,'') as nombresrl,                        
isnull(r.apellidos,'') as apellidos,                        
isnull(r.cargo,'') as cargol,                        
isnull(r.email,'') as email,                         
isnull(r.cedula,'') as cedula,                        
isnull(r.telefono,'') as telefono,               
isnull(r.productos,'') as productos,                        
isnull(l.Status,'') as StatusL,                         
isnull(c.Auxiliar,'') as auxi,                         
isnull(convert(varchar(10),l.Fecha,103),'') as Fecha,                        
isnull(convert(varchar(2),DATEPART(hh, l.Fecha) ) + ':' +  convert(varchar(2),DATEPART(n,  l.Fecha) ) + ':' +  convert(varchar(2),DATEPART(ss,  l.Fecha) ),'') as Timell,                          
isnull((Select NomAgencia from Agencias where CodAgencia = l.CodAgencia),'') as Agen,                        
isnull(b.NomAgencia,'') as NomAgencia,                        
case when isnull(l.UserLeg,'') <> ''  then                        
   l.UserLeg                        
  else                         
      isnull(l.UserTaq,'')                        
end as UsuarioModificacion,                    
isnull(c.OrigenFondos,'') as OrigenFondos,                    
isnull(c.AvgNroOperaciones,0) as AvgNroOperaciones,          
isnull(c.enviarRecibirTF,'') as  enviarRecibirTF,         
-- 02.02.2014 LR Agregar nuevos campos al SP        
isnull(convert(varchar(10),c.FechaVencCartResi,103),'') as FechaVencCartResi,  
-- @eldher 07.03.2014    
ISNULL(c.rif,'') as rif,      
ISNULL(c.correoSecundario,'') as correoSecundario,      
ISNULL(c.nombreRepLegal,'') as nombreRepLegal,      
ISNULL(c.cedulaRepLegal,'') as cedulaRepLegal,      
ISNULL(c.tipoPoder  ,'') as tipoPoder  ,      
ISNULL(CONVERT(varchar(10),c.fechaVencPoder,103),'') as fechaVencPoder,      
ISNULL(c.paisODFondos,'') as paisODFondos,   
ISNULL(c.tipoOperacion,'') as tipoOperacion,     
ISNULL(CONVERT(varchar,c.montoDivisas),'') as montoDivisas,      
ISNULL(CONVERT(varchar,c.equivalDivisas),'') as equivalDivisas,       
ISNULL(CONVERT(varchar,c.tipoCambio),'') as tipoCambio      
-- ***********        
FROM Clientes c                        
LEFT OUTER JOIN representante_legal r On (c.auxiliar = r.auxiliar)                        
LEFT OUTER JOIN ListaLeg l On (c.auxiliar = l.auxiliar)                        
FULL OUTER JOIN agencias b On (c.codagencia = b.codagencia)                           
                        
WHERE                        
 c.Auxiliar = @Cedula                              
                                    
 --***********************************************************************************                          
 --***********************************************************************************     