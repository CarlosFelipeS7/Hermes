<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, br.com.hermes.dao.FreteDAO, br.com.hermes.model.Frete" %>

<%
    // ============================
    // VALIDAR PARÂMETRO "id"
    // ============================
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/erro.jsp?mensagem=ID do frete não informado");
        return;
    }

    Frete f = null;

    try {
        int idFrete = Integer.parseInt(idParam.trim());
        FreteDAO dao = new FreteDAO();
        f = dao.buscarPorId(idFrete);

        // Verificar se existe
        if (f == null) {
            response.sendRedirect(request.getContextPath() + "/erro.jsp?mensagem=Frete não encontrado");
            return;
        }

        // Verificar se está concluído
        if (!"concluido".equalsIgnoreCase(f.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/erro.jsp?mensagem=Este frete ainda não pode ser avaliado");
            return;
        }

    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/erro.jsp?mensagem=ID do frete inválido");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Avaliar Transportador - Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/avaliacoes.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>

<jsp:include page="../components/navbar.jsp" />

<section class="avaliacao-section">
    <div class="avaliacao-container">
        <div class="avaliacao-header">
            <h1><i class="fas fa-star"></i> Avaliar Transportador</h1>
            <p>Avalie o serviço prestado pelo transportador</p>
        </div>

        <div class="frete-info">
            <h3>Detalhes do Frete</h3>
            <p><strong>Origem:</strong> <%= f.getOrigem() %></p>
            <p><strong>Destino:</strong> <%= f.getDestino() %></p>
            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
            <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
            <p><strong>Status:</strong> <span style="color:#27ae60;font-weight:600;">CONCLUÍDO</span></p>
        </div>

        <form action="${pageContext.request.contextPath}/AvaliacaoServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
            <input type="hidden" name="idAvaliado" value="<%= f.getIdTransportador() %>">

            <div class="stars-rating">
                <label>Avaliação:</label>
                <div class="stars">
                    <input type="radio" id="star5" name="nota" value="5" class="star-input" required>
                    <label for="star5" class="star-label">★</label>
                    
                    <input type="radio" id="star4" name="nota" value="4" class="star-input">
                    <label for="star4" class="star-label">★</label>
                    
                    <input type="radio" id="star3" name="nota" value="3" class="star-input">
                    <label for="star3" class="star-label">★</label>
                    
                    <input type="radio" id="star2" name="nota" value="2" class="star-input">
                    <label for="star2" class="star-label">★</label>
                    
                    <input type="radio" id="star1" name="nota" value="1" class="star-input">
                    <label for="star1" class="star-label">★</label>
                </div>
                <div class="rating-text" id="ratingText">Selecione uma nota de 1 a 5 estrelas</div>
            </div>

            <div class="form-group">
                <label for="comentario"><i class="fas fa-comment"></i> Comentário (opcional):</label>
                <textarea name="comentario" id="comentario" placeholder="Conte como foi sua experiência..."></textarea>
            </div>

            <div class="form-group">
                <label for="foto"><i class="fas fa-camera"></i> Foto da entrega (opcional):</label>
                <input type="file" name="foto" id="foto" accept="image/*" class="form-control">
            </div>

            <button type="submit" class="btn-avaliar">
                <i class="fas fa-paper-plane"></i> Enviar Avaliação
            </button>
        </form>
    </div>
</section>

<jsp:include page="../components/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const starInputs = document.querySelectorAll('.star-input');
        const ratingText = document.getElementById('ratingText');

        const messages = {
            1: "Péssimo",
            2: "Ruim",
            3: "Regular",
            4: "Bom",
            5: "Excelente"
        };

        starInputs.forEach(star => {
            star.addEventListener('change', () => {
                ratingText.textContent = messages[star.value];
                ratingText.style.color = "#27ae60";
                ratingText.style.fontWeight = "600";
            });
        });
    });
</script>

</body>
</html>
