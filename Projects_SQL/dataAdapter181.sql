--****************************Datos Beneficiario TRANSFERENCIAS BANCARIAS *************

SELECT DISTINCT 
                         ISNULL(dt.codbanco, 0) AS CodBanco, 
                         p.Solicitud, b.Auxiliar_Benef, b.Beneficiario, b.Estado, b.Operacion AS operbenef, 
                         b.Parentesco, 
                         pm.PAI_NOMBRE AS Pais_Benef, 
                         pr.providerName AS NombreProveedor, b.Instrumento, CASE WHEN b.instrumento = 'TN' THEN 'TITAN' ELSE ' ' END AS INSTR, CONVERT(varchar(20), 
                         b.Monto_Benef) AS monto_benef, dbo.MontoLetra(b.Monto_Benef) AS MontoEnLetras, CONVERT(varchar(20), b.montodivisa) AS montodivisa, d.Nombre, 
                         rb.nombre_benef1 + '  ' + rb.nombre_benef2 AS NombresBeneficiario, rb.apellido_benef1 + '  ' + rb.apellido_benef2 AS ApellidosBeneficiario, 
                         rb.ciudad_benef AS CiudadBeneficiario, rb.direccion_benef AS DireccionBeneficiario, rb.parentesco AS parentescoreal, ISNULL(rb.depositoEnCuenta, 'N') 
                         AS DepositoenCuenta,
                             (SELECT        NomBanco
                               FROM            Bancos
                               WHERE        (CodBanco = dt.codbanco)) AS NomBanco, ISNULL(dbi.Direccion, ' ') AS DireccionBanco, CASE WHEN rb.Cod_Pais IS NOT NULL THEN
                             (SELECT        PAI_NOMBRE
                               FROM            MtpaisesMundo
                               WHERE        Pai_iso3 = rb.Cod_Pais) ELSE ' ' END AS PaisBanco, ISNULL(dt.codcuenta, ' ') AS Cuenta, ISNULL(dt.swift, ' ') AS CodSwif, ISNULL(dt.abba, ' ') AS Abba,
                          ISNULL(dt.iban, ' ') AS IBAN,
                             (SELECT        NomBanco
                               FROM            Bancos AS Bancos_1
                               WHERE        (CodBanco = dbi.Banco)) AS BancoIntermediario, ISNULL(dbi.Direccion, ' ') AS DirBancoIntermediario, ISNULL(dbi.Pais, ' ') AS PaisBancoIntermediario, 
                         ISNULL(dbi.Cuenta, ' ') AS CtaBancoIntermediario, ISNULL(dbi.CodSwif, ' ') AS SwifBancoIntermediario, ISNULL(dbi.Abba, ' ') AS AbbaBancoIntermediario, 
                         ISNULL(dbi.Banco, ' ') AS IBANBancoIntermediario
FROM            Remesas_FamiliaresSol AS p INNER JOIN
                         Remesas_FamiliaresBenef AS b ON p.Operacion = b.OperacionSol INNER JOIN
                         Clientes AS c ON p.Auxiliar_Sol = c.Auxiliar INNER JOIN
                         tRusadbeneficiario AS rb ON b.Auxiliar_Benef = rb.auxiliarbenef AND b.Solicitud = rb.solicitud INNER JOIN
                         Divisas AS d ON d.Divisa = b.divisa LEFT OUTER JOIN
                         tblrusadtransferencia AS dt ON b.Solicitud = dt.solicitud AND b.Auxiliar_Benef = dt.auxiliarbenef LEFT OUTER JOIN
                         tDatosBancoIntermediario AS dbi ON p.Operacion = dbi.Operacion INNER JOIN
                         MtProvider AS pr ON pr.providerAcronym = b.Instrumento
                         INNER JOIN mtpaisesmundo pm On rb.Cod_Pais = pm.Pai_Iso3
WHERE        (p.Operacion = @Operacion) AND (p.Estado = 'G') AND (p.Usuario_Ger IS NOT NULL) AND (b.Instrumento = 'TF') AND (DATEDIFF(mm, p.Fecha_Sol, GETDATE()) = 0) 
                         AND (p.OperacionCierre IS NULL)
                        
