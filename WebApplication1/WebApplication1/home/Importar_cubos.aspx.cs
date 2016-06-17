using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1.home
{
    
    public partial class Importar_cubos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["linea"] = null;
            Session["contrato"] = null;
            txtBuscarCliente.Attributes.Add("placeholder", "Nro. de Cliente");
            txtBuscarNombre.Attributes.Add("placeholder", "Nombre de Cliente");
            txtBuscarLinea.Attributes.Add("placeholder", "Nro. de Linea"); //.Attributes.Add("placeholder", "Nro. de Linea");
            txtBuscarContrato.Attributes.Add("placeholder", "Nro. de Contrato");
            
            busquedas();
        }

        public static string GetWebAppRoot()
        {
            string port = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
            if (port == null || port == "80" || port == "443")
                port = "";
            else
                port = ":" + port;

            string protocol = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT_SECURE"];
            if (protocol == null || protocol == "0")
                protocol = "http://";
            else
                protocol = "https://";

            string sOut = protocol + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"] + port + System.Web.HttpContext.Current.Request.ApplicationPath;

            if (sOut.EndsWith("/"))
            {
                sOut = sOut.Substring(0, sOut.Length - 1);
            }

            return sOut;
        }
        
        
        public void importarCuboClientes()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_cliente.txt";
            string linea;
            int cont = 0;
            using (StreamReader stream = new StreamReader(path, Encoding.Default, true))
            {
                while ((linea = stream.ReadLine()) != null)
                {
                    cont++;
                    if (cont > 1)
                    {
                        char[] delimit = new char[] { ';' };
                        string[] campos = linea.Split(delimit);

                        Clientes Cliente = new Clientes();
                        Cliente.cliente = campos[0].ToString();
                        Cliente.cod_oficina = campos[1].ToString();
                        Cliente.nom_cliente = campos[2].ToString();
                        Cliente.cedula_rif = campos[3].ToString();
                        Cliente.nom_grupo = campos[4].ToString();
                        Cliente.clasificacion_riesgo = campos[5].ToString();
                        Cliente.calificacion_interna = campos[6].ToString();
                        Cliente.calificacion_subjetiva = campos[7].ToString();

                        Cliente.insertarCliente(Cliente);
                       // TextBox1.Text = TextBox1.Text + linea + "\r\n";
                    }
                }
            }
        }
        
        protected void btn_ImportarCubos_Click(object sender, System.EventArgs e)
        {
            importarCuboClientes();
        }

        protected void btnImportarCuboContratos_Click(object sender, EventArgs e)
        {
            Contratos Contrato = new Contratos();
            Contrato.importarCuboContratos();
        }

        protected void btnImportarCuboLC_Click(object sender, EventArgs e)
        {
            Lineas Linea = new Lineas();
            Linea.importarCuboLineas();
        }

        protected void btnImportarCuboMadres_Click(object sender, EventArgs e)
        {
            Madres Madre = new Madres();
            Madre.importarCuboMadres();
        }

        protected void btnImportarSubprod_Click(object sender, EventArgs e)
        {
            Subproductos Subproducto = new Subproductos();
            Subproducto.importarSubprod();
        }

        protected void btnBorrarTablas_Click(object sender, EventArgs e)
        {
            Mantenimiento mant = new Mantenimiento();
            mant.borrarTablas();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Todas las tablas fueron borradas.')", true);
        }

        
        /******************** Busquedas ***********************/        
        protected void btnBuscarPorContrato_Click(object sender, EventArgs e) 
        {
            busquedas();
        }
        public void busquedas() 
        {
            // Verifica el largo de los textos en los campos, luego buscar dependiendo
            Clientes cliente = new Clientes();
            Contratos contratos = new Contratos();

            int[] indicador = new int[4];
            indicador[0] = txtBuscarCliente.Text.Length;
            indicador[1] = txtBuscarNombre.Text.Length;
            indicador[2] = txtBuscarLinea.Text.Length;
            indicador[3] = txtBuscarContrato.Text.Length;
            string criterio = string.Empty;


            int maximoValor = indicador.Max();
            int maximoIndice = indicador.ToList().IndexOf(maximoValor);

            txtBuscarCliente.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");
            txtBuscarNombre.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");
            txtBuscarLinea.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");
            txtBuscarContrato.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");


            DataTable dt = new DataTable();
            if (maximoIndice == 0 ) {
                txtBuscarCliente.BackColor = System.Drawing.ColorTranslator.FromHtml("#EDF8FF");
                dt = cliente.buscarCliente(txtBuscarCliente.Text);
                criterio = "Número de Cliente";
            }
            else if (maximoIndice == 1) {
                txtBuscarNombre.BackColor = System.Drawing.ColorTranslator.FromHtml("#EDF8FF");
                dt = cliente.buscarClientePorNombre(txtBuscarNombre.Text);
                criterio = "Nombre de Cliente";
            }
            else if (maximoIndice == 2)
            {
                txtBuscarLinea.BackColor = System.Drawing.ColorTranslator.FromHtml("#EDF8FF");
                dt = contratos.buscarPorLinea(txtBuscarLinea.Text);
                criterio = "Linea";
            }
            else {
                txtBuscarContrato.BackColor = System.Drawing.ColorTranslator.FromHtml("#EDF8FF");
                dt = contratos.buscarPorContrato(txtBuscarContrato.Text);
                criterio = "Contrato";
                }

            if (dt.Rows.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Búsqueda por " + criterio + " no arrojó resultados.')", true);
            }
            else
            {

                if (criterio == "Contrato")
                {
                    string ruta_aplicacion = GetWebAppRoot();



                    string scriptText = "window.location.href='" + ruta_aplicacion + "/home/detalle_contrato.aspx?contrato=010800499600089042&linea=010800499600085147'";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", scriptText, true);
                    //Response.Redirect(ruta_aplicacion + "/home/detalle_contrato.aspx");
                    //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", scriptText, true);
                    //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "redirect", scriptText, true);
                }
                else
                {
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
            }   
        
        }
      
   

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            int intEmailCol = 2;
            if (e.Row.RowType == DataControlRowType.DataRow)            
            { 
                string temp = e.Row.Cells[intEmailCol].Text;
                e.Row.Cells[intEmailCol].Text = string.Empty;
                e.Row.Cells[intEmailCol].Text = "<a href='./detalle_linea.aspx?linea=" + temp + "'>" + temp + "</a>";
                e.Row.Cells[0].Width = new Unit("77px");
                e.Row.Cells[1].Width = new Unit("770px");
                e.Row.Cells[2].Width = new Unit("220px");
                e.Row.Cells[3].Width = new Unit("100px");
                e.Row.Cells[4].Width = new Unit("80px");
            }




        }

        protected void btnImportarDEPT_Click(object sender, EventArgs e)
        {
            Dept dept = new Dept();
            dept.importarCuboDept();
        }

        protected void btnImportarFT_Click(object sender, EventArgs e)
        {
            FichaTecnica fichaTecnica = new FichaTecnica();
            fichaTecnica.importarCuboFichaTecnica();
        }

    }
}
    
