<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");

    List<Frete> fretesDisponiveis = (List<Frete>) request.getAttribute("fretesDisponiveis");
    List<Frete> fretesEmAndamento = (List<Frete>) request.getAttribute("fretesEmAndamento");
    List<Frete> fretesConcluidos = (List<Frete>) request.getAttribute("fretesConcluidos");
    List<Frete> fretesRecentes = (List<Frete>) request.getAttribute("fretesRecentes");
    List<Frete> fretesAceitos = (List<Frete>) request.getAttribute("fretesAceitos");

    if (fretesDisponiveis == null) fretesDisponiveis = java.util.Collections.emptyList();
    if (fretesEmAndamento == null) fretesEmAndamento = java.util.Collections.emptyList();
    if (fretesConcluidos == null) fretesConcluidos = java.util.Collections.emptyList();
    if (fretesRecentes == null) fretesRecentes = java.util.Collections.emptyList();
    if (fretesAceitos == null) fretesAceitos = java.util.Collections.emptyList();

    if (nome == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Painel do Transportador | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* Estilos específicos para o transportador */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 4px solid #3498db;
        }
        
        .stat-card i {
            font-size: 2rem;
            color: #3498db;
            margin-bottom: 0.5rem;
        }
        
        .stat-card h3 {
            margin: 0.5rem 0;
            color: #2c3e50;
            font-size: 1rem;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #2c3e50;
            margin: 0;
        }
        
        .fretes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        
        .frete-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #3498db;
        }
        
        .frete-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .frete-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .frete-status {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .frete-status.pendente {
            background: #e74c3c;
            color: white;
        }
        
        .frete-status.aceito {
            background: #3498db;
            color: white;
        }
        
        .frete-status.em_andamento {
            background: #f39c12;
            color: white;
        }
        
        .frete-status.concluido {
            background: #27ae60;
            color: white;
        }
        
        .frete-info {
            margin-bottom: 1rem;
        }
        
        .frete-info p {
            margin: 0.25rem 0;
            color: #5a6c7d;
        }
        
        .frete-info strong {
            color: #2c3e50;
        }
        
        .frete-action {
            margin-top: 1rem;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-success:hover {
            background: #219653;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .btn-small {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #7f8c8d;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #bdc3c7;
        }
        
        .empty-state h3 {
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }
        
        .empty-state p {
            margin: 0;
        }
        
        .fretes-title {
            color: #2c3e50;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e9ecef;
        }
        
        .section-title {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .section-subtitle {
            color: #7f8c8d;
            margin-bottom: 2rem;
        }
    </style>
</head>

<body>

<jsp:include page="../../components/navbar.jsp" />

<section class="dashboard-section">
    <div class="dashboard-container">

        <div class="dashboard-header">
            <h1 class="section-title">Bem-vindo, <%= nome %></h1>
            <p class="section-subtitle">Gerencie seus fretes e acompanhe suas atividades</p>
        </div>

        <!-- CARDS DE ESTATÍSTICAS -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-truck"></i>
                <h3>Fretes Disponíveis</h3>
                <p class="stat-number"><%= fretesDisponiveis.size() %></p>
            </div>

            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <h3>Aceitos - Para Iniciar</h3>
                <p class="stat-number"><%= fretesAceitos.size() %></p>
            </div>

            <div class="stat-card">
                <i class="fas fa-route"></i>
                <h3>Em Andamento</h3>
                <p class="stat-number"><%= fretesEmAndamento.size() %></p>
            </div>

            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <h3>Concluídos</h3>
                <p class="stat-number"><%= fretesConcluidos.size() %></p>
            </div>
        </div>

        <!-- BOTÃO PARA VER FRETES DISPONÍVEIS -->
        <div style="text-align: center; margin: 2rem 0;">
            <a href="${pageContext.request.contextPath}/FreteListarServlet" class="btn btn-primary">
                <i class="fas fa-truck-loading"></i> Ver Todos os Fretes Disponíveis
            </a>
        </div>

        <!-- FRETES ACEITOS (PRONTOS PARA INICIAR) -->
        <h2 class="fretes-title">Fretes Aceitos - Prontos para Iniciar</h2>

        <% if (!fretesAceitos.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesAceitos) { %>
                    <div class="frete-card">
                        <div class="frete-header">
                            <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                            <span class="frete-status aceito">ACEITO</span>
                        </div>
                        
                        <div class="frete-info">
                            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                            <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                            <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                            <p><strong>Cliente:</strong> ID <%= f.getIdCliente() %></p>
                            <p><strong>Data Solicitação:</strong> 
                                <%= f.getDataSolicitacao() != null ? f.getDataSolicitacao().toLocalDateTime().toLocalDate() : "" %>
                            </p>
                        </div>

                        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" class="frete-action">
                            <input type="hidden" name="action" value="iniciar">
                            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                            <button type="submit" class="btn btn-primary btn-small">
                                <i class="fas fa-play"></i> Iniciar Frete
                            </button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-clock fa-3x"></i>
                <h3>Nenhum frete aguardando início</h3>
                <p>Todos os fretes aceitos já estão em andamento ou concluídos.</p>
            </div>
        <% } %>

        <!-- FRETES EM ANDAMENTO -->
        <h2 class="fretes-title" style="margin-top: 40px;">Fretes em Andamento</h2>

        <% if (!fretesEmAndamento.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesEmAndamento) { %>
                    <div class="frete-card">
                        <div class="frete-header">
                            <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                            <span class="frete-status em_andamento">EM ANDAMENTO</span>
                        </div>
                        
                        <div class="frete-info">
                            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                            <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                            <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                            <p><strong>Cliente:</strong> ID <%= f.getIdCliente() %></p>
                            <p><strong>Data Início:</strong> 
                                <%= f.getDataSolicitacao() != null ? f.getDataSolicitacao().toLocalDateTime().toLocalDate() : "" %>
                            </p>
                        </div>

                        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" class="frete-action">
                            <input type="hidden" name="action" value="concluir">
                            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                            <button type="submit" class="btn btn-success btn-small" 
                                    onclick="return confirm('Tem certeza que deseja finalizar este frete?')">
                                <i class="fas fa-check-double"></i> Finalizar Frete
                            </button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-truck-moving fa-3x"></i>
                <h3>Nenhum frete em andamento</h3>
                <p>Você não tem fretes em andamento no momento.</p>
            </div>
        <% } %>

        <!-- FRETES CONCLUÍDOS -->
        <h2 class="fretes-title" style="margin-top: 40px;">Fretes Concluídos Recentemente</h2>

        <% if (!fretesConcluidos.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesConcluidos) { %>
                    <div class="frete-card">
                        <div class="frete-header">
                            <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                            <span class="frete-status concluido">CONCLUÍDO</span>
                        </div>
                        
                        <div class="frete-info">
                            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                            <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                            <p><strong>Cliente:</strong> ID <%= f.getIdCliente() %></p>
                            <p><strong>Data Conclusão:</strong> 
                                <%= f.getDataConclusao() != null ? f.getDataConclusao().toLocalDateTime().toLocalDate() : "" %>
                            </p>
                        </div>
                        
                        <div class="frete-action">
                            <span style="color: #27ae60; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Frete finalizado com sucesso
                            </span>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-check-circle fa-3x"></i>
                <h3>Nenhum frete concluído</h3>
                <p>Os fretes concluídos aparecerão aqui.</p>
            </div>
        <% } %>

        <!-- ÚLTIMOS FRETES ACEITOS -->
        <h2 class="fretes-title" style="margin-top: 40px;">Últimos Fretes Aceitos</h2>

        <% if (!fretesRecentes.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesRecentes) { %>
                    <div class="frete-card">
                        <div class="frete-header">
                            <h3><i class="fas fa-truck-moving"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                            <span class="frete-status <%= f.getStatus().toLowerCase() %>">
                                <%= f.getStatus().toUpperCase() %>
                            </span>
                        </div>
                        
                        <div class="frete-info">
                            <p><strong>Status:</strong> <%= f.getStatus() %></p>
                            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                            <p><strong>Data Solicitação:</strong>
                                <%= (f.getDataSolicitacao() != null ? f.getDataSolicitacao().toLocalDateTime().toLocalDate() : "") %>
                            </p>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-truck-loading fa-3x"></i>
                <h3>Você ainda não aceitou nenhum frete</h3>
                <p>Explore os fretes disponíveis para começar a trabalhar.</p>
                <a href="${pageContext.request.contextPath}/FreteListarServlet" class="btn btn-primary" style="margin-top: 1rem;">
                    <i class="fas fa-search"></i> Buscar Fretes
                </a>
            </div>
        <% } %>

    </div>
</section>

<jsp:include page="../../components/footer.jsp" />

<script>
    // Confirmação para ações importantes
    document.addEventListener('DOMContentLoaded', function() {
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            const button = form.querySelector('button[type="submit"]');
            if (button && button.textContent.includes('Finalizar')) {
                form.addEventListener('submit', function(e) {
                    if (!confirm('Tem certeza que deseja finalizar este frete? Esta ação não pode ser desfeita.')) {
                        e.preventDefault();
                    }
                });
            }
        });
    });
</script>

</body>
</html>