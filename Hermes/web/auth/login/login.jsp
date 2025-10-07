<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Variáveis para mensagens e valores preenchidos
    String mensagem = "";
    String email = "";
    String tipoMensagem = "";
    
    // Processar formulário se foi submetido
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String lembrar = request.getParameter("lembrar");
        
        // Validação básica
        if (email == null || email.trim().isEmpty() || 
            senha == null || senha.trim().isEmpty()) {
            mensagem = "Por favor, preencha todos os campos.";
            tipoMensagem = "error";
        } else {
            try {
                // Conexão com banco de dados - AJUSTE SUAS CREDENCIAIS
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/hermes_db", "usuario", "senha");
                
                // Verificar credenciais
                String sql = "SELECT id, nome, tipo_usuario FROM usuarios WHERE email = ? AND senha = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                stmt.setString(2, senha); // Na prática, use hash!
                
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    // Login bem-sucedido
                    session.setAttribute("usuarioId", rs.getInt("id"));
                    session.setAttribute("usuarioNome", rs.getString("nome"));
                    session.setAttribute("usuarioTipo", rs.getString("tipo_usuario"));
                    session.setAttribute("usuarioEmail", email);
                    
                    // Cookie "Lembrar de mim"
                    if ("on".equals(lembrar)) {
                        Cookie emailCookie = new Cookie("usuarioEmail", email);
                        emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 dias
                        response.addCookie(emailCookie);
                    }
                    
                    // Redirecionar baseado no tipo de usuário
                    String tipoUsuario = rs.getString("tipo_usuario");
                    if ("cliente".equals(tipoUsuario)) {
                        response.sendRedirect("../cliente/dashboard.jsp");
                    } else if ("transportador".equals(tipoUsuario)) {
                        response.sendRedirect("../transportador/dashboard.jsp");
                    } else {
                        response.sendRedirect("../admin/dashboard.jsp");
                    }
                    return;
                    
                } else {
                    mensagem = "E-mail ou senha incorretos.";
                    tipoMensagem = "error";
                }
                
                conn.close();
                
            } catch (Exception e) {
                mensagem = "Erro no sistema. Tente novamente.";
                tipoMensagem = "error";
                e.printStackTrace();
            }
        }
    }
    
    // Verificar cookie "Lembrar de mim"
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("usuarioEmail".equals(cookie.getName())) {
                email = cookie.getValue();
                break;
            }
        }
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
    <link rel="stylesheet" href="../../assets/css/auth.css">
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
                    <i class="fas fa-shipping-fast logo-icon"></i>
                    <span class="logo-text">HERMES</span>
                </div>
                
                <h1 class="login-title">Bem-vindo de volta</h1>
                <p class="login-subtitle">Entre em sua conta para continuar</p>
            </div>
            
            <% if (!mensagem.isEmpty()) { %>
                <div class="message <%= tipoMensagem %> animated-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= mensagem %></span>
                </div>
            <% } %>
            
            <form class="login-form" method="POST" action="login.jsp">
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
            </form>
            
            <div class="login-footer animated-input" data-delay="500">
                <p>Voltar para <a href="../index.jsp">página inicial</a></p>
            </div>
        </div>
    </div>
    
    <script src="../../assets/js/auth.js"></script>
    <script src="../../assets/js/login-animations.js"></script>
</body>
</html>