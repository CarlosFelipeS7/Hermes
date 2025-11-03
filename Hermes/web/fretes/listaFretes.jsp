<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<!--
<%
    /* Recupera ID do cliente logado
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    if (usuarioId == null) {
        response.sendRedirect("../auth/login/login.jsp");
        return;
    }

    List<Map<String, String>> fretes = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hermes_db", "usuario", "senha");

        String sql = "SELECT id, origem, destino, data, tipo_carga, status FROM fretes WHERE cliente_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, usuarioId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> f = new HashMap<>();
            f.put("id", rs.getString("id"));
            f.put("origem", rs.getString("origem"));
            f.put("destino", rs.getString("destino"));
            f.put("data", rs.getString("data"));
            f.put("tipo", rs.getString("tipo_carga"));
            f.put("status", rs.getString("status"));
            fretes.add(f);
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
   */
%>
-->
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Fretes - Hermes</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
    <jsp:include page="../components/navbar.jsp" />

    <section class="features" style="padding-top:8rem;">
        <div class="container">
            <h1 class="section-title">Meus Fretes</h1>
            <p class="section-subtitle">Acompanhe seus pedidos de transporte</p>

            <table class="frete-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Origem</th>
                        <th>Destino</th>
                        <th>Data</th>
                        <th>Tipo</th>
                        <th>Status</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    
                </tbody>
            </table>
        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
