<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detalle_linea.aspx.cs" Inherits="WebApplication1.home.detalle_linea" %>
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
    <li><a href="#" onclick="alert('Debe seleccionar una Disposición')" >Datos Espec. Proyecto</a></li>
    <!--<li><a href="detalle_proyecto.aspx">Datos Espec. Proyecto</a></li> -->
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
            <asp:Label ID="Label24" runat="server" Text="Fecha Venc."></asp:Label>          <asp:TextBox ID="txt_fecha_vencimiento" runat="server"></asp:TextBox>
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
    <asp:GridView ID="GridView2" runat="server" onrowdatabound="GridView2_RowDataBound"  ShowHeader="False" SelectedRowStyle-BackColor="#66CCFF"></asp:GridView>
</div>

<div id="panel_izq">
    <div class="sub_panel_izq">
        <h1>Uso de la Línea de Crédito</h1>
        <asp:Label ID="Label13" runat="server" Text="Dispuesto Construcción"></asp:Label>   <asp:TextBox ID="txtDispuestoConstruccion" runat="server"></asp:TextBox>
        <asp:Label ID="Label14" runat="server" Text="Dispuesto Ampliación"></asp:Label>     <asp:TextBox ID="txtDispuestoAmpliacion" runat="server"></asp:TextBox>
        <asp:Label ID="Label15" runat="server" Text="Dispuesto Equipamiento"></asp:Label>   <asp:TextBox ID="txtDispuestoEquipamiento" runat="server"></asp:TextBox>
        <asp:Label ID="Label16" runat="server" Text="Dispuesto Adquisición"></asp:Label>    <asp:TextBox ID="txtDispuestoAdquisición" runat="server"></asp:TextBox>
        <asp:Label ID="Label17" runat="server" Text="Dispuesto Otros"></asp:Label>          <asp:TextBox ID="txtDispuestoOtros" runat="server"></asp:TextBox>
        <asp:Label ID="Label18" runat="server" Text="Dispuesto Acumulado"></asp:Label>      <asp:TextBox ID="txtDispuestoAcumulado" runat="server"></asp:TextBox>      
    </div>

    <div class="sub_panel_izq">
        <h1>Aumentos/Anticipos sobre la LC</h1>
        <asp:Label ID="Label19" runat="server" Text="Cantidad Ampliaciones"></asp:Label>    <asp:TextBox ID="TextBox7" runat="server"></asp:TextBox>
        <asp:Label ID="Label20" runat="server" Text="Última Ampliación"></asp:Label>        <asp:TextBox ID="TextBox8" runat="server"></asp:TextBox>
        <asp:Label ID="Label21" runat="server" Text="Cantidad Anticipos"></asp:Label>       <asp:TextBox ID="TextBox9" runat="server"></asp:TextBox>
        <asp:Label ID="Label22" runat="server" Text="Bs. Ampliaciones"></asp:Label>         <asp:TextBox ID="TextBox10" runat="server"></asp:TextBox>
        <asp:Label ID="Label23" runat="server" Text="Bs. Anticipos"></asp:Label>            <asp:TextBox ID="TextBox11" runat="server"></asp:TextBox>   
    </div>

</div>


    </form>
</body>
</html>