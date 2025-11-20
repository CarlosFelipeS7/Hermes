<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Frete" %>
<%@ page import="java.util.List" %>

<%
    List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");
    if (fretes == null) fretes = java.util.Collections.emptyList();
    
    List<String> dddsDisponiveis = (List<String>) request.getAttribute("dddsDisponiveis");
    if (dddsDisponiveis == null) dddsDisponiveis = java.util.Collections.emptyList();
    
    String dddFiltroAtual = (String) request.getAttribute("dddFiltroAtual");
    if (dddFiltroAtual == null) dddFiltroAtual = "";
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Fretes Disponíveis | Hermes</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container">

        <h1 class="section-title">Fretes disponíveis</h1>
        <p class="section-subtitle">Veja os fretes pendentes e aceite os que você deseja transportar.</p>

        <!-- 🔽 FILTRO POR DDD DINÂMICO -->
        <div class="filtro-ddd">
            <h3><i class="fas fa-filter"></i> Filtrar por região (DDD):</h3>
            
            <div class="filtro-options">
                <select onchange="filtrarPorDDD(this.value)" class="filtro-select">
                    <option value="">Todos os DDDs</option>
                    <% for (String ddd : dddsDisponiveis) { %>
                        <option value="<%= ddd %>" 
                            <%= ddd.equals(dddFiltroAtual) ? "selected" : "" %>>
                            DDD <%= ddd %>
                        </option>
                    <% } %>
                </select>
                
                <div class="filtro-input-group">
                    <input type="text" id="dddInput" placeholder="Digite o DDD (ex: 17)" 
                           maxlength="2" value="<%= dddFiltroAtual %>"
                           onkeypress="return event.charCode >= 48 && event.charCode <= 57">
                    <button onclick="filtrarPorDDD(document.getElementById('dddInput').value)" 
                            class="btn btn-secondary">
                        <i class="fas fa-search"></i> Filtrar
                    </button>
                </div>
            </div>
            
            <% if (!dddFiltroAtual.isEmpty()) { %>
                <div class="filtro-resultado">
                    <span>Mostrando fretes do DDD <strong><%= dddFiltroAtual %></strong></span>
                    <button onclick="limparFiltro()" class="btn-link">
                        <i class="fas fa-times"></i> Limpar filtro
                    </button>
                </div>
            <% } %>
        </div>
        <!-- 🔼 FIM DO FILTRO -->

        <div class="frete-grid">
            <% if (!fretes.isEmpty()) { %>
                <% for (Frete f : fretes) { %>
                    <div class="frete-card">
                        <div class="frete-header">
                            <h3><i class="fas fa-map-marker-alt"></i> <%= f.getOrigem() %> → <%= f.getDestino() %></h3>
                            <span class="frete-status pendente">PENDENTE</span>
                        </div>
                        
                        <div class="frete-info">
                            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
                            <p><strong>Descrição:</strong> <%= f.getDescricaoCarga() %></p>
                            <p><strong>Valor:</strong> R$ <%= String.format("%.2f", f.getValor()) %></p>
                            <p><strong>Data:</strong> <%= f.getDataSolicitacao() != null ? f.getDataSolicitacao().toLocalDateTime().toLocalDate() : "N/A" %></p>
                            <% if (f.getDddOrigem() != null && !f.getDddOrigem().isEmpty()) { %>
                                <p><strong>Região:</strong> DDD <%= f.getDddOrigem() %></p>
                            <% } %>
                        </div>

                        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" class="frete-action">
                            <input type="hidden" name="action" value="aceitar">
                            <input type="hidden" name="idFrete" value="<%= f.getId() %>">
                            <button class="btn btn-primary btn-small">
                                <i class="fas fa-check"></i> Aceitar frete
                            </button>
                        </form>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-box-open fa-3x"></i>
                    <h3>Nenhum frete disponível</h3>
                    <p>
                        <% if (!dddFiltroAtual.isEmpty()) { %>
                            Não encontramos fretes para o DDD <strong><%= dddFiltroAtual %></strong>.
                            <a href="javascript:void(0)" onclick="limparFiltro()">Ver todos os fretes</a>
                        <% } else { %>
                            Todos os fretes disponíveis já foram aceitos. Volte mais tarde!
                        <% } %>
                    </p>
                </div>
            <% } %>
        </div>

    </div>
</section>

<jsp:include page="../components/footer.jsp" />

<script>
function filtrarPorDDD(ddd) {
    if (ddd && ddd.trim() !== '') {
        // Validar se é um DDD válido (2 dígitos)
        if (/^\d{2}$/.test(ddd)) {
            // ✅ AGORA USA O FreteListarServlet CORRETO!
            window.location.href = '${pageContext.request.contextPath}/FreteListarServlet?dddFiltro=' + ddd;
        } else {
            alert('Por favor, digite um DDD válido com 2 dígitos.');
        }
    } else {
        // Recarregar sem filtro
        window.location.href = '${pageContext.request.contextPath}/FreteListarServlet';
    }
}

function limparFiltro() {
    window.location.href = '${pageContext.request.contextPath}/FreteListarServlet';
}

// Enter no input de DDD
document.getElementById('dddInput')?.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filtrarPorDDD(this.value);
    }
});
</script>

</body>
</html>