<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    // 🔒 Quando o back-end estiver pronto:
    // Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    // if (usuarioId == null) {
    //     response.sendRedirect("../auth/login/login.jsp");
    //     return;
    // }

    // String freteId = request.getParameter("id");
    // Map<String, String> frete = new HashMap<>();

    // try {
    //     Class.forName("com.mysql.cj.jdbc.Driver");
    //     Connection conn = DriverManager.getConnection(
    //         "jdbc:mysql://localhost:3306/hermes_db", "usuario", "senha");
    //
    //     String sql = "SELECT * FROM fretes WHERE id = ?";
    //     PreparedStatement stmt = conn.prepareStatement(sql);
    //     stmt.setString(1, freteId);
    //     ResultSet rs = stmt.executeQuery();
    //
    //     if (rs.next()) {
    //         frete.put("origem", rs.getString("origem"));
    //         frete.put("destino", rs.getString("destino"));
    //         frete.put("status", rs.getString("status"));
    //         frete.put("data", rs.getString("data"));
    //     }
    //
    //     conn.close();
    // } catch (Exception e) {
    //     e.printStackTrace();
    // }

    // 🚧 Dados temporários enquanto o back-end não está pronto
    String freteId = request.getParameter("id") != null ? request.getParameter("id") : "001";
    String origem = "Jales/SP";
    String destino = "Votuporanga/SP";
    String status = "Em Transporte";
    String data = "05/11/2025";
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rastreamento | Hermes</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/fretes.css">
</head>

<body>
    <jsp:include page="../components/navbar.jsp" />

    <section class="rastreamento-section">
        <div class="rastreamento-container animate-fade-in">
            <div class="rastreamento-header">
                <h1>Rastreamento do Frete #<%= freteId %></h1>
                <p>Acompanhe o andamento da sua entrega</p>
            </div>

            <div class="rastreamento-info">
                <p><strong>Origem:</strong> <%= origem %></p>
                <p><strong>Destino:</strong> <%= destino %></p>
                <p><strong>Data:</strong> <%= data %></p>
                <p><strong>Status Atual:</strong> <span style="color: var(--primary); font-weight:600;"><%= status %></span></p>
            </div>

            <!-- Linha de progresso -->
            <div class="status-bar">
                <div class="status-line active"></div>

                <div class="status-step active">
                    <i class="fas fa-clipboard-check"></i>
                    <span>Solicitado</span>
                </div>
                <div class="status-step active">
                    <i class="fas fa-truck-moving"></i>
                    <span>Em Transporte</span>
                </div>
                <div class="status-step">
                    <i class="fas fa-flag-checkered"></i>
                    <span>Entregue</span>
                </div>
            </div>

            <div class="btns">
                <a href="listaFretes.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
                <a href="avaliacaoFretes.jsp?id=<%= freteId %>" class="btn btn-primary">
                    <i class="fas fa-star"></i> Avaliar Frete
                </a>
            </div>
        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
