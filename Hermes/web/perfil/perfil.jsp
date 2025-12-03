<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="br.com.hermes.model.Usuario, br.com.hermes.model.Frete, br.com.hermes.model.Avaliacao, java.util.List" %>

<%
    String base = request.getContextPath();
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    List<Frete> historico = (List<Frete>) request.getAttribute("historicoFretes");
    List<Avaliacao> avaliacoes = (List<Avaliacao>) request.getAttribute("avaliacoes");
    List<Avaliacao> avaliacoesFeitas = (List<Avaliacao>) request.getAttribute("avaliacoesFeitas");
    Double mediaAvaliacoes = (Double) request.getAttribute("mediaAvaliacoes");
    String tipoUsuario = (String) request.getAttribute("tipoUsuario");

    String nome = (usuario != null && usuario.getNome() != null) ? usuario.getNome() : "";
    String email = (usuario != null && usuario.getEmail() != null) ? usuario.getEmail() : "";
    String telefone = (usuario != null && usuario.getTelefone() != null) ? usuario.getTelefone() : "";
    String estado = (usuario != null && usuario.getEstado() != null) ? usuario.getEstado() : "";
    String cidade = (usuario != null && usuario.getCidade() != null) ? usuario.getCidade() : "";
    String endereco = (usuario != null && usuario.getEndereco() != null) ? usuario.getEndereco() : "";
    String documento = (usuario != null && usuario.getDocumento() != null) ? usuario.getDocumento() : "";
    String veiculo = (usuario != null && usuario.getVeiculo() != null) ? usuario.getVeiculo() : "";
    String ddd = (usuario != null && usuario.getDdd() != null) ? usuario.getDdd() : "";
    String tipo = (usuario != null && usuario.getTipoUsuario() != null) ? usuario.getTipoUsuario() : "";

    // Inicial do avatar
    String inicial = "";
    if (nome != null && !nome.trim().isEmpty()) {
        inicial = nome.trim().substring(0, 1).toUpperCase();
    }

    boolean sucesso = "1".equals(request.getParameter("ok"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Meu Perfil | Hermes</title>

    <!-- Fonte & Ícones -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- CSS global + CSS específico do perfil -->
    <link rel="stylesheet" href="<%= base %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= base %>/assets/css/perfil.css">
    
   
    
</head>
<body>

<% if (sucesso) { %>
<div class="alert-overlay">
    <div class="alert-box success">
        <i class="fa-solid fa-check-circle"></i>
        <span>Perfil atualizado com sucesso!</span>
    </div>
</div>
<script>
    setTimeout(function() {
        var el = document.querySelector('.alert-overlay');
        if (el) el.style.display = 'none';
    }, 3000);
</script>
<% } %>

<div class="perfil-page">

    <!-- Seta verde para voltar -->
    <a href="<%= base %>/index.jsp" class="perfil-back-btn">
        <i class="fa-solid fa-arrow-left"></i>
        <span>Voltar</span>
    </a>

    <div class="perfil-wrapper">

        <div class="perfil-header">
            <div>
                <h1>Meu Perfil</h1>
                <p>
                    <%
                        if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                    %>
                        Gerencie seus dados, veículo e acompanhe seus fretes e avaliações.
                    <%
                        } else {
                    %>
                        Atualize suas informações e acompanhe o histórico de fretes e avaliações.
                    <%
                        }
                    %>
                </p>
            </div>
            <div class="perfil-tag">
                <i class="fa-solid fa-user-gear"></i>
                <span><%= tipo.equalsIgnoreCase("transportador") ? "Transportador" : "Cliente" %></span>
            </div>
        </div>

        <div class="perfil-main">

            <!-- LADO ESQUERDO: Avatar + infos rápidas -->
            <aside class="perfil-sidebar">
                <div class="perfil-card perfil-user-card">
                    <div class="perfil-avatar-wrapper">
                        <!-- Avatar com inicial -->
                        <div class="perfil-avatar">
                            <span><%= inicial %></span>
                        </div>
                        <button type="button" class="btn-avatar-upload">
                            <i class="fa-solid fa-camera"></i>
                        </button>
                    </div>

                    <h2 class="perfil-name"><%= nome %></h2>
                    <p class="perfil-email"><i class="fa-solid fa-envelope"></i> <%= email %></p>
                    <p class="perfil-phone"><i class="fa-solid fa-phone"></i> <%= telefone %></p>

                    <div class="perfil-location">
                        <i class="fa-solid fa-location-dot"></i>
                        <span>
                            <%= (cidade.isEmpty() && estado.isEmpty())
                                ? "Localização não informada"
                                : (cidade + (cidade.isEmpty() || estado.isEmpty() ? "" : " - ") + estado) %>
                        </span>
                    </div>

                    <!-- MÉDIA DE AVALIAÇÕES (APENAS TRANSPORTADOR) -->
                    <% if ("transportador".equalsIgnoreCase(tipoUsuario) && mediaAvaliacoes != null && mediaAvaliacoes > 0) { %>
                    <div class="perfil-rating">
                        <div class="rating-stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star <%= i <= mediaAvaliacoes ? "active" : "" %>"></i>
                            <% } %>
                        </div>
                        <span class="rating-text"><%= String.format("%.1f", mediaAvaliacoes) %> (<%= avaliacoes != null ? avaliacoes.size() : 0 %> avaliações)</span>
                    </div>
                    <% } %>

                    <div class="perfil-badge">
                        <i class="fa-solid fa-badge-check"></i>
                        <span>Conta ativa Hermes</span>
                    </div>
                </div>

                <div class="perfil-card perfil-stats">
                    <h3>Resumo</h3>
                    <div class="perfil-stats-grid">
                        <div class="perfil-stat">
                            <span class="perfil-stat-number">
                                <%= (historico != null) ? historico.size() : 0 %>
                            </span>
                            <span class="perfil-stat-label">
                                <% if ("transportador".equalsIgnoreCase(tipoUsuario)) { %>
                                    Fretes realizados
                                <% } else { %>
                                    Fretes solicitados
                                <% } %>
                            </span>
                        </div>
                        <div class="perfil-stat">
                            <span class="perfil-stat-number">DDD <%= ddd.isEmpty() ? "--" : ddd %></span>
                            <span class="perfil-stat-label">Região de atuação</span>
                        </div>
                    </div>
                </div>
                
                <!-- NOVA SEÇÃO: EXCLUIR CONTA -->
                <div class="perfil-card perfil-delete-card">
                    <h3><i class="fas fa-exclamation-triangle" style="color: #e74c3c;"></i> Zona de Perigo</h3>
                    <p style="font-size: 0.9rem; color: #7f8c8d; margin-bottom: 1rem;">
                        Esta ação é irreversível. Todos seus dados serão permanentemente excluídos.
                    </p>
                    <button type="button" class="btn btn-danger btn-block" id="btnExcluirConta">
                        <i class="fas fa-trash"></i> Excluir minha conta
                    </button>
                </div>
            </aside>

            <!-- LADO DIREITO: Conteúdo principal -->
            <section class="perfil-content">

                <!-- SEÇÃO: DADOS PESSOAIS -->
                <div class="perfil-card perfil-form-card">
                    <h3>Informações da conta</h3>
                    <p class="perfil-card-subtitle">
                        Atualize seus dados pessoais e de contato.
                    </p>

                    <form action="<%= base %>/PerfilServlet" method="post" class="perfil-form">
                        <div class="perfil-form-grid">
                            <div class="perfil-form-group">
                                <label for="nome">Nome completo</label>
                                <input type="text" id="nome" name="nome" value="<%= nome %>" required>
                            </div>

                            <div class="perfil-form-group">
                                <label for="email">E-mail</label>
                                <input type="email" id="email" name="email" value="<%= email %>" required>
                            </div>

                            <div class="perfil-form-group">
                                <label for="telefone">Telefone</label>
                                <input type="text" id="telefone" name="telefone" value="<%= telefone %>" required>
                                <span class="field-info">Inclua o DDD no número. O sistema atualiza sua região automaticamente.</span>
                            </div>

                            <div class="perfil-form-group">
                                <label for="estado">Estado</label>
                                <input type="text" id="estado" name="estado" value="<%= estado %>">
                            </div>

                            <div class="perfil-form-group">
                                <label for="cidade">Cidade</label>
                                <input type="text" id="cidade" name="cidade" value="<%= cidade %>">
                            </div>

                            <div class="perfil-form-group perfil-form-group-full">
                                <label for="endereco">Endereço</label>
                                <input type="text" id="endereco" name="endereco" value="<%= endereco %>">
                            </div>

                            <div class="perfil-form-group">
                                <label for="documento">Documento</label>
                                <input type="text" id="documento" name="documento" value="<%= documento %>">
                            </div>

                            <div class="perfil-form-group">
                                <label for="ddd">DDD</label>
                                <input type="text" id="ddd" name="ddd" value="<%= ddd %>" readonly>
                                <span class="field-info">O DDD é calculado a partir do telefone.</span>
                            </div>

                            <% if ("transportador".equalsIgnoreCase(tipoUsuario)) { %>
                            <div class="perfil-form-group perfil-form-group-full">
                                <label for="veiculo">Veículo</label>
                                <input type="text" id="veiculo" name="veiculo" value="<%= veiculo %>">
                                <span class="field-info">Ex.: Caminhão 3/4, Fiorino, Carro de passeio, etc.</span>
                            </div>
                            <% } %>
                        </div>

                        <div class="perfil-form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-floppy-disk"></i>
                                Salvar alterações
                            </button>
                        </div>
                    </form>
                </div>

                <!-- SEÇÃO: HISTÓRICO DE FRETES -->
                <div class="perfil-card perfil-history-card">
                    <div class="perfil-history-header">
                        <h3>Histórico de fretes</h3>
                        <p class="perfil-card-subtitle">
                            Acompanhe os últimos fretes vinculados à sua conta.
                        </p>
                    </div>

                    <% if (historico == null || historico.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fa-regular fa-box-archive"></i>
                            <p>Nenhum frete encontrado no histórico.</p>
                        </div>
                    <% } else { %>
                        <div class="perfil-history-list">
                            <% for (Frete f : historico) { %>
                                <div class="perfil-history-item">
                                    <div class="history-main">
                                        <div class="history-route">
                                            <span class="history-label">Origem</span>
                                            <p><%= f.getOrigem() %></p>
                                        </div>
                                        <div class="history-route">
                                            <span class="history-label">Destino</span>
                                            <p><%= f.getDestino() %></p>
                                        </div>
                                    </div>

                                    <div class="history-meta">
                                        <span class="history-status history-status-<%= f.getStatus() != null ? f.getStatus().toLowerCase() : "" %>">
                                            <%= f.getStatus() != null ? f.getStatus() : "Sem status" %>
                                        </span>
                                        <span class="history-value">
                                            <i class="fa-solid fa-coins"></i>
                                            R$ <%= String.format(java.util.Locale.US, "%.2f", f.getValor()) %>
                                        </span>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
                
                
<!-- SEÇÃO: AVALIAÇÕES RECEBIDAS (TRANSPORTADOR) -->
<% if ("transportador".equalsIgnoreCase(tipoUsuario)) { %>
<div class="perfil-card perfil-avaliacoes-card">
    <div class="perfil-avaliacoes-header">
        <h3>Avaliações dos Clientes</h3>
        <% if (mediaAvaliacoes != null && mediaAvaliacoes > 0) { %>
        <div class="avaliacoes-summary">
            <div class="avaliacoes-rating">
                <span class="rating-number"><%= String.format("%.1f", mediaAvaliacoes) %></span>
                <div class="rating-stars-large">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <i class="fas fa-star <%= i <= mediaAvaliacoes ? "active" : "" %>"></i>
                    <% } %>
                </div>
               <span class="rating-count">
    <%= avaliacoes != null ? avaliacoes.size() : 0 %> avaliações
</span>
            </div>
        </div>
        <% } %>
    </div>

    <% if (avaliacoes == null || avaliacoes.isEmpty()) { %>
        <div class="empty-state">
            <i class="fa-regular fa-star"></i>
            <p>Nenhuma avaliação recebida ainda.</p>
            <small>As avaliações aparecerão aqui quando os clientes avaliarem seus serviços.</small>
        </div>
    <% } else { %>
        <div class="avaliacoes-list">
            <% for (Avaliacao av : avaliacoes) { %>
            <div class="avaliacao-item">
                <div class="avaliacao-header">
                    <div class="avaliacao-user">
                        <div class="user-avatar">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <div class="user-info">
                            <span class="user-name">Cliente #<%= av.getIdFrete() %></span>
                            <div class="avaliacao-stars">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="fas fa-star <%= i <= av.getNota() ? "active" : "" %>"></i>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <span class="avaliacao-date">
                        <%= av.getDataAvaliacao() != null ? 
                            av.getDataAvaliacao().toLocalDateTime().toLocalDate().toString() : "" %>
                    </span>
                </div>

                <% if (av.getComentario() != null && !av.getComentario().isEmpty()) { %>
                <div class="avaliacao-comentario">
                    <p>"<%= av.getComentario() %>"</p>
                </div>
                <% } %>

                <% if (av.getFoto() != null && !av.getFoto().isEmpty()) { %>
                <div class="avaliacao-fotos">
                    <div class="foto-thumbnail">
                        <img src="<%= base %>/uploads/<%= av.getFoto() %>" 
                             alt="Foto da entrega" 
                             onclick="abrirFoto('<%= base %>/uploads/<%= av.getFoto() %>')">
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    <% } %>
</div>
<% } %>
                
                
                
                

                <!-- SEÇÃO: MINHAS AVALIAÇÕES (CLIENTE) -->
<% if (!"transportador".equalsIgnoreCase(tipoUsuario)) { %>
<div class="perfil-card perfil-avaliacoes-card">
    <div class="perfil-avaliacoes-header">
        <h3>Minhas Avaliações</h3>
        <p class="perfil-card-subtitle">
            Avaliações que você fez sobre os transportadores.
        </p>
    </div>

    <% if (avaliacoesFeitas == null || avaliacoesFeitas.isEmpty()) { %>
        <div class="empty-state">
            <i class="fa-regular fa-comment"></i>
            <p>Você ainda não fez nenhuma avaliação.</p>
            <small>As avaliações aparecerão aqui após você avaliar os fretes concluídos.</small>
        </div>
    <% } else { %>
        <div class="avaliacoes-list">
            <% for (Avaliacao av : avaliacoesFeitas) { %>
            <div class="avaliacao-item">
                <div class="avaliacao-header">
                    <div class="avaliacao-user">
                        <div class="user-avatar">
                            <i class="fa-solid fa-truck"></i>
                        </div>
                        <div class="user-info">
                            <span class="user-name">Transportador</span>
                            <div class="avaliacao-stars">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="fas fa-star <%= i <= av.getNota() ? "active" : "" %>"></i>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <span class="avaliacao-date">
                        <%= av.getDataAvaliacao() != null ? 
                            av.getDataAvaliacao().toLocalDateTime().toLocalDate().toString() : "" %>
                    </span>
                </div>

                <% if (av.getComentario() != null && !av.getComentario().isEmpty()) { %>
                <div class="avaliacao-comentario">
                    <p>"<%= av.getComentario() %>"</p>
                </div>
                <% } %>

                <% if (av.getFoto() != null && !av.getFoto().isEmpty()) { %>
                <div class="avaliacao-fotos">
                    <div class="foto-thumbnail">
                        <img src="<%= base %>/uploads/<%= av.getFoto() %>" 
                             alt="Minha foto da entrega" 
                             onclick="abrirFoto('<%= base %>/uploads/<%= av.getFoto() %>')">
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    <% } %>
</div>
<% } %>

            </section>
        </div>
    </div>
</div>

<!-- MODAL PARA FOTOS -->
<div id="fotoModal" class="modal">
    <span class="modal-close" onclick="fecharFoto()">&times;</span>
    <img class="modal-content" id="modalFoto">
<!-- MODAL DE EXCLUSÃO - FIXO NO CENTRO DA TELA -->
<div id="modalExcluirConta" class="modal-exclusao-overlay" style="
    display: none;
    position: fixed;  
    top: 0;
    left: 0;
    width: 100vw;  
    height: 100vh; 
    background-color: rgba(0, 0, 0, 0.7);
    z-index: 9999;  
    justify-content: center;
    align-items: center;
    overflow: auto; 
">
    
    <div class="modal-exclusao-container" style="
        background: white;
        border-radius: 12px;
        width: 500px;
        max-width: 90vw; 
        margin: 20px;  
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        position: relative; 
        ">
        <!-- HEADER VERMELHO -->
        <div style="
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        ">
            <h3 style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-exclamation-triangle"></i> Confirmar Exclusão
            </h3>
            <button onclick="fecharModalExclusao()" style="
                background: none;
                border: none;
                color: white;
                font-size: 28px;
                cursor: pointer;
                padding: 0;
                margin: 0;
                line-height: 1;
                transition: opacity 0.2s;
            ">&times;</button>
        </div>
        
        <!-- CONTEÚDO -->
        <div style="padding: 25px; color: #333; max-height: 60vh; overflow-y: auto;">
            <p><strong>Atenção! Esta ação é irreversível.</strong></p>
            <p style="color: #e74c3c; font-weight: bold; margin: 15px 0;">
                TODOS os seus dados serão excluídos permanentemente:
            </p>
            <ul style="margin: 15px 0 20px 20px; padding: 0; list-style-type: disc;">
                <li style="margin-bottom: 8px;">Seu perfil e dados pessoais</li>
                <li style="margin-bottom: 8px;">Todos os seus fretes</li>
                <li style="margin-bottom: 8px;">Histórico de atividades</li>
                <li style="margin-bottom: 8px;">Avaliações realizadas/recebidas</li>
                <% if ("transportador".equalsIgnoreCase(tipoUsuario)) { %>
                <li style="margin-bottom: 8px;">Seus veículos cadastrados</li>
                <% } %>
            </ul>
            
            <p style="margin-top: 20px;">
                Digite <strong style="color: #e74c3c;">EXCLUIR CONTA</strong> para confirmar:
            </p>
            <input type="text" id="confirmacaoTexto" placeholder="Digite EXCLUIR CONTA aqui" style="
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
                font-family: 'Inter', sans-serif;
                margin-top: 10px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            ">
        </div>
        
        <!-- BOTÕES -->
        <div style="
            padding: 20px;
            background: #f8f9fa;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid #e9ecef;
        ">
            <button onclick="fecharModalExclusao()" style="
                background: #95a5a6;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 0.95rem;
                transition: background 0.3s;
            ">
                Cancelar
            </button>
            <button onclick="confirmarExclusaoConta()" id="btnConfirmarExclusao" disabled style="
                background: #e74c3c;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 0.95rem;
                transition: background 0.3s, opacity 0.3s;
            ">
                <i class="fas fa-trash"></i> Excluir Conta
            </button>
        </div>
    </div>
</div>

<style>
/* Estilos para garantir que o modal fique sempre no topo */
.modal-exclusao-overlay {
    display: none;
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100% !important;
    height: 100% !important;
    z-index: 9999 !important;
    background-color: rgba(0, 0, 0, 0.7) !important;
    align-items: center;
    justify-content: center;
}

.modal-exclusao-container {
    position: relative;
    animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Garantir que o modal fique acima de tudo */
#modalExcluirConta {
    z-index: 9999 !important;
}

/* Quando o modal estiver aberto, evitar scroll no body */
body.modal-open {
    overflow: hidden;
}
</style>

<script>
// Função para abrir modal CORRETAMENTE
function abrirModalExclusao() {
    console.log("Abrindo modal de exclusão...");
    
    var modal = document.getElementById('modalExcluirConta');
    if (!modal) {
        console.error("Modal não encontrado!");
        return;
    }
    
    // Forçar estilo inline para garantir
    modal.style.cssText = 'display: flex !important; position: fixed !important; top: 0 !important; left: 0 !important; width: 100vw !important; height: 100vh !important; background-color: rgba(0, 0, 0, 0.7) !important; z-index: 9999 !important; align-items: center !important; justify-content: center !important;';
    
    // Prevenir scroll no body
    document.body.classList.add('modal-open');
    
    // Limpar campo e desabilitar botão
    document.getElementById('confirmacaoTexto').value = '';
    document.getElementById('btnConfirmarExclusao').disabled = true;
    
    // Focar no campo
    setTimeout(function() {
        var input = document.getElementById('confirmacaoTexto');
        if (input) input.focus();
    }, 100);
    
    console.log("Modal aberto com sucesso!");
}

// Função para fechar modal
function fecharModalExclusao() {
    var modal = document.getElementById('modalExcluirConta');
    if (modal) {
        modal.style.display = 'none';
    }
    
    // Restaurar scroll no body
    document.body.classList.remove('modal-open');
    
    console.log("Modal fechado!");
}

// Função de exclusão
function confirmarExclusaoConta() {
    var btn = document.getElementById('btnConfirmarExclusao');
    if (!btn) return;
    
    var originalText = btn.innerHTML;
    
    // Mostrar loading
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Excluindo...';
    btn.disabled = true;
    
    // Confirmar novamente
    if (!confirm('⚠️ TEM CERTEZA ABSOLUTA?\n\nEsta ação NÃO pode ser desfeita!\nTodos os seus dados serão PERDIDOS permanentemente.')) {
        btn.innerHTML = originalText;
        btn.disabled = false;
        return;
    }
    
    // Fazer requisição AJAX
    fetch('<%= base %>/ExcluirUsuarioServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('✅ Conta excluída com sucesso!\nVocê será redirecionado para a página inicial.');
            window.location.href = '<%= base %>/LogoutServlet';
        } else {
            alert('❌ Erro ao excluir conta: ' + data.message);
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        alert('❌ Erro de conexão. Verifique sua internet e tente novamente.');
        btn.innerHTML = originalText;
        btn.disabled = false;
    });
}

// Configurar eventos quando o DOM carregar
document.addEventListener('DOMContentLoaded', function() {
    console.log("Configurando eventos do modal...");
    
    // 1. Campo de confirmação
    var input = document.getElementById('confirmacaoTexto');
    var btn = document.getElementById('btnConfirmarExclusao');
    
    if (input && btn) {
        input.addEventListener('input', function() {
            var textoDigitado = this.value.toUpperCase().trim();
            btn.disabled = textoDigitado !== 'EXCLUIR CONTA';
            
            // Feedback visual
            if (textoDigitado === 'EXCLUIR CONTA') {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ddd';
            }
        });
        
        // Permitir Enter para confirmar
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !btn.disabled) {
                confirmarExclusaoConta();
            }
        });
    }
    
    // 2. Botão "Excluir minha conta"
    var btnAbrir = document.getElementById('btnExcluirConta');
    if (btnAbrir) {
        console.log("Botão de abrir encontrado!");
        btnAbrir.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            abrirModalExclusao();
        });
    } else {
        console.error("Botão btnExcluirConta NÃO encontrado!");
    }
    
    // 3. Fechar modal com ESC
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            fecharModalExclusao();
        }
    });
    
    // 4. Fechar modal clicando fora
    window.addEventListener('click', function(event) {
        var modal = document.getElementById('modalExcluirConta');
        if (event.target === modal) {
            fecharModalExclusao();
        }
    });
    
    console.log("Eventos configurados com sucesso!");
});

// Fechar modal com clique no X ou fora
function closeModalOnOutsideClick(event) {
    var modal = document.getElementById('modalExcluirConta');
    if (modal && event.target === modal) {
        fecharModalExclusao();
    }
}
</script>

</body>
</html>