<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, br.com.hermes.model.Veiculo" %>
<%
    List<Veiculo> veiculos = (List<Veiculo>) request.getAttribute("veiculos");
    if (veiculos == null) veiculos = java.util.Collections.emptyList();

    String nome = (String) session.getAttribute("usuarioNome");
    if (nome == null) {
        response.sendRedirect("../../auth/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Meus Veículos | Hermes</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<jsp:include page="../../components/navbar.jsp" />
<div style="max-width: 1200px; margin: 125px auto; padding: 20px;">

    <h1 style="color: white; margin-bottom: 30px;">Meus Veículos</h1>

      


    <% if (veiculos.isEmpty()) { %>

        <div style="text-align: center; padding: 50px; background: white; border-radius: 12px; 
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
            <i class="fas fa-truck fa-4x" style="color: #bdc3c7;"></i>
            <h3 style="color: #2c3e50;">Nenhum veículo cadastrado</h3>
            <p style="color: #7f8c8d;">Cadastre seu primeiro veículo para começar a aceitar fretes.</p>
        </div>

    <% } else { %>

        <!-- LISTA DE VEÍCULOS -->
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">

            <% for (Veiculo v : veiculos) { %>
                <div style="background: white; padding: 20px; border-radius: 12px;
                            box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #2ecc71;">

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <h3 style="margin: 0; color: #2c3e50;">
                            <i class="fas fa-truck"></i>
                            <%= v.getMarca() %> <%= v.getModelo() %>
                        </h3>

                        <span style="background: #2ecc71; color: white; padding: 5px 10px;
                                     border-radius: 6px; font-size: 12px; font-weight: bold;">
                            <%= v.getPlaca() %>
                        </span>
                    </div>

                    <div style="color: #5a6c7d; line-height: 1.6;">
                        <p><strong>Tipo:</strong> <%= v.getTipoVeiculo() %></p>
                        <p><strong>Ano:</strong> <%= v.getAno() %></p>
                        <p><strong>Capacidade:</strong> <%= String.format("%.2f", v.getCapacidade()) %> kg</p>
                        <p><strong>Cor:</strong> <%= v.getCor() != null ? v.getCor() : "Não informada" %></p>
                        <p><strong>Cadastrado em:</strong> 
                            <%= v.getDataCadastro() != null ? v.getDataCadastro().toLocalDateTime().toLocalDate() : "" %>
                        </p>
                    </div>

                    <!-- Botões -->
                    <div style="margin-top: 15px; display: flex; justify-content: flex-end; gap: 10px;">

                        <!-- EDITAR -->
                        <a href="${pageContext.request.contextPath}/VeiculoServlet?action=editar&id=<%= v.getId() %>"
                           style="    background: var(--accent);
                                color: white;
                                padding: 8px 18px;
                                border-radius: 6px;
                                text-align: center;
                                text-decoration: none;
                                font-size: 14px;
                                height: 2rem;
                            }">
                            <i class="fas fa-edit"></i> Editar
                        </a>

                        <!-- EXCLUIR -->
                        <form action="${pageContext.request.contextPath}/VeiculoServlet" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="excluir">
                            <input type="hidden" name="id" value="<%= v.getId() %>">

                            <button type="submit"
                                    onclick="return confirm('Tem certeza que deseja excluir este veículo?')"
                                    style="background: #e74c3c; color: white; border: none; 
                                           padding: 8px 18px; border-radius: 6px; cursor: pointer;
                                           font-size: 14px;">
                                <i class="fas fa-trash"></i> Excluir
                            </button>
                        </form>

                    </div>

                </div>
            <% } %>

        </div>

    <% } %>
    
    <div style="margin-top: 1rem;">
    <a href="${pageContext.request.contextPath}/dashboard/transportador/cadastrarVeiculo.jsp"
           class="btn btn-primary"
           style="padding: 10px 20px; border-radius: 8px;">
           <i class="fas fa-plus"></i> Cadastrar Veículo
        </a>
    </div>       

    <!-- BOTÃO VOLTAR AO PAINEL -->
    <div style="text-align: center; margin-top: 40px;">
        <a href="${pageContext.request.contextPath}/dashboard/transportador/transportador.jsp"
           style="color: white; font-size: 18px; text-decoration: none; padding: 12px 20px;
                   display: inline-block;">
            <i class="fas fa-arrow-left"></i> Voltar ao painel
        </a>
    </div>

</div>


</body>
</html>
