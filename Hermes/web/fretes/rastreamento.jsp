<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="br.com.hermes.model.Frete, br.com.hermes.dao.FreteDAO" %>

<%
    String idParam = request.getParameter("id");
    Frete frete = null;
    
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            int idFrete = Integer.parseInt(idParam);
            FreteDAO dao = new FreteDAO();
            frete = dao.buscarPorId(idFrete);
        } catch (Exception e) {
            // Tratar erro silenciosamente
        }
    }
    
    if (frete == null) {
        response.sendRedirect(request.getContextPath() + "/erro.jsp?mensagem=Frete não encontrado");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Rastreamento - Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/rastreamento.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- OpenStreetMap -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        #map { 
            height: 400px; 
            border-radius: 14px; 
            overflow: hidden; 
            z-index: 1;
        }
        .leaflet-popup-content {
            font-family: inherit;
        }
    </style>
   <style>
@media print {
    @page {
        margin: 0.5cm;
        size: A4 portrait;
    }
    
    /* Reset para impressão */
    body {
        background: white !important;
        font-size: 11px;
        line-height: 1.2;
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
    }
    
    /* Navbar estilizada para impressão */
    .navbar {
        display: flex !important;
        justify-content: center;
        align-items: center;
        padding: 8px 0 !important;
        min-height: 35px !important;
        background: linear-gradient(135deg, #047857 0%, #0f766e 100%) !important;
    }
    
    .navbar-brand {
        font-size: 16px !important;
        font-weight: bold;
        color: white !important;
        text-align: center;
    }
    
    /* Esconder elementos desnecessários */
    .navbar-nav, .dropdown,
    .action-buttons, .map-controls, .footer {
        display: none !important;
    }
    
    /* Adicionar rodapé personalizado */
    body::after {
        content: "Conectando clientes e transportadores com eficiência e confiança. Sua plataforma completa para soluções de fretes.\A © 2025 Hermes - Sistema de Fretes. Todos os direitos reservados.";
        display: block;
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        background: #f8f9fa !important;
        padding: 10px 15px !important;
        text-align: center;
        border-top: 2px solid #047857;
        font-size: 9px !important;
        color: #666 !important;
        line-height: 1.4;
        white-space: pre-line;
        z-index: 1000;
    }
    
    /* Ajustar container principal para espaço do rodapé */
    .rastreamento-container {
        display: grid;
        grid-template-columns: 1fr; /* UMA coluna apenas */
        gap: 15px;
        margin: 0 !important;
        padding: 0 0 50px 0 !important;
        max-height: 22cm;
    }
    
    /* TODOS os elementos na mesma coluna */
    .rastreamento-header,
    .frete-info-card,
    .timeline-container,
    .map-container {
        grid-column: 1;
    }
    
    /* Header estilizado */
    .rastreamento-header {
        text-align: center;
        margin-bottom: 12px !important;
        padding: 10px;
        background: #f8f9fa !important;
        border-radius: 8px;
        border-left: 4px solid #047857;
    }
    
    .rastreamento-header h1 {
        font-size: 16px !important;
        margin-bottom: 3px !important;
        color: #047857 !important;
        font-weight: bold;
    }
    
    .rastreamento-header p {
        font-size: 11px !important;
        color: #666 !important;
        margin: 0 !important;
    }
    
    /* Cards estilizados */
    .frete-info-card, 
    .timeline-container, 
    .map-container {
        margin-bottom: 12px !important;
        padding: 12px !important;
        break-inside: avoid;
        border: 1px solid #e0e0e0 !important;
        border-radius: 6px !important;
        background: white !important;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1) !important;
    }
    
    .frete-info-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 8px;
        margin-bottom: 8px;
    }
    
    .frete-info-header h3 {
        font-size: 13px !important;
        color: #047857 !important;
        margin: 0 !important;
    }
    
    /* Status badge */
    .status-badge {
        background: #047857 !important;
        color: white !important;
        border: none !important;
        padding: 3px 8px !important;
        font-size: 10px !important;
        border-radius: 12px;
    }
    
    /* Info items compactos */
    .info-item {
        margin-bottom: 6px !important;
        padding: 4px 0;
    }
    
    .info-item strong {
        color: #333 !important;
        font-size: 10px;
    }
    
    .info-item span {
        font-size: 10px;
        color: #555 !important;
    }
    
    /* Mapa compacto */
    #map {
        height: 180px !important;
        border: 1px solid #ddd !important;
    }
    
    /* Timeline compacta e estilizada - ÍCONES VERDES CLAROS */
    .timeline-container h3 {
        font-size: 13px !important;
        color: #047857 !important;
        margin-bottom: 10px !important;
        border-bottom: 1px solid #eee;
        padding-bottom: 5px;
    }
    
    .timeline {
        padding: 0 !important;
    }
    
    .timeline-item {
        margin-bottom: 6px !important;
        padding: 6px !important;
        border-left: 3px solid #10b981; /* Verde mais claro */
        background: #f8f9fa;
        border-radius: 0 4px 4px 0;
    }
    
    .timeline-item.active {
        background: #ecfdf5;
        border-left-color: #34d399; /* Verde ainda mais claro */
    }
    
    .timeline-marker {
        width: 18px !important;
        height: 18px !important;
        font-size: 9px !important;
        background: #10b981 !important; /* Verde claro */
        color: white !important;
    }
    
    .timeline-item.active .timeline-marker {
        background: #34d399 !important; /* Verde mais claro */
    }
    
    /* Ícones com cores verdes claras */
    .timeline-marker i {
        color: white !important;
    }
    
    .timeline-content h4 {
        font-size: 11px !important;
        margin: 0 0 2px 0 !important;
        color: #333 !important;
    }
    
    .timeline-content p {
        font-size: 9px !important;
        margin: 0 0 3px 0 !important;
        color: #666 !important;
    }
    
    .timeline-date {
        font-size: 8px !important;
        color: #888 !important;
        font-style: italic;
    }
    
    /* Garantir que não quebre página */
    .rastreamento-section {
        page-break-inside: avoid;
        height: 23cm;
        overflow: hidden;
    }
    
    /* Melhor contraste geral */
    * {
        color: #000 !important;
        font-family: Arial, sans-serif !important;
    }
}
</style>
</head>
<body>

<jsp:include page="../components/navbar.jsp" />

<section class="rastreamento-section">
    <div class="rastreamento-container">
        <div class="rastreamento-header">
            <h1><i class="fas fa-map-marker-alt"></i> Rastreamento do Frete</h1>
            <p>Acompanhe em tempo real a localização do seu frete</p>
        </div>

        <!-- Card de Informações do Frete -->
        <div class="frete-info-card">
            <div class="frete-info-header">
                <h3>Detalhes do Frete</h3>
                <span class="status-badge status-<%= frete.getStatus().toLowerCase() %>">
                    <%= frete.getStatus().toUpperCase() %>
                </span>
            </div>
            
            <div class="frete-info-content">
                <div class="info-row">
                    <div class="info-item">
                        <strong><i class="fas fa-flag"></i> Origem:</strong>
                        <span><%= frete.getOrigem() %></span>
                    </div>
                    <div class="info-item">
                        <strong><i class="fas fa-flag-checkered"></i> Destino:</strong>
                        <span><%= frete.getDestino() %></span>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-item">
                        <strong><i class="fas fa-weight-hanging"></i> Peso:</strong>
                        <span><%= frete.getPeso() %> kg</span>
                    </div>
                    <div class="info-item">
                        <strong><i class="fas fa-dollar-sign"></i> Valor:</strong>
                        <span>R$ <%= String.format("%.2f", frete.getValor()) %></span>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-item">
                        <strong><i class="fas fa-box"></i> Descrição:</strong>
                        <span><%= frete.getDescricaoCarga() %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Timeline de Rastreamento -->
        <div class="timeline-container">
            <h3><i class="fas fa-route"></i> Status do Rastreamento</h3>
            
            <div class="timeline">
                <div class="timeline-item <%= "pendente".equals(frete.getStatus()) || "aceito".equals(frete.getStatus()) || "em_andamento".equals(frete.getStatus()) || "concluido".equals(frete.getStatus()) ? "active" : "" %>">
                    <div class="timeline-marker">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="timeline-content">
                        <h4>Solicitado</h4>
                        <p>Frete criado e aguardando aceitação</p>
                        <span class="timeline-date">
                            <%= frete.getDataSolicitacao() != null ? 
                                frete.getDataSolicitacao().toLocalDateTime().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "" %>
                        </span>
                    </div>
                </div>

                <div class="timeline-item <%= "aceito".equals(frete.getStatus()) || "em_andamento".equals(frete.getStatus()) || "concluido".equals(frete.getStatus()) ? "active" : "" %>">
                    <div class="timeline-marker">
                        <i class="fas fa-truck-loading"></i>
                    </div>
                    <div class="timeline-content">
                        <h4>Aceito</h4>
                        <p>Transportador aceitou o frete</p>
                        <span class="timeline-date">
                            <% if ("aceito".equals(frete.getStatus()) || "em_andamento".equals(frete.getStatus()) || "concluido".equals(frete.getStatus())) { %>
                                Em andamento
                            <% } %>
                        </span>
                    </div>
                </div>

                <div class="timeline-item <%= "em_andamento".equals(frete.getStatus()) || "concluido".equals(frete.getStatus()) ? "active" : "" %>">
                    <div class="timeline-marker">
                        <i class="fas fa-truck-moving"></i>
                    </div>
                    <div class="timeline-content">
                        <h4>Em Transporte</h4>
                        <p>Frete a caminho do destino</p>
                        <span class="timeline-date">
                            <% if ("em_andamento".equals(frete.getStatus()) || "concluido".equals(frete.getStatus())) { %>
                                Em andamento
                            <% } %>
                        </span>
                    </div>
                </div>

                <div class="timeline-item <%= "concluido".equals(frete.getStatus()) ? "active" : "" %>">
                    <div class="timeline-marker">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="timeline-content">
                        <h4>Entregue</h4>
                        <p>Frete entregue com sucesso</p>
                        <span class="timeline-date">
                            <% if (frete.getDataConclusao() != null) { %>
                                <%= frete.getDataConclusao().toLocalDateTime().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                            <% } %>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mapa com OpenStreetMap -->
        <div class="map-container">
            <h3><i class="fas fa-map"></i> Localização em Tempo Real</h3>
            <div id="map"></div>
            
            <div class="map-controls">
                <div class="location-info" id="locationInfo">
                    <strong>Status de Localização:</strong> 
                    <span id="locationText">
                        <% 
                            String localizacao = "";
                            if ("pendente".equals(frete.getStatus())) {
                                localizacao = "Aguardando coleta";
                            } else if ("aceito".equals(frete.getStatus())) {
                                localizacao = "Preparando para coleta";
                            } else if ("em_andamento".equals(frete.getStatus())) {
                                localizacao = "Em trânsito - Próximo ao destino";
                            } else if ("concluido".equals(frete.getStatus())) {
                                localizacao = "Entregue no destino final";
                            }
                        %>
                        <%= localizacao %>
                    </span>
                </div>
                
                <div class="map-stats">
                    <div class="stat">
                        <i class="fas fa-road"></i>
                        <span id="distance">--</span>
                    </div>
                    <div class="stat">
                        <i class="fas fa-clock"></i>
                        <span id="duration">--</span>
                    </div>
                    <div class="stat">
                        <i class="fas fa-tachometer-alt"></i>
                        <span id="speed">--</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Botões de Ação -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/dashboard/clientes/clientes.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Voltar ao Painel
            </a>
            
            <button onclick="window.print()" class="btn btn-outline">
                <i class="fas fa-print"></i> Imprimir Rastreamento
            </button>
            
            <% if ("concluido".equals(frete.getStatus())) { %>
                <a href="${pageContext.request.contextPath}/fretes/avaliacaoFretes.jsp?id=<%= frete.getId() %>" class="btn btn-primary">
                    <i class="fas fa-star"></i> Avaliar Serviço
                </a>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="../components/footer.jsp" />

<!-- OpenStreetMap JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
// Configuração do mapa OpenStreetMap
let map;
let marker;
let routeLine;
let watchId;

// Coordenadas simuladas
const coordenadasFrete = {
    origem: [-23.5505, -46.6333], // [lat, lng] - São Paulo
    destino: [-22.9068, -43.1729], // [lat, lng] - Rio de Janeiro
    atual: [-23.5505, -46.6333],
    rota: [
        [-23.5505, -46.6333], // SP
        [-23.1791, -45.8872], // Taubaté
        [-22.3145, -46.1625], // Poços de Caldas
        [-21.7672, -43.3504], // Juiz de Fora
        [-22.9068, -43.1729]  // RJ
    ]
};

function initMap() {
    // Inicializar mapa OpenStreetMap
    map = L.map('map').setView(coordenadasFrete.origem, 7);
    
    // Adicionar camada do OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors',
        maxZoom: 19
    }).addTo(map);

    // Adicionar marcadores de origem e destino
    L.marker(coordenadasFrete.origem)
        .addTo(map)
        .bindPopup('<strong>📍 Origem</strong><br><%= frete.getOrigem() %>')
        .openPopup();

    L.marker(coordenadasFrete.destino)
        .addTo(map)
        .bindPopup('<strong>🎯 Destino</strong><br><%= frete.getDestino() %>');

    // Adicionar linha da rota
    routeLine = L.polyline(coordenadasFrete.rota, {
        color: '#10b981',
        weight: 4,
        opacity: 0.7,
        dashArray: '10, 10'
    }).addTo(map);

    // Ajustar o zoom para mostrar toda a rota
    map.fitBounds(routeLine.getBounds());

    // Calcular distância aproximada
    const distancia = calcularDistancia(coordenadasFrete.origem, coordenadasFrete.destino);
    document.getElementById('distance').textContent = distancia + ' km';
    document.getElementById('duration').textContent = calcularTempoEstimado(distancia);

    // Iniciar rastreamento automaticamente se estiver em andamento
    if ('<%= frete.getStatus() %>' === 'em_andamento' || '<%= frete.getStatus() %>' === 'aceito') {
        iniciarRastreamentoSimulado();
    } else if ('<%= frete.getStatus() %>' === 'concluido') {
        // Mostrar posição final
        coordenadasFrete.atual = coordenadasFrete.destino;
        atualizarPosicaoNoMapa(coordenadasFrete.atual);
        document.getElementById('locationText').textContent = 'Entrega concluída';
        document.getElementById('speed').textContent = '0 km/h';
    }
}

function calcularDistancia(origem, destino) {
    // Cálculo simplificado de distância
    const R = 6371; // Raio da Terra em km
    const dLat = (destino[0] - origem[0]) * Math.PI / 180;
    const dLon = (destino[1] - origem[1]) * Math.PI / 180;
    const a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(origem[0] * Math.PI / 180) * Math.cos(destino[0] * Math.PI / 180) *
        Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distancia = R * c;
    return Math.round(distancia);
}

function calcularTempoEstimado(distancia) {
    const velocidadeMedia = 60; // km/h
    const horas = distancia / velocidadeMedia;
    if (horas < 1) {
        return Math.round(horas * 60) + ' min';
    }
    return Math.round(horas) + ' h';
}

function iniciarRastreamentoSimulado() {
    let progresso = 0;
    const totalPontos = coordenadasFrete.rota.length;
    
    watchId = setInterval(() => {
        if (progresso >= totalPontos - 1 || '<%= frete.getStatus() %>' === 'concluido') {
            clearInterval(watchId);
            document.getElementById('locationText').textContent = 'Entrega concluída';
            document.getElementById('speed').textContent = '0 km/h';
            return;
        }
        
        // Avançar para próximo ponto da rota
        progresso++;
        const novaPosicao = coordenadasFrete.rota[progresso];
        
        atualizarPosicaoNoMapa(novaPosicao);
        atualizarInterface(progresso, totalPontos);
        
    }, 3000); // Atualizar a cada 3 segundos
}

function atualizarPosicaoNoMapa(posicao) {
    // Remover marcador anterior
    if (marker) {
        map.removeLayer(marker);
    }
    
    // Criar novo marcador personalizado
    const vehicleIcon = L.divIcon({
        className: 'vehicle-marker',
        html: '<div style="background: #ef4444; border: 3px solid white; border-radius: 50%; width: 20px; height: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.3);"></div>',
        iconSize: [20, 20],
        iconAnchor: [10, 10]
    });
    
    marker = L.marker(posicao, { icon: vehicleIcon })
        .addTo(map)
        .bindPopup('<strong>🚚 Veículo</strong><br>Posição atual do frete');
    
    // Centralizar mapa no marcador durante o movimento
    if (progresso > 0 && progresso < coordenadasFrete.rota.length - 1) {
        map.setView(posicao, 8);
    }
    
    // Atualizar velocidade simulada
    const velocidade = Math.random() * 80 + 20; // 20-100 km/h
    document.getElementById('speed').textContent = Math.round(velocidade) + ' km/h';
}

function atualizarInterface(progresso, totalPontos) {
    const statusElement = document.getElementById('locationText');
    const percentual = Math.round((progresso / (totalPontos - 1)) * 100);
    
    if (percentual < 25) {
        statusElement.textContent = `Saindo da origem (${percentual}%)`;
    } else if (percentual < 75) {
        statusElement.textContent = `Em trânsito (${percentual}%)`;
    } else {
        statusElement.textContent = `Próximo ao destino (${percentual}%)`;
    }
}

// Inicializar mapa quando a página carregar
document.addEventListener('DOMContentLoaded', function() {
    initMap();
});

// Parar rastreamento quando a página for fechada
window.addEventListener('beforeunload', function() {
    if (watchId) {
        clearInterval(watchId);
    }
});

// Atualização automática do status a cada 30 segundos
setTimeout(function() {
    window.location.reload();
}, 30000);

// Animação da timeline
document.addEventListener('DOMContentLoaded', function() {
    const timelineItems = document.querySelectorAll('.timeline-item.active');
    timelineItems.forEach((item, index) => {
        setTimeout(() => {
            item.style.opacity = '1';
            item.style.transform = 'translateX(0)';
        }, index * 300);
    });
});
</script>

</body>
</html>