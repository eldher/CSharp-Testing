<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="WebApplication1.Cuentas.Registro" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registro de Usuario</title>
    <!--<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.6.0/pure-min.css" type="text/css"/> -->
    <link href="~/Styles/Registro.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function confirm_registry() {
            alert("Usuario Registrado con éxito !!");
            window.location.replace("../Cuentas/Loguearse.aspx");
        }
    </script>

</head>
<body>
<div id="header_logo"></div>

<div id="Registration_form">
    <form id="form1" runat="server">    
    <%--<label>Usuario</label><br />--%>
    <asp:Textbox runat="server" ID="username" CssClass="frmText"  ></asp:Textbox><br />

    <%--<label>Nombre Usuario</label><br />--%>
    <asp:Textbox runat="server" ID="fullname" CssClass="frmText"  ></asp:Textbox><br />

   <%-- <label>Contraseña</label><br />--%>
    <asp:Textbox runat="server" ID="pass" CssClass="frmText"  TextMode="password" ></asp:Textbox><br />

    <%--<label>Repita su Contraseña</label><br />--%>
    <asp:Textbox runat="server" ID="pass_repeat" CssClass="frmText"  TextMode="password" ></asp:Textbox><br />
    
    <%--<label>Email</label><br />--%>
    <asp:Textbox runat="server" ID="email" CssClass="frmText"  ></asp:Textbox><br />

    <%--<label>Pregunta Seguridad</label><br />--%>
    <asp:Textbox runat="server" ID="question" CssClass="frmText"  ></asp:Textbox><br />

    <%--<label>Respuesta</label><br />--%>
    <asp:Textbox runat="server" ID="answer" CssClass="frmText"  ></asp:Textbox><br />
    
    <asp:Button runat="server" ID="submit" Text="Guardar" onclick="submit_Click"></asp:Button><br />

    </form>
</div>
</body>
</html>
