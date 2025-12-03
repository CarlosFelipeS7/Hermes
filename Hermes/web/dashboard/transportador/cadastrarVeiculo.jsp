<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastrar Veículo | Hermes</title>

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

    <div class="form-icon">
        <i class="fas fa-truck"></i>
    </div>

    <h1>Cadastrar Veículo</h1>

    <form action="${pageContext.request.contextPath}/VeiculoServlet" method="post">
        <input type="hidden" name="action" value="cadastrar">

        <div class="input-group">
            <label>Tipo do Veículo</label>
            <select name="tipoVeiculo" required>
                <option value="">Selecione...</option>
                <option value="Caminhão">Caminhão</option>
                <option value="Carro">Carro</option>
                <option value="Van">Van</option>
                <option value="Moto">Moto</option>
                <option value="Utilitário">Utilitário</option>
            </select>
        </div>

        <div class="input-group">
            <label>Marca</label>
            <input type="text" name="marca" placeholder="Ex: Volkswagen, Mercedes, Ford" required>
        </div>

        <div class="input-group">
            <label>Modelo</label>
            <input type="text" name="modelo" placeholder="Ex: Delivery 9.170, Sprinter, Cargo 816" required>
        </div>

        <div class="input-group">
            <label>Ano</label>
            <input type="number" name="ano" min="1980" max="2050" placeholder="Ex: 2019" required>
        </div>

        <div class="input-group">
            <label>Placa</label>
            <input type="text" name="placa" placeholder="ABC1234" required>
        </div>

        <div class="input-group">
            <label>Capacidade (kg)</label>
            <input type="number" step="0.01" name="capacidade" placeholder="Ex: 3000" required>
        </div>

        <div class="input-group">
            <label>Cor</label>
            <input type="text" name="cor" placeholder="Ex: Branco, Prata, Azul">
        </div>

        <button class="btn-primary">
            <i class="fas fa-save"></i> Cadastrar Veículo
        </button>

    </form>

    <a href="${pageContext.request.contextPath}/VeiculoServlet" class="btn-back">
        <i class="fas fa-arrow-left"></i> Voltar para meus veículos
    </a>
</div>

</body>
</html>
