<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String base = request.getContextPath();

    // Verifica se há usuário logado
    String nomeUsuario = (String) session.getAttribute("usuarioNome");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");
%>

<nav class="navbar">
    <div class="nav-container">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
        <a href="<%= base %>/index.jsp" class="nav-logo">
            <i class="fas fa-shipping-fast"></i>
            <span>HERMES</span>
        </a>

        <div class="nav-menu">
            <% if (nomeUsuario == null) { %>
                <!-- 🔹 Navbar para visitantes -->
                <a href="<%= base %>/index.jsp#features" class="nav-link">Como Funciona</a>
                <a href="<%= base %>/index.jsp#benefits" class="nav-link">Vantagens</a>
                <a href="<%= base %>/index.jsp#pricing" class="nav-link">Planos</a>
                <a href="<%= base %>/auth/login/login.jsp" class="nav-join">
                    <i class="fa-solid fa-user"></i> Entrar
                </a>
                <a href="<%= base %>/auth/cadastro/cadastro.jsp" class="nav-link btn-nav">Cadastrar</a>
            <% } else { %>
                <!-- 🔹 Navbar para usuários logados -->
                <% if ("cliente".equals(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboard/clientes/clientes.jsp" class="nav-link">Painel do Cliente</a>
                <% } else if ("transportador".equals(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboard/transportador/transportador.jsp" class="nav-link">Painel do Transportador</a>
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

        <!-- Menu Mobile -->
        <div class="hamburger">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</nav>
