using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using CLBusinessObjects.DATOS;
using CLBusinessObjects.Archivos;

namespace WFAutorizacionDeGiros.Data
{
    public class DataClass
    {
        public string connection { get; set; }
        public DataTable dtPendientes { get; set; }
        public DataTable dtAprobadas { get; set; }
        public DataTable dtDenegadas { get; set; }
        public DataTable dtDevueltas { get; set; }
        public DataTable dtContratosPendientes { get; set; }
        public DataTable dtContratosAprobados { get; set; }
        public DataTable dtContratosDenegados { get; set; }
        


        public DataTable loadDGV(string option,string dtName)
        {
            Datos DatosAgencia = new Datos(connection);
            DataTable dt = DatosAgencia.ResultTableQuery(string.Format("EXEC AutTransaccionBCV '{0}','{1}'",option,dtName));
            return dt;
        }
        
        public void loadMainDGV()
        {

            dtPendientes = loadDGV("CARGAR","PENDIENTES");
            dtAprobadas = loadDGV("CARGAR","APROBADAS");
            dtDenegadas = loadDGV("CARGAR","DENEGADAS");
            dtDevueltas = loadDGV("CARGAR","DEVUELTAS");

            dtContratosPendientes = loadDGV("CONTRATOS", "PENDIENTES");
            dtContratosAprobados = loadDGV("CONTRATOS", "APROBADOS");
            dtContratosDenegados = loadDGV("CONTRATOS", "DENEGADOS");

        }

        public void loadContratos()
        {
            dtContratosPendientes = loadDGV("CONTRATOS", "PENDIENTES");
            dtContratosAprobados = loadDGV("CONTRATOS", "APROBADOS");
            dtContratosDenegados = loadDGV("CONTRATOS", "DENEGADOS");

        }



        public DataTable ConsultarGiro(string opcion, string operacionfinal)
        {
            Datos DataAg = new Datos(connection);
            DataTable dt2 = DataAg.ResultTableQuery(string.Format("EXEC AutTransaccionBCV '{0}','{1}','{2}'", opcion, "",operacionfinal));
            return dt2;
        }


        public void saveModification(string opcion, string status, string finaloperation, string codOperation, decimal AmountOld, decimal AmountNew)
        {            
            string query = string.Format("EXEC AutTransaccionBCV '{0}','{1}','{2}','{3}',{4},{5} ", opcion, status, finaloperation, codOperation, AmountOld, AmountNew);
            Datos DatosAgencia2 = new Datos(connection);
            DatosAgencia2.ExecQuery(query);
           //DataTable dt = DatosAgencia2.ResultTableQuery(query);
            //return dt;
        }

        public DataTable Hist(string codOperacion)
        {
            Datos _objDatos = new Datos(connection);
            DataTable rdt = _objDatos.ResultTableQuery(string.Format("EXEC AutTransaccionBCV 'HISTORICO','','','{0}',0,0 ", codOperacion));
            return rdt;
        }
          




    }

    public class autorizacionBCVParams
    {
        //****** BCV
        public string suiche { get; set; }
        public string server { get; set; }
        public string db { get; set; }
        public string user { get; set; }
        public string password { get; set; }
        public string operacion { get; set; } //codeCompany
        public string COTIMOVIMIENTO { get; set; }
        public string CODCLIENTE { get; set; }         // CONSULTADOC
        public string NBCLIENTE { get; set; }      // idClient
        public decimal MOBASE { get; set; }          // codAgree
        public decimal TSCAMBIO { get; set; }
        public string COUCTATRANS { get; set; }
        public decimal MOTRANS { get; set; }
        public long COMOTIVOOPERACION { get; set; }
        public string COINTRUM { get; set; }

        public autorizacionBCVParams returnAutorizacionBCVParams(string CAarguments)
        {
            char[] delimit = new char[] { '/' };
            string[] parameters = CAarguments.Split(delimit);
            autorizacionBCVParams aBcvParams = new autorizacionBCVParams();

            try
            {
                aBcvParams.suiche = parameters[0].ToString();
                aBcvParams.server = parameters[1].ToString();
                aBcvParams.db = parameters[2].ToString();
                aBcvParams.user = parameters[3].ToString();
                aBcvParams.password = parameters[4].ToString();
                aBcvParams.operacion = parameters[5].ToString();
                aBcvParams.COTIMOVIMIENTO = parameters[6].ToString();
                aBcvParams.CODCLIENTE = parameters[7].ToString();
                aBcvParams.NBCLIENTE = parameters[8].ToString();
                aBcvParams.MOBASE = Convert.ToDecimal(parameters[9]);
                aBcvParams.TSCAMBIO = Convert.ToDecimal(parameters[10]);
                aBcvParams.COUCTATRANS = parameters[11].ToString();
                aBcvParams.MOTRANS = Convert.ToDecimal(parameters[12]);
                aBcvParams.COMOTIVOOPERACION = Convert.ToInt64(parameters[13]);
                aBcvParams.COINTRUM = parameters[14].ToString();
                return aBcvParams;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Missing Params AutBCV..." + ex.ToString());
                return aBcvParams;
            }
        }
    }
}
