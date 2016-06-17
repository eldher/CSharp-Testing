using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication1.home
{
    public partial class ficha_tecnica : System.Web.UI.Page
    {
        public string linea { get; set; }
        public string contrato { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            linea = Request["linea"];
            DataTable dt = cargarCabecera(linea);
            llenarTextbox(dt);
            DataTable dt2 = cargarDisposiciones(linea);

            bloquearTextbox();
            DataTable dt3 = cargarFichaTecnica(linea);
            llenarTxtFicha(dt3);
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

        }

        public DataTable cargarFichaTecnica(string lc_madre)
        {
            string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"select distinct 
                            lc_madre,
                            presu_contruc_inicial,
                            presu_contruc_final,
                            porc_obra_proyectado,
                            porc_obra_ejecutado,
                            porc_obra_valuada,
                            fecha_ult_valuacion,
                            fecha_ult_visita,
                            indicador_obra_operativa,
                            operador_hotelero,
                            porc_ocupacion_proyectado,
                            fecha_actualiz_ocupacion,
                            porc_ocupacion_real,
                            cant_hab,
                            precio_promedio_x_hab,
                            presu_equipamiento_inicial,
                            presu_equipamiento_final,
                            ing_inspector,
                            ing_residente,
                            porc_ocupacion_fenahoven,
                            fecha_elaboracion,
                            precio_estimado,
                            precio_hab,
                            categoria_hotel,
                            fecha_venc_construcccion
                     from tFichaTecnica
                        where lc_madre = @lc_madre");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("lc_madre", lc_madre);
                    connection.Open();
                    DataTable dt2 = new DataTable();
                    dt2.Load(cmd.ExecuteReader());
                    return dt2;

                }
                catch (Exception ex) { return null; }

            }
        }
        
        public void llenarTxtFicha(DataTable dt)
        {
            txt_porc_ocupacion_proyectado.Text = dt.Rows[0]["porc_ocupacion_proyectado"].ToString();
            txt_precio_estimado.Text = Decimal.Parse(dt.Rows[0]["precio_estimado"].ToString()).ToString("C");
            txt_fecha_elaboracion.Text = Convert.ToDateTime(dt.Rows[0]["fecha_elaboracion"]).ToShortDateString();
            txt_porc_ocupacion_fenahoven.Text = dt.Rows[0]["porc_ocupacion_fenahoven"].ToString();
            txt_precio_promedio_x_hab.Text = Decimal.Parse(dt.Rows[0]["precio_promedio_x_hab"].ToString()).ToString("C");
            txt_porc_ocupacion_real.Text = dt.Rows[0]["porc_ocupacion_real"].ToString();
            txt_precio_hab.Text = Decimal.Parse(dt.Rows[0]["precio_hab"].ToString()).ToString("C");
            txt_fecha_actualiz_ocupacion.Text = Convert.ToDateTime(dt.Rows[0]["fecha_actualiz_ocupacion"]).ToShortDateString();
            txt_presu_contruc_inicial.Text = Decimal.Parse(dt.Rows[0]["presu_contruc_inicial"].ToString()).ToString("C");
            txt_presu_contruc_final.Text = Decimal.Parse(dt.Rows[0]["presu_contruc_final"].ToString()).ToString("C");
            txt_porc_obra_proyectado.Text = dt.Rows[0]["porc_obra_proyectado"].ToString();
            txt_porc_obra_ejecutado.Text = dt.Rows[0]["porc_obra_ejecutado"].ToString();
            txt_porc_obra_valuada.Text = dt.Rows[0]["porc_obra_valuada"].ToString();
            txt_fecha_ult_valuacion.Text = Convert.ToDateTime(dt.Rows[0]["fecha_ult_valuacion"]).ToShortDateString();
            txt_fecha_ult_visita.Text = Convert.ToDateTime(dt.Rows[0]["fecha_ult_visita"]).ToShortDateString();
            txt_fecha_venc_construcccion.Text = Convert.ToDateTime(dt.Rows[0]["fecha_venc_construcccion"]).ToShortDateString();
            txt_operador_hotelero.Text = dt.Rows[0]["operador_hotelero"].ToString();
            txt_ing_inspector.Text = dt.Rows[0]["ing_inspector"].ToString();
            txt_ing_residente.Text = dt.Rows[0]["ing_residente"].ToString();
            txt_categoria_hotel.Text = dt.Rows[0]["categoria_hotel"].ToString();


        }

        protected void btnModificar_Click(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "UPDATE tFichaTecnica(presu_contruc_inicial"
                +",presu_contruc_final,porc_obra_proyectado,porc_obra_ejecutado,"
                +"porc_obra_valuada,fecha_ult_valuacion,fecha_ult_visita,indicador_obra_operativa"
                +",operador_hotelero,porc_ocupacion_proyectado,fecha_actualiz_ocupacion,"
                +"porc_ocupacion_real,cant_hab,precio_promedio_x_hab,"
                +"presu_equipamiento_inicial,presu_equipamiento_final,ing_inspector,"
                +"ing_residente,porc_ocupacion_fenahoven,fecha_elaboracion,precio_estimado,"
                +"precio_hab,categoria_hotel,fecha_venc_construcccion" 
                + "VALUES ("
                +"@presu_contruc_inicial,@presu_contruc_final,@porc_obra_proyectado,"
                +"@porc_obra_ejecutado,@porc_obra_valuada,@fecha_ult_valuacion,@fecha_ult_visita,"
                +"@indicador_obra_operativa,@operador_hotelero,@porc_ocupacion_proyectado,"
                +"@fecha_actualiz_ocupacion,@porc_ocupacion_real,@cant_hab,@precio_promedio_x_hab,"
                +"@presu_equipamiento_inicial,@presu_equipamiento_final,@ing_inspector,@ing_residente,"
                +"@porc_ocupacion_fenahoven,@fecha_elaboracion,@precio_estimado,@precio_hab,"
                +"@categoria_hotel,@fecha_venc_construcccion"+               
                ")");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@presu_contruc_inicial", txt_presu_contruc_final.Text);
                cmd.Parameters.AddWithValue("@presu_contruc_final", txt_presu_contruc_final.Text);
                cmd.Parameters.AddWithValue("@porc_obra_proyectado", txt_porc_obra_proyectado.Text);
                cmd.Parameters.AddWithValue("@porc_obra_ejecutado", txt_porc_obra_ejecutado);
                cmd.Parameters.AddWithValue("@porc_obra_valuada", txt_porc_obra_valuada);
                cmd.Parameters.AddWithValue("@fecha_ult_valuacion", txt_fecha_ult_valuacion);
                cmd.Parameters.AddWithValue("@fecha_ult_visita", txt_fecha_ult_visita);
                cmd.Parameters.AddWithValue("@indicador_obra_operativa", txt_indicador_obra_operativa);
                cmd.Parameters.AddWithValue("@operador_hotelero", txt_operador_hotelero);
                cmd.Parameters.AddWithValue("@porc_ocupacion_proyectado", txt_porc_ocupacion_proyectado);
                cmd.Parameters.AddWithValue("@fecha_actualiz_ocupacion", txt_fecha_actualiz_ocupacion);
                cmd.Parameters.AddWithValue("@porc_ocupacion_real", txt_porc_ocupacion_real);
                cmd.Parameters.AddWithValue("@cant_hab", txt_cant_hab);
                cmd.Parameters.AddWithValue("@precio_promedio_x_hab", txt_precio_promedio_x_hab);
                cmd.Parameters.AddWithValue("@presu_equipamiento_inicial", txt_presu_equipamiento_inicial);
                cmd.Parameters.AddWithValue("@presu_equipamiento_final", txt_presu_equipamiento_final);
                cmd.Parameters.AddWithValue("@ing_inspector", txt_ing_inspector);
                cmd.Parameters.AddWithValue("@ing_residente", txt_ing_residente);
                cmd.Parameters.AddWithValue("@porc_ocupacion_fenahoven", txt_porc_ocupacion_fenahoven);
                cmd.Parameters.AddWithValue("@fecha_elaboracion", txt_fecha_elaboracion);
                cmd.Parameters.AddWithValue("@precio_estimado", txt_precio_estimado);
                cmd.Parameters.AddWithValue("@precio_hab", txt_precio_hab);
                cmd.Parameters.AddWithValue("@categoria_hotel", txt_categoria_hotel);
                cmd.Parameters.AddWithValue("@fecha_venc_construcccion", txt_fecha_venc_construcccion);

                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // guardar datos
        }
      
    }
}