<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");
    if (fretes == null) fretes = java.util.Collections.emptyList();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Fretes Disponíveis | Hermes</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container">

        <h1 class="section-title">Fretes disponíveis</h1>
        <p class="section-subtitle">Veja os fretes pendentes e aceite os que você deseja transportar.</p>

        <div class="frete-grid">
            <% if (!fretes.isEmpty()) { %>
                <% for (Frete f : fretes) { %>
                    <div class="frete-card">
                        <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                        <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                        <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                        <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>

                        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" style="margin-top: 10px;">
                            <input type="hidden" name="action" value="aceitar">
                            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                            <button class="btn btn-primary btn-small">
                                <i class="fas fa-check"></i> Aceitar frete
                            </button>
                        </form>
                    </div>
                <% } %>
            <% } else { %>
                <p class="empty-text">Nenhum frete disponível no momento.</p>
            <% } %>
        </div>

    </div>
</section>

<jsp:include page="../components/footer.jsp" />

</body>
</html>
