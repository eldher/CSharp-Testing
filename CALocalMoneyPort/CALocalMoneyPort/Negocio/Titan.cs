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
    public class Titan
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Titan's Files
        public static string sendFileTitan(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym)
        {
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
                DirectoryInfo di = null;
                //**
                if (sendProviderAcronym.Equals("IC"))
                {
                    nombreCorresponsal = "ICTN";
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    nombreCorresponsal = "MTTN";
                }
                #region Generar Nombre del Archivo
                string nombreArchivo = nombreCorresponsal +
                                              string.Format("{0:dd}", DateTime.Now) +
                                              string.Format("{0:MM}", DateTime.Now) +
                                              string.Format("{0:yyyy}", DateTime.Now) + "-" +
                                              string.Format("{0:HH}", DateTime.Now) +
                                              string.Format("{0:mm}", DateTime.Now) +
                                              string.Format("{0:ss}", DateTime.Now);
                #endregion
                trace.Escribir("Archivo Generado para Titan es " + nombreArchivo);
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\TitanINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\TitanINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\TitanINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\TitanINServiceSicadII\Italcambio\";
                        rutaentrada = @"\\soporteAPPL\IX00A1\TITAN\IC_IN\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\TitanINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\TitanINServiceSicadII\Munditur\";
                        rutaentrada = @"\\soporteAPPL\IX00A1\TITAN\MT_IN\";
                    }
                }
                //**
                di = new DirectoryInfo(ruta_Informacion_Y_Errores_EstaAplicacion);
                di.Create();
                di = new DirectoryInfo(ruta_Respaldos_txt_EstaAplicacion);
                di.Create();
                //***
                DateTimeFormatInfo formatoFecha = CultureInfo.CurrentCulture.DateTimeFormat;
                string nombreMes = formatoFecha.GetMonthName(DateTime.Now.Month);
                string año = Convert.ToString(DateTime.Now.Year);
                string path = rutaentrada + nombreArchivo + ".txt";
                pathRespaldo = ruta_Respaldos_txt_EstaAplicacion + nombreMes + año + @"\" + nombreArchivo + ".txt";
                Traza trazaRespaldo = new Traza(nombreArchivo, ruta_Respaldos_txt_EstaAplicacion, "txt", "");
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
                            string referenciaGiro = "";
                            if (sendProviderAcronym.Equals("IC"))
                            {
                                referenciaGiro = "ITC" + item.operationCashier.ToString();
                            }
                            if (sendProviderAcronym.Equals("MT"))
                            {
                                referenciaGiro = "ITL" + item.operationCashier.ToString();
                            }
                            double amountNational = Convert.ToDouble(item.Amount) * Convert.ToDouble(item.exchangeRateApplied);
                            lineFile = referenciaGiro + "|" +
                                       item.FirstNameBeneficiary + " " + item.SecondNameBeneficiary + " " + item.LastNameBeneficiary + " " + item.SecondLastNameBeneficiary + "|" +
                                       item.PhoneBeneficiary + "|" +
                                       item.AddressBeneficiary + "|" +
                                       item.CityBeneficiary + "|" +
                                       item.FirstNameSender + " " + item.SecondNameSender + " " + item.LastNameSender + " " + item.SecondLastNamerSender + "|" +
                                       " " + "|" +
                                       item.Amount + "|" +
                                       amountNational + "|" +
                                       item.bankName + "|" +
                                       " " + "|" +
                                       " " + "|" +
                                       " " + "|" +
                                       "S2";
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
                        trace.Escribir("Copiando en el FTP de Titan");
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
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                trace.Escribir(" sendFileTitan: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}
