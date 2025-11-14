<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer idUsuario = (Integer) session.getAttribute("usuarioId");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");

    // Só cliente pode solicitar frete
    if (idUsuario == null || !"cliente".equalsIgnoreCase(tipoUsuario)) {
        response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
        return;
    }
    

%>

<script>
    // Máscara de valor (formato brasileiro)
    const campoValor = document.getElementById("valor");

    campoValor.addEventListener("input", function () {
        let v = this.value.replace(/\D/g, ""); // remove tudo que não é número
        v = (Number(v) / 100).toFixed(2) + "";
        v = v.replace(".", ",");
        v = "R$ " + v;
        this.value = v;
    });

    // Remove máscara antes de enviar ao backend
    document.querySelector(".frete-form").addEventListener("submit", function () {
        let v = campoValor.value.replace("R$ ", "").replace(".", "").replace(",", ".");
        campoValor.value = v; // valor puro para o banco/DAO
    });

    // Máscara de peso (kg)
    const campoPeso = document.querySelector("input[name='peso']");

    campoPeso.addEventListener("input", function () {
        let v = this.value.replace(/\D/g, "");
        if (v.length > 3) {
            v = v.replace(/(\d+)(\d{2})$/, "$1,$2");
        }
        this.value = v;
    });

    // Antes de enviar remove vírgula
    document.querySelector(".frete-form").addEventListener("submit", function () {
        campoPeso.value = campoPeso.value.replace(",", ".");
    });
</script>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Solicitar Frete | Hermes</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

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
        <p class="section-subtitle">Preencha os dados abaixo para enviar sua solicitação.</p>

        <form action="${pageContext.request.contextPath}/FreteServlet"
              method="post"
              class="frete-form">

            <input type="hidden" name="action" value="criar">

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
                <input type="text" name="peso" id="peso" required>
            </div>

            <div class="form-group">
                <label>Valor (R$)</label>
                <input type="text" name="valor" id="valor" required>
            </div>

            <div class="form-group full">
                <label>Descrição</label>
                <textarea name="descricao" rows="4" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-large">
                <i class="fas fa-paper-plane"></i> Enviar Solicitação
            </button>

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
