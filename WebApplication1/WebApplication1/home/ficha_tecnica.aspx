<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ficha_tecnica.aspx.cs" Inherits="WebApplication1.home.ficha_tecnica" %>

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
    <!--<li><a href="detalle_contrato.aspx">Detalle Contrato</a></li>  -->    
    
    <li><a href="#" onclick="alert('Debe seleccionar una Disposición')" >Datos Espec. Proyecto</a></li>
    <!--<li><a href="<%= this.ResolveUrl("./detalle_proyecto.aspx?contrato=" + contrato+"&linea="+linea)%>">Datos Espec. Proyecto</a></li> -->
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
            <asp:Label ID="Label24" runat="server" Text="Fecha Venc."></asp:Label>          <asp:TextBox ID="txt_fecha_vencimiento" runat="server"></asp:TextBox>
            <asp:Label ID="Label4" runat="server" Text="Calific. Subjetiva"></asp:Label>    <asp:TextBox ID="txt_calificacion_subjetiva" runat="server"></asp:TextBox>
            <asp:Label ID="Label10" runat="server" Text="Subproducto"></asp:Label>          <asp:TextBox ID="txt_subproducto" runat="server"></asp:TextBox>            
          <!--  <asp:Label ID="Label12" runat="server" Text="Covenant"></asp:Label>             <asp:TextBox ID="txt_covenant" runat="server"></asp:TextBox> -->
        </div>
    </div>
</div>




<div class="contenedor_ficha_tecnica">

    <div class="caja_ficha_tecnica">
        <h1>Datos Adicionales</h1>
        <asp:Label ID="Label126" runat="server" Text="Operador Hotelero"></asp:Label>           <asp:TextBox ID="txt_operador_hotelero" runat="server"></asp:TextBox>
        <asp:Label ID="Label20" runat="server" Text="Ingeniero Inspector"></asp:Label>          <asp:TextBox ID="txt_ing_inspector" runat="server"></asp:TextBox>
        <asp:Label ID="Label21" runat="server" Text="Ingeniero Residente"></asp:Label>          <asp:TextBox ID="txt_ing_residente" runat="server"></asp:TextBox>
        <asp:Label ID="Label22" runat="server" Text="Categoria del Hotel"></asp:Label>          <asp:TextBox ID="txt_categoria_hotel" runat="server"></asp:TextBox>
        <asp:Label ID="Label31" runat="server" Text="Nro. Habitaciones"></asp:Label>            <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>  
        <asp:Label ID="Label121" runat="server" Text="Ubicacion Geográfica"></asp:Label>         <asp:TextBox ID="TextBox10" runat="server"></asp:TextBox>
    </div>

    <div class="caja_ficha_tecnica">
        <h1>Hoteles o Posadas en Fase de Construcción</h1>
        <asp:Label ID="Label125" runat="server" Text="% Ocupación Estimada"></asp:Label>                <asp:TextBox ID="txt_porc_ocupacion_proyectado" runat="server"></asp:TextBox>
        <asp:Label ID="Label27" runat="server" Text="Precio Estimado"></asp:Label>                      <asp:TextBox ID="txt_precio_estimado" runat="server"></asp:TextBox>
        <asp:Label ID="Label28" runat="server" Text="Fecha Elaboración"></asp:Label>                    <asp:TextBox ID="txt_fecha_elaboracion" runat="server"></asp:TextBox>
        <asp:Label ID="Label29" runat="server" Text="% Ocupación FENAHOVEN"></asp:Label>                <asp:TextBox ID="txt_porc_ocupacion_fenahoven" runat="server"></asp:TextBox>
        <asp:Label ID="Label30" runat="server" Text="Precio Promedio Hab. Hotel Zona"></asp:Label>      <asp:TextBox ID="txt_precio_promedio_x_hab" runat="server"></asp:TextBox>
    </div>

    <div class="caja_ficha_tecnica">
        <h1>Hoteles o Posadas Operativos</h1>
        <asp:Label ID="Label37" runat="server" Text="% Ocupación Real"></asp:Label>                     <asp:TextBox ID="txt_porc_ocupacion_real" runat="server"></asp:TextBox>
        <asp:Label ID="Label38" runat="server" Text="Precio de la Habitación"></asp:Label>              <asp:TextBox ID="txt_precio_hab" runat="server"></asp:TextBox>
        <asp:Label ID="Label39" runat="server" Text="Fecha Última Actualización"></asp:Label>           <asp:TextBox ID="txt_fecha_actualiz_ocupacion" runat="server"></asp:TextBox>
        <asp:Label ID="Label40" runat="server" Text="Exceso / Deficit Ocupación"></asp:Label>           <asp:TextBox ID="TextBox24" runat="server"></asp:TextBox>      
    </div>  


    <div class="caja_ficha_tecnica">
        <h1>Situación Actual</h1>
        <asp:Label ID="Label123" runat="server" Text="Desfase de Obra"></asp:Label>   <asp:TextBox ID="TextBox6" runat="server"></asp:TextBox>
        <asp:Label ID="Label23" runat="server" Text="Atraso Valuación"></asp:Label>     <asp:TextBox ID="TextBox7" runat="server"></asp:TextBox>
        <asp:Label ID="Label25" runat="server" Text="Mes Última Visita"></asp:Label>   <asp:TextBox ID="TextBox8" runat="server"></asp:TextBox>
        <asp:Label ID="Label26" runat="server" Text="Último Cierre"></asp:Label>    <asp:TextBox ID="TextBox9" runat="server"></asp:TextBox>        
    </div>

    
    <div class="caja_ficha_tecnica">
        <h1>Datos Técnicos del Proyecto</h1>
        <asp:Label ID="Label13" runat="server" Text="Presup. Contruc. Incio"></asp:Label>               <asp:TextBox ID="txt_presu_contruc_inicial" runat="server"></asp:TextBox>
        <asp:Label ID="Label14" runat="server" Text="Presup. Contruc. Fin"></asp:Label>                 <asp:TextBox ID="txt_presu_contruc_final" runat="server"></asp:TextBox>
        <asp:Label ID="Label15" runat="server" Text="% Obra proyectado"></asp:Label>                    <asp:TextBox ID="txt_porc_obra_proyectado" runat="server"></asp:TextBox>
        <asp:Label ID="Label16" runat="server" Text="% Obra ejecutado"></asp:Label>                     <asp:TextBox ID="txt_porc_obra_ejecutado" runat="server"></asp:TextBox>
        <asp:Label ID="Label17" runat="server" Text="% Obra valuado"></asp:Label>                       <asp:TextBox ID="txt_porc_obra_valuada" runat="server"></asp:TextBox>
        <asp:Label ID="Label129" runat="server" Text="Fecha Ult. Valuac."></asp:Label>                  <asp:TextBox ID="txt_fecha_ult_valuacion" runat="server"></asp:TextBox>
        <asp:Label ID="Label18" runat="server" Text="Fecha Ult. Visita"></asp:Label>                    <asp:TextBox ID="txt_fecha_ult_visita" runat="server"></asp:TextBox>
        <asp:Label ID="Label19" runat="server" Text="Venc. Plazo Construc."></asp:Label>                <asp:TextBox ID="txt_fecha_venc_construcccion" runat="server"></asp:TextBox>     
    </div>

    <div class="caja_ficha_tecnica">
        
    
        <asp:Button ID="btnModificar" runat="server" Text="Modificar" />
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
        
    
    </div>

</div>



    </form>
</body>
</html>
