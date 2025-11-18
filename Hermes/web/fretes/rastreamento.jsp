<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="br.com.hermes.model.Frete, br.com.hermes.dao.FreteDAO" %>

<%
    int idFrete = Integer.parseInt(request.getParameter("id"));
    FreteDAO dao = new FreteDAO();
    Frete f = dao.buscarPorId(idFrete);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rastreamento | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
</head>

<body>

<jsp:include page="../components/navbar.jsp" />

<section class="rast-section">
    <div class="rast-container">

        <h1>Rastreamento do Frete</h1>

        <div class="rast-card">

            <h2><%= f.getOrigem() %> → <%= f.getDestino() %></h2>

            <div class="rast-status-box">
                <p><strong>Status atual:</strong></p>
                <span class="status <%= f.getStatus() %>">
                    <%= f.getStatus().toUpperCase() %>
                </span>
            </div>

            <div class="rast-linha">

                <div class="rast-etapa <%= f.getStatus().equals("PENDENTE") ? "ativo" : "" %>">Pendente</div>

                <div class="rast-etapa <%= f.getStatus().equals("ACEITO") ? "ativo" : "" %>">Aceito</div>

                <div class="rast-etapa <%= f.getStatus().equals("EM COLETA") ? "ativo" : "" %>">Em Coleta</div>

                <div class="rast-etapa <%= f.getStatus().equals("A CAMINHO") ? "ativo" : "" %>">A Caminho</div>

                <div class="rast-etapa <%= f.getStatus().equals("ENTREGUE") ? "ativo" : "" %>">Entregue</div>

            </div>

        </div>

    </div>
</section>

</body>
</html>
