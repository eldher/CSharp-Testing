
CREATE PROCEDURE uSpAlertaRemesasTF 
@codagen integer, 
@diaspermitidos integer        

AS   
  
SELECT DISTINCT 
 rs.estado,     
 r.solicitud,     
 r.Usuario_sol AS usuario_taq ,    
 r.Fecha_sol AS fecha_Taq,    
 c.Nombres+' '+c.Apellido1+' '+c.Apellido2 AS 'Nombres',         
 R.Auxiliar_Sol AS 'Auxiliar',     
 r.codagencia AS agencia,     
 r.operacion, 
 monto_sol         

FROM 
 Clientes C
 INNER JOIN Remesas_familiaressol AS r ON r.auxiliar_sol = c.auxiliar
 INNER JOIN Remesas_FamiliaresBenef AS rs ON rs.OperacionSol = r.Operacion 
 INNER JOIN Divisas AS D ON CONVERT(int,D.divisa)=CONVERT(int,ISNULL(rs.divisa,'1'))
 
WHERE 
 (r.CodAgencia=@codagen)
 AND dbo.uFnDiasLaborales(rs.fecha_bcv,getdate(),r.codagencia)<=@diaspermitidos 
 AND (isnull(r.OperacionCierre,'')<>'') 
 AND r.estado='C'
 AND rs.estado IN ('X') 
 AND isnull(rs.Cod_Aprobacion,'')<>''    
 AND fecha_bcv is not null       
 AND rs.instrumento='tf' 
 
ORDER BY c.Nombres ,r.Solicitud 
 
--Where (r.codagencia='1')         
--And c.auxiliar=r.auxiliar_sol          
--AND dbo.uFnDiasLaborales(rs.fecha_bcv,getdate(),r.codagencia)<=800    
--And (isnull(r.OperacionCierre,'')<>'') 
--And r.estado='C'         
--And rs.OperacionSol=r.Operacion 
--And rs.estado IN ('X') 
--And isnull(rs.Cod_Aprobacion,'')<>''    
--And convert(int,isnull(rs.divisa,'1'))=convert(int,d.divisa) 
--and fecha_bcv is not null 
--And rs.instrumento='tf'     -- agregar condición de que sean transferencias   
--Order by c.Nombres ,r.Solicitud 

--Select * from Remesas_familiaressol Where Operacion='08190220145330005'
