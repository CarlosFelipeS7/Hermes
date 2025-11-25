<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Avaliação Enviada - Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .success-section {
            padding: 4rem 0;
            background: #f8f9fa;
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .success-container {
            max-width: 500px;
            text-align: center;
            background: white;
            padding: 3rem;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .success-icon {
            font-size: 4rem;
            color: #27ae60;
            margin-bottom: 1rem;
        }
        
        .success-actions {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #27ae60;
            color: white;
        }
        
        .btn-primary:hover {
            background: #219653;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
    </style>
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