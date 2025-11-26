<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Notificacao" %>

<%
    List<Notificacao> notificacoes = (List<Notificacao>) request.getAttribute("notificacoes");
    Integer naoLidas = (Integer) request.getAttribute("naoLidas");
    if (notificacoes == null) notificacoes = new ArrayList<>();
    if (naoLidas == null) naoLidas = 0;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Notificações - Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notificacao.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="components/navbar.jsp" />

<section class="notificacoes-section">
    <div class="notificacoes-container">
        <div class="notificacoes-header">
            <h1>Notificações</h1>
            <% if (naoLidas > 0) { %>
                <span class="nao-lidas-badge"><%= naoLidas %> não lida(s)</span>
            <% } %>
        </div>

        <% if (naoLidas > 0) { %>
        <div class="actions-container">
            <a href="${pageContext.request.contextPath}/NotificacaoServlet?action=marcarTodasLidas" 
               class="btn-marcar-todas" id="btnMarcarTodas">
                <i class="fas fa-check-double"></i> Marcar Todas como Lidas
            </a>
        </div>
        <% } %>

        <div class="notificacoes-list">
            <% if (notificacoes.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-bell-slash"></i>
                    <h3>Nenhuma notificação</h3>
                    <p>Você não tem notificações no momento.</p>
                </div>
            <% } else { %>
                <% for (Notificacao notif : notificacoes) { %>
                    <div class="notificacao-item <%= notif.isLida() ? "" : "nao-lida" %>">
                        <div class="notificacao-icon">
                            <% 
                                String icon = "fas fa-bell";
                                if (notif.getTipo() != null) {
                                    switch(notif.getTipo()) {
                                        case "frete_aceito":
                                            icon = "fas fa-truck-loading";
                                            break;
                                        case "frete_concluido":
                                            icon = "fas fa-check-circle";
                                            break;
                                        case "avaliacao_recebida":
                                            icon = "fas fa-star";
                                            break;
                                        case "novo_frete_disponivel":
                                            icon = "fas fa-box";
                                            break;
                                        case "frete_em_andamento":
                                            icon = "fas fa-truck-moving";
                                            break;
                                        default:
                                            icon = "fas fa-bell";
                                    }
                                }
                            %>
                            <i class="<%= icon %>"></i>
                        </div>
                        
                        <div class="notificacao-content">
                            <h4><%= notif.getTitulo() != null ? notif.getTitulo() : "Notificação" %></h4>
                            <p><%= notif.getMensagem() != null ? notif.getMensagem() : "" %></p>
                            <small>
                                <% if (notif.getDataCriacao() != null) { %>
                                    <%= notif.getDataCriacao().toLocalDateTime().toLocalDate().toString() %>
                                    às 
                                    <%= notif.getDataCriacao().toLocalDateTime().toLocalTime().toString().substring(0, 5) %>
                                <% } %>
                            </small>
                        </div>
                        
                        <div class="notificacao-actions">
                            <% if (!notif.isLida()) { %>
                                <a href="${pageContext.request.contextPath}/NotificacaoServlet?action=marcarLida&id=<%= notif.getId() %>" 
                                   class="btn-marcar-lida" title="Marcar como lida">
                                    <i class="fas fa-check"></i>
                                </a>
                            <% } %>
                            
                            <% if (notif.getIdFrete() > 0) { %>
                                <a href="${pageContext.request.contextPath}/fretes/rastreamento.jsp?id=<%= notif.getIdFrete() %>" 
                                   class="btn-ver-frete">
                                    Ver Frete
                                </a>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="components/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Confirmação para marcar todas como lidas
        const btnMarcarTodas = document.getElementById('btnMarcarTodas');
        if (btnMarcarTodas) {
            btnMarcarTodas.addEventListener('click', function(e) {
                if (!confirm('Tem certeza que deseja marcar todas as notificações como lidas?')) {
                    e.preventDefault();
                }
            });
        }
        
        // Animações suaves para as notificações
        const notificacaoItems = document.querySelectorAll('.notificacao-item');
        notificacaoItems.forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                item.style.transition = 'all 0.5s ease-out';
                item.style.opacity = '1';
                item.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>

</body>
</html>