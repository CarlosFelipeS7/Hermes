<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Erro | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body>
    <jsp:include page="components/navbar.jsp" />

    <section class="frete-section">
        <div class="frete-container animate-fade-in">

            <h1 class="section-title">Ocorreu um Erro</h1>

            <p class="section-subtitle">
                <%= request.getAttribute("mensagem") != null ?
                        request.getAttribute("mensagem") :
                        "Algo inesperado aconteceu." %>
            </p>

            <div style="text-align:center; margin-top:2rem;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">
                    Voltar ao Início
                </a>
            </div>

        </div>
    </section>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
