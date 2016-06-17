using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CLBusinessObjects.Archivos;
using CLBusinessObjects.DATOS;

namespace WebApplication1
{
    public partial class _Default : System.Web.UI.Page
    {
        DataClass openData = new DataClass();
        public string fecha = "150318";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Directory.CreateDirectory(openData.ruta);
            if (Directory.Exists(openData.ruta))
                Label1.Text = "Existe Carpeta";
            else
                Label1.Text = "No existe la carpeta";

            string mensaje = string.Empty;
            if (File.Exists(@"\\ccsfilecfp03\Rdsar\PG" + fecha + ".TXT")) { mensaje = "Existe PG" + fecha + ".TXT<BR>"; }
            if (File.Exists(@"\\ccsfilecfp03\Rdsar\PA" + fecha + ".TXT")) { mensaje = mensaje + "Existe PA" + fecha + ".TXT<BR>"; }
            if (File.Exists(@"\\ccsfilecfp03\Rdsar\PC" + fecha + ".TXT")) { mensaje = mensaje + "Existe PC" + fecha + ".TXT<BR>"; }
            if (File.Exists(@"\\ccsfilecfp03\Rdsar\PU" + fecha + ".TXT")) { mensaje = mensaje + "Existe PU" + fecha + ".TXT<BR>"; }
            Response.Write(mensaje + "<BR>");
            // else
           //     Label1.Text = "No Existe Archivo";

        }

        public void getFiles(object sender, EventArgs e)
        {
            try
            {
                string[] abc = Directory.GetFiles(openData.ruta2);
                Grid1D.DataSource = abc;
                Grid1D.DataBind();
                //foreach (string a in abc)
                //{
                //    Response.Write(a);
                //    Response.Write("<BR>");
                //}
            }
            catch (Exception ex)
            {
                string errorr = "No se puede ver la ruta especificada: " + ex.ToString();
                Response.Write(errorr);
            }
        }

        protected void cargarData(object sender, EventArgs e)
        {
            try
            {
                Datos DatosAgencia = new Datos(openData.connectionString);
                DataTable dt = DatosAgencia.ResultTableQuery("Select * from uVwContactos");
                dgv_DataCargada.DataSource = dt;
                dgv_DataCargada.DataBind();
            }
            catch (Exception ex)
            {
                string errorr = "No se puede ver la ruta especificada: " + ex.ToString();
                Response.Write(errorr);
            }
        }

        protected void cargarClientes(object sender, EventArgs e)
        {
            GetSASTable();
        }

        public void GetSASTable()
        {
            DataSet sasDs = new DataSet();
            String sasLibrary = @"C:\A\SAR\";
            OleDbConnection sas = new OleDbConnection(@"Provider=sas.LocalProvider; Data Source="+ sasLibrary);
            try 
            { 
                sas.Open(); 
                OleDbCommand sasCommand = sas.CreateCommand();
                sasCommand.CommandType = CommandType.TableDirect;
                sasCommand.CommandText = "Clientes_juridicos";
                OleDbDataAdapter da = new OleDbDataAdapter(sasCommand);
                da.Fill(sasDs,"SasData");
                sas.Close();

                using (SqlConnection destinationConnection = new SqlConnection(openData.connectionString))
                {
                    // open the connection
                    destinationConnection.Open();
                    using (SqlBulkCopy bulkCopy = new SqlBulkCopy(destinationConnection.ConnectionString))
                    {
                        // column mappings
                        //bulkCopy.ColumnMappings.Add("productID", "ProductID");
                        //bulkCopy.ColumnMappings.Add("productName", "Name");
                        bulkCopy.BatchSize = 50;
                        bulkCopy.NotifyAfter = 100;
                        bulkCopy.BulkCopyTimeout = 60;
                        bulkCopy.DestinationTableName = "clientes";
                        bulkCopy.WriteToServer(sasDs.Tables["SasData"]);
                    }
                }
            }            
            catch (Exception ex) 
            {
                string errorr = "Unable to load SAS dataset. Error seen was: " + ex.ToString();
                Response.Write(errorr);
            }

            sas.Close();
            sasDs.Clear();            
        } 

    }
}
