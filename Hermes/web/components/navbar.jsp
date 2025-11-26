<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String base = request.getContextPath();
    String nomeUsuario = (String) session.getAttribute("usuarioNome");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");
    
    // Contar notificações não lidas - COM TRY/CATCH SEGURO
    int notificacoesNaoLidas = 0;
    if (nomeUsuario != null) {
        try {
            br.com.hermes.dao.NotificacaoDAO notifDAO = new br.com.hermes.dao.NotificacaoDAO();
            Integer usuarioId = (Integer) session.getAttribute("usuarioId");
            if (usuarioId != null) {
                notificacoesNaoLidas = notifDAO.contarNaoLidas(usuarioId);
            }
        } catch (Exception e) {
            // Silencioso - não quebrar a navbar se houver erro
            System.out.println("Erro ao contar notificações: " + e.getMessage());
            notificacoesNaoLidas = 0;
        }
    }
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
    
    <!-- Favicon Hermes -->
    <link rel="apple-touch-icon" sizes="180x180" 
          href="${pageContext.request.contextPath}/assets/favicon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" 
          href="${pageContext.request.contextPath}/assets/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" 
          href="${pageContext.request.contextPath}/assets/favicon/favicon-16x16.png">
    <link rel="shortcut icon" 
          href="${pageContext.request.contextPath}/assets/favicon/favicon.ico" type="image/x-icon">
    <link rel="manifest" 
          href="${pageContext.request.contextPath}/assets/favicon/site.webmanifest">

    
</head>

<nav class="navbar">
    <div class="nav-container">
        <a href="<%= base %>/index.jsp" class="nav-logo">
            <img src="<%= base %>/assets/images/LogoOficial.png" alt="Logo Hermes" class="logo-img">
            <span>HERMES</span>
        </a>

        <div class="nav-menu">
            <% if (nomeUsuario == null) { %>
                <!-- Menu para usuários não logados -->
                <a href="<%= base %>/index.jsp#features" class="nav-link">Como Funciona</a>
                <a href="<%= base %>/index.jsp#benefits" class="nav-link">Vantagens</a>
                <a href="<%= base %>/index.jsp#pricing" class="nav-link">Planos</a>
                <a href="<%= base %>/auth/login/login.jsp" class="nav-join">
                    <i class="fa-solid fa-user"></i> Entrar
                </a>
                <a href="<%= base %>/auth/cadastro/cadastro.jsp" class="nav-link btn-nav">Cadastrar</a>

            <% } else { %>
                <!-- Menu para usuários logados -->
                <% if ("cliente".equalsIgnoreCase(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboard/clientes/clientes.jsp" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i> Painel
                    </a>
                    <a href="<%= base %>/fretes/solicitarFretes.jsp" class="nav-link">
                        <i class="fas fa-plus-circle"></i> Solicitar Frete
                    </a>
                    <a href="<%= base %>/FreteListarServlet" class="nav-link">
                        <i class="fas fa-list"></i> Meus Fretes
                    </a>
                <% } else if ("transportador".equalsIgnoreCase(tipoUsuario)) { %>
                    <a href="<%= base %>/dashboardTransportador" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i> Painel
                    </a>
                    <a href="<%= base %>/FreteListarServlet" class="nav-link">
                        <i class="fas fa-truck-loading"></i> Fretes Disponíveis
                    </a>
                    <a href="<%= base %>/fretes/listaFretesTransportador.jsp" class="nav-link">
                        <i class="fas fa-search"></i> Buscar Fretes
                    </a>
                <% } %>

                <div class="user-menu">
                    <!-- Ícone de Notificações -->
                    <a href="<%= base %>/NotificacaoServlet" class="notification-link" title="Notificações">
                        <i class="fas fa-bell"></i>
                        <% if (notificacoesNaoLidas > 0) { %>
                            <span class="notification-badge">
                                <%= notificacoesNaoLidas > 9 ? "9+" : notificacoesNaoLidas %>
                            </span>
                        <% } %>
                    </a>

                    <!-- Perfil do Usuário -->
                    <a href="<%= base %>/PerfilServlet" class="user-name perfil-link" title="Meu Perfil">
                        <i class="fas fa-user-circle"></i>
                        <span class="user-name-text">
                            <%= nomeUsuario.length() > 15 ? nomeUsuario.substring(0, 15) + "..." : nomeUsuario %>
                        </span>
                    </a>

                    <!-- Botão Sair -->
                    <a href="<%= base %>/LogoutServlet" class="nav-link btn-nav logout-btn" title="Sair">
                        <i class="fas fa-sign-out-alt"></i> 
                        <span class="logout-text">Sair</span>
                    </a>
                </div>
            <% } %>
        </div>
        
        <!-- Menu Mobile -->
        <div class="nav-toggle" id="navToggle">
            <span class="bar"></span>
            <span class="bar"></span>
            <span class="bar"></span>
        </div>
    </div>
</nav>

<script>
    // Menu mobile toggle
    document.addEventListener('DOMContentLoaded', function() {
        const navToggle = document.getElementById('navToggle');
        const navMenu = document.querySelector('.nav-menu');
        
        if (navToggle && navMenu) {
            navToggle.addEventListener('click', function() {
                navMenu.classList.toggle('active');
                navToggle.classList.toggle('active');
            });
        }
        
        // Fechar menu ao clicar em um link (mobile)
        const navLinks = document.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                navMenu.classList.remove('active');
                navToggle.classList.remove('active');
            });
        });
        
        // Fechar menu ao clicar fora (mobile)
        document.addEventListener('click', function(event) {
            if (navMenu && navMenu.classList.contains('active') && 
                !navMenu.contains(event.target) && 
                !navToggle.contains(event.target)) {
                navMenu.classList.remove('active');
                navToggle.classList.remove('active');
            }
        });
    });
</script>