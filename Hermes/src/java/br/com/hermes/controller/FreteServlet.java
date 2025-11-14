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

    // =============================================================
    // GET → LISTAGENS para CLIENTE e TRANSPORTADOR
    // =============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("usuarioId") == null ||
                session.getAttribute("usuarioTipo") == null) {

            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");

        try {

            // CLIENTE
            if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                listarFretesCliente(idUsuario, request, response);
                return;
            }

            // TRANSPORTADOR
            if ("transportador".equalsIgnoreCase(tipoUsuario)) {
                listarFretesTransportador(idUsuario, request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao carregar fretes: " + e.getMessage());
        }
    }


    // =============================================================
    // POST → CRIAR / ACEITAR / INICIAR / CONCLUIR
    // =============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("usuarioId") == null ||
                session.getAttribute("usuarioTipo") == null) {

            response.sendRedirect(request.getContextPath() + "/auth/login/login.jsp");
            return;
        }

        int idUsuario = (Integer) session.getAttribute("usuarioId");
        String tipoUsuario = (String) session.getAttribute("usuarioTipo");
        String action = request.getParameter("action");

        try {

            // ======================================================
            // CRIAR FRETE → CLIENTE
            // ======================================================
            if ("criar".equals(action) && "cliente".equalsIgnoreCase(tipoUsuario)) {
                criarFrete(request, response, idUsuario);
                return;
            }

            // ======================================================
            // ACEITAR FRETE → TRANSPORTADOR
            // ======================================================
            if ("aceitar".equals(action) && "transportador".equalsIgnoreCase(tipoUsuario)) {
                aceitarFrete(request, response, idUsuario);
                return;
            }

            // ======================================================
            // INICIAR FRETE → TRANSPORTADOR
            // ======================================================
            if ("iniciar".equals(action) && "transportador".equalsIgnoreCase(tipoUsuario)) {
                iniciarFrete(request, response);
                return;
            }

            // ======================================================
            // CONCLUIR FRETE → TRANSPORTADOR
            // ======================================================
            if ("concluir".equals(action) && "transportador".equalsIgnoreCase(tipoUsuario)) {
                concluirFrete(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/erro.jsp");

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao processar operação: " + e.getMessage());
        }
    }
    
    

    // =============================================================
    // CLIENTE — LISTAR FRETES
    // =============================================================
    private void listarFretesCliente(int idCliente, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        List<Frete> fretes = freteService.listarFretesCliente(idCliente, 100);

        request.setAttribute("fretes", fretes);
        request.getRequestDispatcher("/fretes/listaFretes.jsp")
               .forward(request, response);
    }

    // =============================================================
    // TRANSPORTADOR — LISTAR FRETES
    // =============================================================
    private void listarFretesTransportador(int idTransportador,
                                           HttpServletRequest request,
                                           HttpServletResponse response)
            throws Exception {

        request.setAttribute("fretesDisponiveis", freteService.listarFretesDisponiveis());
        request.setAttribute("fretesEmAndamento", freteService.listarFretesEmAndamento(idTransportador));
        request.setAttribute("fretesConcluidos", freteService.listarFretesConcluidos(idTransportador));

        request.getRequestDispatcher("/fretes/listaFretesTransportador.jsp")
               .forward(request, response);
    }

    // =============================================================
    // CLIENTE — CRIAR FRETE
    // =============================================================
    private void criarFrete(HttpServletRequest request, HttpServletResponse response, int idCliente)
            throws Exception {

        Frete f = new Frete();
        f.setOrigem(request.getParameter("origem"));
        f.setDestino(request.getParameter("destino"));
        f.setDescricaoCarga(request.getParameter("descricao"));
        f.setPeso(Double.parseDouble(request.getParameter("peso")));
        String v = request.getParameter("valor");
        double valor = Double.parseDouble(v.replace(",", "."));
        f.setValor(valor);
        f.setIdCliente(idCliente);

        freteService.criarFrete(f);

        request.setAttribute("mensagem", "Frete solicitado com sucesso!");
        request.setAttribute("tipoMensagem", "success");

        request.getRequestDispatcher("/fretes/solicitarFretes.jsp")
               .forward(request, response);
    }

    // =============================================================
    // TRANSPORTADOR — ACEITAR FRETE
    // =============================================================
    private void aceitarFrete(HttpServletRequest request, HttpServletResponse response, int idTransportador)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.aceitarFrete(idFrete, idTransportador);

        request.setAttribute("mensagem", "Frete aceito com sucesso!");
        request.setAttribute("tipoMensagem", "success");

        listarFretesTransportador(idTransportador, request, response);
    }

    // =============================================================
    // TRANSPORTADOR — INICIAR FRETE
    // =============================================================
    private void iniciarFrete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.iniciarFrete(idFrete);

        response.sendRedirect(request.getContextPath() + "/FreteServlet");
    }

    // =============================================================
    // TRANSPORTADOR — CONCLUIR FRETE
    // =============================================================
    private void concluirFrete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int idFrete = Integer.parseInt(request.getParameter("idFrete"));
        freteService.concluirFrete(idFrete);

        response.sendRedirect(request.getContextPath() + "/FreteServlet");
    }

    // =============================================================
    // ERRO PADRONIZADO
    // =============================================================
    private void tratarErro(HttpServletRequest request,
                             HttpServletResponse response,
                             String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
    
    
}
