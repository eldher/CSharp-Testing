using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CLBusinessObjects.DATOS;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1.Cuentas
{
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            username.Attributes.Add("placeholder", "Usuario");
            fullname.Attributes.Add("placeholder", "Nombre Usuario");
            pass.Attributes.Add("placeholder", "Contraseña");
            pass_repeat.Attributes.Add("placeholder", "Repita Contraseña");
            email.Attributes.Add("placeholder", "Email");
            question.Attributes.Add("placeholder", "Pregunta Seguridad");
            answer.Attributes.Add("placeholder", "Respuesta");            
        }

        protected void submit_Click(object sender, EventArgs e)
        {
            DataClass openData = new DataClass();
            //Response.Write(username.Text + pass.Text + email.Text);
            Datos dataconn = new Datos(openData.connectionString);

            string query = string.Format("EXEC uSpInsertUser 'REG','{0}','{1}','{2}','{3}','{4}','{5}'",
            username.Text,fullname.Text,pass.Text,email.Text,question.Text,answer.Text);
            DataTable dt = dataconn.ResultTableQuery(query);
            if (dt.Rows[0][0].Equals("inserted"))
            {
                //Response.Write("<script>alert('Usuario Registrado Satisfactoriamente');</script>");
                //Response.Redirect("../Default.aspx");                
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "confirm_registry()", true);
            }
            else
            {
                Response.Write("<script>alert('Usuario ya existe');</script>");
                Response.Redirect("../Registro.aspx");
            }
            //sendEmail();

        }

        public void sendEmail()
        {
            //MailMessage mail = new MailMessage("you@yourcompany.com", "user@hotmail.com");
            try
            {            
                MailAddress from = new MailAddress("eldheralexander.hernandez@bbva.com","Eldher");
                MailAddress to = new MailAddress("eldheralexander.hernandez@bbva.com", "Eldherw");
                MailMessage message = new MailMessage(from, to);
                SmtpClient client = new SmtpClient();
                client.Port = 25;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Host = "smtp.google.com";
                message.Subject = "this is a test email.";
                message.Body = "this is my test email body";
                client.Send(message);
            }
            catch (Exception ex)
            {
                string error = "Error" + ex.ToString();
            }
        }
    }
}