<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Avaliação Enviada - Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/avaliacoes.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
   
</head>

<body>

<jsp:include page="../components/navbar.jsp" />

<section class="success-section">
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        
        <h1>Avaliação Enviada!</h1>
        
        <% if (request.getAttribute("mensagem") != null) { %>
            <p style="color: #27ae60; font-weight: 600; margin: 1rem 0;">
                <%= request.getAttribute("mensagem") %>
            </p>
        <% } else { %>
            <p style="margin: 1rem 0;">Sua avaliação foi registrada com sucesso e o transportador foi notificado.</p>
        <% } %>
        
        <p style="color: #7f8c8d;">Obrigado por contribuir para a comunidade Hermes!</p>
        
        <div class="success-actions">
            <a href="${pageContext.request.contextPath}/dashboard/clientes/clientes.jsp" class="btn btn-primary">
                <i class="fas fa-tachometer-alt"></i> Voltar ao Painel
            </a>
            <a href="${pageContext.request.contextPath}/FreteListarServlet" class="btn btn-secondary">
                <i class="fas fa-list"></i> Ver Meus Fretes
            </a>
        </div>
    </div>
</section>

<jsp:include page="../components/footer.jsp" />

</body>
</html>