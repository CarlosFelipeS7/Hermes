<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Fretes | Hermes</title>

    <!-- Fontes e ícones -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Estilos principais -->
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/fretes.css"> <!-- Arquivo dedicado para o estilo da tabela -->
</head>
<body>
    <jsp:include page="../components/navbar.jsp" />

    <section class="frete-section">
        <div class="frete-container animate-fade-in">
            <h1 class="section-title">Meus Fretes</h1>
            <p class="section-subtitle">Acompanhe todos os seus pedidos de transporte</p>

            <div class="frete-grid">
                <table class="frete-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Origem</th>
                            <th>Destino</th>
                            <th>Data</th>
                            <th>Tipo de Carga</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>001</td>
                            <td>Jales/SP</td>
                            <td>Votuporanga/SP</td>
                            <td>05/11/2025</td>
                            <td>Residencial</td>
                            <td><span class="status aguardando">Aguardando</span></td>
                            <td>
                                <a href="rastreamento.jsp?id=001" class="btn btn-secondary btn-small">
                                    <i class="fas fa-route"></i> Ver Rastreamento
                                </a>
                            </td>
                        </tr>

                        <tr>
                            <td>002</td>
                            <td>Santa Fé do Sul/SP</td>
                            <td>Fernandópolis/SP</td>
                            <td>12/11/2025</td>
                            <td>Comercial</td>
                            <td><span class="status andamento">Em Andamento</span></td>
                            <td>
                                <a href="rastreamento.jsp?id=002" class="btn btn-secondary btn-small">
                                    <i class="fas fa-route"></i> Ver Rastreamento
                                </a>
                            </td>
                        </tr>

                        <tr>
                            <td>003</td>
                            <td>Urânia/SP</td>
                            <td>Jales/SP</td>
                            <td>20/11/2025</td>
                            <td>Frágil</td>
                            <td><span class="status entregue">Entregue</span></td>
                            <td>
                                <a href="avaliacaoFretes.jsp?id=003" class="btn btn-primary btn-small">
                                    <i class="fas fa-star"></i> Avaliar
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <jsp:include page="../components/footer.jsp" />
</body>
</html>
