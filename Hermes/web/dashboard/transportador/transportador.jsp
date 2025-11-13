<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");

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
    <title>Painel do Transportador | Hermes</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
    <jsp:include page="../../components/navbar.jsp" />

    <section class="dashboard-section">
        <div class="dashboard-container animate-fade-in">

            <div class="dashboard-header">
                <h1 class="section-title">Painel do Transportador</h1>
                <p class="section-subtitle">Bem-vindo, <strong><%= nome %></strong>! Veja os fretes disponíveis para aceitar.</p>
            </div>

            <!-- Cards de estatísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-truck-pickup"></i>
                    <h3>Fretes Disponíveis</h3>
                    <p class="stat-number"><%= fretes != null ? fretes.size() : 0 %></p>
                </div>

                <div class="stat-card">
                    <i class="fas fa-route"></i>
                    <h3>Em Andamento</h3>
                    <p class="stat-number">0</p>
                </div>

                <div class="stat-card">
                    <i class="fas fa-check-circle"></i>
                    <h3>Concluídos</h3>
                    <p class="stat-number">0</p>
                </div>
            </div>

            <!-- Lista de fretes reais -->
            <div class="fretes-grid">
                <h2 class="fretes-title">Fretes Recentes</h2>
                    <% 
                    List<Frete> recentes = (List<Frete>) request.getAttribute("recentes");
                    if (recentes != null && !recentes.isEmpty()) {
                        for (Frete f : recentes) { %>

                        <div class="frete-card">
                            <div class="frete-info">
                                <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                                <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                                <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                                <p><strong>Valor:</strong> R$ <%= f.getValor() %></p>
                            </div>
                        </div>

                    <% }} else { %>
                        <p style="color:gray;">Nenhum frete recente.</p>
                    <% } %>
            </div>

        </div>
    </section>

    <jsp:include page="../../components/footer.jsp" />
</body>
</html>
