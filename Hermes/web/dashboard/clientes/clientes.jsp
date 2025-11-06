<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>


<%
    // Recupera o nome do usuário logado na sessão
    String nome = (String) session.getAttribute("usuarioNome");

    // Se não estiver logado, redireciona para o login
    if (nome == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Cliente | Hermes</title>

    <!-- Fontes e ícones -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Estilos -->
    <link rel="stylesheet" href="../../assets/css/style.css">
    <link rel="stylesheet" href="../../assets/css/dashboard.css">
    <link rel="stylesheet" href="../../assets/css/footer.css">
</head>

<body>
    <!-- Navbar -->
    <jsp:include page="../../components/navbar.jsp" />

    <section class="dashboard-section">
        <div class="dashboard-container animate-fade-in">

            <!-- Cabeçalho -->
            <div class="dashboard-header">
                <h1 class="section-title">Painel do Cliente</h1>
                <p class="section-subtitle">
                    Bem-vindo, <strong><%= nome %></strong>! Acompanhe seus fretes e solicite novos envios.
                </p>
            </div>

            <!-- Cards de estatísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-box-open"></i>
                    <h3>Fretes Solicitados</h3>
                    <p class="stat-number">5</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-hourglass-half"></i>
                    <h3>Em Andamento</h3>
                    <p class="stat-number">2</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-check-circle"></i>
                    <h3>Concluídos</h3>
                    <p class="stat-number">3</p>
                </div>
            </div>

            <!-- Ações rápidas -->
            <div class="actions-bar">
                <a href="${pageContext.request.contextPath}/fretes/solicitarFretes.jsp" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> Solicitar Novo Frete
                </a>
                <a href="../../fretes/historico.jsp" class="btn btn-secondary">
                    <i class="fas fa-list"></i> Ver Histórico
                </a>
            </div>

            <!-- Lista de fretes -->
            <div class="fretes-grid">
                <h2 class="fretes-title">Seus Fretes Recentes</h2>

                <!-- Card de Frete -->
                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> Jales/SP → Votuporanga/SP</h3>
                        <p><strong>Status:</strong> Em Andamento</p>
                        <p><strong>Transportador:</strong> João Carlos</p>
                        <p><strong>Data:</strong> 03/11/2025</p>
                        <p><strong>Valor:</strong> R$ 350,00</p>
                    </div>
                    <div class="frete-actions">
                        <a href="../../fretes/detalhes.jsp?id=1" class="btn btn-secondary btn-small">
                            <i class="fas fa-info-circle"></i> Detalhes
                        </a>
                        <button class="btn btn-primary btn-small">
                            <i class="fas fa-star"></i> Avaliar
                        </button>
                    </div>
                </div>

                <!-- Outro exemplo -->
                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> Santa Fé do Sul/SP → Fernandópolis/SP</h3>
                        <p><strong>Status:</strong> Concluído</p>
                        <p><strong>Transportador:</strong> Marcos Lima</p>
                        <p><strong>Data:</strong> 28/10/2025</p>
                        <p><strong>Valor:</strong> R$ 420,00</p>
                    </div>
                    <div class="frete-actions">
                        <a href="../../fretes/detalhes.jsp?id=2" class="btn btn-secondary btn-small">
                            <i class="fas fa-info-circle"></i> Detalhes
                        </a>
                        <button class="btn btn-primary btn-small">
                            <i class="fas fa-star"></i> Avaliar
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- Rodapé -->
    <jsp:include page="../../components/footer.jsp" />
</body>

</html>
