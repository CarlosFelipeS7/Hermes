<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Solicitar Frete</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">

    <!-- Ícones -->
    <link rel="stylesheet" 
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<!-- MENSAGEM DO SERVLET -->
<% if (request.getAttribute("mensagem") != null) { %>
<div class="alert-overlay">
    <div class="alert-box <%= request.getAttribute("tipoMensagem") %>">
        <i class="fas <%= "success".equals(request.getAttribute("tipoMensagem")) 
                ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i>
        <span><%= request.getAttribute("mensagem") %></span>
    </div>
</div>
<% } %>

<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container animate-fade-in">

        <h1 class="section-title">Solicitar Frete</h1>
        <p class="section-subtitle">Preencha todos os dados para enviar sua solicitação.</p>

        <!-- FORMULÁRIO (compatível com FreteServlet) -->
        <form class="frete-form" 
              action="<%= request.getContextPath() %>/FreteServlet" 
              method="POST">

            <!-- Identifica que a ação é CRIAR -->
            <input type="hidden" name="action" value="criar">

            <div class="form-grid">

                <div class="form-group">
                    <label>Origem</label>
                    <input type="text" name="origem" required>
                </div>

                <div class="form-group">
                    <label>Destino</label>
                    <input type="text" name="destino" required>
                </div>

                <div class="form-group">
                    <label>Peso (kg)</label>
                    <input type="number" name="peso" min="1" required>
                </div>

                <div class="form-group full">
                    <label>Descrição / Observações</label>
                    <textarea name="descricao" rows="4"
                              placeholder="Ex: eletrodomésticos frágeis, embalados, etc."
                              required></textarea>
                </div>

            </div>

            <div class="form-actions">
                <button class="btn btn-primary btn-large" type="submit">
                    <i class="fas fa-paper-plane"></i> Enviar Solicitação
                </button>
            </div>

        </form>

    </div>
</section>

<jsp:include page="../components/footer.jsp" />

<script>
setTimeout(() => {
    const alertBox = document.querySelector('.alert-overlay');
    if (alertBox) {
        alertBox.style.opacity = '0';
        setTimeout(() => alertBox.remove(), 500);
    }
}, 4000);
</script>

</body>
</html>
