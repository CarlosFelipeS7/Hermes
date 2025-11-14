<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Avaliar Frete | Hermes</title>

    <!-- Fontes e ícones -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Estilos -->
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/fretes.css">
</head>

<body>
    <jsp:include page="../components/navbar.jsp" />

    <section class="avaliacao-section">
        <div class="avaliacao-container animate-fade-in">
            <h1 class="section-title">Avaliar Frete</h1>
            <p class="section-subtitle">Conte-nos como foi sua experiência com o transporte</p>

            <!-- FORMULÁRIO CORRETO PARA O SEU MODEL -->
            <form class="avaliacao-form" method="POST" enctype="multipart/form-data"
                  action="../../AvaliacaoServlet">

                <!-- Envia apenas o ID do frete -->
                <input type="hidden" name="idFrete" value="<%= request.getParameter("id") %>">

                <div class="frete-info">
                    <p><strong>ID do Frete:</strong> <%= request.getParameter("id") %></p>
                    <p><strong>Transportador:</strong> João Carlos (exemplo)</p>
                </div>

                <div class="rating-group">
                    <label class="rating-label">Sua Avaliação:</label>
                    <div class="stars">
                        <input type="radio" id="star5" name="nota" value="5" required>
                        <label for="star5"><i class="fas fa-star"></i></label>

                        <input type="radio" id="star4" name="nota" value="4">
                        <label for="star4"><i class="fas fa-star"></i></label>

                        <input type="radio" id="star3" name="nota" value="3">
                        <label for="star3"><i class="fas fa-star"></i></label>

                        <input type="radio" id="star2" name="nota" value="2">
                        <label for="star2"><i class="fas fa-star"></i></label>

                        <input type="radio" id="star1" name="nota" value="1">
                        <label for="star1"><i class="fas fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group full">
                    <label class="form-label">Comentário:</label>
                    <textarea name="comentario" rows="4"
                              placeholder="Deixe seu feedback sobre o serviço..."></textarea>
                </div>

                <div class="form-group full">
                    <label for="foto">Foto do frete (opcional):</label>
                    <input type="file" id="foto" name="foto" accept="image/*">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-large">
                        <i class="fas fa-paper-plane"></i> Enviar Avaliação
                    </button>
                    <a href="listaFretes.jsp" class="btn btn-secondary btn-large">
                        <i class="fas fa-arrow-left"></i> Voltar
                    </a>
                </div>

            </form>

        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
