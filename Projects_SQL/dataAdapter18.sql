--***************************Datos Beneficiario*******************************************
/*       
SELECT			p.solicitud, b.auxiliar_benef, b.beneficiario, b.estado, 
                b.operacion AS operbenef,b.Parentesco,b.Pais_Benef,B.Instrumento, 
                case when b.instrumento='TN' then 'TITAN' else '' end as INSTR, 
                convert(varchar(20),b.monto_benef) as monto_benef , convert(varchar(20),b.montodivisa) as montodivisa,
                d.Nombre,
                c.Correo,
                c.TC_Numero as Celular 
FROM			remesas_familiaressol p
INNER JOIN		remesas_familiaresbenef b ON (p.operacion=b.operacionsol)
INNER JOIN		clientes c ON (p.auxiliar_sol = c.auxiliar)
INNER JOIN		Divisas d ON (d.Divisa = b.divisa) 
WHERE			(p.estado = 'G') AND (p.operacioncierre IS NULL) AND (p.usuario_ger IS NOT NULL)
                AND (b.estado NOT IN('R')) 
                AND (p.solicitud =  @SolSe) AND (datediff(mm,p.fecha_sol,getdate()) = 0)
*/


--***************************Datos Beneficiario  TODOS LOS TIPOS DE INSTRUMENTO EXCEPTO TF *************


SELECT  
                pr.providerName as NombreProveedor,
                p.solicitud, b.auxiliar_benef, b.beneficiario, b.estado, 
                b.operacion AS operbenef,b.Parentesco,
                --b.Pais_Benef,
                pm.PAI_NOMBRE AS Pais_Benef,
                b.Instrumento, 
                convert(varchar(20),b.monto_benef) as monto_benef , 
                dbo.MontoLetra(b.monto_benef) as MontoEnLetras,
                convert(varchar(20),b.montodivisa) as montodivisa,
                d.Nombre,
                rb.Nombre_benef1 + ' ' + rb.nombre_benef2 as NombresBeneficiario,
                rb.Apellido_benef1 + ' '+ rb.apellido_benef2 as ApellidosBeneficiario,
                rb.Ciudad_benef as CiudadBeneficiario,
                rb.direccion_benef as DireccionBeneficiario,
                rb.parentesco  as ParentescoReal,
                rb.depositoEnCuenta

FROM			
                remesas_familiaressol   p

INNER JOIN	remesas_familiaresbenef b ON (p.operacion=b.operacionsol)
INNER JOIN	clientes c ON (p.auxiliar_sol = c.auxiliar)
INNER JOIN                 trusadbeneficiario rb ON ((b.auxiliar_benef = rb.auxiliarbenef) and (b.solicitud = rb.solicitud))
INNER JOIN	Divisas d  ON (d.Divisa = b.divisa) 
INNER JOIN                 mtProvider pr ON (pr.providerAcronym = b.Instrumento)
INNER JOIN mtpaisesmundo pm On rb.Cod_Pais = pm.Pai_Iso3

WHERE			 
                 b.estado = 'G'                                        
                 AND (p.usuario_ger IS NOT NULL)
                 AND (b.estado NOT IN('R')) 
                 AND (b.Instrumento <> 'TF')
             -- AND (p.solicitud =  @SolSe)    -- Antes era por solicitud.  ahora es por operacion.
                 AND (p.operacion = @SolSe) 
                 AND (datediff(mm,p.fecha_sol,getdate()) =0)  
                 AND (p.operacioncierre IS NULL)  
                 AND (rb.depositoEnCuenta <> 'S' or rb.depositoEnCuenta IS Null)
                 
                 
