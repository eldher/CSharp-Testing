<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" %>


<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <h2>
        Bievenido al Sistema de Turismo Riesgo Mayorista BBVA
    </h2>
    <p>
        Para saber más de nuestro banco, visite <a href="http://www.provincial.com" title="ASP.NET Website">www.provincial.com</a>.
    </p>
    <p>
        Tambíen puede preguntar <a href="http://go.microsoft.com/fwlink/?LinkID=152368&amp;clcid=0x409"
            title="MSDN ASP.NET Docs">intranet.bbva.com</a>.
    </p>
    <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="Button" />
    <asp:Button ID="btn_GetFiles" runat="server" onclick="getFiles" Text="Ver Archivos" />
    <asp:Button ID="btnCargarData" runat="server" OnClick="cargarData" Text="Cargar Data" />
        <asp:Button ID="btn_CargarClientes" runat="server" onclick="cargarClientes" 
        Text="Cargar PU a SQL" />
        <br />
    <asp:Label ID="Label1" runat="server" Text="      "></asp:Label>
    <br />
    <asp:GridView ID="Grid1D" runat="server"
        AutoGenerateColumns = "true" Font-Names = "Arial"
        Font-Size = "11pt" AlternatingRowStyle-BackColor = "#C2D69B" 
        HeaderStyle-BackColor = "green" Caption = "1-Dimensional Array">
    </asp:GridView>
        <asp:GridView ID="dgv_DataCargada" runat="server"
        AutoGenerateColumns = "true" Font-Names = "Arial"
        Font-Size = "11pt" AlternatingRowStyle-BackColor = "#C2D69B" 
        HeaderStyle-BackColor = "green" Caption = "1-Dimensional Array">
    </asp:GridView>

</asp:Content>
