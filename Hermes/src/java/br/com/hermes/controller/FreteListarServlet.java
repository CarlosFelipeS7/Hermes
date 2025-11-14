package br.com.hermes.controller;

import br.com.hermes.dao.FreteDAO;
import br.com.hermes.model.Frete;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FreteListarServlet", urlPatterns = {"/FreteListarServlet"})
public class FreteListarServlet extends HttpServlet {

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
            switch (tipoUsuario.toLowerCase()) {

                case "cliente":
                    listarFretesCliente(idUsuario, request, response);
                    break;

                case "transportador":
                    listarFretesTransportador(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    break;
            }

        } catch (Exception e) {
            tratarErro(request, response, "Erro ao carregar fretes: " + e.getMessage());
        }
    }

    // ==========================================================
    // LISTAR FRETES PARA CLIENTE
    // ==========================================================
    private void listarFretesCliente(int idCliente,
                                     HttpServletRequest request,
                                     HttpServletResponse response)
            throws Exception {

        FreteDAO dao = new FreteDAO();
        List<Frete> fretes = dao.listarFretesCliente(idCliente, 50);

        request.setAttribute("fretes", fretes);
        request.getRequestDispatcher("/fretes/listaFretes.jsp")
               .forward(request, response);
    }

    // ==========================================================
    // LISTAR FRETES PARA TRANSPORTADOR
    // ==========================================================
    private void listarFretesTransportador(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        FreteDAO dao = new FreteDAO();
        List<Frete> fretes = dao.listarPendentesTodos();

        request.setAttribute("fretes", fretes);
        request.getRequestDispatcher("/fretes/listaFretesTransportador.jsp")
               .forward(request, response);
    }

    // ==========================================================
    // ERRO PADRONIZADO
    // ==========================================================
    private void tratarErro(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("mensagem", msg);
        request.setAttribute("tipoMensagem", "error");
        request.getRequestDispatcher("/erro.jsp").forward(request, response);
    }
}
