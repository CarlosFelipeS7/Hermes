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
    <title>Cadastro - Hermes Sistema de Fretes</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cadastro.css">
</head>

<body class="login-body">
    <% if (request.getAttribute("mensagem") != null) { %>
    <div class="alert-overlay">
        <div class="alert-box <%= request.getAttribute("tipoMensagem") %>">
            <i class="fas <%= "success".equals(request.getAttribute("tipoMensagem")) ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i>
            <span><%= request.getAttribute("mensagem") %></span>
        </div>
    </div>
<% } %>

    <!-- Container principal -->
    <div class="login-container">
        <div class="login-card">
            
            <!-- Cabeçalho -->
            <div class="login-header">
                <div class="login-logo">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="nav-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/LogoOficial.png"
                             alt="Logo Hermes"
                             class="logo-img">
                    </a>
                </div>

                <h1 class="login-title">Crie sua conta</h1>
                <p class="login-subtitle">Preencha os campos abaixo para se cadastrar</p>
            </div>


            <!-- Formulário de cadastro -->
            <form class="login-form" method="POST" action="${pageContext.request.contextPath}/UsuarioServlet">
                
                <!-- Nome -->
                <div class="form-group floating animated-input">
                    <input type="text" id="nome" name="nome" class="form-input" placeholder=" " required>
                    <label for="nome" class="form-label">
                        <i class="fas fa-user"></i>
                        Nome completo
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <!-- E-mail -->
                <div class="form-group floating animated-input">
                    <input type="email" id="email" name="email" class="form-input" placeholder=" " required>
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i>
                        E-mail
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <!-- Senha -->
                <div class="form-group floating animated-input">
                    <input type="password" id="senha" name="senha" class="form-input" placeholder=" " required>
                    <label for="senha" class="form-label">
                        <i class="fas fa-lock"></i>
                        Senha
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <!-- Tipo de usuário -->
                <div class="form-group animated-input">
                    <label class="form-label" style="font-weight:600; color:var(--primary); margin-bottom:0.5rem;">
                        <i class="fas fa-user-tag"></i> Tipo de Usuário
                    </label>

                    <div class="radio-group">
                        <label class="radio-option">
                            <input type="radio" name="tipoUsuario" value="cliente" required onclick="toggleTransportador(false)">
                            <span>Sou Cliente</span>
                        </label>

                        <label class="radio-option">
                            <input type="radio" name="tipoUsuario" value="transportador" required onclick="toggleTransportador(true)">
                            <span>Sou Transportador</span>
                        </label>
                    </div>

                    <!-- Campos adicionais do transportador -->
                    <div id="camposTransportador" class="transportador-bloco">
                        <div class="login-divider"><span>Informações do Transportador</span></div>

                        <div class="form-group floating animated-input">
                            <input type="text" id="documento" name="documento" class="form-input" placeholder=" " oninput="mascararDocumento(this)">
                            <label for="documento" class="form-label">
                            <i class="fas fa-id-card"></i>
                                Documento (CPF ou CNPJ)
                            </label>
                        <div class="input-focus-line"></div>
                    </div>

                        <div class="form-group floating animated-input">
                            <input type="text" id="veiculo" name="veiculo" class="form-input" placeholder=" ">
                            <label for="veiculo" class="form-label">
                                <i class="fas fa-truck"></i>
                                Tipo de Veículo
                            </label>
                            <div class="input-focus-line"></div>
                        </div>
                    </div>
                </div>

                <!-- Telefone -->
                <div class="form-group floating animated-input">
                    <input type="text" id="telefone" name="telefone" class="form-input" placeholder=" " oninput="mascararTelefone(this)">
                    <label for="telefone" class="form-label">
                        <i class="fas fa-phone"></i>
                        Telefone (opcional)
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <!-- Endereço -->
                <div class="form-group floating animated-input">
                    <input type="text" id="endereco" name="endereco" class="form-input" placeholder=" ">
                    <label for="endereco" class="form-label">
                        <i class="fas fa-map-marker-alt"></i>
                        Endereço (opcional)
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <!-- Botão -->
                <button type="submit" class="btn-login animated-input">
                    <span class="btn-text">Cadastrar</span>
                    <i class="fas fa-user-plus btn-icon"></i>
                    <div class="btn-shine"></div>
                </button>

                <!-- Link de login -->
                <div class="register-button animated-input">
                    <p>Já possui conta? <a href="${pageContext.request.contextPath}/auth/login/login.jsp">Faça o login</a></p>
                </div>
            </form>

            <!-- Rodapé -->
            <div class="login-footer animated-input">
                <p>Voltar para <a href="../../index.jsp">página inicial</a></p>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/cadastro.js"></script>
</body>
</html>
