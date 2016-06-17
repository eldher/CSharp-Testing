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
    public class PagosInternacionales
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Pagos Internacionales Files
        public static string sendFilePagosInternacionales(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
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
                string server = string.Empty;
                string serverOUT = string.Empty;
                string userFtp = string.Empty;
                string passwordFtp = string.Empty;
                string prefijoMoneyRemitter = string.Empty;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                //***
                if (sendProviderAcronym.Equals("IC"))
                {
                    server =  "ftp://201.234.190.20/IN/";
                    serverOUT = "ftp://201.234.190.20/OUT/";
                    nombreCorresponsal = "ICCMB";
                    userFtp = "italcambio";
                    passwordFtp = "fpisa2012";
                    prefijoMoneyRemitter = "ITC";
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    server = "ftp://201.234.190.20/IN/";
                    serverOUT = "ftp://201.234.190.20/OUT/";
                    nombreCorresponsal = "MTCMB";
                    userFtp = "mulditour";
                    passwordFtp = "fpisa2012";
                    prefijoMoneyRemitter = "ITL";
                }
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\PagosIntINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\PagosIntINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\PagosIntINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\PagosIntINServiceSicadII\Italcambio\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\PagosIntINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\PagosIntINServiceSicadII\Munditur\";
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
                DataTable dataT = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo PAGOSINTER' ");
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
                    string query = string.Format(" UPDATE [dbo].[parametros] SET [Valor] = convert(varchar,{0}) WHERE clave = 'Correlativo PAGOSINTER' ", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                    //***
                    nombreArchivo = prefijoMoneyRemitter +
                                    "_" +
                                    string.Format("{0:yy}", DateTime.Now) +
                                    string.Format("{0:MM}", DateTime.Now) +
                                    string.Format("{0:dd}", DateTime.Now) +
                                    "_" +
                                    correlativoInc.ToString();
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
                    DataTable dataT1 = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo PAGOSINTER' ");
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
                trace.Escribir("Archivo Generado para Pagos Internacionales es " + nombreArchivo);
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
                            if (((counter % 5) == 0) || (counter == 1) || (counter == t.Count()))
                            {
                                trace.Escribir("Copiando en " + nombreArchivo + " (" + Convert.ToString(counter) + ") de (" + Convert.ToString(t.Count()) + ")");
                            }
                            //***
                            string separador = ";";
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
                            string telefono_Beneficiario = item.PhoneBeneficiary.ToString();
                            // se baja el teléfono a 10 dígitos
                            if (telefono_Beneficiario.Length > 10)
                                telefono_Beneficiario = telefono_Beneficiario.Remove(0, telefono_Beneficiario.Length - 10);
                            //**
                            string tipoCuenta;
                            string numCuenta;
                            if (item.typeAccount.Equals("DC"))
                            {
                                tipoCuenta = "CC";
                                numCuenta = item.accountNumber.ToString();
                            }
                            else
                            {
                                tipoCuenta = "";
                                numCuenta = "";
                            }
                            //**
                            lineFile = string.Format("{0:MM/dd/yyyy}", DateTime.Now) + separador +//1
                                          item.IdProvider.Replace(';', ' ') + separador +//2
                                          "USD" + separador +//3
                                          cantidad_a_Pagar + separador +//4
                                          cantidad_Enviada_En_Dolares + separador +//5
                                          "1" + separador +//6
                                          item.FirstNameSender.Replace(';', ' ') + " " + item.SecondNameSender.Replace(';', ' ') + separador +//7
                                          item.LastNameSender.Replace(';', ' ') + " " + item.SecondLastNamerSender.ToString() + separador +//8
                                          item.IdSender.Replace(';', ' ') + separador +//9
                                          item.FirstNameBeneficiary.Replace(';', ' ') + " " + item.SecondNameBeneficiary.Replace(';', ' ') + separador +//10
                                          item.LastNameBeneficiary.Replace(';', ' ') + " " + item.SecondNameBeneficiary.ToString() + separador +//11
                                          item.AddressBeneficiary.Replace(';', ' ') + separador +//12
                                          item.CityBeneficiary.Replace(';', ' ') + separador +//13
                                          item.Country.Replace(';', ' ') + separador +//14
                                          telefono_Beneficiario.Replace(';', ' ') + separador +//15
                                          item.KeySender.ToString() + "|" + item.operationBoxOffice.ToString() + separador + //16 mensaje
                                          item.bankName.Replace(';', ' ') + separador +//17
                                          item.bankCode.Replace(';', ' ') + separador +//18
                                          numCuenta.Replace(';', ' ') + separador +//19
                                          tipoCuenta.Replace(';', ' ') + separador +//20
                                          item.IdBeneficiary.Replace(';', ' ') + separador +//21
                                          item.bankName.Replace(';', ' ') + separador +//22
                                          "VE" + separador +//23
                                          item.phoneRemitter.Replace(';', ' ') + separador +//24
                                          item.addressRemitter.Replace(';', ' ') + separador +//25
                                          item.cityRemitter.Replace(';', ' ') + separador +//26
                                          "" + separador + //27
                                          "" + separador; //28
                            //***
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
                    if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                    {
                        if (File.Exists(pathRespaldo))
                        {
                            trace.Escribir("Copiando en el FTP de Pagos Internacionales");
                            File.Copy(pathRespaldo, path);
                        }
                    }
                    else
                    {
                        trace.Escribir("Copiando en el FTP de Pagos Internacionales");
                        UploadFTPClass.UploadFTP(pathRespaldo, server, userFtp, passwordFtp);
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
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'Correlativo PAGOSINTER'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" Pagos Internacionales: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}
