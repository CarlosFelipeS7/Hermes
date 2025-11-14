<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Variáveis para mensagens e valores preenchidos
    String mensagem = "";
    String email = "";
    String tipoMensagem = "";
    
    // Verificar se há mensagens do servlet
    if (request.getAttribute("mensagem") != null) {
        mensagem = (String) request.getAttribute("mensagem");
        tipoMensagem = (String) request.getAttribute("tipoMensagem");
        email = (String) request.getAttribute("email");
    }
    
    // Verificar cookie "Lembrar de mim" (apenas se não veio do servlet)
    if (email == null || email.isEmpty()) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("usuarioEmail".equals(cookie.getName())) {
                    email = cookie.getValue();
                    break;
                }
            }
        }
    }
    
    // Garantir que email não seja null
    if (email == null) {
        email = "";
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Hermes Sistema de Fretes</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="login-body">
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="floating-element element-1"></div>
        <div class="floating-element element-2"></div>
        <div class="floating-element element-3"></div>
        <div class="floating-element element-4"></div>
    </div>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="login-logo">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="nav-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/LogoOficial.png"
                             alt="Logo Hermes"
                             class="logo-img">
                    </a>
                </div>


                
                <h1 class="login-title">Bem-vindo</h1>
                <p class="login-subtitle">Entre em sua conta para continuar</p>
            </div>
            
            <% if (!mensagem.isEmpty()) { %>
                <div class="message <%= tipoMensagem %> animated-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= mensagem %></span>
                </div>
            <% } %>
            
            <!-- ⚡ MUDANÇA AQUI: Agora aponta para o Servlet -->
   <form class="login-form" method="POST" action="${pageContext.request.contextPath}/LoginServlet">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group floating animated-input" data-delay="100">
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-input" 
                        placeholder=" "
                        value="<%= email %>"
                        required
                    >
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i>
                        E-mail
                    </label>
                    <div class="input-focus-line"></div>
                </div>
                
                <div class="form-group floating animated-input" data-delay="200">
                    <input 
                        type="password" 
                        id="senha" 
                        name="senha" 
                        class="form-input" 
                        placeholder=" "
                        required
                    >
                    <label for="senha" class="form-label">
                        <i class="fas fa-lock"></i>
                        Senha
                    </label>
                    <button type="button" class="password-toggle" aria-label="Mostrar senha">
                        <i class="fas fa-eye"></i>
                    </button>
                    <div class="input-focus-line"></div>
                </div>
                
                
                <div class="form-options animated-input" data-delay="300">
                    <label class="checkbox-container">
                        <input type="checkbox" name="lembrar" <%= email.isEmpty() ? "" : "checked" %>>
                        <span class="checkmark"></span>
                        Lembrar de mim
                    </label>
                    <a href="recuperar-senha.jsp" class="forgot-password">Esqueci minha senha</a>
                </div>
                
                <button type="submit" class="btn-login animated-input" data-delay="400">
                    <span class="btn-text">Entrar</span>
                    <div class="btn-loader"></div>
                    <i class="fas fa-sign-in-alt btn-icon"></i>
                    <div class="btn-shine"></div>
                </button>
                        
                <div class="register-button animated-input" data-delay="500">
                    <p>Não possui conta? <a href="${pageContext.request.contextPath}/auth/cadastro/cadastro.jsp">Cadastre-se</a></p>
                </div>        
            </form>
            
            <div class="login-footer animated-input" data-delay="500">
                <p>Voltar para <a href="../../index.jsp">página inicial</a></p>
            </div>
        </div>
    </div>
    
    <script src="../../assets/js/auth.js"></script>
    <script src="../../assets/js/login-animations.js"></script>
</body>

</html>