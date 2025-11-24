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
                                <span class="rating-count"><%= avaliacoes != null ? avaliacoes.size() : 0 %> avaliações</span>
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
                                            <span class="user-name">Cliente</span>
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
</div>

<script>
// Modal para fotos
function abrirFoto(src) {
    document.getElementById('modalFoto').src = src;
    document.getElementById('fotoModal').style.display = 'block';
}

function fecharFoto() {
    document.getElementById('fotoModal').style.display = 'none';
}

// Fechar modal clicando fora
window.onclick = function(event) {
    const modal = document.getElementById('fotoModal');
    if (event.target === modal) {
        fecharFoto();
    }
}
</script>

</body>
</html>