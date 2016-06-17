CREATE PROCEDURE [dbo].[uSpSetLocalCurrency]  
  
  
  
@codigoDivisa varchar(5),  
@providerAcronym varchar(5),  
@pai_iso3 varchar(5),  
@nombreDivisa varchar(50),  
@tasaVenta money,  
@tasaCompra money,  
@fixing money,  
@monedaLocal varchar(5),  
@diferencialTasaVenta float,  
@diferencialTasaCompra float,  
@reguladorDifTasaVenta varchar(2),  
@reguladorDifTasaCompra varchar(2),  
@statusDivisa varchar(5),  
@descripcion varchar(200)  
  
AS   
BEGIN  
-- DECLARE  
  
IF NOT EXISTS (SELECT * FROM [mtDivisa]   
WHERE codigoDivisa= @codigoDivisa  
AND [providerAcronym] = @providerAcronym   
AND [pai_iso3] = @pai_iso3)  
  
BEGIN  
 INSERT INTO [mtDivisa]  
      ([codigoDivisa]  
      ,[providerAcronym]  
      ,[pai_iso3]  
      ,[nombreDivisa]  
      ,[tasaVenta]  
      ,[tasaCompra]  
      ,[fixing]  
      ,[monedaLocal]  
      ,[diferencialTasaVenta]  
      ,[diferencialTasaCompra]  
      ,[reguladorDifTasaVenta]  
      ,[reguladorDifTasaCompra]  
      ,[statusDivisa]  
      ,[descripcion])  
   VALUES  
    (@codigoDivisa  
    ,@providerAcronym   
    ,@pai_iso3   
    ,@nombreDivisa   
    ,@tasaVenta   
    ,@tasaCompra   
    ,@fixing  
    ,@monedaLocal   
    ,@diferencialTasaVenta   
    ,@diferencialTasaCompra   
    ,@reguladorDifTasaVenta   
    ,@reguladorDifTasaCompra   
    ,@statusDivisa   
    ,@descripcion)  
  
END  
ELSE  
BEGIN  
 UPDATE mtDivisa  
    SET [codigoDivisa] = @codigoDivisa  
    ,[providerAcronym] = @providerAcronym   
    ,[pai_iso3] = @pai_iso3  
    ,[nombreDivisa] = @nombreDivisa   
    ,[tasaVenta] = @tasaVenta   
    ,[tasaCompra] = @tasaCompra   
    ,[fixing] = @fixing  
    ,[monedaLocal] = @monedaLocal  
    ,[diferencialTasaVenta] = @diferencialTasaVenta   
    ,[diferencialTasaCompra] = @diferencialTasaCompra  
    ,[reguladorDifTasaVenta] = @reguladorDifTasaVenta   
    ,[reguladorDifTasaCompra] = @reguladorDifTasaCompra   
    ,[statusDivisa] =@statusDivisa  
    ,[descripcion] = @descripcion  
  WHERE codigoDivisa = @codigoDivisa  
  AND providerAcronym = @providerAcronym  
    AND pai_iso3 = @pai_iso3  
END  
END