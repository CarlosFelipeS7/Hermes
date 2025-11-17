<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String base = request.getContextPath();
    String nomeUsuario = (String) session.getAttribute("usuarioNome");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");
%>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= base %>/index.jsp" class="nav-logo">
            <img src="<%= base %>/assets/images/LogoOficial.png" alt="Logo Hermes" class="logo-img">
            <span>HERMES</span>
        </a>

        <div class="nav-menu">
            <% if (nomeUsuario == null) { %>
                <a href="<%= base %>/index.jsp#features" class="nav-link">Como Funciona</a>
                <a href="<%= base %>/index.jsp#benefits" class="nav-link">Vantagens</a>
                <a href="<%= base %>/index.jsp#pricing" class="nav-link">Planos</a>
                <a href="<%= base %>/auth/login/login.jsp" class="nav-join">
                    <i class="fa-solid fa-user"></i> Entrar
                </a>
                <a href="<%= base %>/auth/cadastro/cadastro.jsp" class="nav-link btn-nav">Cadastrar</a>

            <% } else { %>

                <% if ("cliente".equals(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboard/clientes/clientes.jsp" class="nav-link">Painel do Cliente</a>
                <% } else if ("transportador".equals(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboardTransportador" class="nav-link">Painel do Transportador</a>
                <% } %>

                <div class="user-menu">
                    <span class="user-name">
                        <i class="fas fa-user-circle"></i>
                        <%= nomeUsuario %>
                    </span>
                    <a href="<%= base %>/LogoutServlet" class="nav-link btn-nav logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Sair
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</nav>
