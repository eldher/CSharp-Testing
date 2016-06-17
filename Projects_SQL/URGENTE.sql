select * from parametros where CLAVE like '%APPENVIO%'



INSERT INTO parametros VALUES('SACC','RUTAAPPENVIOID','\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')
INSERT INTO parametros VALUES('SACC','RUTAAPPENVIOIU','\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')
INSERT INTO parametros VALUES('SACC','RUTAAPPENVIOOI','\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')
INSERT INTO parametros VALUES('SACC','RUTAAPPENVIORY','\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')
INSERT INTO parametros VALUES('SACC','RUTARECIVOSEECAJA','\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe','Ruta donde apunta la aplicación CALocalMoneyPort')

UPDATE parametros SET Valor = '\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe' WHERE CLAVE = 'RUTAAPPENVIOID'
UPDATE parametros SET Valor = '\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe' WHERE CLAVE = 'RUTAAPPENVIOIU'
UPDATE parametros SET Valor = '\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe' WHERE CLAVE = 'RUTAAPPENVIOOI'
UPDATE parametros SET Valor = '\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe' WHERE CLAVE = 'RUTAAPPENVIORY'
UPDATE parametros SET Valor = '\\panama\ejecutables\taquilla\IID\CALocalMoneyPort\CALocalMoneyPort.exe' WHERE CLAVE = 'RUTARECIVOSEECAJA'


INSERT INTO parametros VALUES('SACC','APPENVIOID','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en RAH')
INSERT INTO parametros VALUES('SACC','APPENVIOIU','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en RAH')
INSERT INTO parametros VALUES('SACC','APPENVIOOI','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en RAH')
INSERT INTO parametros VALUES('SACC','APPENVIORY','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en RAH')
INSERT INTO parametros VALUES('SACC','APPENVIOTS','ACTIVADO','(ACTIVADO/DESACTIVADO) Seran sus valores, APP que permite la busqueda de clave en RAH')












DELETE FROM parametros WHERE Clave = 'RUTAAPPENVIOID2'


sp_helptext uSpInsert_tQueryStatusRCV