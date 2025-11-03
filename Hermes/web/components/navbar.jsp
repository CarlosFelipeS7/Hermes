<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String base = request.getContextPath();
%>

<nav class="navbar">
    <div class="nav-container">
        <a href=" <%= base %>/index.jsp" class="nav-logo">
            <i class="fas fa-shipping-fast"></i>
            <span>HERMES</span>
        </a>

        <div class="nav-menu">
            <a href="../index.jsp#features" class="nav-link">Como Funciona</a>
            <a href="../index.jsp#benefits" class="nav-link">Vantagens</a>
            <a href="../index.jsp#pricing" class="nav-link">Planos</a>
            <a href="<%= base %>/auth/login/login.jsp" class="nav-join">
                <i class="fa-solid fa-user" ></i> Entrar
            </a>
            <a href="<%= base %>/auth/cadastro/cadastro.jsp" class="nav-link btn-nav">Cadastrar</a>
        </div>

        <!-- Menu Mobile -->
        <div class="hamburger">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</nav>
