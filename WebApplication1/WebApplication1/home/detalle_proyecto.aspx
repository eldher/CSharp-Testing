<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detalle_proyecto.aspx.cs" Inherits="WebApplication1.home.detalle_proyecto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<link rel="stylesheet" type="text/css" href="../Styles/reset.css"/>
<link rel="stylesheet" type="text/css" href="../Styles/style.css"/>
<title>Datos Específicos del Proyecto</title>
</head>

<body>
<div id="header_logo"></div>

<div class="barra-navegacion">
<ul>
    <li><a href="importar_cubos.aspx">Inicio</a></li>      
    <li><a href="detalle_linea.aspx">Detalle Linea</a></li> 
    <li><a href="<%= this.ResolveUrl("./detalle_proyecto.aspx?contrato=" + contrato+"&linea="+linea)%>">Datos Espec. Proyecto</a></li>
    <li><a href="<%= this.ResolveUrl("./ficha_tecnica.aspx?contrato=" + contrato+"&linea="+linea)%>">Ficha Técnica</a></li>
    
    <li class="construccion"><a href="#" onclick="alert('En contrucción')">Aumentos o Anticipos sobre la LC</a></li>
    <li class="construccion"><a href="#" onclick="alert('En contrucción')">Datos del seguro</a></li>
    <li class="construccion"><a href="#" onclick="alert('En contrucción')">Resumen Ejecutivo</a></li>
    <li class="construccion"><a href="#" onclick="alert('En contrucción')">Observaciones</a></li>
    <li class="construccion"><a href="#" onclick="alert('En contrucción')">Alertas</a></li>
</ul>
</div>



    <form id="form1" runat="server">
    <div id="contenedor-superior">
    <div class="info_container">
        <div class="info_head">
            <asp:Label ID="Label1" runat="server" Text="Cliente"></asp:Label>               <asp:TextBox ID="txt_cliente" runat="server"></asp:TextBox>            
            <asp:Label ID="Label5" runat="server" Text="Nombre"></asp:Label>                <asp:TextBox ID="txt_nom_cliente" runat="server"></asp:TextBox>            
            <asp:Label ID="Label2" runat="server" Text="C.I./RIF"></asp:Label>              <asp:TextBox ID="txt_cedula_rif" runat="server"></asp:TextBox>
            <asp:Label ID="Label9" runat="server" Text="Grupo"></asp:Label>                 <asp:TextBox ID="txt_nom_grupo" runat="server"></asp:TextBox>            
        </div>
    </div>


    <div class="info_container">
        <div class="info_head">
            
            <asp:Label ID="Label8" runat="server" Text="Proyecto"></asp:Label>              <asp:TextBox ID="txt_nombre_del_proyecto" runat="server"></asp:TextBox>
            <asp:Label ID="Label6" runat="server" Text="Contrato"></asp:Label>              <asp:TextBox ID="txt_contrato_madre" runat="server"></asp:TextBox>
            <asp:Label ID="Label3" runat="server" Text="Monto Concedido"></asp:Label>       <asp:TextBox ID="txt_concedido_original_autoriz" runat="server"></asp:TextBox>
            <asp:Label ID="Label11" runat="server" Text="Oficina"></asp:Label>              <asp:TextBox ID="txt_cod_oficina" runat="server"></asp:TextBox>

        </div>
    </div>

       <div class="info_container">
        <div class="info_head">
            <asp:Label ID="Label7" runat="server" Text="Fecha Otorg."></asp:Label>          <asp:TextBox ID="txt_fecha_otorgamiento" runat="server"></asp:TextBox>
            <asp:Label ID="Label24" runat="server" Text="Fecha Venc."></asp:Label>           <asp:TextBox ID="txt_fecha_vencimiento" runat="server"></asp:TextBox>
            <asp:Label ID="Label4" runat="server" Text="Calific. Subjetiva"></asp:Label>    <asp:TextBox ID="txt_calificacion_subjetiva" runat="server"></asp:TextBox>
            <asp:Label ID="Label10" runat="server" Text="Subproducto"></asp:Label>          <asp:TextBox ID="txt_subproducto" runat="server"></asp:TextBox>            
          <!--  <asp:Label ID="Label12" runat="server" Text="Covenant"></asp:Label>             <asp:TextBox ID="txt_covenant" runat="server"></asp:TextBox> -->
        </div>
    </div>
</div>


<table class="table-header" width="825px" border="1" bgcolor="#ffffff">
    <tr>
        <td width="13%">Disposiciones</td>
        <td width="8%">Subproducto</td>
        <td width="9%">Destino</td>
        <td width="13%">Concedido</td>
        <td width="15%">Saldo Actual</td>
    </tr>
</table> 


 <div class="central" id="mid">
    <asp:GridView ID="GridView2" runat="server" onrowdatabound="GridView2_RowDataBound" ShowHeader="false"></asp:GridView>    
</div>




<div id="panel_izq">
    <div class="sub_panel_izq">
        <h1>Datos del Proyecto</h1>
        <asp:Label ID="Label13" runat="server" Text="Tipo de Proyecto"></asp:Label>                     <asp:TextBox ID="txt_tipo_proyecto" runat="server"></asp:TextBox>
        <asp:Label ID="Label14" runat="server" Text="Zona"></asp:Label>                                 <asp:TextBox ID="txt_tipo_zona" runat="server"></asp:TextBox>
        <asp:Label ID="Label15" runat="server" Text="Segmento"></asp:Label>                             <asp:TextBox ID="txt_segmento" runat="server"></asp:TextBox>
        <asp:Label ID="Label16" runat="server" Text="Número de RTN"></asp:Label>                        <asp:TextBox ID="txt_num_rtn" runat="server"></asp:TextBox>
        <asp:Label ID="Label17" runat="server" Text="Licencia Turística Nacional"></asp:Label>          <asp:TextBox ID="txt_lic_turistica_nacional" runat="server"></asp:TextBox>
        <asp:Label ID="Label18" runat="server" Text="Expediente Factibildad"></asp:Label>               <asp:TextBox ID="txt_num_expediente_factib" runat="server"></asp:TextBox> 
        <asp:Label ID="Label121" runat="server" Text="Expediente Conformidad"></asp:Label>              <asp:TextBox ID="txt_num_expediente_confor" runat="server"></asp:TextBox>
        <asp:Label ID="Label19" runat="server" Text="Oficio Incentivo"></asp:Label>                     <asp:TextBox ID="txt_num_oficio_incentivo" runat="server"></asp:TextBox>     
        <asp:Label ID="Label20" runat="server" Text="Fecha Factibilidad Técnica"></asp:Label>           <asp:TextBox ID="txt_fecha_factib_tecnica" runat="server"></asp:TextBox>     
        <asp:Label ID="Label21" runat="server" Text="Fecha Conformidad"></asp:Label>                    <asp:TextBox ID="txt_fecha_confor" runat="server"></asp:TextBox>     
        <asp:Label ID="Label22" runat="server" Text="Fecha Protocolización"></asp:Label>                <asp:TextBox ID="txt_fecha_protoc" runat="server"></asp:TextBox>     
    </div>

        <div class="sub_panel_izq">
        <h1>Identidad del Proyecto</h1>
        <asp:Label ID="Label128" runat="server" Text="Nombre del Proyecto"></asp:Label>   <asp:TextBox ID="txt_nom_proyecto" runat="server"></asp:TextBox>
        <asp:Label ID="Label23" runat="server" Text="Ubicación Geográfica"></asp:Label>   <asp:TextBox ID="txt_estado_ubic_proyecto" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
    </div>


</div>


    </form>
</body>
</html>
