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

//using CALocalMoneyPort.Archivo;
using CALocalMoneyPort.Negocio;
using CLBusinessObjects.DATOS;
using System.IO;
using System.Globalization;
using CALocalMoneyPort.autBCV;
using System.Xml;
using System.Xml.Linq;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Serialization;



//C:\Users\ehernandeza\Documents\Visual Studio 2010\Projects\ItalcambioCasadeCambio\CALocalMoneyPort\CALocalMoneyPort\bin\Debug\CALocalMoneyPort.exe FT/IC/123423123

namespace CALocalMoneyPort
{
    class Program
    {
        public static string arguments = string.Empty; // Parametros de Ejecucion de CALMP
        public static WSItalcambioSoapClient acceso = new WSItalcambioSoapClient(); // Define el end point
        // Define el end point
        public static Credencial Credential = new Credencial();
        static Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
        static Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
        static string nombreArchivo = string.Empty;

        public static string environment = "produccion";
        //public static string environment = "desarrollo";
        //public static string environment = "pruebas";

        public static string version = "20140814 V.2.1 RC";
        [PermissionSetAttribute(SecurityAction.Demand, Name = "FullTrust")]


        // Main Method
        public static void Main(params string[] args)
        {
            if (args.Length == 0) // IC,MT
            {
                #region testing
                // PRUEBA CAMBIOSTATUS  // CAMBIA DE V a [P o R]
                //string sendIdProvider = "ID";
                //string receiveIdProvider = "";
                //string request = "CAMBIOSTATUS";
                //string finalOp = "";
                //string paymentKey = "RY3";
                //string paymntStatus = "P";
                //string response = "";
                //string idProvider = "";
                //string sendIdAgency = "";

                //arguments = "desarrollonew3/Exchange/iusr/internet/" + sendIdProvider + "/" + receiveIdProvider + "/"
                //    + request + "/" + finalOp + "/" + paymentKey + "/" + paymntStatus + "/" + response + "/" + idProvider + "/" + sendIdAgency;
                //exeParams(arguments);
                //Console.ReadKey();


                //// PRUEBA VALIDACION  // CAMBIA DE V a [P o R]
                //string sendIdProvider = "ID";
                //string receiveIdProvider = "RY";
                //string request = "VALIDACION";
                //string finalOp = "";
                //string paymentKey = "";
                //string paymntStatus = "";
                //string response = "V15599533";
                //string idProvider = "";
                //string sendIdAgency = "";

                //arguments = "desarrollonew3/Exchange/iusr/internet/" + sendIdProvider + "/" + receiveIdProvider + "/"
                //    + request + "/" + finalOp + "/" + paymentKey + "/" + paymntStatus + "/" + response + "/" + idProvider + "/" + sendIdAgency;
                //exeParams(arguments);
                ////Console.ReadKey();

                //arguments = "desarrollonew3/Exchange/iusr/internet/ID/OI/ENVIO/010605201407590034////";
                //exeParams(arguments);
                //arguments = "desarrollonew3/Exchange/caja/caja/OI/ID/VALIDACION////V17562907//1";
                //exeParams(arguments);
                //"desarrollonew3/Exchange/caja/caja/ID/OI//010705201407590039////"

                //arguments = "desarrollonew3/Exchange/caja/caja/OI//CAMBIOSTATUS//GT423/V//1/DESARROLLO";

                //arguments = "PANAMA/Exchange/irodriguez01/011320/ID/OI/ENVIO/010406201407590014/////1/produccion";
                //arguments = "NET08/Exchange/lromero08/albert0830/ID//CAMBIOSTATUS//OI188/P///8/produccion";
                //arguments = "desarrollonew3/Exchange/taquilla/taquilla/OI/RY/RECIBO//RY011206201410760020////1/desarrollo";
                //exeParams(arguments);
                //arguments = "desarrollonew3/Exchange/taquilla/taquilla/ID//CONSULTADIVISA/USD/VEN////1/desarrollo";
                //exeParams(arguments);

                //arguments = "desarrollonew3/Exchange/taquilla/taquilla/RY//CONSULTADIVISA/USD/VEN/////desarrollo'";
                //arguments = "desarrollonew2/Exchange/caja/prueba/ID//RECIBO//OI1120////1/desarrollo";
                //arguments = "desarrollonew2/Exchange/caja/prueba/IC//CONSULTADOC/V13444812/////1/desarrollo";
                //arguments = "AUTORIZACIONBCV/desarrollonew2/exchange/iusr/internet/011308201411000053/CVR200/15599533/KAREN SOFIA TROMPETERO CHAVEZ/950/49.92/1/47424/1/EF";
                //arguments = "AUTORIZACIONBCV/desarrollonew2/Exchange/caja/prueba/011408201411000080/VV1000/V18466244/IRIS UZCATEGUI ARAUJO/156/49.8363/1/7774.46/1/EF";
                
                //exeParams(arguments);


                #endregion
                exeNoParams();
            }
            else
            {
                string arguments = args[0].ToString();
                exeParams(arguments);
            }
            if (acceso.State.ToString().Equals("Opened")) { acceso.Close(); }
            Environment.Exit(0);
        }

        public static void exeParams(string arguments)
        {
            CALocalParameters objParams = new CALocalParameters();
            autorizacionBCVParams _autBCVParams = new autorizacionBCVParams();

            // si contiene 'AUTORIZACIONBCV' al principio, cambia a AUTORIZACION DE COMPRA VENTA BCV
            if (arguments.Substring(0, 15).ToUpper() == "AUTORIZACIONBCV")
            {
                try
                {
                    Console.WriteLine("V1.1");
                    _autBCVParams = _autBCVParams.returnAutorizacionBCVParams(arguments);
                    autorizaBCV _autBCV = new autorizaBCV();
                    _autBCV.exeAutorizacionBCV(_autBCVParams);
                    return;
                }
                catch (Exception ex)
                {
                    return;        
                }
            }
            // si no, continua al envio de encomiendas electronicas
            else
            {
                objParams = objParams.returnCAParameters(arguments);
            }

            string ruta_info = string.Empty;
            if (objParams.environment == "produccion")
            {
                ruta_info = @"\\" + objParams.server + @"\Logs_Y_Respaldos\Informacion_Y_Errores\CALocalMoneyPort\App";
            }
            else if (objParams.environment == "pruebas")
            {
                ruta_info = @"C:\CALMP\Italcambio";
                // ruta_info = @"\\desarrollonew\ejecutables\Informacion_Y_Errores\CALocalMoneyPort\";
            }
            else { ruta_info = @"C:\CALMP\App\"; }

            //************************************************************************************
            string nombreArchivoTraza = "LMP_" + string.Format("{0:yy}", DateTime.Now) +
                     string.Format("{0:MM}", DateTime.Now) +
                     string.Format("{0:dd}", DateTime.Now);

            string time = string.Format("{0:dd}", DateTime.Now) +
                          string.Format("{0:MM}", DateTime.Now) +
                          string.Format("{0:yy}", DateTime.Now) +
                          "_" +
                          string.Format("{0:hh}", DateTime.Now) + "-" +
                          string.Format("{0:mm}", DateTime.Now) + "-" +
                          string.Format("{0:ss}", DateTime.Now);

            Traza Traza = new Traza(nombreArchivoTraza, ruta_info, "txt", "");
            //**********************************************************************************************


            //Traza Traza = new Traza("TrazaCALMP", ruta_info, "");
            Traza.Escribir("Starting MoneyPort " + version);

            //objParams.environment = "desarrollo";

            defineEndPoint(objParams.environment);


            string conexionAgencia = string.Format("Data Source={0};Initial Catalog={1};Persist Security Info=True;User ID={2};Password={3}"
                , objParams.server, objParams.db, objParams.user, objParams.password);


            Datos DatosAgencia = new Datos(conexionAgencia);

            #region "RECIBO"
            if (objParams.requestType.Equals("RECIBO"))
            {
                try
                {
                    Procesar _processClass = new Procesar();
                    _processClass.gestionarClave(objParams.paymentKey, conexionAgencia, acceso);
                    Traza.Escribir("Payment Key Found...");
                    Traza.Escribir(string.Format("Payment Key: {0}", objParams.paymentKey));
                    Traza.Escribir("Payment Inserted !!");
                }
                catch (Exception ex)
                {
                    Traza.Escribir("Invalid Transaction..." + ex.Message.ToString());
                    return;
                }
            }
            #endregion

            #region "ENVIO"
            if (objParams.requestType.Equals("ENVIO"))
            {
                try
                {
                    string StrQuery = string.Format("EXEC uSpLocalMoneyPort {0},{1},{2}", objParams.sendProviderAcronym, objParams.receiptProviderAcronym, "CREDENTIAL");
                    DataTable tblCredencial = DatosAgencia.ResultTableQuery(StrQuery);
                    // validates transaction
                    if (tblCredencial.Rows[0]["sendLogin"].ToString() == "DENIED" && tblCredencial.Rows[0]["sendPassword"].ToString() == "DENIED")
                    {
                        Traza.Escribir(string.Format("Invalid Transaction"));
                        return;
                    }
                    // puts credential into WSObj
                    Credential.sendProviderAcronym = objEncrypt.Encriptar(objParams.sendProviderAcronym);
                    Credential.receiptProviderAcronym = objEncrypt.Encriptar(objParams.receiptProviderAcronym);
                    Credential.Login = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendLogin"].ToString());
                    Credential.Password = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendPassword"].ToString());
                    Traza.Escribir("Credentials Accepted...");

                    #region get payment data from tMoneySendTransaction and set KeySender (paymentKey)
                    Traza.Escribir("Getting objMoney Data...");
                    tReceiptElectronicMoney MoneyObj = new tReceiptElectronicMoney();
                    MoneyObj.currencyPayment = tblCredencial.Rows[0]["currencyPayment"].ToString();
                    MoneyObj.getMoneyObj(conexionAgencia, objParams.finalOperation.ToString(), Traza);
                    MoneyObj.setPaymentKeyMoneyObj(conexionAgencia, objParams.finalOperation.ToString(), Traza);
                    #endregion

                    #region writes money info and updates tMoneySendTransaction
                    // check if MoneyObj exists
                    if ((MoneyObj.IdSender == null) && (MoneyObj.IdBeneficiary == null) && (MoneyObj.paymenttype == null) && (MoneyObj.IdSender == null))
                    {
                        Traza.Escribir("Sending Cancelled...");
                        return;
                    }
                    else
                    {
                        // write payment information
                        Traza.Escribir("---------------------------------------------------------------------------");
                        Traza.Escribir(string.Format("{0,10}{1,3}{2,14}{3,10}{4,10}{5,13}{6,10}\n{7,10}{8,3}{9,14}{10,10}{11,10}{12,13}{13,10}",
                            "SENDER:", objParams.sendProviderAcronym, MoneyObj.IdSender, MoneyObj.FirstNameSender, MoneyObj.LastNameSender, "AMOUNT:", MoneyObj.Amount,
                            "RECEIVER:", objParams.receiptProviderAcronym, MoneyObj.IdBeneficiary, MoneyObj.FirstNameBeneficiary, MoneyObj.LastNameBeneficiary, "KEYSENDER:", MoneyObj.KeySender));
                        Traza.Escribir("---------------------------------------------------------------------------");

                        // encrypt payment
                        MoneyObj.encryptMoneyObj(Traza);

                        // connect to central service
                        //defineEndPoint(objParams.environment);
                        string Prueba = acceso.HelloWorld();
                        if (Prueba.Length != 0) { Traza.Escribir("Connected to Central Service..."); }

                        // send money
                        Information result = acceso.sendMoney(MoneyObj, Credential);

                        // decrypt credential data
                        string codresult = objDecrypt.Desencriptar(result.codigo).ToString();
                        string desresult = objDecrypt.Desencriptar(result.DescripcionEN).ToString();
                        Traza.Escribir(codresult + " " + desresult);

                        if (codresult == "0052")
                        {
                            string updtQuery = string.Format("EXEC uSpUpdtMoneySendTransaction '{0}','{1}','{2}','{3}','{4}','{5}','{6}'",
                            objDecrypt.Desencriptar(MoneyObj.IdProvider), objDecrypt.Desencriptar(MoneyObj.KeySender), DateTime.Now.ToString("yyyy-MM-dd hh:mm"), nombreArchivoTraza,
                            "E", objParams.receiptProviderAcronym, objParams.finalOperation);

                            DatosAgencia.ExecQuery(updtQuery);
                            Traza.Escribir("Payment succesfully updated...");
                        }
                        else
                        {
                            Traza.Escribir("Payment not updated...");
                        }
                    }

                    #endregion
                }
                catch (Exception ex)
                {
                    Traza.Escribir("Invalid Transaction..." + ex.Message.ToString());
                    return;
                }
            }
            #endregion

            #region "UPDATE"
            if (objParams.requestType == "CAMBIOSTATUS")
            {

                UpdateStatus _updStatus = new UpdateStatus();
                Information info = _updStatus.updatePaymentStatus(objParams.paymentKey, objParams.finalOperation, conexionAgencia, objParams.sendProviderAcronym, objParams.paymentStatus, acceso, Traza);
                string infoDes = objDecrypt.Desencriptar(info.DescripcionEN);
                string infoCod = objDecrypt.Desencriptar(info.codigo);
                Traza.Escribir(infoCod + " " + infoDes);
            }
            #endregion

            #region "VALIDACION"

            if (objParams.requestType == "VALIDACION")
            {
                try
                {
                    Validation _validacion = new Validation();
                    Information info = _validacion.validateLimit(objParams.response, conexionAgencia, objParams.sendProviderAcronym, objParams.receiptProviderAcronym, acceso, Traza);
                    string infoDes = objDecrypt.Desencriptar(info.DescripcionEN);
                    string infoCod = objDecrypt.Desencriptar(info.codigo);
                    //Traza.Escribir(infoCod + " " + infoDes);
                }
                catch (Exception ex) { Traza.Escribir(" Validacion: " + ex.ToString()); }
            }

            #endregion

            #region "CONSULTASTATUS"

            if (objParams.requestType == "CONSULTASTATUS")
            {
                try
                {
                    CheckStatus _checkStatus = new CheckStatus();
                    _checkStatus.ChkStatus(conexionAgencia, objParams.sendProviderAcronym, objParams.receiptProviderAcronym, acceso, objParams.paymentKey, objParams.user, Traza);
                }
                catch (Exception ex) { Traza.Escribir("Validacion: " + ex.ToString()); }
            }

            #endregion

            #region "CONSULTADIVISA"

            if (objParams.requestType == "CONSULTADIVISA")
            {
                string codDivisa = objParams.finalOperation;
                string pai_iso3 = objParams.paymentKey;
                try
                {
                    QueryCurrency _consultaDivisa = new QueryCurrency();
                    Divisa objDivisa = _consultaDivisa.consultarDivisa(conexionAgencia, codDivisa, objParams.sendProviderAcronym, pai_iso3, objParams.user, acceso, Traza);


                    // agregar o modificar divisa
                    // metodo aca

                    string StrQuery = string.Format("EXEC uSpSetLocalCurrency '{0}','{1}','{2}','{3}',{4},{5},{6},{7},{8},'{9}','{10}','{11}','{12}','{13}'",
                    objDivisa.codigodivisa,
                    objDivisa.provideracronym,
                    objDivisa.pai_iso3,
                    objDivisa.nombredivisa,
                    objDivisa.tasaventa,
                    objDivisa.tasacompra,
                    objDivisa.fixing,
                    objDivisa.monedalocal,
                    objDivisa.diferencialtasaventa,
                    objDivisa.difrenecialtasacompra,
                    objDivisa.reguladortasaventa,
                    objDivisa.reguladortasacompra,
                    objDivisa.statusDivisa,
                    objDivisa.descripcion);

                    Datos DtQueryCurr = new Datos(conexionAgencia);
                    DtQueryCurr.ExecQuery(StrQuery);

                }
                catch (Exception ex) { Traza.Escribir("Validacion: " + ex.ToString()); }
            }
            #endregion

            #region "CONSULTADOC"

            if (objParams.requestType == "CONSULTADOC")
            {
                try
                {
                    ConsultaDocumentos _consultardocu = new ConsultaDocumentos();
                    string idClient = objParams.finalOperation;
                    string codeCompany = objParams.sendProviderAcronym;
                    string codAgree = objParams.paymentKey;

                    DataTable dt = _consultardocu.consultadoc(idClient, codeCompany, codAgree, acceso, Traza);

                    //Information info = _validacion.validateLimit(objParams.response, conexionAgencia, objParams.sendProviderAcronym, objParams.receiptProviderAcronym, acceso, Traza);
                    //Traza.Escribir(infoCod + " " + infoDes);
                }
                catch (Exception ex) { Traza.Escribir(" ConsultaDoc: " + ex.ToString()); }
            }


            #endregion


        }

        private static void exeNoParams()
        {

            string Location = ConfigurationManager.AppSettings["LOCATION"];
            string sendIdProvider = ConfigurationManager.AppSettings["COMPANY"];
            string ubicacion_capp = string.Empty;

            CALocalParameters objParams = new CALocalParameters();
            objParams.environment = environment;
            ubicacion_capp = "soporteappl";

            string ruta_info = string.Empty;

            if (objParams.environment == "produccion")
            {
                if (sendIdProvider == "IC")
                {
                    ruta_info = @"\\" + ubicacion_capp + @"\Logs_Y_Respaldos\Informacion_Y_Errores\CALocalMoneyPort\Italcambio\";
                }
                if (sendIdProvider == "MT")
                {
                    ruta_info = @"\\" + ubicacion_capp + @"\Logs_Y_Respaldos\Informacion_Y_Errores\CALocalMoneyPort\Munditur\";
                }

            }
            else
            {
                if (sendIdProvider == "IC")
                {
                    ruta_info = @"C:\CALMP\Italcambio\";
                }
                if (sendIdProvider == "MT")
                {
                    ruta_info = @"C:\CALMP\Munditur\";
                }
            }


            # region conn config
            defineEndPoint(environment);
            // select db server 
            switch (environment)
            {
                case "desarrollo":
                    {
                        if (sendIdProvider == "IC") { objParams.server = "desarrollonew2"; objParams.db = "Exchange"; objParams.user = "iusr"; objParams.password = "internet"; }
                        if (sendIdProvider == "MT") { objParams.server = "desarrollonew2"; objParams.db = "Exchange"; objParams.user = "iusr"; objParams.password = "internet"; }
                        break;
                    }
                case "pruebas":
                    {
                        if (sendIdProvider == "IC") { objParams.server = "desarrollonew2"; objParams.db = "Exchange"; objParams.user = "iusr"; objParams.password = "internet"; }
                        if (sendIdProvider == "MT") { objParams.server = "desarrollonew2"; objParams.db = "Exchange"; objParams.user = "iusr"; objParams.password = "internet"; }
                        break;
                    }
                case "produccion":
                    {
                        if (sendIdProvider == "IC") { objParams.server = "netsql"; objParams.db = "Exchange"; objParams.user = "usrenvelec"; objParams.password = "usree81$;"; }
                        if (sendIdProvider == "MT") { objParams.server = "MUNDITUR"; objParams.db = "MTExchange"; objParams.user = "genericuser"; objParams.password = "123456"; }
                        break;
                    }
            }

            //objParams.sendProviderAcronym = sendIdProvider;
            objParams.sendProviderAcronym = "OI";

            objParams.requestType = "SENDALL";

            string conexionAgencia = string.Format("Data Source={0};Initial Catalog={1};Persist Security Info=True;User ID={2};Password={3}"
                , objParams.server, objParams.db, objParams.user, objParams.password);

            #endregion

            #region bucle providers

            List<String> Providers = new List<String>();
            Providers.Add("ID");
            Providers.Add("IU");
            Providers.Add("RY");
            Providers.Add("TN");
            Providers.Add("CS");
            Providers.Add("PQ");
            Providers.Add("ME");
            Providers.Add("FT");
            Providers.Add("JP");
            Providers.Add("MR");



            string time = string.Format("{0:dd}", DateTime.Now) +
                          string.Format("{0:MM}", DateTime.Now) +
                          string.Format("{0:yy}", DateTime.Now) +
                          "_" +
                          string.Format("{0:hh}", DateTime.Now) + "-" +
                          string.Format("{0:mm}", DateTime.Now) + "-" +
                          string.Format("{0:ss}", DateTime.Now);


            string nombreArchivoTraza = "LMP_" + string.Format("{0:yy}", DateTime.Now) +
            string.Format("{0:MM}", DateTime.Now) +
            string.Format("{0:dd}", DateTime.Now);

            Traza Traza = new Traza(nombreArchivoTraza, ruta_info, "txt", "");
            Traza.Escribir(" ");
            Traza.Escribir(time + "****************************");
            Traza.Escribir(" ");
            Traza.Escribir("0- Current CALocalMoneyPort version: " + version);

            try
            {
                //***
                Datos objDatos = new Datos(conexionAgencia);

                string valor = string.Format("{0:yy}", DateTime.Now) + string.Format("{0:MM}", DateTime.Now) + string.Format("{0:dd}", DateTime.Now);

                string StrQuery1 = string.Format(" Update tRutaEjecutablesEnvio Set statusEjecucion = 'EJECUTANDOSE', ultimaEjecucion = '{0}' where providerAcronym = 'CALMP' ", valor);

                objDatos.ExecQuery(StrQuery1);

                //***

                foreach (String receiptIdProvider in Providers) // BEGIN FOREACH PROVIDER
                {
                    MoneyBatch MoneyListContainer = new MoneyBatch();
                    List<tReceiptElectronicMoney> MoneyList = MoneyListContainer.setMoneyBatch(conexionAgencia, objParams.sendProviderAcronym, receiptIdProvider, Traza);

                    Datos DatosAgencia = new Datos(conexionAgencia);

                    string StrQuery = string.Format("EXEC uSpLocalMoneyPortVEN {0},{1},{2}", objParams.sendProviderAcronym, receiptIdProvider, "CREDENTIAL");

                    DataTable tblCredencial = DatosAgencia.ResultTableQuery(StrQuery);

                    Traza.Escribir("*******");
                    Traza.Escribir(string.Format("Sending from {0} to {1}", objParams.sendProviderAcronym, receiptIdProvider));
                    if (tblCredencial.Rows[0]["sendLogin"].ToString() == "DENIED" && tblCredencial.Rows[0]["sendPassword"].ToString() == "DENIED")
                    {
                        Traza.Escribir(string.Format("Invalid Credentials"));
                        return;
                    }
                    else
                    {
                        // puts credential into object
                        Credential.sendProviderAcronym = objEncrypt.Encriptar(objParams.sendProviderAcronym);
                        Credential.receiptProviderAcronym = objEncrypt.Encriptar(receiptIdProvider);
                        Credential.Login = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendLogin"].ToString());
                        Credential.Password = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendPassword"].ToString());
                        Traza.Escribir("Credentials Accepted...");
                    }

                    //
                    Traza.Escribir(string.Format("{0} payments found", MoneyList.Count));
                    if (MoneyList.Count != 0)
                    {
                        Traza.Escribir("Getting objMoney Data...");

                        #region bucle moneylist

                        foreach (tReceiptElectronicMoney MoneyObj in MoneyList)
                        {
                            MoneyObj.currencyPayment = tblCredencial.Rows[0]["currencyPayment"].ToString();

                            MoneyObj.setPaymentKeyMoneyObjVEN(conexionAgencia, MoneyObj.Aux0.ToString(), Traza);

                            if ((MoneyObj.IdSender == null) && (MoneyObj.IdBeneficiary == null) && (MoneyObj.paymenttype == null) && (MoneyObj.IdSender == null))
                            {
                                Traza.Escribir("Sending Cancelled...");
                                return;
                            }
                            else
                            {
                                // write payment information
                                Traza.Escribir("---------------------------------------------------------------------------");
                                Traza.Escribir(string.Format("{0,10}{1,3}{2,14}{3,10}{4,10}{5,13}{6,10}\n{7,10}{8,3}{9,14}{10,10}{11,10}\n{12,13}{13,10}",
                                    "SENDER:", objParams.sendProviderAcronym, MoneyObj.IdSender, MoneyObj.FirstNameSender, MoneyObj.LastNameSender, "AMOUNT:", MoneyObj.Amount,
                                    "RECEIVER:", receiptIdProvider, MoneyObj.IdBeneficiary, MoneyObj.FirstNameBeneficiary, MoneyObj.LastNameBeneficiary, "KEYSENDER:", MoneyObj.KeySender));
                                Traza.Escribir("---------------------------------------------------------------------------");

                                MoneyObj.encryptMoneyObj(Traza);

                            } // end else
                        } //end foreach moneylist
                        #endregion

                        #region send paymentes to CentralS

                        try
                        {
                            //string connectionCentralS = acceso.HelloWorld();
                            //if (connectionCentralS.Length != 0)

                            Traza.Escribir("Connected to Central Service...");
                            try
                            {
                                // send money to CentralS
                                tReceiptElectronicMoney[] tMoneyList = MoneyList.ToArray();
                                DataTable results = acceso.listSendMoney(tMoneyList, Credential);
                                //Traza.Escribir(results.Rows.Count.ToString());
                                nombreArchivo = nombreArchivoTraza;
                                //***
                                switch (receiptIdProvider)
                                {
                                    case "TN":
                                        nombreArchivo = Titan.sendFileTitan(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"]);
                                        break;
                                    case "CS":
                                        nombreArchivo = Cambiamos.sendFileCambiamos(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                    case "ME":
                                        nombreArchivo = MundialEnvios.sendFileMundialEnvios(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                    case "FT":
                                        nombreArchivo = Transfast.sendTransactionsTransfast(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                    case "PQ":
                                        nombreArchivo = PagosInternacionales.sendFilePagosInternacionales(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                    case "JP":
                                        nombreArchivo = JetPeru.sendFileJetPeru(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                    case "MR":
                                        nombreArchivo = MaguiExpress.sendFileMaguiExpress(Traza, tMoneyList, environment, results, ConfigurationManager.AppSettings["COMPANY"], conexionAgencia);
                                        break;
                                }
                                //***
                                int contador = 0;
                                foreach (DataRow Row in results.Rows)
                                {
                                    string updtQuery = string.Empty;
                                    try
                                    {
                                        string codigoOut = objDecrypt.Desencriptar(Row["codigo"].ToString());
                                        string infoOut = objDecrypt.Desencriptar(Row["DescripcionEN"].ToString());
                                        string finalOperation = objDecrypt.Desencriptar(MoneyList[contador].Aux0);
                                        string clave = objDecrypt.Desencriptar(tMoneyList[contador].KeySender);
                                        //if ((receiptIdProvider.Equals("JP")) || (receiptIdProvider.Equals("PQ"))) 
                                        //{
                                        //    clave = objDecrypt.Desencriptar(tMoneyList[contador].IdProvider);
                                        //}
                                        // checks if payment was inserted by CentralS
                                        if (codigoOut == "0052")
                                        {
                                            updtQuery = string.Format("EXEC uSpUpdtMoneySendTransaction '{0}','{1}','{2}','{3}','{4}','{5}'",
                                            objDecrypt.Desencriptar(tMoneyList[contador].IdProvider), clave,
                                            DateTime.Now.ToString("yyyy/MM/dd hh:mm"), nombreArchivo, "E", receiptIdProvider);

                                            DatosAgencia.ExecQuery(updtQuery);
                                            Traza.Escribir("Payment succesfully updated...");
                                        }
                                        else
                                        {
                                            Traza.Escribir("Payment not updated...");
                                        }
                                        Traza.Escribir(codigoOut + " " + infoOut);
                                        contador++;
                                    }
                                    catch (Exception ex)
                                    {
                                        Traza.Escribir(" Error al actualizar : " + updtQuery + " " + ex.ToString());
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                Traza.Escribir("listSendMoney:" + ex.ToString());
                                return;
                            }
                        }
                        catch (Exception ex)
                        {
                            Traza.Escribir("Unable to connect to Central Service" + ex.ToString());
                            return;
                        }
                        #endregion
                    }

                } // END FOREACH PROVIDER
            }
            catch (Exception ex)
            {
                Traza.Escribir("Error Listing Providers: " + ex.ToString());
                return;
            }
            finally
            {
                Datos objDatos = new Datos(conexionAgencia);
                string StrQuery1 = string.Format(" Update tRutaEjecutablesEnvio Set statusEjecucion = 'CULMINADO' where providerAcronym = 'CALMP' ");
                objDatos.ExecQuery(StrQuery1);
            }
            #endregion
        }// exeNoParams

        // central service connection
        public static void defineEndPoint(string exenvironment)
        {
            BasicHttpBinding binding = new BasicHttpBinding(BasicHttpSecurityMode.Transport);
            try
            {
                switch (exenvironment)
                {
                    case "pruebas":
                        {
                            System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://192.168.170.24/WSItalcambio.asmx");
                            //System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://localhost:4582/WSItalcambio.asmx");
                            acceso.Endpoint.Address = add;
                            break;
                        }
                    case "desarrollo":
                        {
                            System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://gisrvnetprueba1:40/WSItalcambio.asmx");
                            //System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://localhost:4582/WSItalcambio.asmx");
                            acceso.Endpoint.Address = add;
                            break;
                        }
                    case "produccion":
                        {
                            System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://gisrvnet02:70/WSItalcambio.asmx");
                            acceso.Endpoint.Address = add;
                            break;
                        }
                }

            }
            catch (Exception ex) { throw new Exception("defineEndPoint: " + ex.Message.ToString()); }
        }

    }

    //***
    public class Procesar
    {
        public void gestionarClave(string clave, string connection, WSItalcambioSoapClient serv)
        {
            try
            {
                Encrypt.CCryptorEngine objEncryp = new Encrypt.CCryptorEngine();
                Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
                Credencial c = new Credencial();
                c.receiptProviderAcronym = objEncryp.Encriptar("LEC");
                c.Login = objEncryp.Encriptar("giuser");
                c.Password = objEncryp.Encriptar("GIlec123456");
                c.sendProviderAcronym = objEncryp.Encriptar("GI");
                clave = objEncryp.Encriptar(clave);
                tReceiptElectronicMoney t = serv.readTransaction(clave, c);
                t = desencriptarTodo(t);
                registrarTransacion(connection, t);
            }
            catch (Exception ex)
            {
                throw new Exception(" gestionarClave: " + ex.Message.ToString());
            }
        }

        public void registrarTransacion(string connection, tReceiptElectronicMoney t)
        {
            try
            {
                CLBusinessObjects.DATOS.Datos objDatos = new CLBusinessObjects.DATOS.Datos(connection);
                string parametros = "";
                #region Envio de Parametros
                parametros = parametros + "'" + t.sendProviderAcronym + "',";
                parametros = parametros + "'" + t.IdSender + "'" + ',';
                parametros = parametros + "'" + t.FirstNameSender + "'" + ',';
                parametros = parametros + "'" + t.SecondNameSender + "'" + ',';
                parametros = parametros + "'" + t.LastNameSender + "'" + ',';
                parametros = parametros + "'" + t.SecondLastNamerSender + "'" + ',';
                parametros = parametros + "'" + t.IdBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.FirstNameBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.SecondNameBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.LastNameBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.SecondLastNameBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.AddressBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.CityBeneficiary + "'" + ',';
                parametros = parametros + t.Amount + ',';
                parametros = parametros + "'" + t.Country + "'" + ',';
                parametros = parametros + "'" + t.PhoneBeneficiary + "'" + ',';
                parametros = parametros + "'" + t.KeySender + "'" + ',';
                parametros = parametros + "0" + ',';
                parametros = parametros + "" + t.IdProvider + ",";
                parametros = parametros + "'" + t.pai_iso3 + "',";
                parametros = parametros + "'" + t.paymenttype + "',";
                parametros = parametros + "'" + t.bankName + "',";
                parametros = parametros + "'" + t.bankAddress + "',";
                parametros = parametros + "'" + t.bankCode + "',";
                parametros = parametros + "'" + t.phone + "',";
                parametros = parametros + "'" + t.sGroupBranchCode + "',";
                parametros = parametros + "'" + t.sCurrencyPayCode + "',";
                parametros = parametros + "'" + t.sBranchCodePay + "',";
                parametros = parametros + "'" + t.currencyCode + "',";
                parametros = parametros + "'" + t.currency + "',";
                parametros = parametros + "'" + t.typeAccount + "',";
                parametros = parametros + "'" + t.accountNumber + "',";
                parametros = parametros + "'" + t.idRegion + "',";
                parametros = parametros + "'" + t.aba + "',";
                parametros = parametros + "'" + t.swift + "',";
                parametros = parametros + "'" + t.iban + "',";
                parametros = parametros + "'" + t.idAgency + "',";
                parametros = parametros + "'" + t.agency + "',";
                parametros = parametros + t.institutionNumber + ",";
                parametros = parametros + "'" + t.officeNumber + "',";
                parametros = parametros + t.Fixing + ",";
                parametros = parametros + t.exchangeRateApplied + ",";
                parametros = parametros + "'" + t.PaymentStatus + "',";
                parametros = parametros + "'" + t.receiptProviderAcronym + "',";
                parametros = parametros + "'" + t.currencyPayment + "',";
                parametros = parametros + "'" + t.emailBeneficiary + "',";
                parametros = parametros + "'" + t.sendIdAgency + "'";
                #endregion
                string sqlStmt = string.Format("EXEC uSpInsertaTelectronicMoneyAgencia {0}", parametros);
                objDatos.ExecQuery(sqlStmt);
            }
            catch (Exception ex)
            {
                throw new Exception(" registrarTransacion: " + ex.Message.ToString());
            }
        }

        public tReceiptElectronicMoney desencriptarTodo(tReceiptElectronicMoney r)
        {
            try
            {
                Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
                r.sendProviderAcronym = objDecrypt.Desencriptar(r.sendProviderAcronym);
                r.IdSender = objDecrypt.Desencriptar(r.IdSender);
                r.FirstNameSender = objDecrypt.Desencriptar(r.FirstNameSender);
                r.SecondNameSender = objDecrypt.Desencriptar(r.SecondNameSender);
                r.LastNameSender = objDecrypt.Desencriptar(r.LastNameSender);
                r.SecondLastNamerSender = objDecrypt.Desencriptar(r.SecondLastNamerSender);
                r.IdBeneficiary = objDecrypt.Desencriptar(r.IdBeneficiary);
                r.FirstNameBeneficiary = objDecrypt.Desencriptar(r.FirstNameBeneficiary);
                r.SecondNameBeneficiary = objDecrypt.Desencriptar(r.SecondNameBeneficiary);
                r.LastNameBeneficiary = objDecrypt.Desencriptar(r.LastNameBeneficiary);
                r.SecondLastNameBeneficiary = objDecrypt.Desencriptar(r.SecondLastNameBeneficiary);
                r.AddressBeneficiary = objDecrypt.Desencriptar(r.AddressBeneficiary);
                r.CityBeneficiary = objDecrypt.Desencriptar(r.CityBeneficiary);
                r.exchangeRateApplied = objDecrypt.Desencriptar(r.exchangeRateApplied);
                r.Amount = objDecrypt.Desencriptar(r.Amount);
                r.currencyCode = objDecrypt.Desencriptar(r.currencyCode);
                r.Fixing = objDecrypt.Desencriptar(r.Fixing);
                r.currency = objDecrypt.Desencriptar(r.currency);
                r.Country = objDecrypt.Desencriptar(r.Country);
                r.PhoneBeneficiary = objDecrypt.Desencriptar(r.PhoneBeneficiary);
                r.KeySender = objDecrypt.Desencriptar(r.KeySender);
                r.IdCompany = objDecrypt.Desencriptar(r.IdCompany);
                r.PaymentStatus = objDecrypt.Desencriptar(r.PaymentStatus);
                r.PaymentDate = objDecrypt.Desencriptar(r.PaymentDate);
                r.SendDate = objDecrypt.Desencriptar(r.SendDate);
                r.IdProvider = objDecrypt.Desencriptar(r.IdProvider);
                r.pai_iso3 = objDecrypt.Desencriptar(r.pai_iso3);
                r.paymenttype = objDecrypt.Desencriptar(r.paymenttype);
                r.bankName = objDecrypt.Desencriptar(r.bankName);
                r.bankAddress = objDecrypt.Desencriptar(r.bankAddress);
                r.bankCode = objDecrypt.Desencriptar(r.bankCode);
                r.phone = objDecrypt.Desencriptar(r.phone);
                r.sGroupBranchCode = objDecrypt.Desencriptar(r.sGroupBranchCode);
                r.sCurrencyPayCode = objDecrypt.Desencriptar(r.sCurrencyPayCode);
                r.sBranchCodePay = objDecrypt.Desencriptar(r.sBranchCodePay);
                r.typeAccount = objDecrypt.Desencriptar(r.typeAccount);
                r.accountNumber = objDecrypt.Desencriptar(r.accountNumber);
                r.idRegion = objDecrypt.Desencriptar(r.idRegion);
                r.aba = objDecrypt.Desencriptar(r.aba);
                r.swift = objDecrypt.Desencriptar(r.swift);
                r.iban = objDecrypt.Desencriptar(r.iban);
                r.idAgency = objDecrypt.Desencriptar(r.idAgency);
                r.agency = objDecrypt.Desencriptar(r.agency);
                r.institutionNumber = objDecrypt.Desencriptar(r.institutionNumber);
                r.officeNumber = objDecrypt.Desencriptar(r.officeNumber);
                r.receiptProviderAcronym = objDecrypt.Desencriptar(r.receiptProviderAcronym);
                r.currencyPayment = objDecrypt.Desencriptar(r.currencyPayment);
                r.emailBeneficiary = objDecrypt.Desencriptar(r.emailBeneficiary);
                r.sendIdAgency = objDecrypt.Desencriptar(r.sendIdAgency);
                r.paymentDateInCompany = objDecrypt.Desencriptar(r.paymentDateInCompany);
                return r;
            }
            catch (Exception ex)
            {
                throw new Exception(" desencriptarTodo: " + ex.Message.ToString());
            }
        }
    }

    public class UpdateStatus
    {
        public Information updatePaymentStatus(string clave, string finalOperation, string connection, string sendProviderAcronym, string status, WSItalcambioSoapClient serv, Traza Traza)
        {
            Information response = new Information();
            try
            {

                Encrypt.CCryptorEngine objEncryp = new Encrypt.CCryptorEngine();
                Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
                Credencial c = new Credencial();
                c.receiptProviderAcronym = objEncryp.Encriptar("UPD");
                c.Login = objEncryp.Encriptar("iduser");
                c.Password = objEncryp.Encriptar("OIupd123456");
                c.sendProviderAcronym = objEncryp.Encriptar("GI");


                string StrQuery2 = string.Format("EXEC uSpUpdate_tQueryStatusRCV '{0}','{1}','{2}'", clave, status, sendProviderAcronym);

                Datos Dataupdt = new Datos(connection);
                Dataupdt.ExecQuery(StrQuery2);

                clave = objEncryp.Encriptar(clave);
                sendProviderAcronym = objEncryp.Encriptar(sendProviderAcronym);
                status = objEncryp.Encriptar(status);

                response = serv.updateShippingStatus(c, clave, sendProviderAcronym, status);

                return response;
            }
            catch (Exception ex)
            {
                Traza.Escribir("updatePaymentStatus: " + ex.Message.ToString());
                return response;
                //throw new Exception("updatePaymentStatus: " + ex.Message.ToString());

            }

        }

    }

    public class Validation
    {
        public Information validateLimit(string idClient, string conexionAgencia, string sendIdProvider, string receiptIdProvider, WSItalcambioSoapClient serv, Traza Traza)
        {
            Information info = new Information();
            try
            {

                Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
                Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
                Credencial c = new Credencial();

                c.sendProviderAcronym = objEncrypt.Encriptar(sendIdProvider);
                c.receiptProviderAcronym = objEncrypt.Encriptar(receiptIdProvider);

                string StrQuery = string.Format("EXEC uSpLocalMoneyPortVEN '{0}','{1}','{2}'", sendIdProvider, receiptIdProvider, "CREDENTIAL");

                Datos DataValidar = new Datos(conexionAgencia);
                DataTable tblCredencial = DataValidar.ResultTableQuery(StrQuery);


                // validates transaction
                if (tblCredencial.Rows[0]["sendLogin"].ToString() == "DENIED" && tblCredencial.Rows[0]["sendPassword"].ToString() == "DENIED")
                {
                    info.codigo = "0061";
                    info.tipo = "01";
                    info.Descripcion = "Acceso Denegado";
                    info.DescripcionEN = "Access Denied";
                }
                else
                {
                    // puts credential into WSObj
                    c.sendProviderAcronym = objEncrypt.Encriptar(sendIdProvider);
                    c.receiptProviderAcronym = objEncrypt.Encriptar(receiptIdProvider);
                    c.Login = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendLogin"].ToString());
                    c.Password = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendPassword"].ToString());
                    idClient = objEncrypt.Encriptar(idClient);

                    info = serv.validateClient(idClient, c);
                    string validacion = string.Empty;
                    string codValidacion = objDecrypt.Desencriptar(info.codigo).ToString();
                    idClient = objDecrypt.Desencriptar(idClient);

                    if (codValidacion == "0060")
                    {
                        validacion = "TRUE";
                        string StrQuery2 = string.Format("EXEC uSpLocalMoneyPortValidacion '{0}','{1}'", idClient, validacion);
                        DataValidar.ExecQuery(StrQuery2);
                    }

                    if (codValidacion == "0061")
                    {
                        validacion = "FALSE";
                        string StrQuery2 = string.Format("EXEC uSpLocalMoneyPortValidacion '{0}','{1}'", idClient, validacion);
                        DataValidar.ExecQuery(StrQuery2);
                    }

                }
                return info;
            }
            catch (Exception ex)
            {
                Traza.Escribir("validateLimit: " + ex.Message.ToString());
                return info;
            }
        }
    }

    public class CheckStatus
    {
        public void ChkStatus(string conexionAgencia, string sendIdProvider, string receiptIdProvider, WSItalcambioSoapClient serv, string paymentKey, string usuario, Traza Traza)
        {
            try
            {
                Encrypt.CCryptorEngine objEncrypt = new Encrypt.CCryptorEngine();
                Decrypt.CCryptorEngine objDecrypt = new Decrypt.CCryptorEngine();
                Credencial c = new Credencial();

                string StrQuery = string.Format("EXEC uSpLocalMoneyPort {0},{1},{2}", sendIdProvider, receiptIdProvider, "CREDENTIAL");
                Datos dt1 = new Datos(conexionAgencia);
                DataTable tblCredencial = dt1.ResultTableQuery(StrQuery);

                // validates transaction
                if (tblCredencial.Rows[0]["sendLogin"].ToString() == "DENIED" && tblCredencial.Rows[0]["sendPassword"].ToString() == "DENIED")
                {
                    //   Traza.Escribir(string.Format("Invalid Transaction"));
                    return;
                }
                // puts credential into WSObj
                c.sendProviderAcronym = objEncrypt.Encriptar(sendIdProvider);
                c.receiptProviderAcronym = objEncrypt.Encriptar(receiptIdProvider);
                c.Login = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendLogin"].ToString());
                c.Password = objEncrypt.Encriptar(tblCredencial.Rows[0]["sendPassword"].ToString());
                //Traza.Escribir("Credentials Accepted...");

                readtreciptElectronicMoney rtrem = serv.readMoney(paymentKey, c);

                string StrQuery2 = string.Format("EXEC uSpInsert_tQueryStatusRCV '{0}','{1}','{2}','{3}'", rtrem.keySender, rtrem.PaymentStatus, usuario, rtrem.sendProviderAcronym);

                Datos DataCheck = new Datos(conexionAgencia);
                DataCheck.ExecQuery(StrQuery2);
            }
            catch (Exception ex)
            {
                Traza.Escribir("CheckStatus: " + ex.Message.ToString());
                return;
            }
        }
    }

    public class QueryCurrency
    {
        public Divisa consultarDivisa(string connection, string codigoDivisa, string providerAcronym, string pai_iso3, string usuario, WSItalcambioSoapClient serv, Traza Traza)
        {
            Divisa objDivisa = new Divisa();
            try
            {
                //data.defineEndPointServicioCentral(usuario);
                Encrypt.CCryptorEngine objEncriptar = new Encrypt.CCryptorEngine();
                Decrypt.CCryptorEngine objDesencriptar = new Decrypt.CCryptorEngine();


                //***Credencial
                Credencial objCredencial = new Credencial();
                objCredencial.sendProviderAcronym = objEncriptar.Encriptar("OI");
                objCredencial.Login = objEncriptar.Encriptar("oiuser");
                objCredencial.Password = objEncriptar.Encriptar("OIall123456");
                objCredencial.receiptProviderAcronym = objEncriptar.Encriptar("ALL");
                //***
                usuario = objEncriptar.Encriptar(usuario);
                objDivisa = serv.checkCurrency(objEncriptar.Encriptar(pai_iso3),
                                                         objEncriptar.Encriptar(codigoDivisa), objCredencial,
                                                         objEncriptar.Encriptar(providerAcronym));


                //***Desencriptar Divisa

                objDivisa.codigodivisa = objDesencriptar.Desencriptar(objDivisa.codigodivisa);
                objDivisa.provideracronym = objDesencriptar.Desencriptar(objDivisa.provideracronym);
                objDivisa.pai_iso3 = objDesencriptar.Desencriptar(objDivisa.pai_iso3);
                objDivisa.nombredivisa = objDesencriptar.Desencriptar(objDivisa.nombredivisa);
                objDivisa.tasaventa = objDesencriptar.Desencriptar(objDivisa.tasaventa);
                objDivisa.tasacompra = objDesencriptar.Desencriptar(objDivisa.tasacompra);
                objDivisa.fixing = objDesencriptar.Desencriptar(objDivisa.fixing);
                objDivisa.monedalocal = objDesencriptar.Desencriptar(objDivisa.monedalocal);
                objDivisa.diferencialtasaventa = objDesencriptar.Desencriptar(objDivisa.diferencialtasaventa);
                objDivisa.difrenecialtasacompra = objDesencriptar.Desencriptar(objDivisa.difrenecialtasacompra);
                objDivisa.reguladortasaventa = objDesencriptar.Desencriptar(objDivisa.reguladortasaventa);
                objDivisa.reguladortasacompra = objDesencriptar.Desencriptar(objDivisa.reguladortasacompra);
                objDivisa.statusDivisa = objDesencriptar.Desencriptar(objDivisa.statusDivisa);
                objDivisa.descripcion = objDesencriptar.Desencriptar(objDivisa.descripcion);
                return objDivisa;
            }
            catch (Exception ex)
            {
                Traza.Escribir("consultarDivisa: " + ex.Message.ToString());
                return objDivisa;
            }
        }
    }

    public class ConsultaDocumentos
    {
        public DataTable consultadoc(string idClient, string CodeCompany, string codAgree, WSItalcambioSoapClient serv, Traza Traza)
        {
            //data.defineEndPointServicioCentral(usuario);
            Encrypt.CCryptorEngine objEncriptar = new Encrypt.CCryptorEngine();
            Decrypt.CCryptorEngine objDesencriptar = new Decrypt.CCryptorEngine();


            //***Credencial
            Credencial c = new Credencial();
            c.sendProviderAcronym = objEncriptar.Encriptar("OI");
            c.Login = objEncriptar.Encriptar("oiuser");
            c.Password = objEncriptar.Encriptar("OIDoc123456");
            c.receiptProviderAcronym = objEncriptar.Encriptar("DOC");
            //***
            CodeCompany = objEncriptar.Encriptar(CodeCompany);
            idClient = objEncriptar.Encriptar(idClient);

            DataTable dt = new DataTable();
            if (codAgree == "" || codAgree == "0")
            { dt = serv.listDocumentsClient(c, idClient, CodeCompany); }
            else
            { dt = serv.listDocumentsClientByAgree(c, idClient, CodeCompany, codAgree); }

            return dt;
        }

    }

    public class autorizaBCV
    { 

        autBCVSoapClient proxy = new autBCVSoapClient();

        public void exeAutorizacionBCV(autorizacionBCVParams _autBCVParams)
        {
            //string ruta_info = @"\\" + _autBCVParams.server + @"\Logs_Y_Respaldos\Informacion_Y_Errores\CALocalMoneyPort\AutorizacionBCV\";
            string ruta_info = @"C:\CALMP\AutorizacionBCV\";
            Traza trazaDebug = new Traza("TrazaBCV", ruta_info, "");
            trazaDebug.Escribir("Iniciando Autorizacion BCV  Version: "+ Program.version );

            defineEndPointAutBCV();

            try
            {
                string respuestaBCV = string.Empty;
                if (_autBCVParams.COTIMOVIMIENTO.Substring(0, 1) == "V")
                {
                    respuestaBCV = proxy.COMPRADIV(_autBCVParams.COTIMOVIMIENTO,
                        _autBCVParams.CODCLIENTE,
                        _autBCVParams.NBCLIENTE,
                        _autBCVParams.MOBASE,
                        _autBCVParams.TSCAMBIO,
                        _autBCVParams.COUCTATRANS,
                        _autBCVParams.MOTRANS,
                        _autBCVParams.COMOTIVOOPERACION,
                        _autBCVParams.COINTRUM);

                    if (respuestaBCV == "MF012" || respuestaBCV == "MV014" || respuestaBCV == "MV017" || respuestaBCV == "MF011")
                    {
                        trazaDebug.Escribir("Operacion de Compra No Autorizada");
                        actualizarBD(_autBCVParams, "DENEGADA");
                    }
                    else
                    {
                        trazaDebug.Escribir("Operacion de Compra Autorizada");
                        actualizarBD(_autBCVParams, respuestaBCV);
                        trazaDebug.Escribir("Se registro la transacción:" + respuestaBCV);
                    }
                    
                }
                else if (_autBCVParams.COTIMOVIMIENTO.Substring(0, 1) == "C")
                {
                    respuestaBCV = proxy.VENTADIV(_autBCVParams.COTIMOVIMIENTO,
                        _autBCVParams.CODCLIENTE,
                        _autBCVParams.NBCLIENTE,
                        _autBCVParams.MOBASE,
                        _autBCVParams.TSCAMBIO,
                        _autBCVParams.COUCTATRANS,
                        _autBCVParams.MOTRANS,
                        _autBCVParams.COMOTIVOOPERACION,
                        _autBCVParams.COINTRUM);
                    actualizarBD(_autBCVParams, respuestaBCV);

                    if (respuestaBCV == "MF012" || respuestaBCV == "MV014" || respuestaBCV == "MV017" || respuestaBCV == "MF011")
                    {
                        trazaDebug.Escribir("Operacion de Venta No Autorizada");
                        actualizarBD(_autBCVParams, "DENEGADA");
                    }
                    else
                    {
                        trazaDebug.Escribir("Operacion de Venta Autorizada");
                        actualizarBD(_autBCVParams, respuestaBCV);
                        trazaDebug.Escribir("Se registro la transacción:" + respuestaBCV);
                    }
                }
                else
                {
                    respuestaBCV = "PARAMETROS INCORRECTOS";
                }


                //string conn = proxy.HelloWorld();
                //string conn2 = proxy.TIPOSMOVIMIENTOS();
                //string conn3 = proxy.EXCEPCIONES();
                //string conn4 = proxy.MOTIVOS();
                //string conn5 = proxy.MOVIMIENTOS(DateTime.Now.ToString());


                //string conn6 = proxy.COMPRADIV(_autBCVParams.COTIMOVIMIENTO,
                //    _autBCVParams.CODCLIENTE,
                //    _autBCVParams.NBCLIENTE,
                //    _autBCVParams.MOBASE,
                //    _autBCVParams.TSCAMBIO,
                //    _autBCVParams.COUCTATRANS,
                //    _autBCVParams.MOTRANS,
                //    _autBCVParams.COMOTIVOOPERACION,
                //    _autBCVParams.COINTRUM);

                //string conn64 = proxy.COMPRADIV("2", "17978", "ELDHER", 133, 50, "COMPRA DIV", 12334, 122, "CHEQUE");
                //string conn74 = proxy.VENTADIV("2", "17978", "ELDHER", 133, 50, "COMPRA DIV", 12334, 122, "CHEQUE");

                //Console.WriteLine(respuestaBCV);//+conn7);
                 Console.ReadKey();
            
            }
            catch (System.Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public void defineEndPointAutBCV()
        {
            BasicHttpBinding binding = new BasicHttpBinding(BasicHttpSecurityMode.Transport);
            try
            {
                //System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://localhost:56854/WSOIBCV.asmx");
                //System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://localhost:62633/autorizacion.asmx");
                System.ServiceModel.EndpointAddress add = new System.ServiceModel.EndpointAddress("http://gisrvnetprueba1/WSOIBCV/WSOIBCV.asmx");
                proxy.Endpoint.Address = add;
            }
            catch (Exception ex) { throw new Exception("defineEndPoint: " + ex.Message.ToString()); }
        }

        public void actualizarBD(autorizacionBCVParams _autBCVParams, string respuestaBCV)
        {
            string conexionAgencia = string.Format("Data Source={0};Initial Catalog={1};Persist Security Info=True;User ID={2};Password={3}",
                _autBCVParams.server, _autBCVParams.db, _autBCVParams.user, _autBCVParams.password);

            Datos DatosAgencia = new Datos(conexionAgencia);
            string query = string.Format("UPDATE tCompraVentaDivisa set OperacionAutorizBCV= '{0}' where Operacion = '{1}'", respuestaBCV, _autBCVParams.operacion);
            DatosAgencia.ExecQuery(query);

            //actulizar
        }

    }
}



