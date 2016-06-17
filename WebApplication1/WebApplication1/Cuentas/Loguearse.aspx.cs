using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CLBusinessObjects.DATOS;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1.Cuentas
{
    public partial class Loguearse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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

        protected void login_Click(object sender, EventArgs e)
        {
            Autorizar();
        }

        private void Autorizar() {

            string ruta_aplicacion = GetWebAppRoot();
            DataTable dt = new DataTable();

            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select * from users                        
                    where username = @username and pass = @pass");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("username", username.Text);
                    cmd.Parameters.AddWithValue("pass", pass.Text);
                    connection.Open();                    
                    dt.Load(cmd.ExecuteReader());
                }
                catch (Exception ex) 
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", ex.ToString(), true);
                }
            }

            if (dt.Rows.Count > 0)
            {
                string scriptText = "alert('Acceso Concedido'); window.location='" + ruta_aplicacion + "/home/importar_cubos.aspx'";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", scriptText, true);
            }  
            else 
            {
                string scriptText = "alert('Acceso Denegado'); window.location='" + ruta_aplicacion + "/Cuentas/Loguearse.aspx'";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", scriptText, true);
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Cuentas/Registro.aspx");            
        }
    }
}