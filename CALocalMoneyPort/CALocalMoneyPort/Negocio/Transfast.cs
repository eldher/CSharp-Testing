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
using CLBusinessObjects.Archivos;
using CALocalMoneyPort.Negocio;
using CLBusinessObjects.DATOS;
using System.IO;
using System.Globalization;
using System.Security.Cryptography;
using CALocalMoneyPort.TransfastService;
using System.Net;
using System.Data.SqlClient;
using System.ComponentModel;
using System.Diagnostics;
using System.Timers;
using CALocalMoneyPort.WSItalcambio;

namespace CALocalMoneyPort.Negocio
{
    public class Transfast
    {
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();

        //Transfast Transactions
        public static string sendTransactionsTransfast(Traza trace, tReceiptElectronicMoney[] t, string environment, DataTable dt, string sendProviderAcronym,
                                                     string connectionString)
        {
            bool correlativoGenerado = false;
            Datos objDatos = new Datos(connectionString);
            int correlativoInc = 0;
            string pathRespaldo = string.Empty;
            string sPin = string.Empty;
            //***
            //instanciacion de la clase header para la autenticacion del servicio     
            TransfastService.WSTF_PC_Header header = new WSTF_PC_Header();
            //TransFastServiceWeb.WSTF_PC_Header header = new WSTF_PC_Header();
            TransfastService.wstf_PCSoapClient SoapWs = new wstf_PCSoapClient();
            //instanciacion de la clase que contiene los parametros requeridos para la transaccion
            TransfastService.SendTxnRequest SendRequest = new SendTxnRequest();
            TransfastService.SendTxnResponse SendResponse = new SendTxnResponse();
            TransfastService.SendTxnParms SendParams = new TransfastService.SendTxnParms();
            //instanciacion de la clase para obtener la clave desde TRANSFAST para el envio.
            TransfastService.GetTFN_Parms KeyParams = new GetTFN_Parms();
            TransfastService.GetTFNRequest KeyRequest = new GetTFNRequest();
            TransfastService.GetTFNResponse KeyResponse = new GetTFNResponse();
            List<SenderKeyObject> listaClaves = new List<SenderKeyObject>();
            //***
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
                string sSenderKeys = string.Empty;
                Traza trazaRespaldo;
                DirectoryInfo di = null;
                //***
                #region Conexion al Proxy
                WebProxy proxyObject = new WebProxy("http://192.168.110.2:8080/");
                proxyObject.Credentials = new NetworkCredential("vyepez", @"134448126");
                WebRequest.DefaultWebProxy = proxyObject;
                #endregion
                //***
                if (sendProviderAcronym.Equals("IC"))
                {
                    #region Autenticación del Header ITALCAMBIO
                    header.sWebUser = "WSAIT01";
                    header.sWebPassword = "RVM05N92";
                    header.sCompanyID = "1";
                    sPin = "324873VEIT01309";
                    #endregion
                }
                if (sendProviderAcronym.Equals("MT"))
                {
                    #region Autenticación del Header MUNDITUR
                    header.sWebUser = "VN88MU53R";
                    header.sWebPassword = "RVM05N92";
                    header.sCompanyID = "1";
                    sPin = "625233VNMU01402";
                    #endregion
                }
                //***
                if ((environment.Equals("desarrollo")) || (environment.Equals("pruebas")))
                {
                    ruta_Informacion_Y_Errores_EstaAplicacion = @"C:\Logs_Y_Respaldos\Informacion_Y_Errores\TransfastINServiceSicadII\Italcambio\";
                    ruta_Respaldos_txt_EstaAplicacion = @"C:\Logs_Y_Respaldos\Respaldos_txt\TransfastINServiceSicadII\Italcambio\";
                }
                else
                {
                    if (sendProviderAcronym.Equals("IC"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\TransfastINServiceSicadII\Italcambio\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\TransfastINServiceSicadII\Italcambio\";
                    }
                    //***
                    if (sendProviderAcronym.Equals("MT"))
                    {
                        ruta_Informacion_Y_Errores_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Informacion_Y_Errores\TransfastINServiceSicadII\Munditur\";
                        ruta_Respaldos_txt_EstaAplicacion = @"\\Soporteappl\Logs_Y_Respaldos\Respaldos_txt\TransfastINServiceSicadII\Munditur\";
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
                DataTable dataT = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILETRANFAST' ");
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
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILETRANFAST'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                    //***
                    nombreArchivo = "FT_" + string.Format("{0:MM}", DateTime.Now) +
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
                    DataTable dataT1 = objDatos.ResultTableQuery("SELECT [Valor] FROM [dbo].[Correlativos] WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILETRANFAST' ");
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
                trace.Escribir("Archivo Generado para Transfast es " + nombreArchivo);
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
                            sw = true;
                            //***
                            Console.WriteLine("Copiando (" + Convert.ToString(counter) + ") de (" + Convert.ToString(t.Count()) + ")");
                            if (((counter % 5) == 0) || (counter == 1) || (counter == t.Count()))
                            {
                                trace.Escribir("Copiando en " + nombreArchivo + " (" + Convert.ToString(counter) + ") de (" + Convert.ToString(t.Count()) + ")");
                            }
                            //***

                            #region Obteniendo la clave con la que se enviara el giro
                            string sPrePrintedNumber = item.operationCashier;
                            Datos obj = new Datos(connectionString);
                            sSenderKeys = "";
                            //***Eliminamos claves que sean invalidas****
                            obj.ExecQuery(" EXEC uSpDeleteKeysTransfastInvalids ");
                            //***Si ya la operación final tiene clave la solicitamos esto evita la duplicidad para China
                            string sqlText = string.Format("DECLARE @paymentKey VARCHAR(30) EXEC uSpReturnKeyTransfastByOperation '{0}',@paymentKey OUTPUT SELECT @paymentKey AS clave ", item.operationCashier);
                            DataTable dt1 = obj.ResultTableQuery(sqlText);
                            foreach (DataRow dtRow in dt1.Rows)
                            {
                                sSenderKeys = dtRow["clave"].ToString();
                            }
                            //***
                            if (sSenderKeys.Equals("0"))
                            {
                                if (item.Country == "CHN")
                                {
                                    //***Verificamos si hay una clave disponible***
                                    do
                                    {
                                        string sqlText1 = string.Format("DECLARE @paymentKey VARCHAR(30) EXEC uSpReturnKeyTransfastAvailable 'CHN',@paymentKey OUTPUT SELECT @paymentKey AS clave ");
                                        DataTable dt2 = obj.ResultTableQuery(sqlText1);
                                        foreach (DataRow dtRow in dt2.Rows)
                                        {
                                            sSenderKeys = dtRow["clave"].ToString();
                                        }
                                        //***
                                        if (sSenderKeys.Equals("0"))
                                        {
                                            //***Asignamos un lote nuevo de claves, ya que no hay disponibles
                                            KeyParams.sGroupBranchCode = item.sGroupBranchCode;
                                            KeyParams.sReceiverCountryCode = item.Country;
                                            KeyParams.iNoClaves = 15;
                                            KeyRequest.ObjParms = KeyParams;
                                            header.sSecurityToken = CodificarPassword(header.sWebUser + header.sWebPassword + sPin);
                                            DataSet ds = new DataSet();
                                            KeyResponse.WSTF_PC_Header_Out = SoapWs.GetTFN(header, KeyParams, out ds);
                                            if (KeyResponse.WSTF_PC_Header_Out.sFlagStatus != 0)
                                            {
                                                if (ds.Tables.Count > 0)
                                                {
                                                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                                                    {
                                                        string sqlText3 = string.Format("EXEC uSpInsert_tKeysTransfast '{0}','CHN' ", ds.Tables[0].Rows[j][0].ToString());
                                                        obj.ExecQuery(sqlText3);
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            string sqlText2 = string.Format(" EXEC uSpUpdate_tKeysTransfast '{0}','{1}' ", sSenderKeys, item.operationCashier);
                                            obj.ExecQuery(sqlText2);
                                        }
                                    } while (sSenderKeys.Equals("0"));
                                }
                                else
                                {
                                    KeyParams.sGroupBranchCode = item.sGroupBranchCode;
                                    KeyParams.sReceiverCountryCode = item.Country;
                                    KeyParams.iNoClaves = 1;
                                    KeyRequest.ObjParms = KeyParams;
                                    header.sSecurityToken = CodificarPassword(header.sWebUser + header.sWebPassword + sPin);
                                    DataSet ds = new DataSet();
                                    KeyResponse.WSTF_PC_Header_Out = SoapWs.GetTFN(header, KeyParams, out ds);
                                    if (KeyResponse.WSTF_PC_Header_Out.sFlagStatus == 0)
                                    {
                                        sSenderKeys = "TF" + sPrePrintedNumber;
                                    }
                                    else
                                    {
                                        if (ds.Tables.Count > 0)
                                        {
                                            sSenderKeys = ds.Tables[0].Rows[0][0].ToString();
                                        }
                                    }
                                }
                            }
                            #endregion

                            #region Enviamos los parametros al SendTxn
                            //if (item.Country == "CHN")
                            //{
                            //    SendParams.sPrePrintedNumber = "";
                            //}
                            //else
                            //{
                            //    SendParams.sPrePrintedNumber = "0101" + sPrePrintedNumber;
                            //}
                            //if (item.Country == "CHN")
                            //{
                            //    SendParams.sClavePay = "";
                            //}
                            //else
                            //{
                            //    SendParams.sClavePay = sSenderKeys;
                            //}
                            SendParams.sPrePrintedNumber = "0101" + sPrePrintedNumber;
                            SendParams.sClavePay = sSenderKeys;
                            SendParams.sSenderName1 = item.FirstNameSender;
                            SendParams.sSenderName2 = item.SecondNameSender;
                            SendParams.sSenderName3 = item.LastNameSender;
                            SendParams.sSenderName4 = item.SecondLastNamerSender;
                            SendParams.sSenderAddress = item.addressRemitter;
                            SendParams.sSenderPhone1 = item.phoneRemitter;
                            SendParams.sSenderPhone2 = "No posee";
                            SendParams.sSenderCity = item.cityRemitter;
                            SendParams.sSenderCountryCode = "VEN";
                            SendParams.sSenderEmail = item.emailRemitter;
                            SendParams.dSenderDOB = Convert.ToDateTime(item.dateOnBornRemitter);
                            SendParams.sTypeIDSender = EjecutarGetCat("T", item.Country, sPin,header,SoapWs);
                            SendParams.sNumIDSender = item.IdSender;
                            SendParams.dIssueIDDate = Convert.ToDateTime(item.dIssueIDDate);
                            SendParams.dExpirationIDDate = Convert.ToDateTime("1900-01-01");
                            SendParams.sSenderOcupation = item.sSenderOcupation;
                            SendParams.sSenderSSN = item.IdSender;
                            SendParams.sSourceFund = item.sSourceFund;
                            SendParams.sReasonTxn = item.sReasonTxt;
                            SendParams.sReceiverName1 = item.FirstNameBeneficiary;
                            SendParams.sReceiverName2 = item.SecondNameBeneficiary;
                            SendParams.sReceiverName3 = item.LastNameBeneficiary;
                            SendParams.sReceiverName4 = item.SecondLastNameBeneficiary;
                            SendParams.sReceiverAddress = item.AddressBeneficiary;
                            if (item.PhoneBeneficiary.Substring(0, 2) == "00")
                            {
                                SendParams.sReceiverPhone1 = item.PhoneBeneficiary.Substring(2, item.PhoneBeneficiary.Length - 2);
                            }
                            else
                            {
                                SendParams.sReceiverPhone1 = item.PhoneBeneficiary;
                            }
                            SendParams.sReceiverPhone2 = "No posee";
                            SendParams.sReceiverCityCode = item.CityBeneficiary;
                            SendParams.sReceiverStateCode = item.stateBeneficiary;
                            SendParams.sReceiverCountryCode = item.Country;
                            SendParams.sReceiverZipCode = item.senderZipCodeBenef.ToString();
                            SendParams.sReceiverEmail = item.emailBeneficiary;
                            SendParams.dReceiverDOB = Convert.ToDateTime("1900-01-01");
                            SendParams.nCurrencyRemiter = (1);
                            if (item.Country == "CAN")
                            {
                                SendParams.sModePayCode = "C";
                            }
                            else
                            {
                                SendParams.sModePayCode = "2";
                            }
                            SendParams.sCurrencyPayCode = item.sCurrencyPayCode;
                            SendParams.sBranchCodePay = item.sBranchCodePay;
                            SendParams.dAmountPay = Convert.ToDecimal(item.Amount);
                            if (item.Country == "CAN")
                            {
                                SendParams.sAccountNumber = item.accountNumber;
                                SendParams.sTypeAcc = "2";
                                SendParams.sBranchBankCode = item.sBranchBankCode;
                            }
                            else
                            {
                                SendParams.sAccountNumber = " ";
                                SendParams.sTypeAcc = " ";
                                SendParams.sBranchBankCode = " ";
                            }
                            SendParams.sBankCode = item.bankCode;
                            SendParams.sCPFNumber = " ";
                            SendParams.sApprovalCode = " ";
                            SendParams.sMessage = "-----";
                            SendParams.sReceiverName1ForeLang = item.FirstNameBeneficiary;
                            SendParams.sReceiverName2ForeLang = item.SecondNameBeneficiary;
                            SendParams.sReceiverName3ForeLang = item.LastNameBeneficiary;
                            SendParams.sReceiverName4ForeLang = item.SecondLastNameBeneficiary;
                            SendParams.sReceiverAddressForeLang = item.AddressBeneficiary;
                            SendParams.sMessageForeLang = "-----";
                            #endregion

                            #region Pase de parametros al metodo SendTxn
                            //Autenticacion de los metodos 
                            SendRequest.objParms = SendParams;
                            header.sSecurityToken =
                                CodificarPassword(header.sWebUser + header.sWebPassword + sPin + SendParams.sPrePrintedNumber + SendParams.sClavePay);

                            SendResponse.WSTF_PC_Header_Out = SoapWs.SendTxn(header, SendParams);

                            int i = -1;
                            string e, x = string.Empty;

                            i = SendResponse.WSTF_PC_Header_Out.sFlagStatus;
                            e = SendResponse.WSTF_PC_Header_Out.sErrorCode;
                            x = SendResponse.WSTF_PC_Header_Out.sErrorDescription;
                            #endregion
                            //***
                            #region Copia de la Linea en el Archivo
                            //if (item.Country == "CHN")
                            //{
                            //    sSenderKeys = x.ToString();
                            //    sPrePrintedNumber = x.ToString();
                            //}
                            //***
                            if (i != 1)
                            {
                                sPrePrintedNumber = "(" + e + ")" + sPrePrintedNumber;
                            }
                            //***
                            if (i > -1)
                            {
                                lineFile = sPrePrintedNumber + "|" + //1
                                           item.IdBeneficiary + "|" + //2
                                           item.FirstNameBeneficiary + " " + item.SecondNameBeneficiary + " " + item.LastNameBeneficiary + " " + item.SecondLastNameBeneficiary + "|" + //3
                                           item.IdSender + "|" + //4
                                           item.FirstNameSender + " " + item.SecondNameSender + " " + item.LastNameSender + " " + item.SecondLastNamerSender + "|" + //5
                                           item.Amount + "|" + //6
                                           item.sBranchCodePay + "|" + //7
                                           item.Country + "|" + //8
                                           item.sGroupBranchCode + "|" + //9
                                           sSenderKeys; //10
                            }
                            //***
                            //SenderKeyObject objSenderKeyObject = new SenderKeyObject();
                            //objSenderKeyObject.idProvider = item.IdProvider;
                            //objSenderKeyObject.sPrePrintedNumber = sPrePrintedNumber;
                            //objSenderKeyObject.sClavePay = sSenderKeys;
                            //objSenderKeyObject.Flag = i.ToString();
                            //objSenderKeyObject.errorCode = e;
                            //listaClaves.Add(objSenderKeyObject);
                            //***
                            #endregion
                            //***
                            trazaRespaldo.Escribir(lineFile);
                            counter++;
                            //***
                        }
                        tr = tr.encryptMoneyObj(trace);
                    }
                }
                if (sw == false)
                {
                    if (File.Exists(pathRespaldo))
                    {
                        File.Delete(pathRespaldo);
                    }
                }
                return nombreArchivo;
            }
            catch (Exception ex)
            {
                if (correlativoGenerado)
                {
                    string query = string.Format("UPDATE [dbo].[Correlativos] SET [Valor] = {0} WHERE [Agencia] = '1' AND [Concepto] = 'CORRFILETRANFAST'", (correlativoInc + 1));
                    objDatos.ExecQuery(query);
                }
                //***
                if (File.Exists(pathRespaldo))
                {
                    File.Delete(pathRespaldo);
                }
                //***
                trace.Escribir(" Transfast: " + ex.Message.ToString());
                return "";
            }
        }
        //***
        #region metodo CodificarPassword
        //metodo para codificar el password con el algoritmo MD5
        public static string CodificarPassword(string originalPassword)
        {
            try
            {
                Byte[] originalBytes;
                Byte[] encodedBytes;
                MD5 md5;
                md5 = new MD5CryptoServiceProvider();
                originalBytes = System.Text.Encoding.UTF8.GetBytes(originalPassword);
                encodedBytes = md5.ComputeHash(originalBytes);
                string output = "";
                for (int i = 0; i < encodedBytes.Length; i++)
                {
                    output += encodedBytes[i].ToString("x2");
                }
                return output;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        #endregion
        //***
        #region metodo EjecutarGetCat
        public static string EjecutarGetCat(string sCatType, string sCountryId, string sPin1, TransfastService.WSTF_PC_Header header,
                                     TransfastService.wstf_PCSoapClient SoapWs)
        {
            try
            {
                TransfastService.GetCatRequest wmResquestGetCat = new GetCatRequest();
                TransfastService.GetCatResponse wsResponseGetCat = new GetCatResponse();
                TransfastService.GetCatParms objParmsGetCat = new GetCatParms();
                string CountryCode = string.Empty;
                DataSet dgdgd = new DataSet();
                DataTable dataTable = new DataTable();
                DataSet ds = new DataSet();
                ds = null;
                wmResquestGetCat.WSTF_PC_Header = header;
                objParmsGetCat.sCountryId = sCountryId;
                objParmsGetCat.sCatType = sCatType;
                wmResquestGetCat.ObjParms = objParmsGetCat;
                header.sSecurityToken = CodificarPassword(header.sWebUser + header.sWebPassword + sPin1);
                wsResponseGetCat.WSTF_PC_Header_Out = SoapWs.GetCat(header, objParmsGetCat, out ds);
                string x = wsResponseGetCat.WSTF_PC_Header_Out.sErrorDescription;
                int i = wsResponseGetCat.WSTF_PC_Header_Out.sFlagStatus;
                if (ds.Tables[0].Rows.Count > 0)
                {
                    var das = ds.Tables[0].Rows[0];
                    CountryCode = das[0].ToString();
                }
                return CountryCode;
            }
            catch (Exception ex)
            {
                throw new Exception("EjecutarGetCat: " + ex.Message);
            }
        }
        #endregion
        //***
    }
}
