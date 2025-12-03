<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete, br.com.hermes.service.FreteService" %>

<%
    String nome = (String) session.getAttribute("usuarioNome");
    Integer idUsuario = (Integer) session.getAttribute("usuarioId");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");

    if (nome == null || idUsuario == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }

    List<Frete> recentes = (List<Frete>) request.getAttribute("fretesRecentes");
    
    // Inicializar o serviço para verificar permissões
    FreteService freteService = new FreteService();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Painel do Cliente | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body>
<jsp:include page="../../components/navbar.jsp" />

<!-- Mensagens de feedback -->
<% if (session.getAttribute("mensagemSucesso") != null) { %>
    <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 12px; border-radius: 4px; margin: 20px; border: 1px solid #c3e6cb;">
        <i class="fas fa-check-circle"></i> <%= session.getAttribute("mensagemSucesso") %>
        <% session.removeAttribute("mensagemSucesso"); %>
    </div>
<% } %>

<% if (session.getAttribute("mensagemErro") != null) { %>
    <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 4px; margin: 20px; border: 1px solid #f5c6cb;">
        <i class="fas fa-exclamation-triangle"></i> <%= session.getAttribute("mensagemErro") %>
        <% session.removeAttribute("mensagemErro"); %>
    </div>
<% } %>

<section class="dashboard-section">
    <div class="dashboard-container animate-fade-in">

        <div class="dashboard-header">
            <h1 class="section-title">Painel do Cliente</h1>
            <p class="section-subtitle">Bem-vindo, <strong><%= nome %></strong>!</p>
        </div>

        <div class="actions-bar">
            <a href="${pageContext.request.contextPath}/fretes/solicitarFretes.jsp" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Solicitar Novo Frete
            </a>
            <a href="${pageContext.request.contextPath}/FreteServlet?action=listar"
            class="btn btn-primary">
            <i class="fas fa-list"></i> Ver Todos
        </a>
        </div>

        <h2 class="fretes-title">Últimos Fretes</h2>
        <div class="fretes-grid">

            <% if (recentes != null && !recentes.isEmpty()) { %>
                <% for (Frete f : recentes) { 
                    boolean podeExcluir = freteService.usuarioPodeExcluirFrete(f.getId(), idUsuario, tipoUsuario);
                %>
                <div class="frete-card" id="frete-<%= f.getId() %>">
                    <div class="frete-info">
                        <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>

                        <p><strong>Status:</strong> 
                            <span class="status <%= f.getStatus().toLowerCase() %>">
                                <%= f.getStatus().toUpperCase() %>
                            </span>
                        </p>

                        <p><strong>Data:</strong> <%= f.getDataSolicitacao().toLocalDateTime().toLocalDate() %></p>
                        <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                        <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                    </div>

                    <div class="frete-actions">
                        <% if ("aceito".equals(f.getStatus())) { %>
                            <a class="btn btn-secondary btn-small"
                                href="${pageContext.request.contextPath}/fretes/rastreamento.jsp?id=<%= f.getId() %>">
                                <i class="fas fa-route"></i> Rastrear
                            </a>
                        <% } else if ("concluido".equals(f.getStatus())) { %>
                            <a class="btn btn-primary btn-small"
                               href="${pageContext.request.contextPath}/fretes/avaliacaoFretes.jsp?id=<%= f.getId() %>">
                                <i class="fas fa-star"></i> Avaliar
                            </a>
                        <% } %>
                        
                        <!-- BOTÃO DE EXCLUIR -->
                        <% if (podeExcluir) { %>
                            <button class="btn btn-danger btn-small btn-excluir-frete" 
                                    data-frete-id="<%= f.getId() %>"
                                    data-frete-origem="<%= f.getOrigem() %>"
                                    data-frete-destino="<%= f.getDestino() %>">
                                <i class="fas fa-trash"></i> Excluir
                            </button>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <p class="empty-text">Nenhum frete encontrado.</p>
            <% } %>

        </div>
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
            <button type="button" class="btn btn-danger" onclick="confirmarExclusao()">Sim, Excluir</button>   </div>
    </div>
</div>

<jsp:include page="../../components/footer.jsp" />

<script>
// Variáveis globais para armazenar dados do frete
let freteAtualId = null;
let freteAtualOrigem = null;
let freteAtualDestino = null;

function abrirModalExclusao(freteId, origem, destino) {
    freteAtualId = freteId;
    freteAtualOrigem = origem;
    freteAtualDestino = destino;
    
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
}

// ✅ FUNÇÃO PRINCIPAL DE EXCLUSÃO COM AJAX
function confirmarExclusao() {
    if (!freteAtualId) {
        alert('Erro: ID do frete não encontrado.');
        return;
    }

    // Mostra loading no botão
    const btnExcluir = document.querySelector('#modalExcluirFrete .btn-danger');
    const btnOriginalText = btnExcluir.innerHTML;
    btnExcluir.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Excluindo...';
    btnExcluir.disabled = true;

    // ✅ FAZ REQUISIÇÃO AJAX COM HEADER ESPECÍFICO
    fetch('${pageContext.request.contextPath}/ExcluirFreteServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest' // ✅ IDENTIFICA COMO AJAX
        },
        body: 'idFrete=' + freteAtualId
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erro na rede: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            // ✅ SUCESSO - Remove o frete da lista e mostra mensagem
            removerFreteDaLista(freteAtualId);
            mostrarMensagemSucesso(data.message);
            fecharModalExclusao();
        } else {
            // ❌ ERRO - Mostra mensagem de erro
            mostrarMensagemErro(data.message);
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        mostrarMensagemErro('Erro de conexão. Tente novamente.');
    })
    .finally(() => {
        // Restaura o botão independente do resultado
        btnExcluir.innerHTML = btnOriginalText;
        btnExcluir.disabled = false;
    });
}

// ✅ REMOVE O FRETE VISUALMENTE DA LISTA
function removerFreteDaLista(freteId) {
    // Encontra o elemento do frete
    const freteElement = document.getElementById(`frete-${freteId}`);
    
    if (freteElement) {
        // Animação de fade out
        freteElement.style.transition = 'all 0.3s ease';
        freteElement.style.opacity = '0';
        freteElement.style.transform = 'translateX(-100px)';
        
        // Remove após a animação
        setTimeout(() => {
            freteElement.remove();
            atualizarEstatisticas();
            verificarListaVazia();
        }, 300);
    } else {
        // Fallback: recarrega a página se não encontrar o elemento
        console.log('Elemento não encontrado, recarregando página...');
        location.reload();
    }
}

// ✅ ATUALIZA ESTATÍSTICAS (opcional)
function atualizarEstatisticas() {
    // Atualiza contador de fretes
    const fretesGrid = document.querySelector('.fretes-grid');
    const fretesCards = fretesGrid.querySelectorAll('.frete-card');
    const emptyText = document.querySelector('.empty-text');
    
    // Se não há mais fretes, mostra mensagem
    if (fretesCards.length === 0 && !emptyText) {
        const emptyState = document.createElement('p');
        emptyState.className = 'empty-text';
        emptyState.textContent = 'Nenhum frete encontrado.';
        fretesGrid.appendChild(emptyState);
    }
}

// ✅ VERIFICA SE A LISTA ESTÁ VAZIA
function verificarListaVazia() {
    const fretesGrid = document.querySelector('.fretes-grid');
    if (!fretesGrid) return;
    
    const fretesCards = fretesGrid.querySelectorAll('.frete-card');
    const emptyText = fretesGrid.querySelector('.empty-text');
    
    if (fretesCards.length === 0 && !emptyText) {
        const emptyState = document.createElement('p');
        emptyState.className = 'empty-text';
        emptyState.textContent = 'Nenhum frete encontrado.';
        fretesGrid.appendChild(emptyState);
    } else if (fretesCards.length > 0 && emptyText) {
        emptyText.remove();
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
        btn.addEventListener('click', function() {
            const freteId = this.getAttribute('data-frete-id');
            const origem = this.getAttribute('data-frete-origem');
            const destino = this.getAttribute('data-frete-destino');
            
            abrirModalExclusao(freteId, origem, destino);
        });
    });

    // Fechar modal
    document.querySelector('.modal .close')?.addEventListener('click', fecharModalExclusao);
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('modalExcluirFrete');
        if (event.target === modal) {
            fecharModalExclusao();
        }
    });
});
</script>

<style>
/* Estilos para o modal e botão de excluir */
.btn-excluir-frete {
    background: #e74c3c;
    color: white;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.3s;
    margin-left: 10px;
}

.btn-excluir-frete:hover {
    background: #c0392b;
}

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

.btn {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 600;
}

.btn-danger {
    background: #e74c3c;
    color: white;
}

.btn-danger:hover {
    background: #c0392b;
}

.btn-secondary {
    background: #95a5a6;
    color: white;
}

.btn-secondary:hover {
    background: #7f8c8d;
}

.btn-small {
    padding: 6px 12px;
    font-size: 12px;
}

.frete-actions {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-top: 10px;
}

/* Estilos para mensagens flutuantes */
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

/* Animação para remoção de fretes */
.frete-card {
    transition: all 0.3s ease;
}
</style>
</body>
</html>