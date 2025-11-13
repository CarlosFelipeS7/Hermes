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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fretes Disponíveis | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
</head>
<body>

    <jsp:include page="../components/navbar.jsp" />

    <% if (request.getAttribute("mensagem") != null) { %>
        <div class="alert-overlay">
            <div class="alert-box <%= request.getAttribute("tipoMensagem") %>">
                <i class="fas <%= "success".equals(request.getAttribute("tipoMensagem")) ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i>
                <span><%= request.getAttribute("mensagem") %></span>
            </div>
        </div>
    <% } %>

    <section class="frete-section">
        <div class="frete-container animate-fade-in">
            <h1 class="section-title">Fretes Disponíveis</h1>
            <p class="section-subtitle">Selecione um frete para aceitar</p>

            <% if (fretes != null && !fretes.isEmpty()) { 
                   for (Frete f : fretes) { %>

                <div class="frete-card">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                        <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                        <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                        <p><strong>Valor:</strong> R$ <%= f.getValor() %></p>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/FreteServlet">
                        <input type="hidden" name="action" value="aceitar">
                        <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                        <button type="submit" class="btn btn-primary btn-small">
                            <i class="fas fa-check"></i> Aceitar
                        </button>
                    </form>
                </div>

            <% } } else { %>
                <p style="color:gray;">Nenhum frete disponível.</p>
            <% } %>
        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
