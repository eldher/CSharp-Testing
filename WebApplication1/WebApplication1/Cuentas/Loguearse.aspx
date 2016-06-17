<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loguearse.aspx.cs" Inherits="WebApplication1.Cuentas.Loguearse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">

<link href="~/Styles/Registro.css" rel="stylesheet" type="text/css" />

<title>Ingresar a la aplicación</title>


</head>
<body>
<div id="header_logo"></div>
    <div id="Login_form">
        <form id="form1" runat="server">

        <label>Usuario</label><br />
        <asp:TextBox runat="server" ID="username" CssClass="frmText"></asp:TextBox><br />

        <label>Contraseña</label><br />
        <asp:TextBox runat="server" ID="pass" TextMode="password" CssClass="frmText"></asp:TextBox><br />       
       
        <asp:Button runat="server" ID="login" Text="Enviar" onclick="login_Click"></asp:Button><br />
        <asp:Button runat="server" ID="btnRegister" Text="Registrarse" onclick="btnRegister_Click"></asp:Button><br />
        </form>
    </div>
</body>
</html>
