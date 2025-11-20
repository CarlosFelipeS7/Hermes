<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer idUsuario = (Integer) session.getAttribute("usuarioId");
    String tipoUsuario = (String) session.getAttribute("usuarioTipo");

    // Só cliente pode solicitar frete
    if (idUsuario == null || !"cliente".equalsIgnoreCase(tipoUsuario)) {
        response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Solicitar Frete | Hermes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fretes.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

<% if (request.getAttribute("mensagem") != null) { %>
    <div class="alert-overlay">
        <div class="alert-box <%= request.getAttribute("tipoMensagem") %>">
            <i class="fas <%= "success".equals(request.getAttribute("tipoMensagem"))
                    ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i>
            <span><%= request.getAttribute("mensagem") %></span>
        </div>
    </div>
<% } %>

<jsp:include page="../components/navbar.jsp" />

<section class="frete-section">
    <div class="frete-container animate-fade-in">
        <h1 class="section-title">Solicitar Frete</h1>
        <p class="section-subtitle">Preencha os dados completos para enviar sua solicitação.</p>

        <form action="${pageContext.request.contextPath}/FreteServlet" method="post" class="frete-form">
            <input type="hidden" name="action" value="criar">
            <input type="hidden" name="idCliente" value="<%= idUsuario %>">

            <!-- SEÇÃO ORIGEM -->
            <div class="form-section">
                <h3><i class="fas fa-map-marker-alt"></i> Endereço de Origem</h3>
                
                <div class="form-group">
                    <label>CEP Origem <small>(opcional)</small></label>
                    <div class="cep-container">
                        <input type="text" name="cepOrigem" id="cepOrigem" placeholder="00000-000" maxlength="9">
                        <div class="loading" id="loadingOrigem" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                    </div>
                    <small class="field-info">Informe o CEP para preenchimento automático</small>
                </div>

                <div class="form-group">
                    <label>Região de Origem (DDD) *</label>
                    <select name="dddOrigem" required class="form-select">
                        <option value="">Selecione o DDD da região</option>
                        <!-- São Paulo -->
                        <option value="11">11 - São Paulo e Região Metropolitana</option>
                        <option value="12">12 - São José dos Campos e Vale do Paraíba</option>
                        <option value="13">13 - Santos e Baixada Santista</option>
                        <option value="14">14 - Bauru e Centro-Oeste Paulista</option>
                        <option value="15">15 - Sorocaba e Sudoeste Paulista</option>
                        <option value="16">16 - Ribeirão Preto e Nordeste Paulista</option>
                        <option value="17">17 - São José do Rio Preto e Noroeste Paulista</option>
                        <option value="18">18 - Presidente Prudente e Oeste Paulista</option>
                        <option value="19">19 - Campinas e Região</option>
                        <!-- Outros estados -->
                        <option value="21">21 - Rio de Janeiro/RJ</option>
                        <option value="31">31 - Belo Horizonte/MG</option>
                        <option value="41">41 - Curitiba/PR</option>
                        <option value="51">51 - Porto Alegre/RS</option>
                        <option value="61">61 - Brasília/DF</option>
                        <option value="71">71 - Salvador/BA</option>
                        <option value="81">81 - Recife/PE</option>
                        <option value="85">85 - Fortaleza/CE</option>
                        <option value="91">91 - Belém/PA</option>
                    </select>
                    <small class="field-info">Selecione o DDD da região de origem</small>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Endereço Completo de Origem *</label>
                        <input type="text" name="origem" placeholder="Ex: Rua das Flores, 123 - Centro - São Paulo/SP" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Cidade de Origem *</label>
                        <input type="text" name="cidadeOrigem" placeholder="Cidade" required>
                    </div>
                    <div class="form-group">
                        <label>Estado de Origem *</label>
                        <input type="text" name="estadoOrigem" placeholder="UF" maxlength="2" required>
                    </div>
                </div>
            </div>

            <!-- SEÇÃO DESTINO -->
            <div class="form-section">
                <h3><i class="fas fa-flag-checkered"></i> Endereço de Destino</h3>

                <div class="form-group">
                    <label>CEP Destino <small>(opcional)</small></label>
                    <div class="cep-container">
                        <input type="text" name="cepDestino" id="cepDestino" placeholder="00000-000" maxlength="9">
                        <div class="loading" id="loadingDestino" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                    </div>
                    <small class="field-info">Informe o CEP para preenchimento automático</small>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Endereço Completo de Destino *</label>
                        <input type="text" name="destino" placeholder="Ex: Av. Paulista, 1000 - Bela Vista - São Paulo/SP" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Cidade de Destino *</label>
                        <input type="text" name="cidadeDestino" placeholder="Cidade" required>
                    </div>
                    <div class="form-group">
                        <label>Estado de Destino *</label>
                        <input type="text" name="estadoDestino" placeholder="UF" maxlength="2" required>
                    </div>
                </div>
            </div>

            <!-- SEÇÃO CARGA -->
            <div class="form-section">
                <h3><i class="fas fa-box"></i> Informações da Carga</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label>Peso (kg) *</label>
                        <input type="text" name="peso" id="peso" placeholder="Ex: 150,50" required>
                        <small class="field-info">Use vírgula para decimais</small>
                    </div>

                    <div class="form-group">
                        <label>Valor do Frete (R$) *</label>
                        <input type="text" name="valor" id="valor" placeholder="R$ 0,00" required>
                        <small class="field-info">Valor que está disposto a pagar</small>
                    </div>
                </div>

                <div class="form-group full">
                    <label>Descrição da Carga *</label>
                    <textarea name="descricaoCarga" rows="4" placeholder="Descreva o tipo de carga, dimensões, cuidados especiais, etc." required></textarea>
                    <small class="field-info">Informações detalhadas ajudam os transportadores</small>
                </div>
            </div>

            <div class="form-info">
                <i class="fas fa-info-circle"></i>
                <div>
                    <strong>Como funciona:</strong> 
                    <ul>
                        <li>O CEP é <strong>opcional</strong> - use apenas se souber</li>
                        <li>Se informar o CEP, os campos de endereço serão preenchidos automaticamente</li>
                        <li>O DDD é usado para mostrar seu frete apenas para transportadores da mesma região</li>
                        <li>O endereço completo será usado para cálculo de rota</li>
                    </ul>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-large">
                <i class="fas fa-paper-plane"></i> Solicitar Frete
            </button>
        </form>
    </div>
</section>

<jsp:include page="../components/footer.jsp" />

<script>
// Máscara de valor
const campoValor = document.getElementById("valor");
campoValor.addEventListener("input", function () {
    let v = this.value.replace(/\D/g, "");
    v = (Number(v) / 100).toFixed(2) + "";
    v = v.replace(".", ",");
    v = "R$ " + v;
    this.value = v;
});

// Remove máscara antes de enviar
document.querySelector(".frete-form").addEventListener("submit", function () {
    let v = campoValor.value.replace("R$ ", "").replace(".", "").replace(",", ".");
    campoValor.value = v;
});

// Máscara de peso
const campoPeso = document.querySelector("input[name='peso']");
campoPeso.addEventListener("input", function () {
    let v = this.value.replace(/\D/g, "");
    if (v.length > 3) {
        v = v.replace(/(\d+)(\d{2})$/, "$1,$2");
    }
    this.value = v;
});

// Remove vírgula do peso
document.querySelector(".frete-form").addEventListener("submit", function () {
    campoPeso.value = campoPeso.value.replace(",", ".");
});

// Validação do DDD
document.querySelector(".frete-form").addEventListener("submit", function(e) {
    const dddSelect = document.querySelector("select[name='dddOrigem']");
    if (!dddSelect.value) {
        e.preventDefault();
        alert('Por favor, selecione a região de origem (DDD).');
        dddSelect.focus();
        return false;
    }
    return true;
});

// Máscara de CEP
function mascaraCEP(input) {
    let value = input.value.replace(/\D/g, '');
    if (value.length > 5) {
        value = value.replace(/(\d{5})(\d{0,3})/, '$1-$2');
    }
    input.value = value;
}

// Buscar endereço por CEP
async function buscarEnderecoPorCEP(cep, tipo) {
    if (cep.length === 9) {
        const cepLimpo = cep.replace('-', '');
        
        try {
            // Mostrar loading
            const loadingElement = document.getElementById('loading' + tipo);
            if (loadingElement) loadingElement.style.display = 'inline';
            
            const response = await fetch('https://viacep.com.br/ws/' + cepLimpo + '/json/');
            const data = await response.json();
            
            if (!data.erro) {
                // Preencher campos automaticamente
                document.querySelector('input[name="origem"]').value = 
                    (data.logradouro || '') + ' - ' + (data.bairro || '') + ' - ' + data.localidade + '/' + data.uf;
                document.querySelector('input[name="cidadeOrigem"]').value = data.localidade || '';
                document.querySelector('input[name="estadoOrigem"]').value = data.uf || '';
                
                // Auto-selecionar DDD baseado no estado E cidade (apenas para origem)
                if (tipo === 'Origem') {
                    selecionarDDDPorEstado(data.uf, data.localidade);
                }
                
                showMessage('Endereço ' + tipo.toLowerCase() + ' preenchido automaticamente!', 'success');
            } else {
                showMessage('CEP não encontrado. Preencha os campos manualmente.', 'warning');
            }
        } catch (error) {
            console.error('Erro ao buscar CEP:', error);
            showMessage('Erro ao buscar CEP. Preencha os campos manualmente.', 'error');
        } finally {
            // Esconder loading
            const loadingElement = document.getElementById('loading' + tipo);
            if (loadingElement) loadingElement.style.display = 'none';
        }
    }
}

// Buscar endereço de destino por CEP
async function buscarEnderecoDestinoPorCEP(cep, tipo) {
    if (cep.length === 9) {
        const cepLimpo = cep.replace('-', '');
        
        try {
            const loadingElement = document.getElementById('loading' + tipo);
            if (loadingElement) loadingElement.style.display = 'inline';
            
            const response = await fetch('https://viacep.com.br/ws/' + cepLimpo + '/json/');
            const data = await response.json();
            
            if (!data.erro) {
                document.querySelector('input[name="destino"]').value = 
                    (data.logradouro || '') + ' - ' + (data.bairro || '') + ' - ' + data.localidade + '/' + data.uf;
                document.querySelector('input[name="cidadeDestino"]').value = data.localidade || '';
                document.querySelector('input[name="estadoDestino"]').value = data.uf || '';
                
                showMessage('Endereço destino preenchido automaticamente!', 'success');
            } else {
                showMessage('CEP não encontrado. Preencha os campos manualmente.', 'warning');
            }
        } catch (error) {
            console.error('Erro ao buscar CEP:', error);
            showMessage('Erro ao buscar CEP. Preencha os campos manualmente.', 'error');
        } finally {
            const loadingElement = document.getElementById('loading' + tipo);
            if (loadingElement) loadingElement.style.display = 'none';
        }
    }
}

// Selecionar DDD baseado no estado E cidade
function selecionarDDDPorEstado(uf, cidade) {
    const mapeamentoDDD = {
        '11': ['São Paulo', 'Guarulhos', 'Osasco', 'Santo André', 'São Bernardo do Campo', 'Mauá', 'Diadema'],
        '12': ['São José dos Campos', 'Taubaté', 'Jacareí', 'Caçapava', 'Campos do Jordão'],
        '13': ['Santos', 'São Vicente', 'Praia Grande', 'Guarujá', 'Cubatão'],
        '14': ['Bauru', 'Jaú', 'Botucatu', 'Avaré', 'Marília'],
        '15': ['Sorocaba', 'Itapetininga', 'Itu', 'Tatuí', 'Porto Feliz'],
        '16': ['Ribeirão Preto', 'Franca', 'São Carlos', 'Araraquara', 'Sertãozinho'],
        '17': ['São José do Rio Preto', 'Votuporanga', 'Catanduva', 'Jales', 'Fernandópolis', 'Auriflama', 'Santa Fé do Sul'],
        '18': ['Presidente Prudente', 'Araçatuba', 'Assis', 'Adamantina', 'Dracena'],
        '19': ['Campinas', 'Piracicaba', 'Limeira', 'Americana', 'Sumaré', 'Hortolândia'],
        '21': ['RJ'], '22': ['RJ'], '24': ['RJ'], 
        '27': ['ES'], '28': ['ES'],
        '31': ['MG'], '32': ['MG'], '33': ['MG'], '34': ['MG'], '35': ['MG'], '37': ['MG'], '38': ['MG'],
        '41': ['PR'], '42': ['PR'], '43': ['PR'], '44': ['PR'], '45': ['PR'], '46': ['PR'],
        '47': ['SC'], '48': ['SC'], '49': ['SC'],
        '51': ['RS'], '53': ['RS'], '54': ['RS'], '55': ['RS'],
        '61': ['DF'], '62': ['GO'], '63': ['TO'], '64': ['GO'], '65': ['MT'], '66': ['MT'], '67': ['MS'],
        '68': ['AC'], '69': ['RO'],
        '71': ['BA'], '73': ['BA'], '74': ['BA'], '75': ['BA'], '77': ['BA'],
        '79': ['SE'],
        '81': ['PE'], '82': ['AL'], '83': ['PB'], '84': ['RN'],
        '85': ['CE'], '86': ['PI'], '87': ['PE'], '88': ['CE'], '89': ['PI'],
        '91': ['PA'], '92': ['AM'], '93': ['PA'], '94': ['PA'], '95': ['RR'],
        '96': ['AP'], '97': ['AM'], '98': ['MA'], '99': ['MA']
    };

    // Primeiro tenta encontrar pela cidade
    for (const [ddd, cidades] of Object.entries(mapeamentoDDD)) {
        for (const nomeCidade of cidades) {
            if (cidade.toLowerCase().includes(nomeCidade.toLowerCase())) {
                document.querySelector('select[name="dddOrigem"]').value = ddd;
                console.log('DDD encontrado por cidade:', ddd, 'para', cidade);
                return;
            }
        }
    }

    // Se não encontrou pela cidade, tenta pelo estado
    for (const [ddd, cidades] of Object.entries(mapeamentoDDD)) {
        for (const nomeCidade of cidades) {
            if (nomeCidade === uf) {
                document.querySelector('select[name="dddOrigem"]').value = ddd;
                console.log('DDD encontrado por estado:', ddd, 'para', uf);
                return;
            }
        }
    }

    console.log('DDD não encontrado para:', cidade, uf);
}

// Mostrar mensagens
function showMessage(message, type) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'alert-message ' + type;
    
    let iconClass = 'fa-exclamation-circle';
    if (type === 'success') {
        iconClass = 'fa-check-circle';
    }
    
    messageDiv.innerHTML = '<i class="fas ' + iconClass + '"></i>' + message;
    
    document.querySelector('.frete-form').prepend(messageDiv);
    
    setTimeout(function() {
        messageDiv.remove();
    }, 5000);
}

// Event listeners para CEP
document.getElementById('cepOrigem').addEventListener('input', function(e) {
    mascaraCEP(this);
    if (this.value.length === 9) {
        buscarEnderecoPorCEP(this.value, 'Origem');
    }
});

document.getElementById('cepDestino').addEventListener('input', function(e) {
    mascaraCEP(this);
    if (this.value.length === 9) {
        buscarEnderecoDestinoPorCEP(this.value, 'Destino');
    }
});

// Fechar alertas automáticos
setTimeout(function() {
    const alertBox = document.querySelector('.alert-overlay');
    if (alertBox) {
        alertBox.style.opacity = '0';
        setTimeout(function() {
            alertBox.remove();
        }, 500);
    }
}, 4000);
</script>

</body>
</html>