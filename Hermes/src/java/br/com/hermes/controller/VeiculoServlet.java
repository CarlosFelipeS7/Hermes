package br.com.hermes.controller;

import br.com.hermes.model.Veiculo;
import br.com.hermes.service.VeiculoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VeiculoServlet", urlPatterns = {"/VeiculoServlet"})
public class VeiculoServlet extends HttpServlet {

    private final VeiculoService veiculoService = new VeiculoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        if (idUsuario == null || tipoUsuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        tipoUsuario = tipoUsuario.trim().toLowerCase();

        String action = request.getParameter("action");

        // ============================
        //       TELA DE EDIÇÃO
        // ============================
        if (action != null && action.equals("editar")) {

            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                session.setAttribute("mensagemErro", "ID do veículo não informado.");
                response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
                return;
            }

            try {
                int idVeiculo = Integer.parseInt(idParam);

                // *** LINHA 50 AJUSTADA: tratar a Exception do Service/DAO ***
                Veiculo v = veiculoService.buscarPorId(idVeiculo);

                if (v == null) {
                    session.setAttribute("mensagemErro", "Veículo não encontrado.");
                    response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
                    return;
                }

                request.setAttribute("veiculo", v);
                request.getRequestDispatcher("/dashboard/transportador/editarVeiculo.jsp")
                       .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                session.setAttribute("mensagemErro", "ID inválido.");
                response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
                return;

            } catch (Exception e) {
                // Exceção vinda do service/DAO (buscarPorId)
                e.printStackTrace();
                session.setAttribute("mensagemErro", "Erro ao carregar veículo: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
                return;
            }
        }

        // ============================
        // LISTA DE VEÍCULOS
        // ============================
        try {
            List<Veiculo> veiculos = veiculoService.listarPorUsuario(idUsuario, tipoUsuario);
            request.setAttribute("veiculos", veiculos);

            request.getRequestDispatcher("/dashboard/transportador/veiculos.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensagemErro", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard/transportador/transportador.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        if (idUsuario == null || tipoUsuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        tipoUsuario = tipoUsuario.trim().toLowerCase();

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "cadastrar" -> cadastrarVeiculo(request, response, idUsuario, tipoUsuario);
                case "atualizar" -> atualizarVeiculo(request, response, idUsuario, tipoUsuario);
                case "excluir" -> excluirVeiculo(request, response, idUsuario, tipoUsuario);
                default -> response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensagemErro", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
        }
    }

    private void cadastrarVeiculo(HttpServletRequest request, HttpServletResponse response,
                                  int idUsuario, String tipoUsuario) throws Exception {

        Veiculo v = new Veiculo();
        v.setTipoVeiculo(request.getParameter("tipoVeiculo"));
        v.setMarca(request.getParameter("marca"));
        v.setModelo(request.getParameter("modelo"));
        v.setAno(Integer.parseInt(request.getParameter("ano")));
        v.setPlaca(request.getParameter("placa"));
        v.setCapacidade(Double.parseDouble(request.getParameter("capacidade")));
        v.setCor(request.getParameter("cor"));
        v.setAtivo(true);

        veiculoService.cadastrar(v, idUsuario, tipoUsuario);

        request.getSession().setAttribute("mensagemSucesso", "Veículo cadastrado com sucesso!");
        response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
    }

    private void atualizarVeiculo(HttpServletRequest request, HttpServletResponse response,
                                  int idUsuario, String tipoUsuario) throws Exception {

        int idVeiculo = Integer.parseInt(request.getParameter("id"));

        Veiculo v = new Veiculo();
        v.setId(idVeiculo);
        v.setTipoVeiculo(request.getParameter("tipoVeiculo"));
        v.setMarca(request.getParameter("marca"));
        v.setModelo(request.getParameter("modelo"));
        v.setAno(Integer.parseInt(request.getParameter("ano")));
        v.setPlaca(request.getParameter("placa"));
        v.setCapacidade(Double.parseDouble(request.getParameter("capacidade")));
        v.setCor(request.getParameter("cor"));
        v.setAtivo("on".equals(request.getParameter("ativo")));

        veiculoService.atualizar(v, idUsuario, tipoUsuario);

        request.getSession().setAttribute("mensagemSucesso", "Veículo atualizado com sucesso!");
        response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
    }

    private void excluirVeiculo(HttpServletRequest request, HttpServletResponse response,
                                int idUsuario, String tipoUsuario) throws Exception {

        int idVeiculo = Integer.parseInt(request.getParameter("id"));

        veiculoService.excluir(idVeiculo, idUsuario, tipoUsuario);

        request.getSession().setAttribute("mensagemSucesso", "Veículo excluído com sucesso!");
        response.sendRedirect(request.getContextPath() + "/VeiculoServlet");
    }
}
