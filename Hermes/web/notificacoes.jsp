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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .notificacoes-section {
            padding: 2rem 0;
            background: #f8f9fa;
            min-height: 80vh;
        }

        .notificacoes-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .notificacoes-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
        }

        .nao-lidas-badge {
            background: #e74c3c;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .notificacao-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }

        .notificacao-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .notificacao-item.nao-lida {
            border-left-color: #e74c3c;
            background: #fff8f8;
        }

        .notificacao-icon {
            font-size: 1.5rem;
            color: #3498db;
            margin-top: 0.25rem;
            min-width: 40px;
            text-align: center;
        }

        .notificacao-item.nao-lida .notificacao-icon {
            color: #e74c3c;
        }

        .notificacao-content {
            flex: 1;
        }

        .notificacao-content h4 {
            margin: 0 0 0.5rem 0;
            color: #2c3e50;
            font-weight: 600;
        }

        .notificacao-content p {
            margin: 0 0 0.5rem 0;
            color: #5a6c7d;
            line-height: 1.5;
        }

        .notificacao-content small {
            color: #7f8c8d;
            font-size: 0.875rem;
        }

        .notificacao-actions {
            display: flex;
            gap: 0.5rem;
            align-items: flex-start;
        }

        .btn-marcar-lida {
            background: #27ae60;
            color: white;
            padding: 0.5rem;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
        }

        .btn-marcar-lida:hover {
            background: #219653;
        }

        .btn-ver-frete {
            background: #3498db;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.875rem;
            transition: background 0.3s ease;
            white-space: nowrap;
        }

        .btn-ver-frete:hover {
            background: #2980b9;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #7f8c8d;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .empty-state i {
            margin-bottom: 1rem;
            color: #bdc3c7;
            font-size: 4rem;
        }

        .empty-state h3 {
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }

        .empty-state p {
            margin: 0;
            font-size: 1.1rem;
        }

        .actions-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 1rem;
            gap: 0.5rem;
        }

        .btn-marcar-todas {
            background: #27ae60;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.875rem;
            transition: background 0.3s ease;
        }

        .btn-marcar-todas:hover {
            background: #219653;
        }

        @media (max-width: 768px) {
            .notificacoes-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
            
            .notificacao-item {
                flex-direction: column;
                gap: 1rem;
            }
            
            .notificacao-actions {
                align-self: flex-end;
            }
        }
    </style>
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