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
    public partial class detalle_contrato : System.Web.UI.Page
    {
        public string linea { get; set; }
        public string contrato { get; set; }
        static string prevPage = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {

            contrato = Request.QueryString["contrato"];
            linea = Request.QueryString["linea"];

                DataTable dt = cargarCabecera(linea);
                llenarTextbox(dt);
                DataTable dt2 = cargarDisposiciones(linea);
                GridView2.DataSource = dt2;
                GridView2.DataBind();
                bloquearTextbox();
                DataTable dt3 = cargarDatosContrato(contrato);
                llenarTxtContratos(dt3);  
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

        public DataTable cargarDatosContrato(string contrato)
        {
            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select distinct 
                        fecha_desembolso,
                        fecha_venci_contrato,
                        fecha_fin_gracia_inicial,
                        fecha_fin_gracia_actual,
                        fecha_primera_amortiz,
                        indicador_reestruc,
                        plazo_en_meses,
                        importe_liquidado,
                        cap_x_cobrar_vig,
                        cap_x_cobrar_ven,
                        cap_litigio,
                        monto_interes_x_cobrar,
                        cap_x_cobrar_ven
                        from tContratos
                        where contrato = @contrato");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("contrato", contrato);
                    connection.Open();
                    DataTable dt2 = new DataTable();
                    dt2.Load(cmd.ExecuteReader());
                    return dt2;

                }
                catch (Exception ex) { return null; }

            }
        }

        public void llenarTxtContratos(DataTable dt)
        {

            txt_fecha_desembolso.Text = Convert.ToDateTime(dt.Rows[0][0]).ToShortDateString();
            txt_fecha_venci_contrato.Text = Convert.ToDateTime(dt.Rows[0][1]).ToShortDateString();
            txt_fecha_fin_gracia_inicial.Text = Convert.ToDateTime(dt.Rows[0][2]).ToShortDateString();
            txt_fecha_fin_gracia_actual.Text = Convert.ToDateTime(dt.Rows[0][3]).ToShortDateString();
            txt_fecha_primera_amortiz.Text = Convert.ToDateTime(dt.Rows[0][4]).ToShortDateString();
            txt_indicador_reestruc.Text = dt.Rows[0][5].ToString();
            txt_plazo_en_meses.Text = dt.Rows[0][6].ToString();
            txt_importe_liquidado.Text = Decimal.Parse(dt.Rows[0][7].ToString()).ToString("C");
            txt_cap_x_cobrar_vig.Text = Decimal.Parse(dt.Rows[0][8].ToString()).ToString("C");
            txt_cap_x_cobrar_ven.Text = Decimal.Parse(dt.Rows[0][9].ToString()).ToString("C");
            txt_cap_litigio.Text = Decimal.Parse(dt.Rows[0][10].ToString()).ToString("C");
            txt_monto_interes_x_cobrar.Text = Decimal.Parse(dt.Rows[0][11].ToString()).ToString("C");
            txt_total_cap_impa.Text =   Decimal.Parse(dt.Rows[0][12].ToString()).ToString("C");
            txt_total_int_impa.Text = txt_monto_interes_x_cobrar.Text;
        }


        protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.Cells[0].Text == contrato)
            {
                e.Row.BackColor = ColorTranslator.FromHtml("#9ee2f7");
            }

            
            

            int intEmailCol = 0; // set to correct column, starting at 0
            if (e.Row.RowType == DataControlRowType.DataRow)// && // skip header/footer
            //e.Row.Cells[intEmailCol].Text.StartsWith("&lt;a href"))
            {
                string temp = e.Row.Cells[intEmailCol].Text;
                e.Row.Cells[intEmailCol].Text = string.Empty;
                e.Row.Cells[intEmailCol].Text = "<a href='./detalle_contrato.aspx?contrato=" + temp + "&linea=" + linea + "'>" + temp + "</a>";
                //(e.Row.Cells(i).Text, "c0").ToString()
            }

            int currencyCol = 3;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[currencyCol].Text = Decimal.Parse(e.Row.Cells[currencyCol].Text).ToString("C");
                e.Row.Cells[4].Text = Decimal.Parse(e.Row.Cells[4].Text).ToString("C");
            }

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


            txt_fecha_desembolso.ReadOnly = true;
            txt_fecha_venci_contrato.ReadOnly = true;
            txt_fecha_fin_gracia_inicial.ReadOnly = true;
            txt_fecha_fin_gracia_actual.ReadOnly = true;
            txt_fecha_primera_amortiz.ReadOnly = true;
            txt_indicador_reestruc.ReadOnly = true;
            TextBox12.ReadOnly = true;
            txt_plazo_en_meses.ReadOnly = true;

            txt_importe_liquidado.ReadOnly = true;
            txt_cap_x_cobrar_vig.ReadOnly = true;
            txt_cap_x_cobrar_ven.ReadOnly = true;
            txt_cap_litigio.ReadOnly = true;
            txt_monto_interes_x_cobrar.ReadOnly = true;
            txt_total_cap_impa.ReadOnly = true;
            txt_total_int_impa.ReadOnly = true;


            /* bloquear dispuestos */
        }
              

    }
}
