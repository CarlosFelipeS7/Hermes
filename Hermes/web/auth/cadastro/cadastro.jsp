<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro - Hermes Sistema de Fretes</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../assets/css/cadastro.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body class="login-body">
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

                <h1 class="login-title">Crie sua conta</h1>
                <p class="login-subtitle">Preencha os campos abaixo para se cadastrar</p>
            </div>

            <form class="login-form" method="POST" action="${pageContext.request.contextPath}/UsuarioServlet">
                <div class="form-group floating animated-input">
                    <input type="text" id="nome" name="nome" class="form-input" placeholder=" " required>
                    <label for="nome" class="form-label">
                        <i class="fas fa-user"></i>
                        Nome completo
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <div class="form-group floating animated-input">
                    <input type="email" id="email" name="email" class="form-input" placeholder=" " required>
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i>
                        E-mail
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <div class="form-group floating animated-input">
                    <input type="password" id="senha" name="senha" class="form-input" placeholder=" " required>
                    <label for="senha" class="form-label">
                        <i class="fas fa-lock"></i>
                        Senha
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <div class="form-group animated-input">
                    <label class="form-label" style="font-weight:600; color:var(--primary); margin-bottom:0.5rem;">
                        <i class="fas fa-user-tag"></i> Tipo de Usuário
                    </label>
                    <div class="radio-group">
                        <label class="radio-option">
                            <input type="radio" name="tipoUsuario" value="cliente" required>
                            <span>Sou Cliente</span>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="tipoUsuario" value="transportador" required>
                            <span>Sou Transportador</span>
                        </label>
                    </div>
                </div>

                <div class="form-group floating animated-input">
                    <input type="text" id="telefone" name="telefone" class="form-input" placeholder=" ">
                    <label for="telefone" class="form-label">
                        <i class="fas fa-phone"></i>
                        Telefone (opcional)
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <div class="form-group floating animated-input">
                    <input type="text" id="endereco" name="endereco" class="form-input" placeholder=" ">
                    <label for="endereco" class="form-label">
                        <i class="fas fa-map-marker-alt"></i>
                        Endereço (opcional)
                    </label>
                    <div class="input-focus-line"></div>
                </div>

                <button type="submit" class="btn-login animated-input">
                    <span class="btn-text">Cadastrar</span>
                    <i class="fas fa-user-plus btn-icon"></i>
                    <div class="btn-shine"></div>
                </button>

                <div class="register-button animated-input">
                    <p>Já possui conta? <a href="../login/login.jsp">Faça o login</a></p>
                </div>
            </form>

            <div class="login-footer animated-input">
                <p>Voltar para <a href="../../index.jsp">página inicial</a></p>
            </div>
        </div>
    </div>
</body>
</html>
