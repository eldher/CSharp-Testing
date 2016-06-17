using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;

namespace WebApplication1.home
{
    public partial class detalle_linea : System.Web.UI.Page
    {
        public string linea { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = string.Empty;
            if (Request["linea"] != null || Session["linea"] != null)  
            {
                if (Request["linea"] == null) { 
                    linea = Session["linea"].ToString(); 
                }
                else{
                    linea = Request["linea"].ToString();
                    Session["linea"] = linea;
                }
                DataTable dt = cargarCabecera(linea);
                llenarTextbox(dt);

                DataTable dt2 = cargarDisposiciones(linea);                 
                GridView2.DataSource = dt2;
                GridView2.DataBind();

                // Mostrar Saldos Dispuestos
                DataTable dt_ = cargarDispuesto(linea);
                llenarTextboxDispuesto(dt_);

                // bloquear todos los txtbox
                bloquearTextbox();
            }
        }

        public DataTable cargarCabecera(string contrato_madre)
        {
            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select distinct
                        a.cliente,
                        a.cedula_rif,
                        b.concedido_original_autoriz,
                        a.calificacion_subjetiva,
                        a.nom_cliente,
                        b.contrato_madre,
                        b.fecha_otorgamiento,
                        e.nom_proyecto,
                        a.nom_grupo,
                        'LC11' as subproducto, /*d.subproducto,*/ /* Buscar subproducto */
                        a.cod_oficina,
                        '' as covenant, /* e.covenant */ /* Falta este campo */
                        b.fecha_venci_linea
                        from tMadres f
                        inner join tLineas b on f.contrato_madre = b.contrato_madre
                        inner join tContratos d on f.contrato = d.contrato
                        inner join tClientes a on d.cliente = a.cliente
                        inner join tDept e on f.contrato = e.contrato
                    where f.contrato_madre = @contrato_madre ");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("contrato_madre", contrato_madre);
                    connection.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
                catch (Exception ex) { return null; }
            }
        }

        public void llenarTextbox(DataTable dt)
        {
            txt_cliente.Text = dt.Rows[0][0].ToString();
            txt_cedula_rif.Text = dt.Rows[0][1].ToString();            
            txt_concedido_original_autoriz.Text = Decimal.Parse(dt.Rows[0][2].ToString()).ToString("C");
            txt_calificacion_subjetiva.Text = dt.Rows[0][3].ToString();
            txt_nom_cliente.Text = dt.Rows[0][4].ToString();
            txt_contrato_madre.Text = dt.Rows[0][5].ToString();
            txt_fecha_otorgamiento.Text = Convert.ToDateTime(dt.Rows[0][6]).ToShortDateString();            
            txt_nombre_del_proyecto.Text = dt.Rows[0][7].ToString();
            txt_nom_grupo.Text = dt.Rows[0][8].ToString();
            txt_subproducto.Text = dt.Rows[0][9].ToString();
            txt_cod_oficina.Text = dt.Rows[0][10].ToString();

            //txt_covenant.Text = dt.Rows[0][11].ToString();  
            txt_fecha_vencimiento.Text = Convert.ToDateTime(dt.Rows[0][12]).ToShortDateString();

        }

        public DataTable cargarDisposiciones(string contrato_madre)
        {
            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select distinct 
                        c.Contrato as Disposiciones,
                        c.Subproducto as Subproducto,
                        c.tipo_cartera as Destino,
                        c.importe_liquidado as Concedido, /* Monto liquidado */
                        c.cap_x_cobrar_vig + C.cap_x_cobrar_ven as [Saldo Actual] 
                        from tMadres a
                        inner join tLineas b on a.contrato_madre = b.contrato_madre
                        inner join tContratos c on a.contrato = c.contrato
                        inner join tSubprod d on c.Subproducto = d.cod_subpro
                        where a.contrato_madre = @contrato_madre");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("contrato_madre", contrato_madre);
                    connection.Open();
                    DataTable dt2 = new DataTable();
                    dt2.Load(cmd.ExecuteReader());
                    return dt2;
     
                }
                catch (Exception ex) { return null; }

            }
        }

        public DataTable cargarDispuesto(string contrato_madre)
        {
            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select distinct 
                        dispuesto_construccion,
                        dispuesto_ampliacion,
                        dispuesto_equipamiento,
                        dispuesto_adquisicion,
                        dispuesto_otros,
                        dispuesto as total
                        from tLineas                        
                        where contrato_madre = @contrato_madre");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("contrato_madre", contrato_madre);
                    connection.Open();
                    DataTable dt2 = new DataTable();
                    dt2.Load(cmd.ExecuteReader());
                    return dt2;

                }
                catch (Exception ex) { return null; }

            }
        }

        public void llenarTextboxDispuesto(DataTable dt)
        {
            txtDispuestoConstruccion.Text   = Decimal.Parse(dt.Rows[0][0].ToString()).ToString("C");
            txtDispuestoAmpliacion.Text     = Decimal.Parse(dt.Rows[0][1].ToString()).ToString("C");
            txtDispuestoEquipamiento.Text   = Decimal.Parse(dt.Rows[0][2].ToString()).ToString("C");
            txtDispuestoAdquisición.Text    = Decimal.Parse(dt.Rows[0][3].ToString()).ToString("C");
            txtDispuestoOtros.Text          = Decimal.Parse(dt.Rows[0][4].ToString()).ToString("C");
            txtDispuestoAcumulado.Text      = Decimal.Parse(dt.Rows[0][5].ToString()).ToString("C");
          /*  txtDispuestoOtros.Text = Decimal.Parse(dt.Rows[0][5].ToString()).ToString("C"); */
        }

        public void bloquearTextbox()
        {
            txt_cliente.ReadOnly = true;
            txt_cedula_rif.ReadOnly = true;
            txt_concedido_original_autoriz.ReadOnly = true;
            txt_calificacion_subjetiva.ReadOnly = true;
            txt_nom_cliente.ReadOnly = true;
            txt_contrato_madre.ReadOnly = true;
            txt_fecha_otorgamiento.ReadOnly = true;
            txt_fecha_vencimiento.ReadOnly = true;
            txt_nombre_del_proyecto.ReadOnly = true;
            txt_nom_grupo.ReadOnly = true;
            txt_subproducto.ReadOnly = true;
            txt_cod_oficina.ReadOnly = true;

            /* bloquear dispuestos */
            
            txtDispuestoConstruccion.ReadOnly = true;
            txtDispuestoAmpliacion.ReadOnly = true;
            txtDispuestoEquipamiento.ReadOnly = true;
            txtDispuestoAdquisición.ReadOnly = true;
            txtDispuestoOtros.ReadOnly = true;
            txtDispuestoAcumulado.ReadOnly = true;
            TextBox8.ReadOnly = true;
            TextBox9.ReadOnly = true;
            TextBox10.ReadOnly = true;
            TextBox11.ReadOnly = true;

            
            TextBox7.BackColor = Color.Yellow;
            TextBox8.BackColor = Color.Yellow;
            TextBox9.BackColor = Color.Yellow;
            TextBox10.BackColor = Color.Yellow;
            TextBox11.BackColor = Color.Yellow;
        
        }

        protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.Cells[0].Text == linea) {
                e.Row.Cells[0].BackColor = Color.Yellow;            
            }

            int intEmailCol = 0; // set to correct column, starting at 0
            if (e.Row.RowType == DataControlRowType.DataRow)// && // skip header/footer
            //e.Row.Cells[intEmailCol].Text.StartsWith("&lt;a href"))
            { 
                string temp = e.Row.Cells[intEmailCol].Text;
                e.Row.Cells[intEmailCol].Text = string.Empty;
                e.Row.Cells[intEmailCol].Text = "<a href='./detalle_contrato.aspx?contrato=" + temp + "&linea="+linea+"'>" + temp + "</a>";                
                //(e.Row.Cells(i).Text, "c0").ToString()
            }
            
            int currencyCol = 3; 
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[currencyCol].Text = Decimal.Parse(e.Row.Cells[currencyCol].Text).ToString("C");
                e.Row.Cells[4].Text = Decimal.Parse(e.Row.Cells[4].Text).ToString("C");
            }

            
                
           

       }


    }
}