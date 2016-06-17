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
    public class MundialEnvios
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Mundial Envios Files
        public static string sendFileMundialEnvios(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
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
                string agentId = string.Empty;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                //***
                if (sendProviderAcronym.Equals("IC"))
                {
                    server = "ftp://ftp.mundialenvios.com/in/";
                    serverOUT = "ftp://ftp.mundialenvios.com/OUT/";
                    prefijoMoneyRemitter = "ITC";
                    userFtp = "italcambio";
                    passwordFtp = "aM7an4zo";
                    agentId = "1088";
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    server = "ftp://ftp.mundialenvios.com/in/";
                    serverOUT = "ftp://ftp.mundialenvios.com/OUT/";
                    prefijoMoneyRemitter = "ITL";
                    userFtp = "munditur";
                    passwordFtp = "Jou0phee";
                    agentId = "1089";
                }
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\MundialEnviosINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\MundialEnviosINServiceSicadII\Italcambio\";
                    rutaentrada = @"C:\Publico\Vladimir\";
                    di = new DirectoryInfo(rutaentrada);
                    di.Create();
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\MundialEnviosINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\MundialEnviosINServiceSicadII\Italcambio\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\MundialEnviosINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\MundialEnviosINServiceSicadII\Munditur\";
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
                DataTable dataT = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo Mundial Envio' ");
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
                    string query = string.Format(" UPDATE [dbo].[parametros] SET [Valor] = {0} WHERE clave = 'Correlativo Mundial Envio' ", (correlativoInc + 1));
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
                    DataTable dataT1 = objDatos.ResultTableQuery(" SELECT convert(int,Valor) as valor FROM [dbo].[parametros] WHERE [clave] = 'Correlativo Mundial Envio' ");
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
                trace.Escribir("Archivo Generado para Mundial Envios es " + nombreArchivo);
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
                            NumberFormatInfo en_US = new CultureInfo("en-US", false).NumberFormat;
                            decimal tasaComision = 4.25M;
                            string cantidad_a_Pagar = item.Amount.ToString().Replace(",", ".");
                            decimal dCantidad_a_Pagar = decimal.Parse(cantidad_a_Pagar, en_US);
                            dCantidad_a_Pagar = dCantidad_a_Pagar - (dCantidad_a_Pagar * tasaComision / 100);
                            cantidad_a_Pagar = dCantidad_a_Pagar.ToString("0.00", en_US);
                            //**
                            decimal fixingEuro = 1; // Ya el monto viene en euro de la vista
                            decimal dTasa_de_Cambio = fixingEuro;
                            string cantidad_Enviada_En_Euros = string.Empty;
                            decimal comision = 5.0M;//comision de 5euros
                            decimal dCantidad_Enviada_En_Euros = (dCantidad_a_Pagar * dTasa_de_Cambio) - comision;
                            cantidad_Enviada_En_Euros = dCantidad_Enviada_En_Euros.ToString("0.00", en_US);
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
                                if (item.bankTypeAccount.Equals("C"))
                                {
                                    tipoCuenta = "CORRIENTE";
                                }
                                else
                                {
                                    tipoCuenta = "AHORRO";
                                }
                                numCuenta = item.accountNumber.ToString();
                            }
                            else
                            {
                                tipoCuenta = "";
                                numCuenta = "";
                            }
                            //**
                            string separador = ";";
                            lineFile = agentId + separador + //1
                                       string.Format("{0:MM/dd/yyyy}", DateTime.Now) + separador +//2
                                       correlativo.ToString() + separador +//3
                                       item.IdProvider.ToString() + separador +//4
                                       prefijoMoneyRemitter + item.operationCashier.ToString() + separador +//5 
                                       cantidad_a_Pagar + separador +//6
                                       fixingEuro + separador +//7
                                       tasaComision.ToString("0.00", en_US) + separador +//8
                                       cantidad_Enviada_En_Euros + separador +//9
                                       "EUROS" + ";" +
                                       item.operationCashier.ToString() + "|" + item.operationBoxOffice.ToString() + separador +//11
                                       item.FirstNameSender.Replace(';', ' ') + " " + item.SecondNameSender.Replace(';', ' ') + separador +//12
                                       item.LastNameSender.Replace(';', ' ') + " " + item.SecondLastNamerSender.ToString() + separador +//13
                                       item.IdSender.ToString() + separador +//14
                                       item.FirstNameBeneficiary.Replace(';', ' ') + " " + item.SecondNameBeneficiary.Replace(';', ' ') + separador +//15
                                       item.LastNameBeneficiary.Replace(';', ' ') + " " + item.SecondNameBeneficiary.ToString() + separador +//16
                                       item.AddressBeneficiary.Replace(';', ' ') + separador +//17
                                       "" + separador +//18 item.receiveNeighborhood.ToString()
                                       item.CityBeneficiary.Replace(';', ' ') + separador +//19
                                       item.stateBeneficiary.Replace(';', ' ') + separador +//20
                                       telefono_Beneficiario + separador +//21
                                       "" + separador +//22 item.ReceivePhone2.ToString()
                                       item.Country.ToString() + separador +//23
                                       item.bankName.ToString() + separador +//24
                                       item.bankCode.ToString() + separador +//25
                                       tipoCuenta + separador +//26
                                       numCuenta + separador +//27
                                       "MUNDIALENVIO" + separador;//28
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
                            trace.Escribir("Copiando en el FTP de Mundial Envios");
                            File.Copy(pathRespaldo, path);
                        }
                    }
                    else
                    {
                        trace.Escribir("Copiando en el FTP de Mundial Envios");
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
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'Correlativo Mundial Envio'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" Mundial Envios: " + ex.Message.ToString());
                return "";
            }
        }
        //***
    }
}
