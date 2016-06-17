using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.IO;
using System.Text;


namespace WebApplication1
{
    public class DataClass
    {
        public string ruta = @"C:\ELDHER\TestDirectory";
        public string ruta2 = @"\\ccsfilecfp03\RdSar";
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";
    }

    public class Clientes
    {
        public string cliente { get; set; }
        public string cod_oficina { get; set; }
        public string nom_cliente { get; set; }
        public string cedula_rif { get; set; }
        public string nom_grupo { get; set; }
        public string clasificacion_riesgo { get; set; }
        public string calificacion_interna { get; set; }
        public string calificacion_subjetiva { get; set; }
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void insertarCliente(Clientes Cliente)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tClientes("
                + "cliente, cod_oficina, nom_cliente, cedula_rif,nom_grupo, clasificacion_riesgo,"
                + "calificacion_interna, calificacion_subjetiva)"
                + "VALUES (@cliente, @cod_oficina, @nom_cliente, @cedula_rif,"
                + "@nom_grupo, @clasificacion_riesgo, @calificacion_interna, @calificacion_subjetiva)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@cliente", Cliente.cliente);
                cmd.Parameters.AddWithValue("@cod_oficina", Cliente.cod_oficina);
                cmd.Parameters.AddWithValue("@nom_cliente", Cliente.nom_cliente);
                cmd.Parameters.AddWithValue("@cedula_rif", Cliente.cedula_rif);
                cmd.Parameters.AddWithValue("@nom_grupo", Cliente.nom_grupo);
                cmd.Parameters.AddWithValue("@clasificacion_riesgo", Cliente.clasificacion_riesgo);
                cmd.Parameters.AddWithValue("@calificacion_interna", Cliente.calificacion_interna);
                cmd.Parameters.AddWithValue("@calificacion_subjetiva", Cliente.calificacion_subjetiva);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public DataTable buscarCliente(string nroCliente)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                    @"SELECT DISTINCT 
                        a.cliente as Cliente,
                        a.nom_cliente as [Nombre Cliente],
                        b.contrato_madre as [Contrato Madre],
                        convert(varchar(20),b.fecha_venci_linea,103) as [Fecha Vencimiento],
                        CASE concedido_original_autoriz WHEN  0 THEN 'Si' END AS [LC Suplente]
                        FROM tClientes a 
                        LEFT JOIN tLineas b on a.cliente = b.cliente                    
                        WHERE a.cliente LIKE @cliente
                        order by a.nom_cliente");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("@cliente", "%" + nroCliente + "%");
                    connection.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
                catch (Exception ex) { return null; }                
            }

        }

        public DataTable buscarClientePorNombre(string nomCliente)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                       @"SELECT DISTINCT 
                            a.cliente as Cliente,
                            a.nom_cliente as [Nombre del Cliente],
                            b.contrato_madre as [Contrato Madre],
                            convert(varchar(20),b.fecha_venci_linea,103) as [Fecha Vencimiento],
                            CASE concedido_original_autoriz WHEN  0 THEN 'Si' END AS [LC Suplente]
                            FROM tClientes a 
                            LEFT JOIN tLineas b on a.cliente = b.cliente                    
                            WHERE a.nom_cliente LIKE @cliente
                            ORDER BY a.nom_cliente
                            ");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("@cliente", nomCliente + "%");
                    connection.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
                catch (Exception ex) { return null; }
            }
        }
    }

    public class Contratos 
    {
        public string contrato { get; set; }
        public string cliente { get; set; }
        public string nom_director { get; set; }
        public string nom_gerente { get; set; }
        public string espec_tecnico { get; set; }
        public DateTime fecha_desembolso { get; set; }
        public DateTime fecha_venci_contrato { get; set; }
        public decimal importe_liquidado { get; set; }
        public decimal cap_x_cobrar_vig { get; set; }
        public decimal cap_x_cobrar_ven { get; set; }
        public string cap_litigio { get; set; }
        public string indicador_reestruc { get; set; }
        public Int32 plazo_en_meses { get; set; }
        public DateTime fecha_fin_gracia_inicial { get; set; }
        public DateTime fecha_fin_gracia_actual { get; set; }
        public DateTime fecha_primera_amortiz { get; set; }
        public decimal cuotas_interes_x_cobrar { get; set; }
        public decimal monto_interes_x_cobrar { get; set; }
        public decimal ctas_cap_fact_x_cobrar { get; set; }
        public decimal monto_cap_fact_x_cobrar { get; set; }
        public string tipo_cartera { get; set; }
        public string subproducto { get; set; }
        public string cta_contable { get; set; }
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";


        public void insertarContrato(Contratos Contrato)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tContratos("
                +"contrato,cliente,nom_director,nom_gerente,espec_tecnico,fecha_desembolso,fecha_venci_contrato,"
                +"importe_liquidado,cap_x_cobrar_vig,cap_x_cobrar_ven,cap_litigio,indicador_reestruc,plazo_en_meses,"
                +"fecha_fin_gracia_inicial,fecha_fin_gracia_actual,fecha_primera_amortiz,cuotas_interes_x_cobrar,"
                +"monto_interes_x_cobrar,ctas_cap_fact_x_cobrar,monto_cap_fact_x_cobrar,tipo_cartera,subproducto,"
                +"cta_contable)" 
                + "VALUES ("
                +"@contrato,@cliente,@nom_director,@nom_gerente,@espec_tecnico,@fecha_desembolso,@fecha_venci_contrato,"
                +"@importe_liquidado,@cap_x_cobrar_vig,@cap_x_cobrar_ven,@cap_litigio,@indicador_reestruc,@plazo_en_meses,"
                +"@fecha_fin_gracia_inicial,@fecha_fin_gracia_actual,@fecha_primera_amortiz,@cuotas_interes_x_cobrar,"
                +"@monto_interes_x_cobrar,@ctas_cap_fact_x_cobrar,@monto_cap_fact_x_cobrar,@tipo_cartera,@subproducto,"
                +"@cta_contable)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@contrato", Contrato.contrato);
                cmd.Parameters.AddWithValue("@cliente", Contrato.cliente);
                cmd.Parameters.AddWithValue("@nom_director", Contrato.nom_director);
                cmd.Parameters.AddWithValue("@nom_gerente", Contrato.nom_gerente);
                cmd.Parameters.AddWithValue("@espec_tecnico", Contrato.espec_tecnico);
                cmd.Parameters.AddWithValue("@fecha_desembolso", Contrato.fecha_desembolso);
                cmd.Parameters.AddWithValue("@fecha_venci_contrato", Contrato.fecha_venci_contrato);
                cmd.Parameters.AddWithValue("@importe_liquidado", Contrato.importe_liquidado);
                cmd.Parameters.AddWithValue("@cap_x_cobrar_vig", Contrato.cap_x_cobrar_vig);
                cmd.Parameters.AddWithValue("@cap_x_cobrar_ven", Contrato.cap_x_cobrar_ven);
                cmd.Parameters.AddWithValue("@cap_litigio", Contrato.cap_litigio);
                cmd.Parameters.AddWithValue("@indicador_reestruc", Contrato.indicador_reestruc);
                cmd.Parameters.AddWithValue("@plazo_en_meses", Contrato.plazo_en_meses);
                cmd.Parameters.AddWithValue("@fecha_fin_gracia_inicial", Contrato.fecha_fin_gracia_inicial);
                cmd.Parameters.AddWithValue("@fecha_fin_gracia_actual", Contrato.fecha_fin_gracia_actual);
                cmd.Parameters.AddWithValue("@fecha_primera_amortiz", Contrato.fecha_primera_amortiz);
                cmd.Parameters.AddWithValue("@cuotas_interes_x_cobrar", Contrato.cuotas_interes_x_cobrar);
                cmd.Parameters.AddWithValue("@monto_interes_x_cobrar", Contrato.monto_interes_x_cobrar);
                cmd.Parameters.AddWithValue("@ctas_cap_fact_x_cobrar", Contrato.ctas_cap_fact_x_cobrar);
                cmd.Parameters.AddWithValue("@monto_cap_fact_x_cobrar", Contrato.monto_cap_fact_x_cobrar);
                cmd.Parameters.AddWithValue("@tipo_cartera", Contrato.tipo_cartera);
                cmd.Parameters.AddWithValue("@subproducto", Contrato.subproducto);
                cmd.Parameters.AddWithValue("@cta_contable", Contrato.cta_contable);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void importarCuboContratos()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_contrato.txt";
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

                        Contratos Contrato = new Contratos();
                        Contrato.contrato = campos[0].ToString();
                        Contrato.cliente = campos[1].ToString();
                        Contrato.nom_director = campos[2].ToString();
                        Contrato.nom_gerente = campos[3].ToString();
                        Contrato.espec_tecnico = campos[4].ToString();
                        Contrato.fecha_desembolso = Convert.ToDateTime(campos[5]);
                        Contrato.fecha_venci_contrato = Convert.ToDateTime(campos[6]);
                        Contrato.importe_liquidado = Convert.ToDecimal(campos[7]);
                        Contrato.cap_x_cobrar_vig = Convert.ToDecimal(campos[8]);
                        Contrato.cap_x_cobrar_ven = Convert.ToDecimal(campos[9]);
                        Contrato.cap_litigio = campos[10].ToString();
                        Contrato.indicador_reestruc = campos[11].ToString();
                        Contrato.plazo_en_meses = Convert.ToInt32(campos[12]);
                        Contrato.fecha_fin_gracia_inicial = Convert.ToDateTime(campos[13]);
                        Contrato.fecha_fin_gracia_actual = Convert.ToDateTime(campos[14]);
                        Contrato.fecha_primera_amortiz = Convert.ToDateTime(campos[15]);
                        Contrato.cuotas_interes_x_cobrar = Convert.ToDecimal(campos[16]);
                        Contrato.monto_interes_x_cobrar = Convert.ToDecimal(campos[17]);
                        Contrato.ctas_cap_fact_x_cobrar = Convert.ToDecimal(campos[18]);
                        Contrato.monto_cap_fact_x_cobrar = Convert.ToDecimal(campos[19]);
                        Contrato.tipo_cartera = campos[20].ToString();
                        Contrato.subproducto = campos[21].ToString();
                        Contrato.cta_contable = campos[22].ToString();
                                                
                        Contrato.insertarContrato(Contrato);
                    }
                }
            }
        }

        public DataTable buscarPorLinea(string contrato)
        { 
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                       @"SELECT DISTINCT 
                            a.cliente as Cliente,
                            a.nom_cliente as [Nombre del Cliente],
                            b.contrato_madre as [Contrato Madre],
                            convert(varchar(20),b.fecha_venci_linea,103) as [Fecha Vencimiento],
                            CASE concedido_original_autoriz WHEN  0 THEN 'Si' END AS [LC Suplente]
                            FROM tClientes a 
                            LEFT JOIN tLineas b on a.cliente = b.cliente                    
                            WHERE b.contrato_madre LIKE @contrato
                            ORDER BY a.nom_cliente
                            ");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("@contrato", contrato + "%");
                    connection.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
                catch (Exception ex) { return null; }
            }
        }

        public DataTable buscarPorContrato(string contrato)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(
                       @"SELECT DISTINCT 
                            contrato_madre,
                            contrato
                            FROM tMadres                                             
                            WHERE contrato LIKE @contrato                            
                            ");
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = connection;
                    cmd.Parameters.AddWithValue("@contrato", contrato + "%");
                    connection.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
                catch (Exception ex) { return null; }
            }
        }
    }

    public class Lineas
    {
        public string cliente { get; set; }
        public string contrato_madre { get; set; }
        public decimal concedido_original_autoriz { get; set; }
        public DateTime fecha_otorgamiento { get; set; }
        public decimal total_ampliacion_limite_lc { get; set; }
        public decimal total_anticipo { get; set; }
        public decimal dispuesto_construccion { get; set; }
        public decimal dispuesto_ampliacion { get; set; }
        public decimal dispuesto_equipamiento { get; set; }
        public decimal dispuesto_adquisicion { get; set; }
        public decimal dispuesto_otros { get; set; }
        public decimal dispuesto { get; set; }
        public DateTime fecha_venci_linea { get; set; }  
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";


        public void insertarLinea(Lineas Linea)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tLineas("
                +"cliente,contrato_madre,concedido_original_autoriz,fecha_otorgamiento,total_ampliacion_limite_lc,"
                +"total_anticipo,dispuesto_construccion,dispuesto_ampliacion,dispuesto_equipamiento,"
                +"dispuesto_adquisicion,dispuesto_otros,dispuesto,fecha_venci_linea)" 
                + "VALUES ("
                +"@cliente,@contrato_madre,@concedido_original_autoriz,@fecha_otorgamiento,"
                +"@total_ampliacion_limite_lc,@total_anticipo,@dispuesto_construccion,@dispuesto_ampliacion,"
                + "@dispuesto_equipamiento,@dispuesto_adquisicion,@dispuesto_otros,@dispuesto,@fecha_venci_linea)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@cliente", Linea.cliente);
                cmd.Parameters.AddWithValue("@contrato_madre", Linea.contrato_madre);
                cmd.Parameters.AddWithValue("@concedido_original_autoriz", Linea.concedido_original_autoriz);
                cmd.Parameters.AddWithValue("@fecha_otorgamiento", Linea.fecha_otorgamiento);
                cmd.Parameters.AddWithValue("@total_ampliacion_limite_lc", Linea.total_ampliacion_limite_lc);
                cmd.Parameters.AddWithValue("@total_anticipo", Linea.total_anticipo);
                cmd.Parameters.AddWithValue("@dispuesto_construccion", Linea.dispuesto_construccion);
                cmd.Parameters.AddWithValue("@dispuesto_ampliacion", Linea.dispuesto_ampliacion);
                cmd.Parameters.AddWithValue("@dispuesto_equipamiento", Linea.dispuesto_equipamiento);
                cmd.Parameters.AddWithValue("@dispuesto_adquisicion", Linea.dispuesto_adquisicion);
                cmd.Parameters.AddWithValue("@dispuesto_otros", Linea.dispuesto_otros);
                cmd.Parameters.AddWithValue("@dispuesto", Linea.dispuesto);
                cmd.Parameters.AddWithValue("@fecha_venci_linea", Linea.fecha_venci_linea);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void importarCuboLineas()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_lc.txt";
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

                        Lineas Linea = new Lineas();
                        Linea.cliente = campos[0].ToString();
                        Linea.contrato_madre = campos[1].ToString();
                        Linea.concedido_original_autoriz = Convert.ToDecimal(campos[2]);
                        Linea.fecha_otorgamiento = Convert.ToDateTime(campos[3]);
                        Linea.total_ampliacion_limite_lc = Convert.ToDecimal(campos[4]);
                        Linea.total_anticipo = Convert.ToDecimal(campos[5]);
                        Linea.dispuesto_construccion = Convert.ToDecimal(campos[6]);
                        Linea.dispuesto_ampliacion = Convert.ToDecimal(campos[7]);
                        Linea.dispuesto_equipamiento = Convert.ToDecimal(campos[8]);
                        Linea.dispuesto_adquisicion = Convert.ToDecimal(campos[9]);
                        Linea.dispuesto_otros = Convert.ToDecimal(campos[10]);
                        Linea.dispuesto = Convert.ToDecimal(campos[11]);
                        Linea.fecha_venci_linea = Convert.ToDateTime(campos[12]);
                        Linea.insertarLinea(Linea);
                    }
                }
            }
        }
    
    }

    public class Madres
    {
        public string contrato_madre { get; set; }
        public string contrato { get; set; }
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void insertarMadre(Madres Madre)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tMadres(contrato_madre,contrato) VALUES (@contrato_madre,@contrato)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@contrato_madre", Madre.contrato_madre);
                cmd.Parameters.AddWithValue("@contrato", Madre.contrato);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void importarCuboMadres()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_madre.txt";
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

                        Madres Madre = new Madres();
                        Madre.contrato_madre = campos[0].ToString();
                        Madre.contrato = campos[1].ToString();
                        Madre.insertarMadre(Madre);
                        //TextBox1.Text = TextBox1.Text + linea + "\r\n";

                        // Agregar validacion de return
                    }
                }
            }
        }



    }

    public class Subproductos
    {
        public string cod_subpro { get; set; }
        public string descr_subpro { get; set; }
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void insertarSubprod(Subproductos Subproducto)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO tSubprod(cod_subpro,descr_subpro) VALUES (@cod_subpro,@descr_subpro)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@cod_subpro", Subproducto.cod_subpro);
                cmd.Parameters.AddWithValue("@descr_subpro", Subproducto.descr_subpro);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void importarSubprod()
        {            
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\subprod.txt";
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

                        Subproductos Subprod = new Subproductos();
                        Subprod.cod_subpro = campos[0].ToString();
                        Subprod.descr_subpro = campos[1].ToString();
                        Subprod.insertarSubprod(Subprod);
                        //TextBox1.Text = TextBox1.Text + linea + "\r\n";

                        // Agregar validacion de return
                    }
                }
            }
        }


    }

    public class Mantenimiento
    {
        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void borrarTablas()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("delete from tClientes", connection))    { cmd.ExecuteNonQuery(); }
                using (SqlCommand cmd = new SqlCommand("delete from tContratos", connection))   { cmd.ExecuteNonQuery(); }
                using (SqlCommand cmd = new SqlCommand("delete from tLineas", connection))      { cmd.ExecuteNonQuery(); }
                using (SqlCommand cmd = new SqlCommand("delete from tMadres", connection))      { cmd.ExecuteNonQuery(); }
                using (SqlCommand cmd = new SqlCommand("delete from tDept", connection))        { cmd.ExecuteNonQuery(); }
                using (SqlCommand cmd = new SqlCommand("delete from tFichaTecnica", connection)) { cmd.ExecuteNonQuery(); }   
            }
        }
        
    }

    public class FichaTecnica 
    {
        public string lc_madre { get; set; }
        public decimal presu_contruc_inicial { get; set; }
        public decimal presu_contruc_final { get; set; }
        public decimal porc_obra_proyectado { get; set; }
        public decimal porc_obra_ejecutado { get; set; }
        public decimal porc_obra_valuada { get; set; }
        public DateTime fecha_ult_valuacion { get; set; }
        public DateTime fecha_ult_visita { get; set; }
        public decimal indicador_obra_operativa { get; set; }
        public string operador_hotelero { get; set; }
        public decimal porc_ocupacion_proyectado { get; set; }
        public DateTime fecha_actualiz_ocupacion { get; set; }
        public decimal porc_ocupacion_real { get; set; }
        public decimal cant_hab { get; set; }
        public decimal precio_promedio_x_hab { get; set; }
        public decimal presu_equipamiento_inicial { get; set; }
        public decimal presu_equipamiento_final { get; set; }
        public string ing_inspector { get; set; }
        public string ing_residente { get; set; }
        public decimal porc_ocupacion_fenahoven { get; set; }
        public DateTime fecha_elaboracion { get; set; }
        public decimal precio_estimado { get; set; }
        public decimal precio_hab { get; set; }
        public string categoria_hotel { get; set; }
        public DateTime fecha_venc_construcccion { get; set; }

        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void insertarFichaTecnica(FichaTecnica FichaTecnica)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tFichaTecnica("
                + "lc_madre,presu_contruc_inicial,presu_contruc_final,porc_obra_proyectado,"
                + "porc_obra_ejecutado,porc_obra_valuada,fecha_ult_valuacion,fecha_ult_visita,"
                + "indicador_obra_operativa,operador_hotelero,porc_ocupacion_proyectado,"
                + "fecha_actualiz_ocupacion,porc_ocupacion_real,cant_hab,precio_promedio_x_hab,"
                + "presu_equipamiento_inicial,presu_equipamiento_final,ing_inspector,ing_residente,"
                + "porc_ocupacion_fenahoven,fecha_elaboracion,precio_estimado,precio_hab,categoria_hotel,fecha_venc_construcccion)"
                + "VALUES ("
                + "@lc_madre,@presu_contruc_inicial,@presu_contruc_final,@porc_obra_proyectado,"
                + "@porc_obra_ejecutado,@porc_obra_valuada,@fecha_ult_valuacion,@fecha_ult_visita,"
                + "@indicador_obra_operativa,@operador_hotelero,@porc_ocupacion_proyectado,"
                + "@fecha_actualiz_ocupacion,@porc_ocupacion_real,@cant_hab,@precio_promedio_x_hab,"
                + "@presu_equipamiento_inicial,@presu_equipamiento_final,@ing_inspector,@ing_residente,"
                + "@porc_ocupacion_fenahoven,@fecha_elaboracion,@precio_estimado,@precio_hab,@categoria_hotel,@fecha_venc_construcccion)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@lc_madre", FichaTecnica.lc_madre);
                cmd.Parameters.AddWithValue("@presu_contruc_inicial", FichaTecnica.presu_contruc_inicial);
                cmd.Parameters.AddWithValue("@presu_contruc_final", FichaTecnica.presu_contruc_final);
                cmd.Parameters.AddWithValue("@porc_obra_proyectado", FichaTecnica.porc_obra_proyectado);
                cmd.Parameters.AddWithValue("@porc_obra_ejecutado", FichaTecnica.porc_obra_ejecutado);
                cmd.Parameters.AddWithValue("@porc_obra_valuada", FichaTecnica.porc_obra_valuada);
                cmd.Parameters.AddWithValue("@fecha_ult_valuacion", FichaTecnica.fecha_ult_valuacion);
                cmd.Parameters.AddWithValue("@fecha_ult_visita", FichaTecnica.fecha_ult_visita);
                cmd.Parameters.AddWithValue("@indicador_obra_operativa", FichaTecnica.indicador_obra_operativa);
                cmd.Parameters.AddWithValue("@operador_hotelero", FichaTecnica.operador_hotelero);
                cmd.Parameters.AddWithValue("@porc_ocupacion_proyectado", FichaTecnica.porc_ocupacion_proyectado);
                cmd.Parameters.AddWithValue("@fecha_actualiz_ocupacion", FichaTecnica.fecha_actualiz_ocupacion);
                cmd.Parameters.AddWithValue("@porc_ocupacion_real", FichaTecnica.porc_ocupacion_real);
                cmd.Parameters.AddWithValue("@cant_hab", FichaTecnica.cant_hab);
                cmd.Parameters.AddWithValue("@precio_promedio_x_hab", FichaTecnica.precio_promedio_x_hab);
                cmd.Parameters.AddWithValue("@presu_equipamiento_inicial", FichaTecnica.presu_equipamiento_inicial);
                cmd.Parameters.AddWithValue("@presu_equipamiento_final", FichaTecnica.presu_equipamiento_final);
                cmd.Parameters.AddWithValue("@ing_inspector", FichaTecnica.ing_inspector);
                cmd.Parameters.AddWithValue("@ing_residente", FichaTecnica.ing_residente);
                cmd.Parameters.AddWithValue("@porc_ocupacion_fenahoven", FichaTecnica.porc_ocupacion_fenahoven);
                cmd.Parameters.AddWithValue("@fecha_elaboracion", FichaTecnica.fecha_elaboracion);
                cmd.Parameters.AddWithValue("@precio_estimado", FichaTecnica.precio_estimado);
                cmd.Parameters.AddWithValue("@precio_hab", FichaTecnica.precio_hab);
                cmd.Parameters.AddWithValue("@categoria_hotel", FichaTecnica.categoria_hotel);
                cmd.Parameters.AddWithValue("@fecha_venc_construcccion", FichaTecnica.fecha_venc_construcccion);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }


        public void importarCuboFichaTecnica()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_ft.txt";
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

                        FichaTecnica FichaTecnica = new FichaTecnica();
                        FichaTecnica.lc_madre = campos[0].ToString();
                        FichaTecnica.presu_contruc_inicial = Convert.ToDecimal(campos[1]);
                        FichaTecnica.presu_contruc_final = Convert.ToDecimal(campos[2]);
                        FichaTecnica.porc_obra_proyectado = Convert.ToDecimal(campos[3]);
                        FichaTecnica.porc_obra_ejecutado = Convert.ToDecimal(campos[4]);
                        FichaTecnica.porc_obra_valuada = Convert.ToDecimal(campos[5]);
                        FichaTecnica.fecha_ult_valuacion = Convert.ToDateTime(campos[6]);
                        FichaTecnica.fecha_ult_visita = Convert.ToDateTime(campos[7]);
                        FichaTecnica.indicador_obra_operativa = Convert.ToDecimal(campos[8]);
                        FichaTecnica.operador_hotelero = campos[9].ToString();
                        FichaTecnica.porc_ocupacion_proyectado = Convert.ToDecimal(campos[10]);
                        FichaTecnica.fecha_actualiz_ocupacion = Convert.ToDateTime(campos[11]);
                        FichaTecnica.porc_ocupacion_real = Convert.ToDecimal(campos[12]);
                        FichaTecnica.cant_hab = Convert.ToDecimal(campos[13]);
                        FichaTecnica.precio_promedio_x_hab = Convert.ToDecimal(campos[14]);
                        FichaTecnica.presu_equipamiento_inicial = Convert.ToDecimal(campos[15]);
                        FichaTecnica.presu_equipamiento_final = Convert.ToDecimal(campos[16]);
                        FichaTecnica.ing_inspector = campos[17].ToString();
                        FichaTecnica.ing_residente = campos[18].ToString();
                        FichaTecnica.porc_ocupacion_fenahoven = Convert.ToDecimal(campos[19]);
                        FichaTecnica.fecha_elaboracion = Convert.ToDateTime(campos[20].ToString());
                        FichaTecnica.precio_estimado = Convert.ToDecimal(campos[21]);
                        FichaTecnica.precio_hab = Convert.ToDecimal(campos[22]);
                        FichaTecnica.categoria_hotel = campos[23].ToString();
                        FichaTecnica.fecha_venc_construcccion = Convert.ToDateTime(campos[24].ToString());
                        FichaTecnica.insertarFichaTecnica(FichaTecnica);
                    }
                }
            }
        }
    
    }

    public class Dept
    {
        public string contrato { get; set; }
        public string num_rtn { get; set; }
        public string lic_turistica_nacional { get; set; }
        public DateTime fecha_factib_tecnica { get; set; }
        public DateTime fecha_confor { get; set; }
        public string num_expediente_factib { get; set; }
        public string num_expediente_confor { get; set; }
        public string nom_proyecto { get; set; }
        public string tipo_proyecto { get; set; }
        public string destino_credito { get; set; }
        public string tipo_zona { get; set; }
        public DateTime fecha_protoc { get; set; }
        public string num_oficio_incentivo { get; set; }
        public string segmento { get; set; }
        public string estado_ubic_proyecto { get; set; }
        public string municip_ubic_proy { get; set; }
        public string ciudad_ubic_proy { get; set; }

        public string connectionString = @"Data Source=BPVMXL224160V\SQLEXPRESS;Initial Catalog=turismo;Persist Security Info=True;User ID=bbva_admin;Password=bbva+123;Connection Timeout=300";

        public void insertarDEPT(Dept Dept)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(
                "INSERT INTO tDept("
                + "contrato,num_rtn,lic_turistica_nacional,fecha_factib_tecnica,fecha_confor,"
                + "num_expediente_factib,num_expediente_confor,nom_proyecto,tipo_proyecto,destino_credito,"
                + "tipo_zona,fecha_protoc,num_oficio_incentivo,segmento,estado_ubic_proyecto,municip_ubic_proy,"
                + "ciudad_ubic_proy)"
                + "VALUES ("
                + "@contrato,@num_rtn,@lic_turistica_nacional,@fecha_factib_tecnica,"
                + "@fecha_confor,@num_expediente_factib,@num_expediente_confor,@nom_proyecto,"
                + "@tipo_proyecto,@destino_credito,@tipo_zona,@fecha_protoc,@num_oficio_incentivo,"
                + "@segmento,@estado_ubic_proyecto,@municip_ubic_proy,@ciudad_ubic_proy)");
                cmd.CommandType = CommandType.Text;
                cmd.Connection = connection;
                cmd.Parameters.AddWithValue("@contrato", Dept.contrato);
                cmd.Parameters.AddWithValue("@num_rtn", Dept.num_rtn);
                cmd.Parameters.AddWithValue("@lic_turistica_nacional", Dept.lic_turistica_nacional);
                cmd.Parameters.AddWithValue("@fecha_factib_tecnica", Dept.fecha_factib_tecnica);
                cmd.Parameters.AddWithValue("@fecha_confor", Dept.fecha_confor);
                cmd.Parameters.AddWithValue("@num_expediente_factib", Dept.num_expediente_factib);
                cmd.Parameters.AddWithValue("@num_expediente_confor", Dept.num_expediente_confor);
                cmd.Parameters.AddWithValue("@nom_proyecto", Dept.nom_proyecto);
                cmd.Parameters.AddWithValue("@tipo_proyecto", Dept.tipo_proyecto);
                cmd.Parameters.AddWithValue("@destino_credito", Dept.destino_credito);
                cmd.Parameters.AddWithValue("@tipo_zona", Dept.tipo_zona);
                cmd.Parameters.AddWithValue("@fecha_protoc", Dept.fecha_protoc);
                cmd.Parameters.AddWithValue("@num_oficio_incentivo", Dept.num_oficio_incentivo);
                cmd.Parameters.AddWithValue("@segmento", Dept.segmento);
                cmd.Parameters.AddWithValue("@estado_ubic_proyecto", Dept.estado_ubic_proyecto);
                cmd.Parameters.AddWithValue("@municip_ubic_proy", Dept.municip_ubic_proy);
                cmd.Parameters.AddWithValue("@ciudad_ubic_proy", Dept.ciudad_ubic_proy);
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void importarCuboDept()
        {
            /* Aqui va el codigo para importar cubos de cliente */
            string path = @"\\ccsnascfp01\Gestion_Global_De_Riesgo\04 GESTION_DE_PROYECTOS\2015\Proyectos Internos 2015\2015_Cartera de Turismo\012. Data\cubo_dept.txt";
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

                        Dept Dept = new Dept();

                        Dept.contrato = campos[0].ToString();
                        Dept.num_rtn = campos[1].ToString();
                        Dept.lic_turistica_nacional = campos[2].ToString();
                        Dept.fecha_factib_tecnica = Convert.ToDateTime(campos[3]);
                        Dept.fecha_confor = Convert.ToDateTime(campos[4]);
                        Dept.num_expediente_factib = campos[5].ToString();
                        Dept.num_expediente_confor = campos[6].ToString();
                        Dept.nom_proyecto = campos[7].ToString();
                        Dept.tipo_proyecto = campos[8].ToString();
                        Dept.destino_credito = campos[9].ToString();
                        Dept.tipo_zona = campos[10].ToString();
                        Dept.fecha_protoc = Convert.ToDateTime(campos[11]);
                        Dept.num_oficio_incentivo = campos[12].ToString();
                        Dept.segmento = campos[13].ToString();
                        Dept.estado_ubic_proyecto = campos[14].ToString();
                        Dept.municip_ubic_proy = campos[15].ToString();
                        Dept.ciudad_ubic_proy = campos[16].ToString();

                        Dept.insertarDEPT(Dept);
                        //TextBox1.Text = TextBox1.Text + linea + "\r\n";

                        // Agregar validacion de return
                    }
                }
            }
        }


    
    }

}