<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    List<Frete> fretesCliente = (List<Frete>) request.getAttribute("fretesCliente");

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
    <title>Painel do Cliente | Hermes</title>
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
                <h1 class="section-title">Painel do Cliente</h1>
                <p class="section-subtitle">Bem-vindo, <strong><%= nome %></strong>! Acompanhe seus fretes.</p>
            </div>

            <div class="actions-bar">
                <a href="${pageContext.request.contextPath}/fretes/solicitarFretes.jsp" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> Solicitar Novo Frete
                </a>
                <a href="${pageContext.request.contextPath}/fretes/listaFretes.jsp" class="btn btn-secondary">
                    <i class="fas fa-list"></i> Ver Todos
                </a>
            </div>

            <div class="fretes-grid">
                <h2 class="fretes-title">Seus Fretes Recentes</h2>

                <% if (fretesCliente != null && !fretesCliente.isEmpty()) { %>
                    <% for (Frete f : fretesCliente) { %>
                        <div class="frete-card">
                            <div class="frete-info">
                                <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                                <p><strong>Status:</strong> <%= f.getStatus() %></p>
                                <p><strong>Data Solicitação:</strong> <%= f.getDataSolicitacao() %></p>
                                <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                                <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                            </div>
                            <div class="frete-actions">
                                <% if ("aceito".equalsIgnoreCase(f.getStatus())) { %>
                                    <a href="../../fretes/rastreamento.jsp?id=<%= f.getId() %>" class="btn btn-secondary btn-small">
                                        <i class="fas fa-route"></i> Rastrear
                                    </a>
                                <% } else if ("concluido".equalsIgnoreCase(f.getStatus())) { %>
                                    <a href="../../fretes/avaliacaoFretes.jsp?id=<%= f.getId() %>" class="btn btn-primary btn-small">
                                        <i class="fas fa-star"></i> Avaliar
                                    </a>
                                <% } else { %>
                                    <span style="color:gray;">—</span>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <p style="color:gray; margin-top:1rem;">Nenhum frete encontrado.</p>
                <% } %>
            </div>
        </div>
    </section>

    <jsp:include page="../../components/footer.jsp" />
</body>
</html>
