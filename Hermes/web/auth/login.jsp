<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Hermes</title>
    <link rel="stylesheet" href="assets/css/auth.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="auth-logo">
                    <i class="fas fa-shipping-fast"></i>
                    <span>HERMES</span>
                </div>
                <h1>Bem-vindo de volta</h1>
                <p>Entre em sua conta para continuar</p>
            </div>

            <form class="auth-form" action="login" method="POST">
                <div class="form-group">
                    <div class="input-container">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" class="form-input" placeholder=" " required>
                        <label class="form-label">E-mail</label>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-container">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="senha" class="form-input" placeholder=" " required>
                        <label class="form-label">Senha</label>
                        <button type="button" class="password-toggle">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-container">
                        <input type="checkbox" name="lembrar">
                        <span class="checkmark"></span>
                        Lembrar de mim
                    </label>
                    <a href="#" class="forgot-password">Esqueci minha senha</a>
                </div>

                <button type="submit" class="btn btn-primary btn-full">
                    <i class="fas fa-sign-in-alt"></i>
                    Entrar
                </button>
            </form>

            <div class="auth-footer">
                <p>Não tem uma conta? 
                    <a href="auth/cadastro/cliente.jsp" class="auth-link">Cadastre-se como Cliente</a>
                    ou
                    <a href="auth/cadastro/transportador.jsp" class="auth-link">Transportador</a>
                </p>
            </div>
        </div>

        <div class="auth-background">
            <div class="floating-elements">
                <div class="float-element el-1"></div>
                <div class="float-element el-2"></div>
                <div class="float-element el-3"></div>
            </div>
        </div>
    </div>

    <script src="assets/js/auth.js"></script>
</body>
</html>