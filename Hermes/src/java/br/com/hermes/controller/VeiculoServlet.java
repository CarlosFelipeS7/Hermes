package br.com.hermes.controller;

import br.com.hermes.model.Veiculo;
import br.com.hermes.service.VeiculoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/VeiculoServlet")
public class VeiculoServlet extends HttpServlet {
    private VeiculoService veiculoService;

    @Override
    public void init() throws ServletException {
        this.veiculoService = new VeiculoService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Verificar se usuário está logado
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");
        
        if (idUsuario == null) {
            response.sendRedirect("../../auth/login/login.jsp");
            return;
        }

        // Verificar se é transportador
        if (!"transportador".equals(tipoUsuario)) {
            sendJsonResponse(response, false, "Apenas transportadores podem cadastrar veículos");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            if ("cadastrar".equals(action)) {
                cadastrarVeiculo(request, response, idUsuario);
            } else if ("excluir".equals(action)) {
                excluirVeiculo(request, response, idUsuario);
            } else {
                sendJsonResponse(response, false, "Ação inválida");
            }
        } catch (Exception e) {
            sendJsonResponse(response, false, "Erro: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");

        if (idUsuario == null) {
            response.sendRedirect("../../auth/login/login.jsp");
            return;
        }

        try {
            var veiculos = veiculoService.listarVeiculosPorUsuario(idUsuario);
            request.setAttribute("veiculos", veiculos);
            request.getRequestDispatcher("/dashboard/veiculo/veiculo.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erro ao carregar veículos: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/veiculo/veiculo.jsp").forward(request, response);
        }
    }

    private void cadastrarVeiculo(HttpServletRequest request, HttpServletResponse response, Integer idUsuario) throws IOException {
        try {
            String tipoVeiculo = request.getParameter("tipoVeiculo");
            String marca = request.getParameter("marca");
            String modelo = request.getParameter("modelo");
            int ano = Integer.parseInt(request.getParameter("ano"));
            String placa = request.getParameter("placa").toUpperCase();
            double capacidade = Double.parseDouble(request.getParameter("capacidade"));
            String cor = request.getParameter("cor");

            Veiculo veiculo = new Veiculo(idUsuario, tipoVeiculo, marca, modelo, ano, placa, capacidade, cor);
            
            boolean sucesso = veiculoService.cadastrarVeiculo(veiculo);
            
            if (sucesso) {
                sendJsonResponse(response, true, "Veículo cadastrado com sucesso!");
            } else {
                sendJsonResponse(response, false, "Erro ao cadastrar veículo");
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Dados numéricos inválidos");
        } catch (IllegalArgumentException e) {
            sendJsonResponse(response, false, e.getMessage());
        } catch (Exception e) {
            sendJsonResponse(response, false, "Erro interno ao cadastrar veículo");
        }
    }

    private void excluirVeiculo(HttpServletRequest request, HttpServletResponse response, Integer idUsuario) throws IOException {
        try {
            int idVeiculo = Integer.parseInt(request.getParameter("idVeiculo"));
            
            boolean sucesso = veiculoService.excluirVeiculo(idVeiculo, idUsuario);
            
            if (sucesso) {
                sendJsonResponse(response, true, "Veículo excluído com sucesso!");
            } else {
                sendJsonResponse(response, false, "Erro ao excluir veículo ou veículo não encontrado");
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID do veículo inválido");
        } catch (Exception e) {
            sendJsonResponse(response, false, "Erro interno ao excluir veículo");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        PrintWriter out = response.getWriter();
        
        // Criar JSON manualmente
        String json = String.format(
            "{\"success\": %s, \"message\": \"%s\"}",
            success,
            message.replace("\"", "\\\"") // Escapar aspas
        );
        
        out.print(json);
        out.flush();
    }
}