<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
    
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hermes - Sistema de Fretes</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    
        <!-- Navbar  -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <i class="fas fa-shipping-fast"></i>
                <span>HERMES</span>
            </div>
            <div class="nav-menu">
                <a href="#features" class="nav-link">Como Funciona</a>
                <a href="#benefits" class="nav-link">Vantagens</a>
                <a href="#pricing" class="nav-link">Planos</a>
                <a href="auth/login/login.jsp" class="nav-join"><i class="fa-solid fa-user"></i>  Entrar</a>
                <a href="auth/cadastro/cliente.jsp" class="nav-link btn-nav">Cadastrar</a>
            </div>
            <div class="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        
        <div class="hero-content">
            <h1 class="hero-title animate-fade-in">
                Encontre os <span class="text-gradient">melhores fretes</span> 
                para sua carga
            </h1>
            <p class="hero-subtitle animate-fade-in-delay">
                Conectamos embarcadores e transportadores de forma rápida e segura
            </p>
            <div class="hero-buttons animate-fade-in-delay-2">
                <a href="auth/cadastro/cliente.jsp" class="btn btn-large btn-primary">
                    <i class="fas fa-box"></i>
                    Preciso de um frete
                </a>
                <a href="auth/cadastro/transportador.jsp" class="btn btn-large btn-secondary">
                    <i class="fas fa-truck"></i>
                    Sou Transportador
                </a>
            </div>
        </div>
        
        <div class="hero-visual">
            
        </div>
    </section>

   <!-- Features Section -->
<section class="features">
    <div class="container">
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-shipping-fast"></i>
                </div>
                <h3>Solicitar Frete</h3>
                <p>Encontre os melhores transportadores para sua carga de forma rápida e segura.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <h3>Ser Transportador</h3>
                <p>Cadastre-se como transportador e encontre novas oportunidades de fretes.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <h3>Cadastro Verificado</h3>
                <p>Todos os usuários são verificados para garantir segurança e confiabilidade.</p>
            </div>
        </div>
    </div>
</section>
   
       <!-- Seção Complementar -->
    <section class="complement-section">
        <div class="complement-grid">
            <div class="complement-content">
                <h2>Transforme sua operação de fretes</h2>
                <h3>Texto para colocar ainda :)</h3>
                <p>Sistema completo para gerenciamento de fretes, com cobertura nacional e suporte especializado.</p>
                
                <ul class="feature-list">
                    <li>Cobertura em todas as regiões do Brasil</li>
                    <li>Rastreamento em tempo real</li>
                    <li>Pagamento seguro e rápido</li>
                    <li>Suporte 24/7 especializado</li>
                </ul>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <span class="stat-number">250+</span>
                        <span class="stat-label">Proteções Ativas</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <span class="stat-label">Transportadores</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">99%</span>
                        <span class="stat-label">Satisfação</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">24/7</span>
                        <span class="stat-label">Suporte</span>
                    </div>
                </div>
            </div>
            
            <div class="complement-visual">
                <div class="map-container">
                    <img src="assets/images/backgrounds/mapa.jpg" alt="Mapa de Cobertura Hermes" class="map-image">
                </div>
            </div>
        </div>
    </section>
       
    <script src="assets/js/main.js"></script>
    <script src="assets/js/animations.js"></script>
    <jsp:include page="/components/footer.jsp" />
</body>
</html>