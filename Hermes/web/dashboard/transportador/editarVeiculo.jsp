<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="br.com.hermes.model.Veiculo" %>

<%
    Veiculo v = (Veiculo) request.getAttribute("veiculo");

    if (v == null) {
        response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Editar Veículo | Hermes</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
         body {
            background: #eef2f7;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .container {
            max-width: 650px;
            margin: 3rem auto;
            margin-top: 12rem;
            background: white;
            padding: 2.5rem;
            border-radius: 18px;
            box-shadow: 0px 10px 35px rgba(0,0,0,0.15);
            animation: fadeIn .4s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        h1 {
            margin-bottom: 1rem;
            color: #2c3e50;
            text-align: center;
            font-size: 28px;
            font-weight: 700;
        }

        .form-icon {
            text-align: center;
            font-size: 50px;
            margin-bottom: 1rem;
        }

        .input-group {
            margin-bottom: 1.4rem;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #2c3e50;
            font-weight: 600;
        }

        input, select {
            width: 100%;
            padding: 13px;
            border-radius: 10px;
            border: 1.5px solid #d0d7de;
            background: #fdfdfd;
            font-size: 15px;
            transition: all .2s;
        }

        input:focus, select:focus {
            border-color: #3498db;
            box-shadow: 0px 0px 6px rgba(52, 152, 219, 0.35);
            background: white;
            outline: none;
        }

        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 17px;
            margin-top: .5rem;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            justify-content: center;
            gap: 10px;
            align-items: center;
            transition: all .25s ease;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            background: linear-gradient(135deg, #2980b9, #1f6fa5);
            box-shadow: 0px 8px 20px rgba(52,152,219,0.45);
        }

        .btn-back {
            margin-top: 1.2rem;
            text-align: center;
            display: block;
            color: #7f8c8d;
            text-decoration: none;
            font-weight: 500;
            transition: all .25s;
        }

        .btn-back:hover {
            color: #34495e;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<jsp:include page="../../components/navbar.jsp" />

<div class="container">
    <h1><i class="fas fa-edit"></i> Editar Veículo</h1>

    <form action="${pageContext.request.contextPath}/VeiculoServlet" method="post">
        <input type="hidden" name="action" value="atualizar">
        <input type="hidden" name="id" value="<%= v.getId() %>">

        <div class="input-group">
            <label>Tipo do Veículo</label>
            <select name="tipoVeiculo" required>
                <option value="Caminhão" <%= v.getTipoVeiculo().equals("Caminhão") ? "selected" : "" %>>Caminhão</option>
                <option value="Carro" <%= v.getTipoVeiculo().equals("Carro") ? "selected" : "" %>>Carro</option>
                <option value="Van" <%= v.getTipoVeiculo().equals("Van") ? "selected" : "" %>>Van</option>
                <option value="Moto" <%= v.getTipoVeiculo().equals("Moto") ? "selected" : "" %>>Moto</option>
                <option value="Utilitário" <%= v.getTipoVeiculo().equals("Utilitário") ? "selected" : "" %>>Utilitário</option>
            </select>
        </div>

        <div class="input-group">
            <label>Marca</label>
            <input type="text" name="marca" value="<%= v.getMarca() %>" required>
        </div>

        <div class="input-group">
            <label>Modelo</label>
            <input type="text" name="modelo" value="<%= v.getModelo() %>" required>
        </div>

        <div class="input-group">
            <label>Ano</label>
            <input type="number" name="ano" min="1980" max="2050" value="<%= v.getAno() %>" required>
        </div>

        <div class="input-group">
            <label>Placa</label>
            <input type="text" name="placa" value="<%= v.getPlaca() %>" required>
        </div>

        <div class="input-group">
            <label>Capacidade (kg)</label>
            <input type="number" step="0.01" name="capacidade" value="<%= v.getCapacidade() %>" required>
        </div>

        <div class="input-group">
            <label>Cor</label>
            <input type="text" name="cor" value="<%= v.getCor() %>">
        </div>

        <button class="btn-primary">
            <i class="fas fa-save"></i> Salvar Alterações
        </button>
    </form>

    <a href="${pageContext.request.contextPath}/VeiculoServlet" class="btn-back">
        <i class="fas fa-arrow-left"></i> Voltar para meus veículos
    </a>
</div>

</body>
</html>
