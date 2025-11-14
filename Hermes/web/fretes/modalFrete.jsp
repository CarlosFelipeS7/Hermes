<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="br.com.hermes.model.Frete" %>

<%
    Frete f = (Frete) request.getAttribute("freteDetalhes");
    if (f == null) return;
%>

<div class="modal-overlay" id="modalFrete">
    <div class="modal-card animate-modal">
        <button class="btn-close" onclick="fecharModal()">✖</button>

        <h2>Detalhes do Frete</h2>

        <div class="modal-info">
            <p><strong>Origem:</strong> <%= f.getOrigem() %></p>
            <p><strong>Destino:</strong> <%= f.getDestino() %></p>
            <p><strong>Peso:</strong> <%= f.getPeso() %> kg</p>
            <p><strong>Carga:</strong> <%= f.getDescricaoCarga() %></p>
            <p><strong>Cliente:</strong> <%= f.getIdCliente() %></p>
            <p><strong>Status:</strong>
                <span class="status <%= f.getStatus() %>"><%= f.getStatus() %></span>
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" style="margin-top:1rem;">
            <input type="hidden" name="action" value="aceitar">
            <input type="hidden" name="idFrete" value="<%= f.getId() %>">

            <button class="btn btn-primary btn-large">
                <i class="fas fa-check"></i> Aceitar Frete
            </button>
        </form>

    </div>
</div>
