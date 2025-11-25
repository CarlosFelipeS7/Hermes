<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, br.com.hermes.dao.FreteDAO, br.com.hermes.model.Frete" %>

<%
    // VALIDAÇÃO CONTRA PARÂMETRO NULL
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("erro.jsp?mensagem=ID do frete não informado");
        return;
    }
    
    Frete f = null;
    try {
        int idFrete = Integer.parseInt(idParam.trim());
        FreteDAO dao = new FreteDAO();
        f = dao.buscarPorId(idFrete);
        
        // Verificar se o frete pode ser avaliado
        if (f == null || !"concluido".equalsIgnoreCase(f.getStatus())) {
            response.sendRedirect("erro.jsp?mensagem=Este frete não pode ser avaliado");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("erro.jsp?mensagem=ID do frete inválido");
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .avaliacao-section {
            padding: 2rem 0;
            background: #f8f9fa;
            min-height: 80vh;
        }
        
        .avaliacao-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .avaliacao-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
        }
        
        .frete-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        
        .stars-rating {
            text-align: center;
            margin: 2rem 0;
        }
        
        .stars {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin: 1rem 0;
        }
        
        .star-input {
            display: none;
        }
        
        .star-label {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s ease;
        }
        
        .star-label:hover,
        .star-input:checked ~ .star-label {
            color: #ffc107;
        }
        
        .star-label:hover ~ .star-label {
            color: #ffc107;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }
        
        .form-group textarea:focus {
            outline: none;
            border-color: #27ae60;
        }
        
        .btn-avaliar {
            background: #27ae60;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
            width: 100%;
        }
        
        .btn-avaliar:hover {
            background: #219653;
        }
        
        .rating-text {
            text-align: center;
            color: #7f8c8d;
            margin-top: 0.5rem;
        }
    </style>
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
            <p><strong>Status:</strong> <span style="color: #27ae60; font-weight: 600;">CONCLUÍDO</span></p>
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
                <textarea name="comentario" id="comentario" placeholder="Conte como foi sua experiência com o transportador..."></textarea>
            </div>

            <div class="form-group">
                <label for="foto"><i class="fas fa-camera"></i> Foto da entrega (opcional):</label>
                <input type="file" name="foto" id="foto" accept="image/*" class="form-control">
                <small style="color: #7f8c8d;">Formatos aceitos: JPG, PNG, GIF (máx. 5MB)</small>
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
        
        const ratingMessages = {
            1: "Péssimo - Serviço muito abaixo do esperado",
            2: "Ruim - Serviço abaixo do esperado", 
            3: "Regular - Serviço dentro do esperado",
            4: "Bom - Serviço acima do esperado",
            5: "Excelente - Serviço excepcional"
        };
        
        starInputs.forEach(star => {
            star.addEventListener('change', function() {
                const rating = this.value;
                ratingText.textContent = ratingMessages[rating];
                ratingText.style.color = '#27ae60';
                ratingText.style.fontWeight = '600';
            });
        });
        
        // Validação do formulário
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            const nota = document.querySelector('input[name="nota"]:checked');
            if (!nota) {
                e.preventDefault();
                alert('Por favor, selecione uma nota para a avaliação.');
                return;
            }
        });
    });
</script>

</body>
</html>