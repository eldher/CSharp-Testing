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
    public class MaguiExpress
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Jet Peru Files
        public static string sendFileMaguiExpress(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
                                                string connectionString)
        {
            bool correlativoGenerado = false;
            Datos objDatos = new Datos(connectionString);
            int correlativoInc = 0;
            string pathRespaldo = string.Empty;
            try
            {
                bool sw = false;
                bool swTasa = false; 
                int counter = 1;
                string ruta_Informacion_Y_Errores_EstaAplicacion = string.Empty;
                string ruta_Respaldos_txt_EstaAplicacion = string.Empty;
                string rutaentrada = string.Empty;
                string lineFile = string.Empty;
                string nombreArchivo = string.Empty;
                string path = string.Empty;
                int correlativo = 0;
                bool archivoExiste = false;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                string rutaFtpTasa = string.Empty;
                decimal tasaMagui = 0;
                NumberFormatInfo en_US = new CultureInfo("en-US", false).NumberFormat;
                string prefijoMoneyRemitter = string.Empty;
                string agentId = string.Empty;
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\MaguiExpressINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\MaguiExpressINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    rutaFtpTasa = @"C:\Publico\Vladimir\MAGUIEXPRESS\Italcambio\TASA\";
                    prefijoMoneyRemitter = "ITA";
                    agentId = "801";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\MaguiExpressINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\MaguiExpressINServiceSicadII\Italcambio\";
                        rutaentrada = @"\\soporteappl\MAGUIEXPRESS\Italcambio\IN\";
                        rutaFtpTasa = @"\\soporteappl\MAGUIEXPRESS\Italcambio\TASA\";
                        prefijoMoneyRemitter = "ITA";
                        agentId = "801";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\MaguiExpressINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\MaguiExpressINServiceSicadII\Munditur\";
                        rutaentrada = @"\\soporteappl\MAGUIEXPRESS\Munditur\IN\";
                        rutaFtpTasa = @"\\soporteappl\MAGUIEXPRESS\Munditur\TASA\";
                        prefijoMoneyRemitter = "ITA";
                        agentId = "801";
                    }
                }
                //**
                di = new DirectoryInfo(rutaFtpTasa);
                List<FileInfo> filesInTasa = di.GetFiles().ToList<FileInfo>();
                List<FileInfo> listaFileTasa = (from f in filesInTasa
                                                where f.Name.Substring(12, 8) == DateTime.Now.Date.ToString("ddMMyyyy")
                                                select f).ToList<FileInfo>();
                FileInfo fileTasa = null;
                if (listaFileTasa.Count > 0)
                {
                    fileTasa = listaFileTasa.First();
                    StreamReader sr = fileTasa.OpenText();
                    string sLine = sr.ReadLine();
                    if (string.IsNullOrEmpty(sLine))
                    {
                        swTasa = false;
                        trace.Escribir(" El archivo de la tasa del dia esta vacio, Fin del Programa !");
                    }
                    else
                    {
                        swTasa = true;
                        string[] renglones = sLine.Split(';');
                        if (renglones[0].ToString() == "")
                        {
                            tasaMagui = 0;
                        }
                        else
                        {
                            tasaMagui = decimal.Parse(renglones[0].ToString().Replace(',', '.'), en_US);
                        }
                    }
                    sr.Close();
                }
                else
                {
                    swTasa = false;
                    trace.Escribir(" No hay archivo del dia, para la tasa, Fin del Programa !");
                }
                //**
                if (swTasa)
                {
                    #region Generar Nombre de Archivo
                    //**
                    di = new DirectoryInfo(ruta_Informacion_Y_Errores_EstaAplicacion);
                    di.Create();
                    di = new DirectoryInfo(ruta_Respaldos_txt_EstaAplicacion);
                    di.Create();
                    // Se lee el último correlativo utilizado
                    DataTable dataT = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILEMAGUIEXPRESS' ");
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
                        string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILEMAGUIEXPRESS'", (correlativoInc + 1));
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
                        DataTable dataT1 = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILEMAGUIEXPRESS' ");
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
                                string separador = ";";
                                string cantidad_a_Pagar = item.Amount.ToString().Replace(",", ".");
                                decimal dCantidad_a_Pagar = decimal.Parse(cantidad_a_Pagar, en_US);
                                dCantidad_a_Pagar = dCantidad_a_Pagar * tasaMagui;
                                cantidad_a_Pagar = dCantidad_a_Pagar.ToString("0.00", en_US);
                                //**
                                string cantidad_Enviada_En_Dolares = item.Amount.ToString().Replace(",", ".");
                                decimal dCantidad_Enviada_En_Dolares = decimal.Parse(cantidad_Enviada_En_Dolares, en_US);
                                cantidad_Enviada_En_Dolares = dCantidad_Enviada_En_Dolares.ToString("0.00", en_US);
                                //**
                                string referencia_Giro = prefijoMoneyRemitter + item.operationCashier.ToString();
                                //**
                                string comision = "0.0000";
                                comision = comision.Remove(comision.Length - 2);
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
                                lineFile = agentId + separador + //1
                                           string.Format("{0:MM/dd/yyyy}", DateTime.Now) + separador +//2 
                                           correlativo.ToString() + separador +//3
                                           item.IdProvider + separador + //4
                                           referencia_Giro + separador +//5 
                                           cantidad_Enviada_En_Dolares + separador +//6
                                           "1" +separador +//7 item.exchangeRate
                                           comision + separador +//8
                                           cantidad_a_Pagar + separador +//9
                                           item.currency + separador +//10
                                           item.operationCashier + "|" + item.operationBoxOffice + separador +//11
                                           item.FirstNameSender + " " + item.SecondNameSender + separador + //12
                                           item.LastNameSender + " " + item.SecondLastNamerSender + separador + //13
                                           item.IdSender + separador + //14
                                           item.FirstNameBeneficiary + " " + item.SecondNameBeneficiary + separador + //15
                                           item.LastNameBeneficiary + " " + item.SecondLastNameBeneficiary + separador + //16
                                           item.AddressBeneficiary + separador + //17
                                           " " + separador + //18 item.receiveNeighborhood 
                                           item.CityBeneficiary + separador + //19
                                           item.stateBeneficiary + separador + //20
                                           telefono_Beneficiario + separador + //21
                                           "No posee" + separador + //22 item.ReceivePhone2
                                           item.Country + separador + //23
                                           item.bankName + separador + //24
                                           item.bankCode + separador + //25
                                           tipoCuenta + separador + //26
                                           numCuenta + separador + //27
                                           " " + separador;  //28
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
                                trace.Escribir("Copiando en el FTP de Magui Express");
                                File.Copy(pathRespaldo, path);
                            }
                        }
                        else
                        {
                            trace.Escribir("Copiando en el FTP de Magui Express");
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
                }
                //**
                return nombreArchivo;
            }
            catch (Exception ex)
            {
                if (correlativoGenerado)
                {
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILEMAGUIEXPRESS'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" Magui Express: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}

