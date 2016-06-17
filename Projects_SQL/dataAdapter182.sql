--***************************  Datos Beneficiario DEPOSITOS EN CUENTA *************



SELECT    DISTINCT 
isnull(dt.codbanco,0)		as CodBanco,
pr.providerName			as NombreProveedor,
p.solicitud, 
b.auxiliar_benef, 
b.beneficiario, 
b.estado, 
b.operacion			as operbenef,
b.Parentesco,
pm.PAI_NOMBRE as Pais_Benef,
b.Instrumento, 
    CASE
        WHEN b.instrumento = 'TN' then 'TITAN' 
             ELSE ' ' 
        END					as INSTR, 
        convert(varchar(20),b.monto_benef)	as monto_benef , 
        dbo.MontoLetra(b.monto_benef)		as MontoEnLetras,
        convert(varchar(20),b.montodivisa)	as montodivisa,
        d.Nombre,
        rb.Nombre_benef1 + '  ' + rb.nombre_benef2	as NombresBeneficiario,
        rb.Apellido_benef1 + '  '+ rb.apellido_benef2	as ApellidosBeneficiario,
        rb.Ciudad_benef				as CiudadBeneficiario,
        rb.direccion_benef		                   as DireccionBeneficiario,
        rb.parentesco				as parentescoreal,
        
       (Select Nombanco From Bancos where CodBanco = dt.codbanco) as NomBanco,
        isnull(dt.Direccion, ' ')	as DireccionBanco, 
        Case 
           when dt.CodPais is not null then
	           (Select PAI_NOMBRE From MtpaisesMundo where Pai_iso2 = dt.CodPais) 
           Else
	           ' '
         End				as PaisBanco,
         isnull(dt.CodCuenta, ' ')	                  as Cuenta, 
         isnull(dt.Swift, ' ')                                    as CodSwif, 
         isnull(dt.Abba, ' ')                                   as Abba, 
--       isnull(dt.Swift + ''+ dt.CodCuenta, '') as IBAN,    ---> Asi estaba antes el IBAN

         isnull(dt.iban, ' ')		as IBAN,

--       (Select Nombanco From Bancos where CodBanco = dbi.banco) as BancoIntermediario,
         isnull(bc.NomBanco, ' ')		as BancoIntermediario,
                
        isnull(dbi.Direccion, ' ')      as DirBancoIntermediario,
        isnull(dbi.Pais, ' ')                as PaisBancoIntermediario,
        isnull(dbi.Cuenta, ' ')          as CtaBancoIntermediario,
        isnull(dbi.CodSwif, ' ')        as SwifBancoIntermediario,
        isnull(dbi.Abba, ' ')             as AbbaBancoIntermediario,
--     isnull(dbi.CodSwif  + '' + dbi.Cuenta, '') AS IBANBancoIntermediario    --> Asi estaba antes el IBAN

          isnull(dbi.Iban, ' ')           as IBANBancoIntermediario
  
FROM            
	remesas_familiaressol p
	INNER JOIN      remesas_familiaresbenef b	ON (p.operacion=b.operacionsol)
	INNER JOIN      clientes c		ON (p.auxiliar_sol = c.auxiliar)
	INNER JOIN      trusadbeneficiario rb	ON ((b.auxiliar_benef = rb.auxiliarbenef) and (b.solicitud = rb.solicitud))
	INNER JOIN      Divisas d		ON (d.Divisa = b.divisa) 
	INNER JOIN      mtProvider pr		ON (pr.providerAcronym = b.Instrumento)
	LEFT OUTER JOIN tblrusadtransferencia   dt ON (b.solicitud = dt.solicitud)  and (b.auxiliar_benef=dt.auxiliarbenef)
	LEFT OUTER JOIN tDatosBancoIntermediario dbi	ON (b.solicitud = dbi.solicitud) and (b.auxiliar_benef = dbi.auxiliarbenef)
	LEFT OUTER JOIN Bancos  bc			ON ( dbi.banco = bc.CodBanco)
	INNER JOIN mtPaisesMundo pm ON rb.Cod_Pais = pm.Pai_Iso3

--WHERE			

	--p.operacion =@SolSe                            
	AND p.estado = 'G'                                          
	AND (b.estado NOT IN('R', 'D' )) 
	AND (p.usuario_ger IS NOT NULL)
	AND b.instrumento <> 'TF'
	AND rb.depositoEnCuenta = 'S'                          ---> Es un deposito en Cuenta
	--AND (datediff(mm,p.fecha_sol,getdate()) = 0)                  
	AND (p.operacioncierre IS NULL) 
