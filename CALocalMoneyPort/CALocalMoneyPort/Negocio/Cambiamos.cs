using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.ServiceModel;
using System.Threading;
using System.Security;
using System.Security.Permissions;
using System.Configuration;
using CALocalMoneyPort.WSItalcambio;
using CLBusinessObjects.Archivos;
using CALocalMoneyPort.Negocio;
using CLBusinessObjects.DATOS;
using System.IO;
using System.Globalization;

namespace CALocalMoneyPort.Negocio
{
    public class Cambiamos
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
        string nombreArchivo = string.Empty;

        //Cambiamos Files
        public static string sendFileCambiamos(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
                                             string connectionString)
        {
            bool correlativoGenerado = false;
            Datos objDatos = new Datos(connectionString);
            int correlativoInc = 0;
            string pathRespaldo = string.Empty;
            try
            {
                bool sw = false;
                int counter = 1;
                string ruta_Informacion_Y_Errores_EstaAplicacion = string.Empty;
                string ruta_Respaldos_txt_EstaAplicacion = string.Empty;
                string rutaentrada = string.Empty;
                string lineFile = string.Empty;
                string nombreCorresponsal = string.Empty;
                string nombreArchivo = string.Empty;
                string path = string.Empty;
                int correlativo = 0;
                bool archivoExiste = false;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                //***
                if (sendProviderAcronym.Equals("IC"))
                {
                    nombreCorresponsal = "ICSFC";
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    nombreCorresponsal = "MUSFC";
                }
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\CambiamosINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\CambiamosINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\CambiamosINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\CambiamosINServiceSicadII\Italcambio\";
                        rutaentrada = @"\\Soporteappl\IX00A2\cambiamos\SICAD2\entrada\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\CambiamosINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\CambiamosINServiceSicadII\Munditur\";
                        rutaentrada = @"\\Soporteappl\IX00A2\cambiamos\Munditur\SICAD2\entrada\";
                    }
                }
                //***
                #region Generar Nombre de Archivo
                //**
                di = new DirectoryInfo(ruta_Informacion_Y_Errores_EstaAplicacion);
                di.Create();
                di = new DirectoryInfo(ruta_Respaldos_txt_EstaAplicacion);
                di.Create();
                // Se lee el último correlativo utilizado
                DataTable dataT = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILECAMBIAMOS' ");
                foreach (DataRow Row in dataT.Rows)
                {
                    decimal rounded = decimal.Round(Convert.ToDecimal(Row["Valor"].ToString()), 0);
                    correlativo = Convert.ToInt32(rounded);
                }
                correlativoInc = correlativo;
                string nombreMes;
                string año;
                //***
                do
                {
                    correlativo = correlativoInc;
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILECAMBIAMOS'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                    //***
                    nombreArchivo = string.Format("{0:MM}", DateTime.Now) +
                                    string.Format("{0:dd}", DateTime.Now) +
                                    string.Format("{0:yy}", DateTime.Now) +
                                    correlativoInc.ToString("0000");
                    //***
                    DateTimeFormatInfo formatoFecha = CultureInfo.CurrentCulture.DateTimeFormat;
                    nombreMes = formatoFecha.GetMonthName(DateTime.Now.Month);
                    año = Convert.ToString(DateTime.Now.Year);
                    path = rutaentrada + nombreArchivo + ".txt";
                    pathRespaldo = ruta_Respaldos_txt_EstaAplicacion + nombreMes + año + @"\" + nombreArchivo + ".txt";
                    if (File.Exists(pathRespaldo))
                    {
                        archivoExiste = true;
                    }
                    else
                    {
                        archivoExiste = false;
                    }
                    //***
                    DataTable dataT1 = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILECAMBIAMOS' ");
                    foreach (DataRow Row in dataT1.Rows)
                    {
                        decimal rounded = decimal.Round(Convert.ToDecimal(Row["Valor"].ToString()), 0);
                        correlativoInc = Convert.ToInt32(rounded);
                    }
                    //***
                } while ((correlativoInc == correlativo) || (archivoExiste));
                #endregion
                correlativoGenerado = true;
                trazaRespaldo = new Traza(nombreArchivo, ruta_Respaldos_txt_EstaAplicacion, "txt", "");
                trace.Escribir("Archivo Generado para Cambiamos es " + nombreArchivo);
                //***
                foreach (DataRow Row in dt.Rows)
                {
                    string keySender = objDecrypt.Desencriptar(Row["keySender"].ToString());
                    string codigoOut = objDecrypt.Desencriptar(Row["codigo"].ToString());
                    foreach (var item in t)
                    {
                        tReceiptElectronicMoney tr = new tReceiptElectronicMoney();
                        tr = item;
                        tr = tr.decryptMoneyObj(trace);
                        //***
                        if ((keySender.Equals(tr.KeySender)) && (codigoOut.Equals("0052")))
                        {
                            //***
                            Console.WriteLine("Copiando (" + Convert.ToString(counter) + ") de (" + Convert.ToString(t.Count()) + ")");
                            if (((counter % 10) == 0) || (counter == 1) || (counter == t.Count()))
                            {
                                trace.Escribir("Copiando en " + nombreArchivo + " (" + Convert.ToString(counter) + ") de (" + Convert.ToString(t.Count()) + ")");
                            }
                            //***
                            NumberFormatInfo en_US = new CultureInfo("en-US", false).NumberFormat;
                            decimal tasa = 1;
                            string cantidad_a_Pagar = item.Amount.ToString().Replace(",", ".");
                            decimal dCantidad_a_Pagar = decimal.Parse(cantidad_a_Pagar, en_US);
                            dCantidad_a_Pagar = dCantidad_a_Pagar * tasa;
                            cantidad_a_Pagar = dCantidad_a_Pagar.ToString("0.00", en_US);
                            //**
                            string cantidad_Enviada_En_Dolares = item.Amount.ToString().Replace(",", ".");
                            decimal dCantidad_Enviada_En_Dolares = decimal.Parse(cantidad_Enviada_En_Dolares, en_US);
                            cantidad_Enviada_En_Dolares = dCantidad_Enviada_En_Dolares.ToString("0.00", en_US);
                            //**
                            string referencia_Giro = string.Empty;
                            if (sendProviderAcronym.Equals("IC"))
                            {
                                referencia_Giro = "SIC" + item.operationCashier.ToString();
                            }
                            if (sendProviderAcronym.Equals("MT"))
                            {
                                referencia_Giro = "SMU" + item.operationCashier.ToString();
                            }
                            //**
                            string telefono_Beneficiario = item.PhoneBeneficiary.ToString();
                            // se baja el teléfono a 10 dígitos
                            if (telefono_Beneficiario.Length > 10)
                                telefono_Beneficiario = telefono_Beneficiario.Remove(0, telefono_Beneficiario.Length - 10);
                            // se chequea si el teléfono es un celular de colombia
                            string codigoCelularColombia = string.Empty;
                            if (telefono_Beneficiario.Length >= 3)
                                codigoCelularColombia = telefono_Beneficiario.Substring(0, 3);
                            // si NO es un celular de Colombia entonces se baja el teléfono a 7 dígitos
                            if (codigoCelularColombia.Length >= 2)
                            {
                                if (codigoCelularColombia != "310"
                                 && codigoCelularColombia != "311"
                                 && codigoCelularColombia != "312"
                                 && codigoCelularColombia != "313"
                                 && codigoCelularColombia != "314"
                                 && codigoCelularColombia != "315"
                                 && codigoCelularColombia != "316"
                                 && codigoCelularColombia != "317"
                                 && codigoCelularColombia != "318"
                                 && codigoCelularColombia.Substring(0, 2) != "30"
                                 && codigoCelularColombia.Substring(0, 2) != "32"
                                    )
                                {
                                    if (telefono_Beneficiario.Length > 7)
                                        telefono_Beneficiario = telefono_Beneficiario.Remove(0, telefono_Beneficiario.Length - 7);
                                }
                            }
                            //**
                            string formaPago;
                            if (item.typeAccount.Equals("DC"))
                            {
                                formaPago = "1";
                            }
                            else
                            {
                                formaPago = "2";
                            }
                            //**
                            string mes = string.Format("{0:MMM}", DateTime.Now);
                            if (mes.Equals("Jan"))
                                mes = "Ene";
                            else if (mes.Equals("Apr"))
                                mes = "Abr";
                            else if (mes.Equals("Aug"))
                                mes = "Ago";
                            else if (mes.Equals("Dec"))
                                mes = "Dic";
                            //**
                            lineFile = nombreCorresponsal + "|" +                                   // 1	IDCorresponsal	CHAR(05)	Codigo Asignado por el MoneyRemitter a Cambiamos
                                         item.IdProvider.ToString() + "|" +                         // 2	Secuencia	CHAR(05)	Número secuencial asignado por el MoneyRemitter para los giros enviados a Cambiamos
                                         mes + string.Format("{0:yyyy}", DateTime.Now) + "|" +      // 3 MMMYYYY ej: Ene2011	ID_Interno_Orden_MoneyRemitter	CHAR(09)	Para manejo interno del Money Remitter
                                         item.operationBoxOffice.ToString() + "|" +                 // 4 No.Solicitud  	Numero_Orden_MoneyRemitter	CHAR(11)	Para manejo interno del Money Remitter
                                         string.Format("{0:MM/dd/yyyy}", DateTime.Now) + "|" +      // 5	Fecha_Orden	CHAR(10)	Fecha de creación del Giro en formato MM/DD/AAAA
                                         "COP" + "|" +                                              // 6	Divisa_de_Pago	CHAR(03)	Divisa/Moneda en la que se paga el giro (USD/COP)
                                         cantidad_a_Pagar + "|" +                                   // 7	Cantidad_a_Pagar	CHAR(12)	El formato es 999999999.99 (el carácter PUNTO viene escrito)
                                         referencia_Giro + "|" +                                    // 8	Referencia_Giro	CHAR(17)	Número único asignado al giro y entregado al Remitente; las tres primeras posiciones corresponde a un prefijo del MONEYREMITTER, por ejemplo para Italcambio puede ser ITA (ITA + 8 dígitos)
                                         item.bankName.ToString() + "|" +                           // 9	Oficina_de_Pago	CHAR(15)	Oficina en Colombia hacia donde va dirigido el giro ( el beneficiario puede opcionalmente cobrar en cualquier punto de la red de Cambiamos  ) dado que el giro se puede cobrar en cualquier oficina
                                         item.bankCode.ToString() + "|" +                           // 10	Código_de_Oficina_de_Pago	CHAR(05)	Código asignado por Cambiamos a las oficinas (se les enviará la correspondiente tabla)
                                         item.FirstNameSender.ToString() + "|" +                    // 11	Primer_Nombre_Remitente	CHAR(20)	
                                         item.LastNameSender.ToString() + "|" +                     // 12	Primer_Apellido_Remitente	CHAR(20)	
                                         item.SecondLastNamerSender.ToString() + "|" +              // 13	Segundo_Apellido_Remitente	CHAR(20)	
                                         item.phoneRemitter.ToString() + "|" +                      // 14	Telefono_Remitente	CHAR(15)	
                                         item.addressRemitter.ToString() + "|" +                    // 15	Direccion_Remitente	CHAR(40)	
                                         item.cityRemitter.ToString() + "|" +                       // 16	Ciudad_Remitente	CHAR(20)	
                                         item.stateRemitter.ToString() + "|" +                      // 17	Estado_Remitente	CHAR(20)	
                                         item.senderZipCode.ToString() + "|" +                      // 18	Codigo_Postal_Remitente	CHAR(05)	
                                         item.senderCountry.ToString() + "|" +                      // 19	Pais_Remitente	CHAR(20)	
                                         item.FirstNameBeneficiary.ToString() + "|" +               // 20	Primer_Nombre_Beneficiario	CHAR(20)	
                                         item.LastNameBeneficiary.ToString() + "|" +                // 21	Primer_Apellido_Beneficiario	CHAR(20)	
                                         item.SecondLastNameBeneficiary.ToString() + "|" +          // 22	Segundo_Apellido_Beneficiario	CHAR(20)	
                                         telefono_Beneficiario + "|" +                              // 23	Telefono_Beneficiario	CHAR(15)	Telefono fijo debe tener 7 numeros o el celular debe tener 10 numeros (no incluir area code)
                                         item.AddressBeneficiary.ToString() + "|" +                 // 24	Direccion_Beneficiario	CHAR(40)	
                                         item.CityBeneficiary.ToString() + "|" +                    // 25	Ciudad_Beneficiario	CHAR(20)	
                                         item.stateBeneficiary.ToString() + "|" +                   // 26	Departamento_Beneficiario	CHAR(20)	
                                         item.senderZipCodeBenef.ToString() + "|" +                 // 27	Codigo_Postal_Beneficiario	CHAR(05)	
                                         item.Country.ToString() + "|" +                            // 28	Pais_Beneficiario	CHAR(20)	
                                         item.bankName.ToString() + "|" +                           // 29	Banco_o_Mensaje	CHAR(40)	Nombre del Banco, Ciudad del Banco, Tipo de Cuenta (para abono en cuenta)
                                         formaPago + "|" +                                          // 30	Forma_de_Pago	CHAR(01)	Forma de Pago  ( 1 - Pago en ventanilla, 2 - Abono en cuenta )
                                         item.accountNumber.ToString() + "|" +                      // 31	Numero_de_Cuenta_del_Banco	CHAR(20)	
                                         cantidad_Enviada_En_Dolares + "|" +                        // 32	Cantidad_Enviada_En_Dolares	CHAR(12)	El formato es 999999999.99 (el carácter PUNTO viene escrito)
                                         "USD" + "|" +                                              // 33	Tipo_de_Divisa	CHAR(03)	 Siempre USD
                                         "1.00" + "|" +                                             // 34	Tasa_de_Cambio_Divisa	CHAR(12)	El formato es 999999999.99 (el carácter PUNTO viene escrito)
                                         "0" + "|" +                                                // 35	Valor_Comision	CHAR(12)	El formato es 999999999.99 (el carácter PUNTO viene escrito)
                                         "" + "|";                                                  // 36	Divisa_de_la_Comision	CHAR(03)	
                            trazaRespaldo.Escribir(lineFile);
                            sw = true;
                            counter++;
                            //***
                        }
                        tr = tr.encryptMoneyObj(trace);
                    }
                }
                //***
                if (sw)
                {
                    sw = false;
                    if (File.Exists(pathRespaldo))
                    {
                        trace.Escribir("Copiando en el FTP de Cambiamos");
                        File.Copy(pathRespaldo, path);
                    }
                }
                else
                {
                    if (File.Exists(pathRespaldo))
                    {
                        File.Delete(pathRespaldo);
                    }
                }
                //***
                return nombreArchivo;
            }
            catch (Exception ex)
            {
                if (correlativoGenerado)
                {
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILECAMBIAMOS'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" sendFileCambiamos: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}
