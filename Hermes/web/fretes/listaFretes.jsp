<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>


<%
    if (request.getAttribute("fretes") == null) {
    response.sendRedirect(request.getContextPath() + "/FreteListarServlet");
    return;
}
    
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
    <jsp:include page="../components/navbar.jsp" />

    <section class="frete-section">
        <div class="frete-container animate-fade-in">
            <h1 class="section-title">Meus Fretes</h1>
            <p class="section-subtitle">Acompanhe todos os fretes que você solicitou</p>

            <div class="frete-grid">
                <table class="frete-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Origem</th>
                            <th>Destino</th>
                            <th>Data Solicitação</th>
                            <th>Peso (kg)</th>
                            <th>Valor (R$)</th>
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
                                    <td><%= f.getDataSolicitacao() != null ? f.getDataSolicitacao().toString().substring(0, 10) : "-" %></td>
                                    <td><%= f.getPeso() %></td>
                                    <td><%= String.format("%.2f", f.getValor()) %></td>
                                    <td><span class="status <%= f.getStatus() %>"><%= f.getStatus() %></span></td>
                                    <td>
                                        <% if ("aceito".equalsIgnoreCase(f.getStatus())) { %>
                                            <a href="rastreamento.jsp?id=<%= f.getId() %>" class="btn btn-secondary btn-small">
                                                <i class="fas fa-route"></i> Rastrear
                                            </a>
                                        <% } else if ("concluído".equalsIgnoreCase(f.getStatus())) { %>
                                            <a href="avaliacaoFretes.jsp?id=<%= f.getId() %>" class="btn btn-primary btn-small">
                                                <i class="fas fa-star"></i> Avaliar
                                            </a>
                                        <% } else { %>
                                            <span style="color:gray;">—</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="8" style="text-align:center; color:gray;">
                                    Nenhum frete encontrado.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
