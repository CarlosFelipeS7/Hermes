<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, br.com.hermes.dao.FreteDAO, br.com.hermes.model.Frete" %>

<%
    int idFrete = Integer.parseInt(request.getParameter("id"));
    FreteDAO dao = new FreteDAO();
    Frete f = dao.buscarPorId(idFrete);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Avaliação do Frete</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
</head>

<body>

<jsp:include page="../components/navbar.jsp" />

<section class="avaliacao-section">
    <div class="avaliacao-container">

        <h1>Avaliar Transportador</h1>
        <p>Frete: <strong><%= f.getOrigem() %> → <%= f.getDestino() %></strong></p>

        <form action="${pageContext.request.contextPath}/AvaliacaoServlet" method="post">

            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
            <input type="hidden" name="idAvaliado" value="<%= f.getIdTransportador() %>">

            <label>Nota:</label>
            <div class="stars">
                <input type="radio" name="nota" value="5" required> ★★★★★
                <input type="radio" name="nota" value="4"> ★★★★
                <input type="radio" name="nota" value="3"> ★★★
                <input type="radio" name="nota" value="2"> ★★
                <input type="radio" name="nota" value="1"> ★
            </div>

            <label>Comentário:</label>
            <textarea name="comentario" rows="4" placeholder="Escreva sua opinião..."></textarea>

            <button class="btn btn-primary">Enviar Avaliação</button>
        </form>

    </div>
</section>

</body>
</html>
