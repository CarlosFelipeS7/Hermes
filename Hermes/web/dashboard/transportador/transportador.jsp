<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");

    List<Frete> fretesDisponiveis = (List<Frete>) request.getAttribute("fretesDisponiveis");
    List<Frete> fretesEmAndamento = (List<Frete>) request.getAttribute("fretesEmAndamento");
    List<Frete> fretesConcluidos = (List<Frete>) request.getAttribute("fretesConcluidos");

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
</head>

<body>
<jsp:include page="../../components/navbar.jsp" />

<section class="dashboard-section">
    <div class="dashboard-container">

        <h1 class="section-title">Bem-vindo, <%= nome %></h1>

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
                <i class="fas fa-check"></i>
                <h3>Concluídos</h3>
                <p class="stat-number"><%= fretesConcluidos.size() %></p>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/FreteListarServlet"
            class="btn btn-primary">
            Ver Fretes Disponíveis
        </a>


        <h2 class="fretes-title">Em andamento</h2>

        <% if (!fretesEmAndamento.isEmpty()) { %>
            <% for (Frete f : fretesEmAndamento) { %>
                <div class="frete-card">
                    <h3><%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                    <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                    <p><strong>Cliente:</strong> <%= f.getIdCliente() %></p>

                    <form action="${pageContext.request.contextPath}/FreteServlet" method="post">
                        <input type="hidden" name="action" value="concluir">
                        <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                        <button class="btn btn-primary btn-small">Concluir</button>
                    </form>
                </div>
            <% } %>
        <% } else { %>
            <p class="empty-text">Nenhum frete em andamento.</p>
        <% } %>

    </div>
</section>

<jsp:include page="../../components/footer.jsp" />
</body>
</html>
