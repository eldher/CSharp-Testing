<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detalle_contrato.aspx.cs" Inherits="WebApplication1.home.detalle_contrato" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<link rel="stylesheet" type="text/css" href="../Styles/reset.css"/>
<link rel="stylesheet" type="text/css" href="../Styles/style.css"/>
<title>Detalles de Linea de Credito</title>
</head>

<body>
<div id="header_logo"></div>


<div class="barra-navegacion">
<ul>
    <li><a href="importar_cubos.aspx">Inicio</a></li>      
    <li><a href="detalle_linea.aspx">Detalle Linea</a></li> 
    <li><a href="<%= this.ResolveUrl("./detalle_proyecto.aspx?contrato=" + contrato+"&linea="+linea)%>">Datos Espec. Proyecto</a></li>
    <li><a href="<%= this.ResolveUrl("./ficha_tecnica.aspx?linea="+linea)%>">Ficha Técnica</a></li>
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
            <asp:Label ID="Label55" runat="server" Text="Cliente"></asp:Label>              <asp:TextBox ID="txt_cliente" runat="server"></asp:TextBox>            
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
            <asp:Label ID="Label1" runat="server" Text="Fecha Venc."></asp:Label>          <asp:TextBox ID="txt_fecha_vencimiento" runat="server"></asp:TextBox>
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



 <div class="central" id="full">
    <asp:GridView ID="GridView2" runat="server" OnRowDataBound="GridView2_RowDataBound" ShowHeader="false"></asp:GridView>
</div>

<div id="panel_izq">
    <div class="sub_panel_izq">
        <h1>Fechas (Disposición)</h1>
        <asp:Label ID="Label13" runat="server" Text="Desembolso"></asp:Label>       <asp:TextBox ID="txt_fecha_desembolso" runat="server"></asp:TextBox>
        <asp:Label ID="Label14" runat="server" Text="Vencimiento"></asp:Label>      <asp:TextBox ID="txt_fecha_venci_contrato" runat="server"></asp:TextBox>
        <asp:Label ID="Label15" runat="server" Text="Inicio de gracia"></asp:Label> <asp:TextBox ID="txt_fecha_fin_gracia_inicial" runat="server"></asp:TextBox>
        <asp:Label ID="Label16" runat="server" Text="Fin de gracia"></asp:Label>    <asp:TextBox ID="txt_fecha_fin_gracia_actual" runat="server"></asp:TextBox>
        <asp:Label ID="Label17" runat="server" Text="Primera amortiza."></asp:Label><asp:TextBox ID="txt_fecha_primera_amortiz" runat="server"></asp:TextBox>
        <asp:Label ID="Label18" runat="server" Text="Reestructurado"></asp:Label>   <asp:TextBox ID="txt_indicador_reestruc" runat="server"></asp:TextBox>
        <!--<asp:Label ID="Label24" runat="server" Text="Calificación"></asp:Label>     <asp:TextBox ID="TextBox12" runat="server"></asp:TextBox>       -->
        <asp:Label ID="Label25" runat="server" Text="Plazo"></asp:Label>            <asp:TextBox ID="txt_plazo_en_meses" runat="server"></asp:TextBox>
    </div>

    <div class="sub_panel_izq">
        <h1>Deuda (Disposición)</h1>
        <asp:Label ID="Label19" runat="server" Text="Concedido"></asp:Label>                <asp:TextBox ID="txt_importe_liquidado" runat="server"></asp:TextBox>
        <asp:Label ID="Label20" runat="server" Text="Capital Vigente"></asp:Label>          <asp:TextBox ID="txt_cap_x_cobrar_vig" runat="server"></asp:TextBox>
        <asp:Label ID="Label21" runat="server" Text="Capital Vencido"></asp:Label>          <asp:TextBox ID="txt_cap_x_cobrar_ven" runat="server"></asp:TextBox>
        <asp:Label ID="Label22" runat="server" Text="Capital Litigio"></asp:Label>          <asp:TextBox ID="txt_cap_litigio" runat="server"></asp:TextBox>
        <asp:Label ID="Label23" runat="server" Text="Interés Impagado"></asp:Label>         <asp:TextBox ID="txt_monto_interes_x_cobrar" runat="server"></asp:TextBox>
        <asp:Label ID="Label27" runat="server" Text="Total Impago Capital"></asp:Label>     <asp:TextBox ID="txt_total_cap_impa" runat="server"></asp:TextBox>   
        <asp:Label ID="Label26" runat="server" Text="Total Impago Interés"></asp:Label>     <asp:TextBox ID="txt_total_int_impa" runat="server"></asp:TextBox>   
    </div>

</div>


    </form>
</body>
</html>
