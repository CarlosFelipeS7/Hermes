<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");

    List<Frete> fretesDisponiveis =
            (List<Frete>) request.getAttribute("fretesDisponiveis");
    List<Frete> fretesEmAndamento =
            (List<Frete>) request.getAttribute("fretesEmAndamento");
    List<Frete> fretesConcluidos =
            (List<Frete>) request.getAttribute("fretesConcluidos");
    List<Frete> fretesRecentes =
            (List<Frete>) request.getAttribute("fretesRecentes");

    if (fretesDisponiveis == null) fretesDisponiveis = java.util.Collections.emptyList();
    if (fretesEmAndamento == null) fretesEmAndamento = java.util.Collections.emptyList();
    if (fretesConcluidos == null) fretesConcluidos = java.util.Collections.emptyList();
    if (fretesRecentes == null) fretesRecentes = java.util.Collections.emptyList();

    if (nome == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Painel do Transportador | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<jsp:include page="../../components/navbar.jsp" />

<section class="dashboard-section">
    <div class="dashboard-container">

        <h1 class="section-title">Bem-vindo, <%= nome %></h1>

        <!-- CARDS -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-truck"></i>
                <h3>Fretes Disponíveis</h3>
                <p class="stat-number"><%= fretesDisponiveis.size() %></p>
            </div>

            <div class="stat-card">
                <i class="fas fa-route"></i>
                <h3>Em Andamento</h3>
                <p class="stat-number"><%= fretesEmAndamento.size() %></p>
            </div>

            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <h3>Concluídos</h3>
                <p class="stat-number"><%= fretesConcluidos.size() %></p>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/FreteListarServlet"
           class="btn btn-primary" style="margin-top: 20px;">
            Ver Fretes Disponíveis
        </a>

        <!-- FRETES EM ANDAMENTO -->
        <h2 class="fretes-title" style="margin-top: 40px;">Fretes em andamento</h2>

        <% if (!fretesEmAndamento.isEmpty()) { %>

            <% for (Frete f : fretesEmAndamento) { %>
                <div class="frete-card">
                    <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                    <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                    <p><strong>ID Cliente:</strong> <%= f.getIdCliente() %></p>

                    <form action="${pageContext.request.contextPath}/FreteServlet" method="post" style="margin-top: 10px;">
                        <input type="hidden" name="action" value="concluir">
                        <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                        <button class="btn btn-primary btn-small">
                            <i class="fas fa-check"></i> Concluir frete
                        </button>
                    </form>
                </div>
            <% } %>

        <% } else { %>
            <p class="empty-text">Nenhum frete em andamento.</p>
        <% } %>

        <!-- ÚLTIMOS FRETES ACEITOS -->
        <h2 class="fretes-title" style="margin-top: 40px;">Últimos fretes aceitos</h2>

        <% if (!fretesRecentes.isEmpty()) { %>

            <% for (Frete f : fretesRecentes) { %>
                <div class="frete-card">
                    <h3><i class="fas fa-truck-moving"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                    <p><strong>Status:</strong> <%= f.getStatus() %></p>
                    <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                    <p><strong>Data Solicitação:</strong>
                        <%= (f.getDataSolicitacao() != null ? f.getDataSolicitacao().toLocalDateTime().toLocalDate() : "") %>
                    </p>
                </div>
            <% } %>

        <% } else { %>
            <p class="empty-text">Você ainda não aceitou nenhum frete.</p>
        <% } %>

    </div>
</section>

<jsp:include page="../../components/footer.jsp" />

</body>
</html>
