<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitar Frete | Hermes</title>

    <!-- Fonte e ícones -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- CSS principal -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
</head>
<body>
    <% if (request.getAttribute("mensagem") != null) { %>
    <div class="alert-overlay">
        <div class="alert-box <%= request.getAttribute("tipoMensagem") %>">
            <i class="fas <%= "success".equals(request.getAttribute("tipoMensagem")) ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i>
            <span><%= request.getAttribute("mensagem") %></span>
        </div>
    </div>
<% } %>


    <!-- Navbar -->
    <jsp:include page="../components/navbar.jsp" />

    <!-- Seção principal -->
    <section class="frete-section">
        <div class="frete-container animate-fade-in">
            <h1 class="section-title">Solicitar Frete</h1>
            <p class="section-subtitle">Preencha as informações abaixo para encontrar o transportador ideal.</p>

            <form class="frete-form" method="POST" action="${pageContext.request.contextPath}/FreteServlet">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="origem">Origem</label>
                        <input type="text" id="origem" name="origem" placeholder="Ex: Rua das Flores, 120 - Jales/SP" required>
                    </div>

                    <div class="form-group">
                        <label for="destino">Destino</label>
                        <input type="text" id="destino" name="destino" placeholder="Ex: Av. Brasil, 450 - Votuporanga/SP" required>
                    </div>

                    <div class="form-group">
                        <label for="data">Data da Coleta</label>
                        <input type="date" id="data" name="data" required>
                    </div>

                    <div class="form-group">
                        <label for="horario">Horário Preferencial</label>
                        <input type="time" id="horario" name="horario" required>
                    </div>

                    <div class="form-group">
                        <label for="tipoCarga">Tipo de Carga</label>
                        <select id="tipoCarga" name="tipoCarga" required>
                            <option value="">Selecione...</option>
                            <option value="residencial">Residencial</option>
                            <option value="comercial">Comercial</option>
                            <option value="fragil">Frágil</option>
                            <option value="outros">Outros</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="peso">Peso Estimado (kg)</label>
                        <input type="number" id="peso" name="peso" min="1" placeholder="Ex: 200" required>
                    </div>

                    <div class="form-group full">
                        <label for="observacoes">Observações</label>
                        <textarea id="observacoes" name="observacoes" rows="4" placeholder="Descreva detalhes da carga, horários flexíveis, pontos de referência etc."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-large">
                        <i class="fas fa-paper-plane"></i> Enviar Solicitação
                    </button>
                    <a href="${pageContext.request.contextPath}/fretes/listaFretes.jsp" class="btn btn-secondary btn-large">
                        <i class="fas fa-list"></i> Ver Meus Fretes
                    </a>
                </div>
            </form>
        </div>
    </section>

    <script src="assets/js/main.js"></script>
    <script src="assets/js/animations.js"></script>
    <jsp:include page="/components/footer.jsp" />
</body>
<script>
setTimeout(() => {
    const alertBox = document.querySelector('.alert-overlay');
    if (alertBox) {
        alertBox.style.transition = 'opacity 0.5s';
        alertBox.style.opacity = '0';
        setTimeout(() => alertBox.remove(), 600);
    }
}, 4000);
</script>

</html>
