package br.com.hermes.controller;

import br.com.hermes.model.Frete;
import br.com.hermes.service.FreteService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteServlet", urlPatterns = {"/FreteServlet"})
public class FreteServlet extends HttpServlet {

    private final FreteService freteService = new FreteService();

    // ==========================================================
    // SUPORTE A GET → permite acessar fretes via URL, botões etc.
    // ==========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("listar".equalsIgnoreCase(action)) {
            listarTodos(request, response);
            return;
        }

        // GET fallback → já chama POST
        doPost(request, response);
    }


    // ==========================================================
    // POST → criar, aceitar, iniciar, concluir
    // ==========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        if (idUsuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {

            switch (action.toLowerCase()) {

                case "criar":
                    if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                        criarFrete(request, response, idUsuario);
                    }
                    return;

                case "aceitar":
                    if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                        aceitarFrete(request, response, idUsuario);
                    }
                    return;

                case "iniciar":
                    if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                        iniciarFrete(request, response);
                    }
                    return;

                case "concluir":
                    if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                        concluirFrete(request, response);
                    }
                    return;

                default:
                    response.sendRedirect(request.getContextPath() + "/erro.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            tratarErro(request, response, "Erro ao processar frete: " + e.getMessage());
        }
    }


    // ==========================================================
    // AÇÕES
    // ==========================================================

    private void criarFrete(HttpServletRequest request, HttpServletResponse response, int idCliente)
            throws Exception {

        Frete f = new Frete();
        f.setOrigem(request.getParameter("origem"));
        f.setDestino(request.getParameter("destino"));
        f.setDescricaoCarga(request.getParameter("descricao"));
        f.setPeso(Double.parseDouble(request.getParameter("peso")));
        f.setValor(Double.parseDouble(request.getParameter("valor")));
        f.setIdCliente(idCliente);

        freteService.criarFrete(f);

        request.setAttribute("mensagem", "Frete solicitado com sucesso!");
        request.setAttribute("tipoMensagem", "success");
        request.getRequestDispatcher("/fretes/solicitarFretes.jsp").forward(request, response);
    }


    private void aceitarFrete(HttpServletRequest request, HttpServletResponse response, int idTransportador)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.aceitarFrete(idFrete, idTransportador);

        response.sendRedirect(request.getContextPath() + "/dashboardTransportador");
    }


    private void iniciarFrete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.iniciarFrete(idFrete);

        response.sendRedirect(request.getContextPath() + "/dashboardTransportador");
    }


    private void concluirFrete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.concluirFrete(idFrete);

        response.sendRedirect(request.getContextPath() + "/dashboardTransportador");
    }


    // ==========================================================
    // LISTAR TODOS (GET)
    // ==========================================================
    private void listarTodos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Frete> lista = freteService.listarTodos();
            request.setAttribute("fretes", lista);

            request.getRequestDispatcher("/fretes/listaFretes.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao listar fretes: " + e.getMessage());
        }
    }


    // ==========================================================
    // ERROS
    // ==========================================================
    private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}
