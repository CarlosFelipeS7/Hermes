<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!--
<%
    // 🔒 Backend (comentado)
    // Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    // String nome = (String) session.getAttribute("usuarioNome");
    // if (usuarioId == null) {
    //     response.sendRedirect("../auth/login/login.jsp");
    //     return;
    // }

    // try {
    //     Class.forName("com.mysql.cj.jdbc.Driver");
    //     Connection conn = DriverManager.getConnection(
    //         "jdbc:mysql://localhost:3306/hermes_db", "usuario", "senha");
    //
    //     String sql = "SELECT * FROM fretes WHERE status = 'Disponível'";
    //     PreparedStatement stmt = conn.prepareStatement(sql);
    //     ResultSet rs = stmt.executeQuery();
    //
    //     while (rs.next()) {
    //         ...
    //     }
    //
    //     conn.close();
    // } catch (Exception e) {
    //     e.printStackTrace();
    // }
%>
-->

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Transportador | Hermes</title>

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
    <jsp:include page="../../components/navbar.jsp" />

    <section class="dashboard-section">
        <div class="dashboard-container animate-fade-in">

            <div class="dashboard-header">
                <h1 class="section-title">Painel do Transportador</h1>
                <p class="section-subtitle">Bem-vindo, <strong>João Carlos</strong>! Veja os fretes disponíveis e gerencie suas entregas.</p>
            </div>

            <!-- Cards de estatísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-truck-pickup"></i>
                    <h3>Fretes Disponíveis</h3>
                    <p class="stat-number">8</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-route"></i>
                    <h3>Em Andamento</h3>
                    <p class="stat-number">3</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-check-circle"></i>
                    <h3>Concluídos</h3>
                    <p class="stat-number">12</p>
                </div>
            </div>

            <!-- Lista de fretes disponíveis -->
            <div class="fretes-grid">
                <h2 class="fretes-title">Fretes Disponíveis</h2>

                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> Jales/SP → Votuporanga/SP</h3>
                        <p><strong>Tipo:</strong> Residencial</p>
                        <p><strong>Data:</strong> 10/11/2025</p>
                        <p><strong>Valor:</strong> R$ 380,00</p>
                    </div>
                    <div class="frete-actions">
                        <button class="btn btn-primary btn-small"><i class="fas fa-check"></i> Aceitar</button>
                        <a href="#" class="btn btn-secondary btn-small"><i class="fas fa-info-circle"></i> Ver Detalhes</a>
                    </div>
                </div>

                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> Santa Fé do Sul/SP → Fernandópolis/SP</h3>
                        <p><strong>Tipo:</strong> Comercial</p>
                        <p><strong>Data:</strong> 12/11/2025</p>
                        <p><strong>Valor:</strong> R$ 450,00</p>
                    </div>
                    <div class="frete-actions">
                        <button class="btn btn-primary btn-small"><i class="fas fa-check"></i> Aceitar</button>
                        <a href="#" class="btn btn-secondary btn-small"><i class="fas fa-info-circle"></i> Ver Detalhes</a>
                    </div>
                </div>

                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> Urânia/SP → Jales/SP</h3>
                        <p><strong>Tipo:</strong> Frágil</p>
                        <p><strong>Data:</strong> 18/11/2025</p>
                        <p><strong>Valor:</strong> R$ 250,00</p>
                    </div>
                    <div class="frete-actions">
                        <button class="btn btn-primary btn-small"><i class="fas fa-check"></i> Aceitar</button>
                        <a href="#" class="btn btn-secondary btn-small"><i class="fas fa-info-circle"></i> Ver Detalhes</a>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <jsp:include page="../../components/footer.jsp" />
</body>
</html>
