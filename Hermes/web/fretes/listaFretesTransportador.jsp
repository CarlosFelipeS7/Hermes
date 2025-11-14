<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    List<Frete> fretes = (List<Frete>) request.getAttribute("fretesDisponiveis");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Fretes Disponíveis | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body>

<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container">

        <h1 class="section-title">Fretes Disponíveis</h1>

        <div class="frete-grid">

            <% if (fretes != null && !fretes.isEmpty()) { %>

                <% for (Frete f : fretes) { %>

                <div class="frete-card">
                    <h3><%= f.getOrigem() %> → <%= f.getDestino() %></h3>

                    <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                    <p><strong>Carga:</strong> <%= f.getDescricaoCarga() %></p>
                    <p><strong>Cliente:</strong> <%= f.getIdCliente() %></p>

                    <form action="${pageContext.request.contextPath}/FreteServlet" method="post">
                        <input type="hidden" name="action" value="aceitar">
                        <input type="hidden" name="idFrete" value="<%= f.getId() %>">

                        <button class="btn btn-primary btn-small">
                            <i class="fas fa-check"></i> Aceitar Frete
                        </button>
                    </form>
                </div>

                <% } %>

            <% } else { %>

                <p style="color:gray; text-align:center; margin-top:1rem;">
                    Nenhum frete disponível no momento.
                </p>

            <% } %>

        </div>

    </div>
</section>

</body>
</html>
