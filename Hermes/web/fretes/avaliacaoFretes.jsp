<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!--
<%
    // 🔒 Backend (comentado)
    // Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    // if (usuarioId == null) {
    //     response.sendRedirect("../auth/login/login.jsp");
    //     return;
    // }

    // String freteId = request.getParameter("id");
    //
    // try {
    //     Class.forName("com.mysql.cj.jdbc.Driver");
    //     Connection conn = DriverManager.getConnection(
    //         "jdbc:mysql://localhost:3306/hermes_db", "usuario", "senha");
    //
    //     String sql = "INSERT INTO avaliacoes (frete_id, usuario_id, nota, comentario) VALUES (?, ?, ?, ?)";
    //     PreparedStatement stmt = conn.prepareStatement(sql);
    //     stmt.setString(1, freteId);
    //     stmt.setInt(2, usuarioId);
    //     stmt.setInt(3, nota);
    //     stmt.setString(4, comentario);
    //     stmt.executeUpdate();
    //     conn.close();
    // } catch (Exception e) {
    //     e.printStackTrace();
    // }
%>
-->

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

            <form class="avaliacao-form" method="POST" action="#">
                <div class="frete-info">
                    <p><strong>ID do Frete:</strong> <%= request.getParameter("id") != null ? request.getParameter("id") : "003" %></p>
                    <p><strong>Transportador:</strong> João Carlos (exemplo)</p>
                </div>

                <div class="rating-group">
                    <label class="rating-label">Sua Avaliação:</label>
                    <div class="stars">
                        <input type="radio" id="star5" name="nota" value="5"><label for="star5" title="5 estrelas"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star4" name="nota" value="4"><label for="star4" title="4 estrelas"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star3" name="nota" value="3"><label for="star3" title="3 estrelas"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star2" name="nota" value="2"><label for="star2" title="2 estrelas"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star1" name="nota" value="1"><label for="star1" title="1 estrela"><i class="fas fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group full">
                    <label for="comentario" class="form-label">Comentário:</label>
                    <textarea id="comentario" name="comentario" rows="4" placeholder="Deixe seu feedback sobre o serviço..."></textarea>
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
