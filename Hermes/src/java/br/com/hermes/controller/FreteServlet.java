package br.com.hermes.controller;

import br.com.hermes.model.Frete;
import br.com.hermes.service.FreteService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "FreteServlet", urlPatterns = {"/FreteServlet"})
public class FreteServlet extends HttpServlet {

    private final FreteService freteService = new FreteService();

    // =============================================================
    // GET → LISTAGEM DE FRETES
    // =============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        if (idUsuario == null) {
            response.sendRedirect("auth/login/login.jsp");
            return;
        }

        try {
            switch (tipoUsuario.toLowerCase()) {
                case "cliente":
                    listarFretesCliente(idUsuario, request, response);
                    break;

                case "transportador":
                    listarFretesTransportador(request, response);
                    break;

                default:
                    response.sendRedirect("index.jsp");
            }

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao carregar fretes: " + e.getMessage());
        }
    }


    // =============================================================
    // POST → criar frete OU aceitar frete
    // =============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        if (idUsuario == null) {
            response.sendRedirect("auth/login/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("aceitar".equals(action) && "transportador".equalsIgnoreCase(tipoUsuario)) {
                aceitarFrete(request, response, idUsuario);
                return;
            }

            if ("criar".equals(action) && "cliente".equalsIgnoreCase(tipoUsuario)) {
                criarFrete(request, response, idUsuario);
                return;
            }

            response.sendRedirect("erro.jsp");

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao processar: " + e.getMessage());
        }
    }


    // =============================================================
    // LISTAR FRETES DO CLIENTE
    // =============================================================
    private void listarFretesCliente(int idCliente, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        request.setAttribute("fretes", freteService.listarFretesCliente(idCliente, 50));
        request.getRequestDispatcher("/fretes/listaFretes.jsp").forward(request, response);
    }


    // =============================================================
    // LISTAR FRETES PARA TRANSPORTADOR
    // =============================================================
    private void listarFretesTransportador(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        request.setAttribute("fretes", freteService.listarFretesDisponiveis());
        request.getRequestDispatcher("/fretes/listaFretesTransportador.jsp").forward(request, response);
    }


    // =============================================================
    // CRIAR FRETE (CLIENTE)
    // =============================================================
    private void criarFrete(HttpServletRequest request, HttpServletResponse response, int idCliente)
            throws Exception {

        Frete f = new Frete();
        f.setOrigem(request.getParameter("origem"));
        f.setDestino(request.getParameter("destino"));
        f.setDescricaoCarga(request.getParameter("descricao"));
        f.setPeso(Double.parseDouble(request.getParameter("peso")));
        f.setValor(0.0);
        f.setIdCliente(idCliente);

        freteService.criarFrete(f);

        request.setAttribute("mensagem", "Frete solicitado com sucesso!");
        request.setAttribute("tipoMensagem", "success");
        request.getRequestDispatcher("/fretes/solicitarFretes.jsp").forward(request, response);
    }


    // =============================================================
    // ACEITAR FRETE (TRANSPORTADOR)
    // =============================================================
    private void aceitarFrete(HttpServletRequest request, HttpServletResponse response, int idTransportador)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));

        freteService.aceitarFrete(idFrete, idTransportador);

        request.setAttribute("mensagem", "Frete aceito com sucesso!");
        request.setAttribute("tipoMensagem", "success");

        listarFretesTransportador(request, response);
    }


    // =============================================================
    // ERRO PADRONIZADO
    // =============================================================
    private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}
