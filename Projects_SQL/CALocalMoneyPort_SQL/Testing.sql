select * from mtProviderAgents where iso3Code='VEN'

select * from mtAccesoItalcambioService

select * from uVwGirosTMoneySendTRansaction

select * from tMoneySendTransaction where CodOperation = '013004201407580001'

select * from tMoneySendTransaction where providerAcronym = 'OI'

sp_helptext uVwGirosTMoneySendTRansaction




Select * from parametros where clave like '%APPENVIO%'

--INSERT INTO parametros VALUES ('SACC','APPENVIOOI','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en ORGANIZACIÓN ITALCAMBIO')

--INSERT INTO parametros VALUES ('SACC','APPENVIORY','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en ORGANIZACIÓN ITALCAMBIO')

--INSERT INTO parametros VALUES ('SACC','APPENVIOIU','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en ORGANIZACIÓN ITALCAMBIO')



UPDATE parametros SET Descripcion='(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en ITALCAMBIO INTERNACIONAL' WHERE CLAVE='APPENVIOIU'
--INSERT INTO parametros VALUES ('SACC','RUTAAPPENVIOOI','\\desarrollonew3\ejecutables\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')

--INSERT INTO parametros VALUES ('SACC','RUTAAPPENVIORY','\\desarrollonew3\ejecutables\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')

--INSERT INTO parametros VALUES ('SACC','RUTAAPPENVIOIU','\\desarrollonew3\ejecutables\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')



EXEC uSpLocalMoneyPort ID,OI,CREDENTIAL


select * from mtAccesoItalcambioService

SELECT * FROM mtProviderAgents where iso3Code='PAN'


SELECT * FROM ufnConsultarTBeneficiario('V17978450' ,'')


sp_helptext ufnConsultarTBeneficiario


select * from dbo.tBeneficiario  WHERE Auxiliar_solic='V17978450'

UPDATE tBeneficiario SET Cod_Estado='25' WHERE auxiliar_benef='V17978451'


select * from tREceiptElectronicMoney

DELETE FROM tREceiptElectronicMoney WHERE idProvider='1'

select * from mtDivisa

SELECT * FROM mtProviderAgents WHERE PROVIDERACRONYM = 'IU'

UPDATE mtProviderAgents SET iso2Code='DO' WHERE PROVIDERACRONYM = 'IU'