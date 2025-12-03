<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete, br.com.hermes.service.FreteService" %>
<%@ page import="java.util.*, br.com.hermes.model.Veiculo, br.com.hermes.service.VeiculoService" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    Integer idUsuario = (Integer) session.getAttribute("usuarioId");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");

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
    
    // Inicializar o serviço para verificar permissões
    FreteService freteService = new FreteService();
    
    // Carregar veículos do usuário logado
    VeiculoService veiculoService = new VeiculoService();
    List<Veiculo> veiculos = veiculoService.listarPorUsuario(idUsuario, tipoUsuario);

    if (veiculos == null) {
        veiculos = java.util.Collections.emptyList();
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
            transition: all 0.3s ease;
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
        
        .frete-actions {
            margin-top: 1rem;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
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
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
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
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 0;
            border-radius: 8px;
            width: 400px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .modal-header {
            background: #e74c3c;
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
        }
        
        .modal-header .close {
            font-size: 24px;
            cursor: pointer;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 0 0 8px 8px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .text-warning {
            color: #e67e22;
            font-size: 14px;
        }
        
        /* Alert messages */
        .alert-floating {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            z-index: 10000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideInRight 0.3s ease;
            max-width: 400px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        .btn i.fa-spinner {
            margin-right: 5px;
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
                
                <!-- NOVO BOTÃO PARA GERENCIAR VEÍCULOS -->
            <a href="<%= request.getContextPath() %>/VeiculoServlet" class="btn btn-primary">
                <i class="fas fa-truck"></i> Gerenciar Meus Veículos
            </a>
        </div>
        </div>
                
                

        <!-- FRETES ACEITOS (PRONTOS PARA INICIAR) -->
        <h2 class="fretes-title">Fretes Aceitos - Prontos para Iniciar</h2>

        <% if (!fretesAceitos.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesAceitos) { 
                    boolean podeExcluir = freteService.usuarioPodeExcluirFrete(f.getId(), idUsuario, tipoUsuario);
                %>
                    <div class="frete-card" id="frete-<%= f.getId() %>">
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

                        <div class="frete-actions">
                            <form action="${pageContext.request.contextPath}/FreteServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="iniciar">
                                <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                                <button type="submit" class="btn btn-primary btn-small">
                                    <i class="fas fa-play"></i> Iniciar Frete
                                </button>
                            </form>
                            
                            <!-- BOTÃO DE EXCLUIR PARA FRETES ACEITOS -->
                            <% if (podeExcluir) { %>
                                <button class="btn btn-danger btn-small btn-excluir-frete" 
                                        data-frete-id="<%= f.getId() %>"
                                        data-frete-origem="<%= f.getOrigem() %>"
                                        data-frete-destino="<%= f.getDestino() %>"
                                        data-frete-tipo="ACEITO">
                                    <i class="fas fa-trash"></i> Excluir
                                </button>
                            <% } %>
                        </div>
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
                <% for (Frete f : fretesEmAndamento) { 
                    boolean podeExcluir = freteService.usuarioPodeExcluirFrete(f.getId(), idUsuario, tipoUsuario);
                %>
                    <div class="frete-card" id="frete-<%= f.getId() %>">
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

                        <div class="frete-actions">
                            <form action="${pageContext.request.contextPath}/FreteServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="concluir">
                                <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                                <button type="submit" class="btn btn-success btn-small" 
                                        onclick="return confirm('Tem certeza que deseja finalizar este frete?')">
                                    <i class="fas fa-check-double"></i> Finalizar Frete
                                </button>
                            </form>
                            
                            <!-- BOTÃO DE EXCLUIR PARA FRETES EM ANDAMENTO -->
                            <% if (podeExcluir) { %>
                                <button class="btn btn-danger btn-small btn-excluir-frete" 
                                        data-frete-id="<%= f.getId() %>"
                                        data-frete-origem="<%= f.getOrigem() %>"
                                        data-frete-destino="<%= f.getDestino() %>"
                                        data-frete-tipo="EM_ANDAMENTO">
                                    <i class="fas fa-trash"></i> Excluir
                                </button>
                            <% } %>
                        </div>
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
        <h2 class="fretes-title" style="margin-top: 40px;">Fretes Concluídos</h2>

        <% if (!fretesConcluidos.isEmpty()) { %>
            <div class="fretes-grid">
                <% for (Frete f : fretesConcluidos) { 
                    boolean podeExcluir = freteService.usuarioPodeExcluirFrete(f.getId(), idUsuario, tipoUsuario);
                %>
                    <div class="frete-card" id="frete-<%= f.getId() %>">
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
                        
                        <div class="frete-actions">
                            <span style="color: #27ae60; font-weight: 600;">
                                <i class="fas fa-check-circle"></i> Frete finalizado com sucesso
                            </span>
                            
                            <!-- BOTÃO DE EXCLUIR PARA FRETES CONCLUÍDOS -->
                            <% if (podeExcluir) { %>
                                <button class="btn btn-danger btn-small btn-excluir-frete" 
                                        data-frete-id="<%= f.getId() %>"
                                        data-frete-origem="<%= f.getOrigem() %>"
                                        data-frete-destino="<%= f.getDestino() %>"
                                        data-frete-tipo="CONCLUIDO">
                                    <i class="fas fa-trash"></i> Excluir
                                </button>
                            <% } %>
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
        
            <div class="veiculos-container" style="margin-top: 50px;">
                <h2 class="fretes-title">Meus Veículos</h2>
                <% if (veiculos.isEmpty()) { %>

                    <div class="empty-state">
                        <i class="fas fa-truck fa-3x"></i>
                        <h3>Nenhum veículo cadastrado</h3>
                        <p>Cadastre seu primeiro veículo para começar a aceitar fretes.</p>
                        <a href="${pageContext.request.contextPath}/dashboard/transportador/cadastrarVeiculo.jsp"
                           class="btn btn-primary" style="margin-top: 1rem;">
                             Cadastrar Veículo
                        </a>
                    </div>

                <% } else { %>

                    <div class="fretes-grid">
                        <% for (Veiculo v : veiculos) { %>

                            <div class="frete-card" style="border-left: 4px solid #2ecc71;">

                                <!-- Título / Placa -->
                                <div class="frete-header">
                                    <h3>
                                        <i class="fas fa-truck"></i>
                                        <%= v.getMarca() %> <%= v.getModelo() %>
                                    </h3>
                                    <span class="frete-status concluido"><%= v.getPlaca() %></span>
                                </div>

                                <!-- Informações -->
                                <div class="frete-info">
                                    <p><strong>Tipo:</strong> <%= v.getTipoVeiculo() %></p>
                                    <p><strong>Ano:</strong> <%= v.getAno() %></p>
                                    <p><strong>Capacidade:</strong> <%= String.format("%.2f", v.getCapacidade()) %> kg</p>
                                    <p><strong>Cor:</strong> <%= v.getCor() != null ? v.getCor() : "Não informada" %></p>
                                    <p><strong>Cadastrado em:</strong> 
                                        <%= v.getDataCadastro() != null 
                                            ? v.getDataCadastro().toLocalDateTime().toLocalDate() 
                                            : "" %>
                                    </p>
                                </div>

                                <div class="frete-actions">
                                    <button class="btn btn-danger btn-small btn-excluir-veiculo"
                                            data-veiculo-id="<%= v.getId() %>"
                                            data-veiculo-modelo="<%= v.getMarca() %> <%= v.getModelo() %>"
                                            data-veiculo-placa="<%= v.getPlaca() %>">
                                        <i class="fas fa-trash"></i> Excluir
                                    </button>
                                </div>
                            </div>

                        <% } %>
                    </div>

                <% } %>

            </div>



</section>

<!-- Modal de Confirmação de Exclusão -->
<div id="modalExcluirFrete" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Confirmar Exclusão</h3>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <p>Tem certeza que deseja excluir o frete de <strong id="freteOrigem"></strong> para <strong id="freteDestino"></strong>?</p>
            <p class="text-warning">⚠️ Esta ação não pode ser desfeita!</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="fecharModalExclusao()">Cancelar</button>
            <button type="button" class="btn btn-danger" id="btnConfirmarExclusao">Sim, Excluir</button>
        </div>
    </div>
</div>

<jsp:include page="../../components/footer.jsp" />

<script>
// Variáveis globais para armazenar dados do frete
let freteAtualId = null;
let freteAtualOrigem = null;
let freteAtualDestino = null;
let freteAtualTipo = null;

function abrirModalExclusao(freteId, origem, destino, tipo) {
    console.log('Abrindo modal para frete:', freteId, origem, destino, tipo);
    freteAtualId = freteId;
    freteAtualOrigem = origem;
    freteAtualDestino = destino;
    freteAtualTipo = tipo;
    
    document.getElementById('freteOrigem').textContent = origem;
    document.getElementById('freteDestino').textContent = destino;
    document.getElementById('modalExcluirFrete').style.display = 'block';
}

function fecharModalExclusao() {
    document.getElementById('modalExcluirFrete').style.display = 'none';
    // Limpa os dados
    freteAtualId = null;
    freteAtualOrigem = null;
    freteAtualDestino = null;
    freteAtualTipo = null;
}

// ✅ ATUALIZA ESTATÍSTICAS CORRETAMENTE
function atualizarEstatisticas(tipoFrete) {
    console.log(`Atualizando estatísticas para tipo: ${tipoFrete}`);
    
    // Mapeia os tipos de frete para os índices dos cards
    const tipoParaIndice = {
        'ACEITO': 1,        // Segundo card (Aceitos - Para Iniciar)
        'EM_ANDAMENTO': 2,  // Terceiro card (Em Andamento) 
        'CONCLUIDO': 3,     // Quarto card (Concluídos)
        'DISPONIVEL': 0     // Primeiro card (Fretes Disponíveis)
    };
    
    const statNumbers = document.querySelectorAll('.stat-number');
    const indice = tipoParaIndice[tipoFrete];
    
    if (indice !== undefined && statNumbers[indice]) {
        const current = parseInt(statNumbers[indice].textContent) || 0;
        if (current > 0) {
            statNumbers[indice].textContent = current - 1;
            console.log(`Estatística atualizada: ${tipoFrete} de ${current} para ${current - 1}`);
        }
    }
}

// ✅ REMOVE O FRETE VISUALMENTE DA LISTA - CORRIGIDO
function removerFreteDaLista(freteId, tipoFrete) {
    console.log(`Removendo frete ${freteId} do tipo ${tipoFrete}`);
    
    // ✅ CORREÇÃO: Usar o ID que vem do servlet, não da variável global
    const freteIdParaRemover = freteId || freteAtualId;
    console.log('ID para remover:', freteIdParaRemover);
    
    if (!freteIdParaRemover) {
        console.error('❌ ID do frete não encontrado para remoção');
        mostrarMensagemErro('Erro: ID do frete não encontrado.');
        return;
    }
    
    const freteElement = document.getElementById(`frete-${freteIdParaRemover}`);
    console.log('Elemento encontrado:', freteElement);
    
    if (freteElement) {
        // Encontra a seção pai para verificar se ficará vazia
        const section = freteElement.closest('.fretes-grid');
        
        // Animação de fade out
        freteElement.style.transition = 'all 0.3s ease';
        freteElement.style.opacity = '0';
        freteElement.style.transform = 'translateX(-100px)';
        
        // Remove após a animação
        setTimeout(() => {
            freteElement.remove();
            
            // Atualiza estatísticas baseadas no tipo
            atualizarEstatisticas(tipoFrete);
            
            // Verifica se a seção ficou vazia
            verificarListaVazia(section);
            
            console.log('✅ Frete removido visualmente com sucesso');
        }, 300);
    } else {
        console.error('❌ Elemento do frete não encontrado. ID:', freteIdParaRemover);
        console.log('Tentando buscar elemento com ID:', `frete-${freteIdParaRemover}`);
        mostrarMensagemErro('Elemento não encontrado na página. Recarregando...');
        setTimeout(() => location.reload(), 2000);
    }
}

// ✅ FUNÇÃO PRINCIPAL DE EXCLUSÃO COM AJAX - CORRIGIDA
function confirmarExclusao() {
    if (!freteAtualId) {
        mostrarMensagemErro('Erro: ID do frete não encontrado.');
        return;
    }

    console.log('Iniciando exclusão do frete:', freteAtualId, 'Tipo:', freteAtualTipo);

    // Mostra loading no botão
    const btnExcluir = document.getElementById('btnConfirmarExclusao');
    const btnOriginalText = btnExcluir.innerHTML;
    btnExcluir.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Excluindo...';
    btnExcluir.disabled = true;

    // ✅ FAZ REQUISIÇÃO AJAX
    fetch('${pageContext.request.contextPath}/ExcluirFreteServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: 'idFrete=' + freteAtualId
    })
    .then(response => {
        console.log('Resposta recebida, status:', response.status);
        if (!response.ok) {
            throw new Error('Erro na rede: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        console.log('Dados recebidos:', data);
        
        // ✅ CORREÇÃO: Usar o freteId da resposta, não da variável global
        const freteIdExcluido = data.freteId || freteAtualId;
        console.log('ID do frete excluído (da resposta):', freteIdExcluido);
        
        if (data.success) {
            // ✅ SUCESSO - Remove o frete da lista usando o ID da resposta
            removerFreteDaLista(freteIdExcluido, freteAtualTipo);
            mostrarMensagemSucesso(data.message || 'Frete excluído com sucesso!');
            fecharModalExclusao();
        } else {
            // ❌ ERRO
            mostrarMensagemErro(data.message || 'Erro ao excluir frete.');
        }
    })
    .catch(error => {
        console.error('Erro na requisição:', error);
        mostrarMensagemErro('Erro de conexão. Tente novamente.');
    })
    .finally(() => {
        // Restaura o botão independente do resultado
        btnExcluir.innerHTML = btnOriginalText;
        btnExcluir.disabled = false;
    });
}

// ✅ VERIFICA SE A LISTA ESTÁ VAZIA E MOSTRA ESTADO VAZIO
function verificarListaVazia(section) {
    if (!section) return;
    
    const fretesCards = section.querySelectorAll('.frete-card');
    const emptyState = section.querySelector('.empty-state');
    const sectionTitle = section.previousElementSibling;
    
    if (fretesCards.length === 0) {
        if (!emptyState) {
            const emptyDiv = document.createElement('div');
            emptyDiv.className = 'empty-state';
            
            // Mensagem personalizada baseada no título da seção
            let mensagem = 'Nenhum frete encontrado';
            let icon = 'fa-box-open';
            
            if (sectionTitle && sectionTitle.textContent.includes('Aceitos')) {
                mensagem = 'Nenhum frete aguardando início';
                icon = 'fa-clock';
            } else if (sectionTitle && sectionTitle.textContent.includes('Andamento')) {
                mensagem = 'Nenhum frete em andamento';
                icon = 'fa-truck-moving';
            } else if (sectionTitle && sectionTitle.textContent.includes('Concluídos')) {
                mensagem = 'Nenhum frete concluído';
                icon = 'fa-check-circle';
            } else if (sectionTitle && sectionTitle.textContent.includes('Últimos')) {
                mensagem = 'Você ainda não aceitou nenhum frete';
                icon = 'fa-truck-loading';
            }
            
            emptyDiv.innerHTML = `
                <i class="fas ${icon} fa-3x"></i>
                <h3>${mensagem}</h3>
                <p>${mensagem.includes('aguardando') ? 'Todos os fretes aceitos já estão em andamento ou concluídos.' : 
                    mensagem.includes('andamento') ? 'Você não tem fretes em andamento no momento.' :
                    mensagem.includes('concluído') ? 'Os fretes concluídos aparecerão aqui.' :
                    'Explore os fretes disponíveis para começar a trabalhar.'}</p>
            `;
            
            // Adiciona botão de ação se for a seção de últimos fretes
            if (mensagem.includes('nenhum frete')) {
                emptyDiv.innerHTML += `
                    <a href="${pageContext.request.contextPath}/FreteListarServlet" class="btn btn-primary" style="margin-top: 1rem;">
                        <i class="fas fa-search"></i> Buscar Fretes
                    </a>
                `;
            }
            
            section.appendChild(emptyDiv);
        }
    } else {
        // Remove empty state se houver fretes
        if (emptyState) {
            emptyState.remove();
        }
    }
}

// ✅ MOSTRA MENSAGEM DE SUCESSO
function mostrarMensagemSucesso(mensagem) {
    showFloatingMessage(mensagem, 'success');
}

// ✅ MOSTRA MENSAGEM DE ERRO
function mostrarMensagemErro(mensagem) {
    showFloatingMessage(mensagem, 'error');
}

// ✅ FUNÇÃO UNIFICADA PARA MENSAGENS
function showFloatingMessage(mensagem, tipo) {
    // Remove mensagens anteriores
    const alertasAntigos = document.querySelectorAll('.alert-floating');
    alertasAntigos.forEach(alerta => alerta.remove());
    
    // Cria nova mensagem
    const alerta = document.createElement('div');
    alerta.className = `alert-floating alert-${tipo}`;
    
    const icon = tipo === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle';
    alerta.innerHTML = `<i class="fas ${icon}"></i> ${mensagem}`;
    
    document.body.appendChild(alerta);
    
    // Remove após alguns segundos
    setTimeout(() => {
        if (alerta.parentNode) {
            alerta.remove();
        }
    }, tipo === 'success' ? 3000 : 5000);
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    const botoesExcluir = document.querySelectorAll('.btn-excluir-frete');
    
    botoesExcluir.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const freteId = this.getAttribute('data-frete-id');
            const origem = this.getAttribute('data-frete-origem');
            const destino = this.getAttribute('data-frete-destino');
            const tipo = this.getAttribute('data-frete-tipo');
            
            abrirModalExclusao(freteId, origem, destino, tipo);
        });
    });

    // Botão de confirmar exclusão
    document.getElementById('btnConfirmarExclusao').addEventListener('click', confirmarExclusao);

    // Fechar modal
    document.querySelector('.modal .close')?.addEventListener('click', fecharModalExclusao);
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('modalExcluirFrete');
        if (event.target === modal) {
            fecharModalExclusao();
        }
    });

    // Prevenir comportamento padrão de botões dentro de formulários
    document.querySelectorAll('.btn-excluir-frete').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });
    });
});
</script>

</body>
</html>