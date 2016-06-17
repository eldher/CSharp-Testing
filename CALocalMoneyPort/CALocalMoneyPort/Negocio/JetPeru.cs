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
    public class JetPeru
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Jet Peru Files
        public static string sendFileJetPeru(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
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
                string userFtp = string.Empty;
                string passwordFtp = string.Empty;
                string prefijoMoneyRemitter = string.Empty;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                //***
                if (sendProviderAcronym.Equals("IC"))
                {
                    server = "ftp://190.223.47.94/input/";
                    nombreCorresponsal = "ICCMB";
                    userFtp = "italcambios";
                    passwordFtp = "559ital230412";
                    prefijoMoneyRemitter = "559";
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    server = "ftp://190.223.47.94/input/";
                    nombreCorresponsal = "ICCMB";
                    userFtp = "munditur";
                    passwordFtp = "560mund110712";
                    prefijoMoneyRemitter = "560";
                }
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\JetPeruINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\JetPeruINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\JetPeruINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\JetPeruINServiceSicadII\Italcambio\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\JetPeruINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\JetPeruINServiceSicadII\Munditur\";
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
                DataTable dataT = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo JETPERU' ");
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
                    string query = string.Format(" UPDATE [dbo].[parametros] SET [Valor] = convert(varchar,{0}) WHERE clave = 'Correlativo JETPERU' ", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                    //***
                    nombreArchivo = prefijoMoneyRemitter + correlativoInc.ToString("00000000");
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
                    DataTable dataT1 = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo JETPERU'  ");
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
                trace.Escribir("Archivo Generado para JetPeru es " + nombreArchivo);
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
                            string separador = ",";
                            NumberFormatInfo en_US = new CultureInfo("en-US", false).NumberFormat;
                            decimal tasa = 1;
                            string cantidad_a_Pagar = item.Amount.ToString().Replace(",", ".");
                            decimal dCantidad_a_Pagar = decimal.Parse(cantidad_a_Pagar, en_US);
                            dCantidad_a_Pagar = dCantidad_a_Pagar * tasa;
                            cantidad_a_Pagar = dCantidad_a_Pagar.ToString("0.00", en_US);
                            //**
                            string tasa_Cambio = "1.00";
                            //**
                            string telefono_Beneficiario = item.PhoneBeneficiary.ToString();
                            // se baja el teléfono a 10 dígitos
                            if (telefono_Beneficiario.Length > 10)
                                telefono_Beneficiario = telefono_Beneficiario.Remove(0, telefono_Beneficiario.Length - 10);
                            //**
                            string CurrencyPaymentType = "D";
                            string PaymentType = string.Empty;
                            string tipoCuenta;
                            string numCuenta;
                            if (item.typeAccount.Equals("DC"))
                            {
                                PaymentType = "B";
                                tipoCuenta = "CC";
                                numCuenta = item.accountNumber.ToString();
                            }
                            else
                            {
                                PaymentType = "O";
                                tipoCuenta = "";
                                numCuenta = "";
                            }
                            //**
                            lineFile = item.IdProvider.ToString() + separador +//1
                                       item.IdProvider.ToString() + separador +//2
                                       string.Format("{0:MM/dd/yyyy}", DateTime.Now) + separador +//3
                                       item.LastNameSender.ToString() + separador +//4
                                       item.SecondLastNamerSender.ToString() + separador +//5
                                       item.FirstNameSender.ToString() + " " + item.SecondNameSender.ToString() + separador +//6
                                       item.IdSender.ToString() + separador +//7
                                       item.addressRemitter.ToString() + separador +//8
                                       item.LastNameBeneficiary.ToString() + separador +//9
                                       item.SecondLastNameBeneficiary.ToString() + separador +//10
                                       item.FirstNameBeneficiary.ToString() + " " + item.SecondNameBeneficiary.ToString() + separador +//11
                                       item.AddressBeneficiary.ToString() + separador +//12
                                       item.CityBeneficiary.ToString() + separador +//13
                                       item.Country.ToString() + separador +//14
                                       telefono_Beneficiario + separador +//15
                                       " " + separador +//16
                                       PaymentType + separador + //17
                                       cantidad_a_Pagar + separador +//18
                                       CurrencyPaymentType + separador + //19
                                       tasa_Cambio + separador + //20
                                       cantidad_a_Pagar + separador +//21
                                       item.bankName.ToString() + separador +//22
                                       tipoCuenta + separador +//23
                                       numCuenta + separador +//24
                                       item.KeySender.ToString() + "|" + item.operationBoxOffice.ToString() + separador + //25
                                       "" + separador; //26
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
                            trace.Escribir("Copiando en el FTP de JetPeru");
                            File.Copy(pathRespaldo, path);
                        }
                    }
                    else
                    {
                        trace.Escribir("Copiando en el FTP de JetPeru");
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
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'Correlativo JETPERU'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" JetPeru: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}
