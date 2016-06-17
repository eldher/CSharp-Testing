<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Importar_cubos.aspx.cs" Inherits="WebApplication1.home.Importar_cubos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<link rel="stylesheet" type="text/css" href="../Styles/reset.css"/>
<link rel="stylesheet" type="text/css" href="../Styles/style.css"/>
<title>Sistema de Seguimiento Cartera Turismo</title>   
</head>

<body>


    <div id="header_logo">
        <div class="header_links">
            <a href="#">Admin</a>
            <a href="#">Sesión</a>
            <a href="../Cuentas/Loguearse.aspx">Salir</a>
        </div>
    </div>   

    <div class="main_wrapper">
    <form id="form1" runat="server">    

     <div class="busquedas">
        <asp:TextBox ID="txtBuscarCliente" runat="server" Width="100px"></asp:TextBox>
        <asp:TextBox ID="txtBuscarNombre" runat="server" Width="300px"></asp:TextBox>        
        <asp:TextBox ID="txtBuscarLinea" runat="server" Width="160px"></asp:TextBox>
        <asp:TextBox ID="txtBuscarContrato" runat="server" Width="160px"></asp:TextBox>
        <asp:Button ID="btnBuscarPorContrato" runat="server" onclick="btnBuscarPorContrato_Click"  Text="Buscar"/></asp:Button>
    </div>


    <div id="importar-cubos">
    
        <asp:Button ID="btn_ImportarCubos" runat="server" Text="Importar Cubo Cliente" 
            onclick="btn_ImportarCubos_Click" />

        <asp:Button ID="btnImportarCuboContratos" runat="server" Text="Importar Cubo Contratos" 
            onclick="btnImportarCuboContratos_Click" />
    
        <asp:Button ID="btnImportarCuboLC" runat="server" Text="Importar Cubo LC" 
            onclick="btnImportarCuboLC_Click" />

        <asp:Button ID="btnImportarCuboMadres" runat="server" Text="Importar Cubo Madres" 
            onclick="btnImportarCuboMadres_Click" />
        
        <asp:Button ID="btnImportarFT" runat="server" Text="Importar Cubo Ficha Tec." 
            onclick="btnImportarFT_Click" />

        <asp:Button ID="btnImportarDEPT" runat="server" Text="Importar Detalle Proyectos" 
            onclick="btnImportarDEPT_Click" />

        <asp:Button ID="btnImportarSubprod" runat="server" Text="Importar Subproductos" 
            onclick="btnImportarSubprod_Click" />
  
        <asp:Button ID="btnBorrarTablas" runat="server" Text="Borrar Tablas" 
            onclick="btnBorrarTablas_Click" />    
  
    </div>  

        <table class="table-header" width="972px" border="1" bgcolor="#ffffff">
            <tr>
                <td width="9%">Número Cliente</td>
                <td width="38%">Nombre Cliente</td>
                <td width="18%">Nro. Linea</td>
                <td width="10%">Fecha Vencimiento</td>
                <td width="10%">Linea Creada</td>
            </tr>
        </table>        

        <div class="central" id="wide">        
        <asp:GridView ID="GridView1" runat="server" ViewStateMode="Enabled" onrowdatabound="GridView1_RowDataBound" ShowHeader="False"></asp:GridView>
        </div>
    </form>
</div>
</body>
</html>
