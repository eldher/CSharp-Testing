using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Reflection;
using CLBusinessObjects.DATOS;
using CLBusinessObjects.Archivos;
using System.Windows.Forms;
using System.ServiceModel;
using System.Threading;
using System.Security;
using System.Security.Permissions;
using System.Configuration;


//using CALocalMoneyPort.Archivo;
using System.IO;
using System.Globalization;
using WFAutorizacionDeGiros.autBCV;
using System.Xml;
using System.Xml.Linq;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Serialization;
using WFAutorizacionDeGiros.Data;


namespace WFAutorizacionDeGiros.Business
{
    public class BusinessClass
    {
        // Clase para Encomiendas Electronicas
        public class moneyObj
        {
            public bool Agregar { get; set; }
            public string OperacionFinal { get; set; }
            public string Status { get; set; }
            public DateTime FechaCreacion { get; set; } //datetime
            public DateTime FechaModificacion { get; set; } //datetime   
            public int id {get;set;}
            public string providerAcronym {get;set;}
            public string codOperation {get;set;}
            public string finalOperation {get;set;}
            public int codProductType {get;set;}
            public string codSender {get;set;}
            public string codReceiver {get;set;}
            public Single amount {get;set;}
            public Single feeamount { get; set; }
            public Single exchangeRateApplied { get; set; }
            public string sendCountry {get;set;}
            public string sendCurrency {get;set;}
            public string sendAgent {get;set;}
            public string rcvCountry {get;set;}
            public string rcvCurrency {get;set;}
            public string rcvAgent {get;set;}
            public DateTime timeStamp { get; set; } //datetime
            public int codDestination {get;set;}
            public string stateService {get;set;}
            public DateTime stateDate { get; set; } //datetime
            public DateTime paymentDate { get; set; } //datetime
            public DateTime expirationDate { get; set; } //datetime
            public string fileName {get;set;}
            public string paymentKey {get;set;}
            public DateTime smsDate { get; set; } //datetime
            public DateTime emailDate { get; set; } //datetime
            public DateTime iossDate { get; set; } //datetime
            public string createUser {get;set;}
            public DateTime createDate { get; set; } //datetime
            public string createAplication {get;set;}
            public string createMachine {get;set;}
            public string NameSender { get; set; }
            public string NameReceiver { get; set; }
        
        }

        // Clase para Contratos
        public class Contratos
        {
            public bool Agregar { get; set; }
            public string Contrato { get; set; }
            public string Tipo { get; set; }
            public string Cedula { get; set; } //datetime
            public string Nombre { get; set; } //datetime   
            public decimal Monto { get; set; }
            public decimal Tasa { get; set; }
            public string Divisa { get; set; }
            public decimal MontoBS { get; set; }
            public string Motivo { get; set; }
            public string Instrumento { get; set; }
            public string OperacionCaja { get; set; }
            public string AutorizacionBCV { get; set; }
            public string Status { get; set; }

            #region Contratos

            // Funcion que asigna Objeto a Clase desde DataRow
            public void SetContratoFromRow(Contratos Contrato, DataRow row)
            {
                // go through each column
                foreach (DataColumn c in row.Table.Columns)
                {
                    // find the property for the column
                    PropertyInfo p = Contrato.GetType().GetProperty(c.ColumnName);

                    // if exists, set the value
                    if (p != null && row[c] != DBNull.Value)
                    {
                        p.SetValue(Contrato, row[c], null);
                    }
                }
            }


            // function that creates an object from the given data row
            public Contratos CreateContratoFromRow(DataRow row)
            {
                Contratos item = new Contratos();
                SetContratoFromRow(item, row);
                return item;
            }


            // Metodo que Crea una lista de objetos desde una tabla
            public List<Contratos> CreateListContratosFromTable(DataTable tbl)
            {
                List<Contratos> lst = new List<Contratos>();
                foreach (DataRow r in tbl.Rows)
                {
                    lst.Add(CreateContratoFromRow(r));
                }
                return lst;
            }

            #endregion Contratos

        }

        // Metodo que Agrega Columna Check al DGV
        public DataTable addBoolColumnToDGV(DataTable dgv)
        {
            DataColumn Col = dgv.Columns.Add("Agregar", System.Type.GetType("System.Boolean"));
            Col.SetOrdinal(0);// to put the column in position 0;
            return dgv;
        }


        #region Encomiendas Electronicas
        // Funcion que asigna Objeto a Clase desde DataRow
        public void SetItemFromRow(moneyObj mObj , DataRow row)
        {
            // go through each column
            foreach (DataColumn c in row.Table.Columns)
            {
                // find the property for the column
                PropertyInfo p = mObj.GetType().GetProperty(c.ColumnName);

                // if exists, set the value
                if (p != null && row[c] != DBNull.Value)
                {
                    p.SetValue(mObj, row[c], null);
                }
            }
        }

        // function that creates an object from the given data row
        public moneyObj CreateItemFromRow(DataRow row)
        {
            moneyObj item = new moneyObj();
            SetItemFromRow(item, row);
            return item;
        }

        // Metodo que Crea una lista de objetos desde una tabla
        public List<moneyObj> CreateListFromTable(DataTable tbl)
        {
            List<moneyObj> lst = new List<moneyObj>();            
            foreach (DataRow r in tbl.Rows)
            {            
                lst.Add(CreateItemFromRow(r));
            }            
            return lst;           
        }
        #endregion Contratos
       

        // Clase proxy para AutorizacionBCV
        public class autorizaBCV
        {
            autBCVSoapClient proxy = new autBCVSoapClient();

            public void exeAutorizacionBCV(autorizacionBCVParams _autBCVParams)
            {
                //string ruta_info = @"\\" + _autBCVParams.server + @"\Logs_Y_Respaldos\Informacion_Y_Errores\CALocalMoneyPort\AutorizacionBCV\";
                //string ruta_info = @"C:\CALMP\AutorizacionBCV\";
                //Traza trazaDebug = new Traza("TrazaBCV", ruta_info, "");
                //trazaDebug.Escribir("Iniciando Autorizacion BCV  Version: " + Program.version);

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
                           // trazaDebug.Escribir("Operacion de Compra No Autorizada");
                            actualizarBD(_autBCVParams, "DENEGADO");
                        }
                        else
                        {
                            //trazaDebug.Escribir("Operacion de Compra Autorizada");
                            actualizarBD(_autBCVParams, respuestaBCV);
                            //trazaDebug.Escribir("Se registro la transacción:" + respuestaBCV);
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
                            //trazaDebug.Escribir("Operacion de Venta No Autorizada");
                            actualizarBD(_autBCVParams, "DENEGADO");
                        }
                        else
                        {
                            //trazaDebug.Escribir("Operacion de Venta Autorizada");
                            actualizarBD(_autBCVParams, respuestaBCV);
                            //trazaDebug.Escribir("Se registro la transacción:" + respuestaBCV);
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
                    //Console.ReadKey();

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
    

}
