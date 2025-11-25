<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");

    if (nome == null) {
        response.sendRedirect("../auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Meus Fretes | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body>
<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container">

        <h1 class="section-title">Meus Fretes</h1>

        <table class="frete-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Origem</th>
                <th>Destino</th>
                <th>Data</th>
                <th>Peso</th>
                <th>Valor</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
            </thead>

            <tbody>
            <% if (fretes != null && !fretes.isEmpty()) { %>
                <% for (Frete f : fretes) { %>
                    <tr>
                        <td><%= f.getId() %></td>
                        <td><%= f.getOrigem() %></td>
                        <td><%= f.getDestino() %></td>
                        <td><%= f.getDataSolicitacao().toLocalDateTime().toLocalDate() %></td>
                        <td><%= f.getPeso() %> kg</td>
                        <td>R$ <%= String.format("%.2f", f.getValor()) %></td>
                        <td>
                            <span class="status <%= f.getStatus() %>"><%= f.getStatus() %></span>
                        </td>

                        <td>
                            <% if ("aceito".equalsIgnoreCase(f.getStatus())) { %>
                                <a class="btn btn-secondary btn-small"
                                   href="rastreamento.jsp?id=<%= f.getId() %>">Rastrear</a>
                            <% } else if ("concluido".equalsIgnoreCase(f.getStatus())) { %>
                                                        <a class="btn btn-primary btn-small"
                            href="${pageContext.request.contextPath}/fretes/avaliacaoFretes.jsp?id=<%= f.getId() %>">
                             <i class="fas fa-star"></i> Avaliar</a>
                            <% } else { %>
                                <span>—</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
            <tr><td colspan="8">Nenhum frete encontrado.</td></tr>
            <% } %>
            </tbody>
        </table>

    </div>
</section>

<jsp:include page="../components/footer.jsp" />
</body>
</html>
