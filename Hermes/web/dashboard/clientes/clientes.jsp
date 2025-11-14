<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    Integer idUsuario = (Integer) session.getAttribute("usuarioId");

    if (nome == null || idUsuario == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }

    List<Frete> recentes = (List<Frete>) request.getAttribute("fretesRecentes");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Painel do Cliente | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
<jsp:include page="../../components/navbar.jsp" />

<section class="dashboard-section">
    <div class="dashboard-container animate-fade-in">

        <div class="dashboard-header">
            <h1 class="section-title">Painel do Cliente</h1>
            <p class="section-subtitle">Bem-vindo, <strong><%= nome %></strong>!</p>
        </div>

        <div class="actions-bar">
            <a href="${pageContext.request.contextPath}/fretes/solicitarFretes.jsp" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Solicitar Novo Frete
            </a>
            <a href="${pageContext.request.contextPath}/FreteServlet" class="btn btn-secondary">
                <i class="fas fa-list"></i> Ver Todos
            </a>
        </div>

        <h2 class="fretes-title">Últimos Fretes</h2>
        <div class="fretes-grid">

            <% if (recentes != null && !recentes.isEmpty()) { %>
                <% for (Frete f : recentes) { %>
                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>

                        <p><strong>Status:</strong> 
                            <span class="status <%= f.getStatus().toLowerCase() %>">
                                <%= f.getStatus().toUpperCase() %>
                            </span>
                        </p>

                        <p><strong>Data:</strong> <%= f.getDataSolicitacao().toLocalDateTime().toLocalDate() %></p>
                        <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                        <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                    </div>

                    <div class="frete-actions">
                        <% if ("aceito".equals(f.getStatus())) { %>
                            <a class="btn btn-secondary btn-small"
                                href="${pageContext.request.contextPath}/fretes/rastreamento.jsp?id=<%= f.getId() %>">
                                <i class="fas fa-route"></i> Rastrear
                            </a>
                        <% } else if ("concluido".equals(f.getStatus())) { %>
                            <a class="btn btn-primary btn-small"
                               href="${pageContext.getRequest().getContextPath()}/fretes/avaliacaoFretes.jsp?id=<%= f.getId() %>">
                                <i class="fas fa-star"></i> Avaliar
                            </a>
                        <% } else { %>
                            <span style="color:gray;">—</span>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p class="empty-text">Nenhum frete encontrado.</p>
            <% } %>

        </div>
    </div>
</section>

<jsp:include page="../../components/footer.jsp" />
</body>
</html>
